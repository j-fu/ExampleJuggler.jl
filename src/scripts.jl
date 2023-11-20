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
