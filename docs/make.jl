using Documenter, ExampleJuggler, CairoMakie
import PlutoStaticHTML, PlutoSliderServer

ExampleJuggler.verbose!(true)

function mkdocs()
    DocMeta.setdocmeta!(ExampleJuggler, :DocTestSetup, :(using ExampleJuggler); recursive = true)

    example_dir = joinpath(@__DIR__, "..", "examples")

    scripts = ["ExampleScript.jl"]
    modules = ["ExampleModule.jl"]

    notebooks = [
        "PlutoTemplate.jl"
        "Example with Graphics" => "ExamplePluto.jl"
    ]

    cleanexamples()

    script_examples = @docscripts(example_dir, scripts)
    module_examples = @docmodules(example_dir, modules, Plotter = CairoMakie)
    html_examples = @docplutonotebooks(example_dir, notebooks, iframe = false)
    pluto_examples = @docplutonotebooks(example_dir, notebooks, iframe = true)

    makedocs(;
        sitename = "ExampleJuggler.jl",
        modules = [ExampleJuggler],
        clean = false,
        doctest = true,
        format = Documenter.HTML(;
            size_threshold_ignore = last.(html_examples),
            mathengine = MathJax3()
        ),
        authors = "J. Fuhrmann",
        repo = "https://github.com/j-fu/ExampleJuggler.jl",
        pages = [
            "Home" => "index.md",
            "api.md",
            "Modules" => module_examples,
            "Scripts" => script_examples,
            "Notebooks" => html_examples,
            "Notebooks in iframe" => pluto_examples,
            "mock.md",
            "internal.md",
        ]
    )

    cleanexamples()

    return if !isinteractive()
        deploydocs(; repo = "github.com/j-fu/ExampleJuggler.jl.git", devbranch = "main")
    end
end

mkdocs()
