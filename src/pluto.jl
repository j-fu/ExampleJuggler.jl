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
     testplutonotebooks(notebooks; kwargs...)

Test pluto notebooks as notebooks in a pluto session which means that
the notebook code is run in an extra process.

The method tracks `Test.@test` statements in notebook cells via 
testing errors of failed cells. The method does not invoke eventual `runteststs()` methods
in the notebooks.

Parameters:
- `notebooks`: vector of pathnames of notebooks to be tested.

Keyword arguments:
- `pluto_project`: if not `nothing`, this is passed via `ENV["PLUTO_PROJECT"]` to the notebooks with the
  possibility to activate it. By default it has the value of `Base.active_project()` which in practice 
  is the environment `runtests.jl` is running in. 
  As a consequence, if this default is kept, it is necessary to have all package dependencies of the
  notebooks in the package environment.


"""
function testplutonotebooks(notebooks; kwargs...)
    for notebook in notebooks
        testplutonotebook(notebook; kwargs...)
    end
end

"""
     @testplutonotebooks(notebooks,  kwargs...)

Macro wrapper for [`testplutonotebooks`](@ref).
Just for aestethic reasons, as other parts of the API have to be macros.
"""
macro testplutonotebooks(notebooks, kwargs...)
    esc(:(ExampleJuggler.testplutonotebooks($notebooks; $(kwargs...))))
end
