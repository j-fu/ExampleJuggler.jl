"""
    testscript(script)

Wrap script (or Pluto notebook seen as script) into a custom module and evaluate
it in the context of the calling module. If the script contains a function 
`runtests`, call it. It is assumed that the script uses `Test.@test` to
test correctness. 
"""
macro testscript(source, kwargs...)
    esc(:(mod = eval(ExampleJuggler.parsescript($(source)));
          if isdefined(mod, :runtests)
              ExampleJuggler.verbose() && @info "calling runtests() from " * normpath($(source))
              invokelatest(getproperty(mod, :runtests); $(kwargs...))
          end))
end

randmod() = "mod" * string(uuid1())[1:8]
parsescript(source) = Meta.parse("module " * ExampleJuggler.randmod() * "\n\n" * read(source, String) * "\n\nend")

"""
    @testscripts(scripts)
    
Run scripts in the context of the calling module via [`@testscript`](@ref)
"""
macro testscripts(sources, kwargs...)
    esc(quote
            for source in $(sources)
                ExampleJuggler.@testscript(source, $(kwargs...))
            end
        end)
end

"""
    testmodule(module, kwargs...)

Include script defining a module in the context of the calling module and call the `runtests` method
if it is defined in this module, passing `kwargs...`.
"""
macro testmodule(source, kwargs...)
    esc(:(mod = include($source);
          if isdefined(mod, :runtests)
              ExampleJuggler.verbose() && @info "calling runtests() from " * normpath($(source))
              invokelatest(getproperty(mod, :runtests); $(kwargs...))
          end))
end

"""
    @testmodules(modules, kwargs...)

Test several scripts defining modules via [`@testmodule`](@ref).
"""
macro testmodules(sources, kwargs...)
    esc(quote
            for source in $(sources)
                ExampleJuggler.@testmodule(source, $(kwargs...))
            end
        end)
end

"""
    @plotmodule(modules, kwargs...)

Include module into context of calling module and execute `genplots(;kwargs...)` if it exists.
"""
macro plotmodule(source, kwargs...)
    esc(:(mod = include($source);
          if isdefined(mod, :genplots)
              ExampleJuggler.verbose() && @info "generating plots for " * normpath($(source))
              invokelatest(getproperty(mod, :genplots), ExampleJuggler.example_md_dir("modules"); $(kwargs...))
          end))
end

"""
    @plotmodules(modules, kwargs...)

Plot several scripts defining modules via [`@plotmodule`](@ref).
"""
macro plotmodules(sources, kwargs...)
    esc(quote
            for source in $(sources)
                ExampleJuggler.@plotmodule(source, $(kwargs...))
            end
        end)
end
