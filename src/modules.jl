"""
$(SIGNATURES)

Replace SOURCE_URL marker with url of source.
Used for preprocessing the input of `Literate.markdown` in [`ExampleJuggler.docmodules`](@ref).
"""
function replace_source_url(input, source_url)
    lines_in = collect(eachline(IOBuffer(input)))
    lines_out = IOBuffer()
    for line in lines_in
        println(lines_out, replace(line, "@__SOURCE_URL__" => source_url))
    end
    return String(take!(lines_out))
end

"""
    @plotmodule(modules, kwargs...)

Include module into context of calling module and execute `generateplots(;kwargs...)` if it exists.
"""
macro plotmodule(source, kwargs...)
    esc(:(mod = include($source);
          if isdefined(mod, :generateplots)
              ExampleJuggler.verbose() && @info "generating plots for " * normpath($(source))
              invokelatest(getproperty(mod, :generateplots), ExampleJuggler.example_md_dir(ExampleJuggler.module_examples);
                           $(kwargs...))
          end))
end

"""
    @plotmodules(modules, kwargs...)

Plot several scripts defining modules via [`@plotmodule`](@ref).
"""
macro plotmodules(example_dir, modules, kwargs...)
    esc(quote
            sources = last.(ExampleJuggler.homogenize_notebooklist($modules))
            for source in sources
                ExampleJuggler.@plotmodule(joinpath(example_dir, source), $(kwargs...))
            end
        end)
end

"""
         docmodules(example_sources; kwargs...)

Generate markdown files for use with documenter from list of Julia code examples via [Literate.jl](https://github.com/fredrikekre/Literate.jl).
See [ExampleModule.jl](@ref) for an example.
"""
function docmodules(example_dir, modules; kwargs...)
    md_dir = example_md_dir(module_examples)
    modulelist = homogenize_notebooklist(modules)
    modules = last.(modulelist)
    example_sources = joinpath.(example_dir, modules)
    example_md = String[]
    for example_source in example_sources
        cp(example_source, joinpath(example_md_dir(ExampleJuggler.module_examples), basename(example_source)))
        example_base, ext = splitext(example_source)
        if ext == ".jl"
            Literate.markdown(example_source,
                              md_dir;
                              info = verbose(),
                              preprocess = buffer -> replace_source_url(buffer, basename(example_source)))
        else
            @warn "$(example_source) appears to be not a Julia file, skipping"
        end
        push!(example_md, joinpath(module_examples, splitext(basename(example_source))[1] * ".md"))
    end
    Pair.(first.(modulelist), example_md)
end

"""
    @docmodules(example_dir, modules, kwargs...)

Generate markdown files and plots for use with documenter from list of Julia modules.
Wrapper macro for [`docmodules`](@ref).
"""
macro docmodules(example_dir, modules, kwargs...)
    esc(:(ExampleJuggler.@plotmodules(example_dir, modules, $(kwargs...));
          ExampleJuggler.docmodules(example_dir, modules;
                                    $(kwargs...))))
end

"""
    @testmodule
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
    @testmodules(example_dir,modules, kwargs...)

Test several scripts defining modules via [`@testmodule`](@ref).
"""
macro testmodules(example_dir, sources, kwargs...)
    esc(quote
            for source in $(sources)
                ExampleJuggler.@testmodule(joinpath(example_dir, source), $(kwargs...))
            end
        end)
end
