using Documenter, ExampleJuggler, CairoMakie

ExampleJuggler.verbose!(true)

function mkdocs()
    DocMeta.setdocmeta!(ExampleJuggler, :DocTestSetup, :(using ExampleJuggler); recursive = true)

    example_sources = [joinpath(@__DIR__, "..", "examples", "ExampleLiterate.jl")]
    example_notebooks = joinpath.(@__DIR__, "..", "examples", ["PlutoTemplate.jl", "ExamplePluto.jl"])
    cleanexamples()

    #    literate_examples = docliterate(example_sources)
    #    @plotmodules(example_sources, Plotter=CairoMakie)

    plutostatichtml_examples = docplutostatichtml(example_notebooks)

    makedocs(; sitename = "ExampleJuggler.jl",
             modules = [ExampleJuggler],
             clean = false,
             doctest = true,
             warnonly = true,
             format = Documenter.HTML(; size_threshold_ignore = plutostatichtml_examples,
                                      mathengine = MathJax3()),
             authors = "J. Fuhrmann",
             repo = "https://github.com/j-fu/ExampleJuggler.jl",
             pages = [
                 "Home" => "index.md",
                 "api.md",
                 "mock.md",
                 #                "Literate" => literate_examples,
                 "Notebooks" => plutostatichtml_examples,
                 "internal.md",
             ])

    cleanexamples()

    if !isinteractive()
        deploydocs(; repo = "github.com/j-fu/ExampleJuggler.jl.git", devbranch = "main")
    end
end

mkdocs()
