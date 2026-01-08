"""
    @testscript(script, kwargs)

Wrap script (or Pluto notebook seen as script) into a custom module and evaluate
it in the context of the calling module. If the script contains a function 
`runtests`, call `runtests(;kwargs...)`,
It is assumed that the script uses `Test.@test` to test correctness.
"""
macro testscript(source, kwargs...)
    return esc(
        :(
            ExampleJuggler.verbose() && @info "Testing " * basename($(source));
            try
                cd(dirname($source)) do
                    mod = eval(ExampleJuggler.parsescript($(source)))
                    if Base.invokelatest(isdefined, mod, :runtests)
                        Base.invokelatest(Base.invokelatest(getproperty, mod, :runtests); $(kwargs...))
                    end
                end
            catch err
                @error  "Error in $(source): $(err)"
                rethrow(err)
            end
        )
    )
end

"""
    randmod()

Generate a random module name.
"""
randmod() = "mod" * string(uuid1())[1:8]


"""
    parsescript(source)

Read script source, wrap it into a module with random name and return this module.
"""
function parsescript(source)
    modname = ExampleJuggler.randmod()
    mod = Meta.parse("module " * modname * "\n\n" * read(source, String) * "\n\nend")
    return mod
end
"""
    @testscripts(example_dir, scripts, kwargs...)
    
Run scripts in the context of the calling module via [`@testscript`](@ref)
"""
macro testscripts(example_dir, sources, kwargs...)
    return esc(
        quote
            for source in $(sources)
                ExampleJuggler.@testscript(joinpath($(example_dir), source), $(kwargs...))
            end
        end
    )
end

"""
    @plotscript(script, kwargs...)
    
Wrap script into a custom module and evaluate
it in the context of the calling module. If the script contains a function 
`generateplots`, call it as  `generateplots(output_dir; kwargs...)` where
`output_dir` is the name of the directory where the plot files should be written.
"""
macro plotscript(source, kwargs...)
    return esc(
        :(
            mod = eval(ExampleJuggler.parsescript($(source)));
            if isdefined(mod, :generateplots)
                ExampleJuggler.verbose() && @info "generating plots for " * normpath($(source))
                Base.invokelatest(
                    getproperty(mod, :generateplots), ExampleJuggler.example_md_dir(ExampleJuggler.script_examples);
                    $(kwargs...)
                )
            end
        )
    )
end

"""
    @plotscripts(example_dir, scripts, kwargs...)
    
Run  [`ExampleJuggler.@plotscript`](@ref) for each script in `scripts`.
"""
macro plotscripts(example_dir, scripts, kwargs...)
    return esc(
        quote
            sources = last.(ExampleJuggler.homogenize_notebooklist($(scripts)))
            for source in sources
                base, ext = splitext(source)
                if ext == ".jl"
                    ExampleJuggler.@plotscript(joinpath($example_dir, source), $(kwargs...))
                end
            end
        end
    )
end

"""
    @docscripts(example_dir, scripts, kwargs...)

Generate markdown files and plots  (via the respective `generateplots` methods) for use with documenter from list of Julia scripts. Wrapper macro for  [`ExampleJuggler.@plotscripts`](@ref) and  [`docmodules`](@ref). 


Parameters:
- `example_dir`: subdirectory where the files corresponding to the modules reside. 
- `scripts`: Vector of file names or pairs `"title" => "filename"` as in  
   [Documenter.jl](https://documenter.juliadocs.org/stable/man/guide/#Pages-in-the-Sidebar).

Keyword arguments:

- `use_script_titles`: use titles from script input files
- Other keyword arguments can be used to pass information to `generateplots` of each of the scripts.

"""
macro docscripts(example_dir, scripts, kwargs...)
    return esc(
        :(
            ExampleJuggler.@plotscripts($example_dir, $scripts, $(kwargs...));
            ExampleJuggler.docmodules(
                $example_dir, $scripts; x_examples = ExampleJuggler.script_examples,
                $(kwargs...)
            )
        )
    )
end
