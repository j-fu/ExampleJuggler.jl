"""
    testplutonotebook(notebookname; pluto_project = nothing)

Test pluto notebook in a Pluto session. Core of [`testplutonotebooks`](@ref)
"""
function testplutonotebook(notebookname; pluto_project = Base.active_project())
    if verbose()
        @info "running notebook $(basename(notebookname))"
    end
    if pluto_project != nothing
        ENV["PLUTO_PROJECT"] = pluto_project
    end
    session = Pluto.ServerSession()
    session.options.server.disable_writing_notebook_files = true
    session.options.server.show_file_system = false
    session.options.server.launch_browser = false
    session.options.server.dismiss_update_notification = true
    session.options.evaluation.capture_stdout = false
    session.options.evaluation.workspace_use_distributed = false

    wd = pwd()
    t = @elapsed notebook = Pluto.SessionActions.open(session, notebookname; run_async = false)
    if verbose()
        @info "notebook executed in $(round(t,sigdigits=4)) seconds"
    end
    cd(wd)

    errored = false
    for c in notebook.cells
        if occursin("@test", c.code)
            @test !c.errored
        end
        if c.errored
            errored = true
            @error "Error in  $(c.cell_id): $(c.output.body[:msg])\n\n $(c.code)\n"
        end
    end
    ENV["PLUTO_PROJECT"] = nothing
    !errored
end

"""
     testplutonotebooks(example_dir, notebooks; kwargs...)

Test pluto notebooks as notebooks in a pluto session which means that
the notebook code is run in an extra process.

The method tracks `Test.@test` statements in notebook cells via 
testing errors of failed cells. The method does not invoke eventual `runteststs()` methods
in the notebooks.

Parameters:
- `example_dir`: subdirectory with examples
- `notebooks`: vector of pathnames of notebooks to be tested.

Keyword arguments:
- `pluto_project`: if not `nothing`, this is passed via `ENV["PLUTO_PROJECT"]` to the notebooks with the
  possibility to activate it. By default it has the value of `Base.active_project()` which in practice 
  is the environment `runtests.jl` is running in. 
  As a consequence, if this default is kept, it is necessary to have all package dependencies of the
  notebooks in the package environment.


"""
function testplutonotebooks(example_dir, notebooks; kwargs...)
    for notebook in notebooks
        testplutonotebook(joinpath(example_dir, notebook); kwargs...)
    end
end

"""
     @testplutonotebooks(example_dir,notebooks,  kwargs...)

Macro wrapper for [`testplutonotebooks`](@ref).
Just for aestethic reasons, as other parts of the API have to be macros.
"""
macro testplutonotebooks(example_dir, notebooks, kwargs...)
    esc(:(ExampleJuggler.testplutonotebooks($example_dir, $notebooks; $(kwargs...))))
end

"""
    docplutonotebooks(example_dir, notebooks, kwargs...)

Parameters:
- `notebooks`: vector of pathnames or pairs of pathnames and strings pointing to  notebooks to be tested.

Keyword arguments:
- `pluto_project`: if not `nothing`, this is passed via `ENV["PLUTO_PROJECT"]` to the notebooks with the
  possibility to activate it. By default it has the value of `Base.active_project()` which in practice 
  is the environment `runtests.jl` is running in. 
  As a consequence, if this default is kept, it is necessary to have all package dependencies of the
  notebooks in the package environment.
- `iframe`: boolean (default: false). 
    - If `true`, html files are produced from the notebooks via `PlutoSliderServer.jl`, similar to Pluto's
      html export. For documenter, a markdown page is created which contains statements to show the 
      notebook html in an iframe. The advantage of this method is that active javascript content is shown.
      The disadvantage is weak integration into documenter.
    - If false, Documenter markdown files are ceated via `PlutoStaticHTML.jl`. These integrate well with
      Documenter, but are (as of now) unable to show active javascript content. Graphics is best prepared
      with CairoMakie.
- `source_prefix`: Path prefix to the notebooks on github (for generating download links)
   Default: "https://github.com/j-fu/ExampleJuggler.jl/blob/main/examples".
- `iframe_height`: Height of the iframe generated. Default: "500px".
Return value: Vector of pairs of pathnames and strings pointing to generated markdown files for use in 
`Documenter.makedocs()`

"""
function docplutonotebooks(example_dir, notebooklist;
                           iframe = false,
                           source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blob/main/examples",
                           iframe_height = "500px",
                           pluto_project = Base.active_project())
    notebooklist = homogenize_notebooklist(notebooklist)
    notebooks = last.(notebooklist)
    if iframe
        mdpaths = docplutosliderserver(example_dir, notebooks; pluto_project, source_prefix, iframe_height)
    else
        mdpaths = docplutostatichtml(example_dir, notebooks; pluto_project)
    end
    Pair.(first.(notebooklist), mdpaths)
end

"""
    @docplutonotebooks(example_dir, notebooklist, kwargs...)

Macro wrapper for [`docplutonotebooks`](@ref).
Just for aestethic reasons, as other parts of the API have to be macros.
"""
macro docplutonotebooks(example_dir, notebooklist, kwargs...)
    esc(:(docplutonotebooks($example_dir, $notebooklist; $(kwargs...))))
end
