"""
    testscript(script)

Wrap script (or Pluto notebook seen as script) into a custom module and evaluate
it in the context of the calling module. If the script contains a function 
`runtests`, call it. It is assumed that the script uses `Test.@test` to
test correctness. 
"""
macro testscript(source, kwargs...)
    esc(:(ExampleJuggler.verbose() && @info "testing " * basename($(source));
          mod = eval(ExampleJuggler.parsescript($(source)));
          if Base.invokelatest(isdefined, mod, :runtests)
              Base.invokelatest(Base.invokelatest(getproperty, mod, :runtests); $(kwargs...))
          end))
end

randmod() = "mod" * string(uuid1())[1:8]
parsescript(source) = Meta.parse("module " * ExampleJuggler.randmod() * "\n\n" * read(source, String) * "\n\nend")

"""
    @testscripts(example_dir, scripts)
    
Run scripts in the context of the calling module via [`@testscript`](@ref)
"""
macro testscripts(example_dir, sources, kwargs...)
    esc(quote
            for source in $(sources)
                ExampleJuggler.@testscript(joinpath($(example_dir), source), $(kwargs...))
            end
        end)
end

macro plotscript(source, kwargs...)
    esc(:(mod = eval(ExampleJuggler.parsescript($(source)));
          if isdefined(mod, :generateplots)
              ExampleJuggler.verbose() && @info "generating plots for " * normpath($(source))
              Base.invokelatest(getproperty(mod, :generateplots), ExampleJuggler.example_md_dir(ExampleJuggler.script_examples);
                                $(kwargs...))
          end))
end

macro plotscripts(example_dir, modules, kwargs...)
    esc(quote
            sources = last.(ExampleJuggler.homogenize_notebooklist($(modules)))
            for source in sources
                base, ext = splitext(source)
                if ext == ".jl"
                    ExampleJuggler.@plotscript(joinpath($example_dir, source), $(kwargs...))
                end
            end
        end)
end

"""
    @docscripts(example_dir, modules, kwargs...)

Generate markdown files and plots for use with documenter from list of Julia modules.
Wrapper macro for [`docmodules`](@ref).
"""
macro docscripts(example_dir, modules, kwargs...)
    esc(:(ExampleJuggler.@plotscripts($example_dir, $modules, $(kwargs...));
          ExampleJuggler.docmodules($example_dir, $modules; x_examples = ExampleJuggler.script_examples,
                                    $(kwargs...))))
end
