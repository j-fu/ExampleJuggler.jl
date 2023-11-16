"""
$(SIGNATURES)

Replace SOURCE_URL marker with url of source.
Used for preprocessing the input of `Literate.markdown` in [`ExampleJuggler.docliterate`](@ref).
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
         docliterate(example_sources;
                     with_plots = false,
                     Plotter = nothing,
                     example_subdir = "literate_examples",
                     source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blobs/main/examples",
                     info = false,
                     clean = true)

Generate markdown files for use with documenter from list of Julia code examples.
See [ExampleLiterate.jl](@ref) for an example.
"""
function docliterate(example_sources;
                     with_plots = false,
                     Plotter = nothing,
                     example_subdir = "literate_examples",
                     source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blobs/main/examples",
                     info = false,
                     clean = true)
    if basename(pwd()) == "docs" # run from docs subdirectory, e.g, during developkment
        example_md_dir = joinpath("src", example_subdir)
    else # standard case with ci
        example_md_dir = joinpath("docs", "src", example_subdir)
    end
    if clean
        rm(example_md_dir; recursive = true, force = true)
        if info
            @info "removed $(example_md_dir)"
        end
    end
    for example_source in example_sources
        example_base, ext = splitext(example_source)
        if ext == ".jl"
            source_url = source_prefix * "/" * basename(example_source)
            Literate.markdown(example_source,
                              example_md_dir;
                              info,
                              preprocess = buffer -> replace_source_url(buffer, source_url))

            if with_plots
                example_module = include(example_source)
                if isdefined(example_module, :genplots)
                    if info
                        @info "generating plots from $(example_source)"
                    end
                    # see https://docs.julialang.org/en/v1/manual/methods/#Redefining-Methods
                    Base.invokelatest(example_module.genplots, example_md_dir; Plotter)
                end
            end
        else
            @warn "$(example_source) is not a Julia file, skipping"
        end
    end
    joinpath.(example_subdir, filter(fname -> splitext(fname)[end] == ".md", readdir(example_md_dir)))
end

docliterate(example_source::String; kwargs...) = literate([example_source]; kwargs...)

"""
    testliterate(example_sources;
                 info = false,
                 with_timing = false)

Test the literate files by calling the the `test()` method of the module.
"""
function testliterate(example_sources;
                      info = false,
                      with_timing = false)
    for example_source in example_sources
        if info
            @info "testing $(example_source)"
        end
        example_module = include(example_source)
        @test Base.invokelatest(example_module.test)
        if with_timing
            @time Base.invokelatest(example_module.test)
        end
    end
end
