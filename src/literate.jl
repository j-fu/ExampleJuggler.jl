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
         docmodules(example_sources;
                     source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blobs/main/examples")

Generate markdown files for use with documenter from list of Julia code examples.
See [ExampleLiterate.jl](@ref) for an example.
"""
function docmodules(example_sources;
                    source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blobs/main/examples")
    md_dir = example_md_dir("modules")
    example_md = String[]
    for example_source in example_sources
        example_base, ext = splitext(example_source)
        if ext == ".jl"
            source_url = source_prefix * "/" * basename(example_source)
            Literate.markdown(example_source,
                              md_dir;
                              info = verbose(),
                              preprocess = buffer -> replace_source_url(buffer, source_url))
        else
            @warn "$(example_source) appears to be not a Julia file, skipping"
        end
        push!(example_md, joinpath(example_subdir, "modules", splitext(basename(example_source))[1] * ".md"))
    end
    example_md
end

docmodule(example_source::String; kwargs...) = documodules([example_source]; kwargs...)
