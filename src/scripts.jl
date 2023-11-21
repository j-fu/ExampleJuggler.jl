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
          if isdefined(mod, :runtests)
              invokelatest(getproperty(mod, :runtests); $(kwargs...))
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
