"""
    replace_source_url(input, source_url)

Replace "@__SOURCE_URL__" marker with url of source.
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
     replace_atat(input)

Replace "@@" marker with "@".
Used for postprocessing the output of `Literate.markdown` in [`ExampleJuggler.docmodules`](@ref).
"""
function replace_atat(input)
    lines_in = collect(eachline(IOBuffer(input)))
    lines_out = IOBuffer()
    for line in lines_in
        println(lines_out, replace(line, "@@" => "@"))
    end
    return String(take!(lines_out))
end


"""
    @plotmodule(modules, kwargs...)

Include module into context of calling module and execute `generateplots(;kwargs...)` if it exists.
"""
macro plotmodule(source, kwargs...)
    return esc(
        :(
            mod = include($source);
            if isdefined(mod, :generateplots)
                ExampleJuggler.verbose() && @info "generating plots for " * normpath($(source))
                Base.invokelatest(
                    getproperty(mod, :generateplots), ExampleJuggler.example_md_dir(ExampleJuggler.module_examples);
                    $(kwargs...)
                )
            end
        )
    )
end

"""
    @plotmodules(modules, kwargs...)

Plot several scripts defining modules via [`@plotmodule`](@ref).
"""
macro plotmodules(example_dir, modules, kwargs...)
    return esc(
        quote
            sources = last.(ExampleJuggler.homogenize_notebooklist($(modules)))
            for source in sources
                base, ext = splitext(source)
                if ext == ".jl"
                    ExampleJuggler.@plotmodule(joinpath($example_dir, source), $(kwargs...))
                end
            end
        end
    )
end

"""
         docmodules(example_dir, example_modules; kwargs...)

Generate markdown files for use with documenter from list of Julia code examples in `example_dir` 
via [Literate.jl](https://github.com/fredrikekre/Literate.jl) in form of modules.

Keyword arguments:

- `use_module_titles`: use titles from module input files
- `use_script_titles`: use titles from script input files

See [ExampleModule.jl](@ref) for an example.
"""
function docmodules(
        example_dir, modules;
        use_module_titles = false,
        use_script_titles = false,
        x_examples = module_examples,
        force = true, kwargs...
    )
    startroot!(pwd())
    thisdir = pwd()
    md_dir = example_md_dir(x_examples)
    modulelist = homogenize_notebooklist(modules)
    modules = last.(modulelist)
    example_sources = joinpath.(example_dir, modules)
    example_md = String[]
    for example_source in example_sources
        example_base, ext = splitext(example_source)
        if ext == ".jl"
            cp(example_source, joinpath(example_md_dir(x_examples), basename(example_source)); force)
            Literate.markdown(
                example_source,
                md_dir;
                documenter = false,
                info = verbose(),
                preprocess = buffer -> replace_source_url(buffer, basename(example_source)),
                postprocess = replace_atat
            )
        else
            @warn "$(example_source) appears to be not a Julia file, skipping"
        end
        push!(example_md, joinpath(x_examples, splitext(basename(example_source))[1] * ".md"))
    end
    cd(thisdir)
    return if use_module_titles || use_script_titles
        example_md
    else
        Pair.(first.(modulelist), example_md)
    end
end

"""
    @docmodules(example_dir, modules, kwargs...)

Generate markdown files and plots (via the respective `generateplots` methods) 
for use with documenter from list of Julia modules.
Wrapper macro for [`docmodules`](@ref) and [`ExampleJuggler.@plotmodules`](@ref).

Parameters:
- `example_dir`: subdirectory where the files coresponding to the modules reside. 
- `modules`: Vector of file names or pairs `"title" => "filename"` as in  
   [Documenter.jl](https://documenter.juliadocs.org/stable/man/guide/#Pages-in-the-Sidebar).

Keyword arguments:

- `use_module_titles`: use titles from module input files
- other `kwargs` are passed to the optional `generateplots` method in the module. 

"""
macro docmodules(example_dir, modules, kwargs...)
    return esc(
        :(
            ExampleJuggler.@plotmodules($example_dir, $modules, $(kwargs...));
            ExampleJuggler.docmodules(
                $example_dir, $modules;
                $(kwargs...)
            )
        )
    )
end

"""
    @testmodule(source, kwargs...)
Include script defining a module in the context of the calling module and call the `runtests` method
if it is defined in this module, passing `kwargs...`.
"""
macro testmodule(source, kwargs...)
    return esc(
        :(
            mod = include($source);
            if Base.invokelatest(isdefined, mod, :runtests)
                ExampleJuggler.verbose() && @info "testing " * basename($(source))
                Base.invokelatest(Base.invokelatest(getproperty, mod, :runtests); $(kwargs...))
            end
        )
    )
end

"""
    @testmodules(example_dir,modules, kwargs...)

Test several scripts defining modules via [`@testmodule`](@ref).
"""
macro testmodules(example_dir, sources, kwargs...)
    return esc(
        quote
            for source in $(sources)
                ExampleJuggler.@testmodule(joinpath($(example_dir), source), $(kwargs...))
            end
        end
    )
end
