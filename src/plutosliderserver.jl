function docpluto(notebooks;
                  source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blobs/main/examples",
                  iframe_height = "500px",
                  plutoenv = Base.active_project())
    if plutoenv != nothing
        Pkg.activate(plutoenv)
        ENV["PLUTO_PROJECT"] = plutoenv
    end

    Export_output_dir = joinpath(example_md_dir("pluto"), "..", "..", "..", "build", example_subdir, "pluto")
    if verbose()
        @info "notebook output to $(normpath(Export_output_dir))"
    end
    export_directory(dirname(notebooks[1]);
                     notebook_paths = basename.(notebooks),
                     Export_output_dir,
                     Export_offer_binder = false)
    example_md = String[]

    for notebook in notebooks
        base = splitext(basename(notebook))[1]
        mdstring = """
##### [$(base).jl](@id $(base))

[Download]($(source_prefix)/$(basename(notebook))) this [Pluto.jl](https://plutojl.org)  notebook.

```@raw html
<iframe style="height:$(iframe_height)" width="100%" src="../$(base).html"> </iframe>
```
"""
        # <iframe sandbox="allow-same-origin" onload="this.style.height=(this.contentWindow.document.body.scrollHeight+20)+'px';" width="100%" src="../$(base).html"> </iframe>
        mdname = base * ".md"
        io = open(joinpath(example_md_dir("pluto"), base * ".md"), "w")
        write(io, mdstring)
        close(io)
        push!(example_md, joinpath(example_subdir, "pluto", base * ".md"))
    end
    example_md
end
