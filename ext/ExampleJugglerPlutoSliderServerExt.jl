module ExampleJugglerPlutoSliderServerExt

using ChunkSplitters: chunks
import Pkg
import ExampleJuggler: docplutosliderserver, verbose, example_md_dir, pluto_examples
import PlutoSliderServer


function docplutosliderserver(
        example_dir, notebooks;
        source_prefix = "https://github.com/j-fu/ExampleJuggler.jl/blob/main/examples",
        iframe_height = "500px",
        force = true,
        pluto_project = Base.active_project(),
        ntasks = Threads.nthreads(),
    )
    if pluto_project != nothing
        Pkg.activate(pluto_project)
        ENV["PLUTO_PROJECT"] = pluto_project
    end

    Export_output_dir = joinpath(example_md_dir(pluto_examples), "..", "..", "build", pluto_examples)
    if verbose()
        @info "notebook output to $(normpath(Export_output_dir))"
    end
    if ntasks < 2
        PlutoSliderServer.export_directory(
            example_dir;
            notebook_paths = notebooks,
            Export_output_dir,
            Export_offer_binder = false
        )
    else
        asyncmap(chunks(notebooks; n = ntasks); ntasks) do chunk
            PlutoSliderServer.export_directory(
                example_dir;
                notebook_paths = collect(chunk),
                Export_output_dir,
                Export_offer_binder = false
            )
        end
    end
    example_md = String[]

    for notebook in notebooks
        base = splitext(basename(notebook))[1]
        cp(joinpath(example_dir, notebook), joinpath(example_md_dir(pluto_examples), basename(notebook)); force)
        mdstring = """
        ##### [$(base).jl](@id $(base))

        [Download]($(basename(notebook))) this [Pluto.jl](https://plutojl.org)  notebook.

        ```@raw html
        <iframe style="height:$(iframe_height)" width="100%" src="../$(base).html"> </iframe>
        ```
        """
        # <iframe sandbox="allow-same-origin" onload="this.style.height=(this.contentWindow.document.body.scrollHeight+20)+'px';" width="100%" src="../$(base).html"> </iframe>
        mdname = base * ".md"
        io = open(joinpath(example_md_dir(pluto_examples), base * ".md"), "w")
        write(io, mdstring)
        close(io)
        push!(example_md, joinpath(pluto_examples, base * ".md"))
    end
    return example_md
end
end
