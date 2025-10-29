"""
    docplutostatichtml(example_dir, notebooks;
                       pluto_project = nothing, 
                       ntasks = Threads.nthreads())


Document notebooks via  [PlutoStaticHTML.jl](https://github.com/rikhuijzer/PlutoStaticHTML.jl).
Implemented in extension `ExampleJugglerPlutoStaticHTMLExt`.

Parameters:
- `example_dir`: Directory where notebooks reside.
- `notebooks`: Vector of notebook file names relative to `example_dir`.

Keyword arguments:
- `pluto_project`: passed as `ENV[PLUTO_PROJECT]` to notebooks. See [`testplutonotebooks`](@ref) for explanation.
- `ntasks`: number of parallel tasks.

Returns: Vector of markdown file names (one for each notebook) ready to be passed to `makedocs`.

"""
function docplutostatichtml(args...; kwargs...)
    error("Please have Pluto in the environment and import/use PlutoStaticHTML.jl in order to use docplutonotebooks with `iframe=false`")
end


"""
    docplutosliderserver(example_dir, notebooks; 
                         pluto_project = nothing, 
                         ntasks = Threads.nthreads(),
                         source_prefix = "",
                         iframe_height = "500px",
                         force = true)

Document notebooks via  [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl)
Implemented in extension `ExampleJugglerPlutoSliderServerExt`. Rendered 
notebooks will appear in iframes.

Parameters:
- `example_dir`: Directory where notebooks reside
- `notebooks`: Vector of notebook file names relative to `example_dir`

Keyword arguments:
- `pluto_project`: passed as `ENV[PLUTO_PROJECT]` to notebooks.  See [`testplutonotebooks`](@ref) for explanation.
- `ntasks`: number of parallel tasks.
- `source_prefix`: Prefix of notebook source file on github.
- `iframe_height`: Height of iframe.
- `force`: force ovewriting of already rendered notebooks.


Returns: Vector of markdown file names (one for each notebook) ready to be passed to `makedocs`.


"""
function docplutosliderserver(args...; kwargs...)
    error("Please import/use PlutoSliderServer.jl in order to use docplutonotebooks with `iframe=true`")
end


"""
    testplutonotebook(notebookname; 
                      pluto_project = nothing)

Test pluto notebook in a Pluto session. Core of [`testplutonotebooks`](@ref).
Implemented in extension `ExampleJugglerPlutoExt`.
"""
function testplutonotebook(args...; kwargs...)
    error("Please import/use Pluto.jl in order to use testplutonotebooks()")
end


"""
     testplutonotebooks(example_dir, notebooks; kwargs...)

Test pluto notebooks as notebooks in a pluto session which means that
the notebook code is run in an extra process. Implemented in an extension triggered
by `using Pluto`.

The method tracks `Test.@test` statements in notebook cells via 
testing errors of failed cells. The method does not invoke eventual `runteststs()` methods
in the notebooks.

Parameters:
- `example_dir`: subdirectory with examples
- `notebooks`: vector of pathnames of notebooks to be tested.

Keyword arguments:
- `pluto_project`: if not `nothing`, this is passed via `ENV["PLUTO_PROJECT"]` to the notebooks.
  By default it has the value of `Base.active_project()` which in practice 
  is the environment `runtests.jl` is running in. 
  As a consequence, if this default is kept, it is necessary to have all package dependencies of the
  notebooks in the package environment.
  In a notebook  it can be activated like:
```
    import Pkg as _Pkg
    haskey(ENV, "PLUTO_PROJECT") && _Pkg.activate(ENV["PLUTO_PROJECT"])
```


"""
function testplutonotebooks(example_dir, notebooks; kwargs...)
    for notebook in notebooks
        testplutonotebook(joinpath(example_dir, notebook); kwargs...)
    end
    return
end


"""
     @testplutonotebooks(example_dir,notebooks,  kwargs...)

Macro wrapper for [`testplutonotebooks`](@ref).
Just for aestethic reasons, as other parts of the API have to be macros.
"""
macro testplutonotebooks(example_dir, notebooks, kwargs...)
    return esc(:(ExampleJuggler.testplutonotebooks($example_dir, $notebooks; $(kwargs...))))
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
    - If `true`, html files are produced from the notebooks via [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl), similar to Pluto's
      html export. For documenter, a markdown page is created which contains statements to show the 
      notebook html in an iframe. The advantage of this method is that active javascript content is shown.
      The disadvantage is weak integration into documenter. Prerequisite is `import PlutoSliderServer` in `docs/make.jl`.
    - If false, Documenter markdown files are ceated via  [PlutoStaticHTML.jl](https://github.com/rikhuijzer/PlutoStaticHTML.jl). These integrate well with
      Documenter, but are (as of now) unable to show active javascript content. Graphics is best prepared
      with CairoMakie. Prerequisite is `import PlutoStaticHTML` in `docs/make.jl`.
- `distributed`: Use parallel evaluation
- `ntasks` (default: `Threads.nthreads()`: Number of parallel tasks
- `append_build_context`: pass this to [PlutoStaticHTML.OutputOptions](https://plutostatichtml.huijzer.xyz/dev/#PlutoStaticHTML.OutputOptions).
   Possibly needed when running the notebook in external environment.
- `source_prefix`: Path prefix to the notebooks on github (for generating download links)
   Default: "https://github.com/j-fu/ExampleJuggler.jl/blob/main/examples".
- `iframe_height`: Height of the iframe generated. Default: "500px".
Return value: Vector of pairs of pathnames and strings pointing to generated markdown files for use in 
`Documenter.makedocs()`

"""
function docplutonotebooks(
        example_dir, notebooklist;
        iframe = false,
        source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blob/main/examples",
        iframe_height = "500px",
        distributed = true,
        ntasks = Threads.nthreads(),
        append_build_context = true,
        pluto_project = Base.active_project()
    )
    startroot!(pwd())
    thisdir = pwd()
    notebooklist = homogenize_notebooklist(notebooklist)
    notebooks = last.(notebooklist)
    if iframe
        mdpaths = docplutosliderserver(example_dir, notebooks; pluto_project, source_prefix, iframe_height, ntasks)
    else
        mdpaths = docplutostatichtml(example_dir, notebooks; append_build_context, distributed, pluto_project, ntasks)
    end
    cd(thisdir)
    return Pair.(first.(notebooklist), mdpaths)
end

"""
    @docplutonotebooks(example_dir, notebooklist, kwargs...)

Macro wrapper for [`docplutonotebooks`](@ref).
Just for aestethic reasons, as other parts of the API have to be macros.
"""
macro docplutonotebooks(example_dir, notebooklist, kwargs...)
    return esc(:(docplutonotebooks($example_dir, $notebooklist; $(kwargs...))))
end
