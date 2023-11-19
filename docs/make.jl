using Documenter, ExampleJuggler, CairoMakie

ExampleJuggler.verbose!(true)

function mkdocs()
    DocMeta.setdocmeta!(ExampleJuggler, :DocTestSetup, :(using ExampleJuggler); recursive = true)

    example_sources = [joinpath(@__DIR__, "..", "examples", "ExampleLiterate.jl")]

    literate_examples = docliterate(example_sources)

    @plotmodules(example_sources, Plotter=CairoMakie)

    makedocs(; sitename = "ExampleJuggler.jl",
             modules = [ExampleJuggler],
             clean = false,
             doctest = true,
             authors = "J. Fuhrmann",
             repo = "https://github.com/j-fu/ExampleJuggler.jl",
             pages = [
                 "Home" => "index.md",
                 "api.md",
                 "mock.md",
                 "Literate" => literate_examples,
                 "internal.md",
             ])

    cleanliterate()

    if !isinteractive()
        deploydocs(; repo = "github.com/j-fu/ExampleJuggler.jl.git", devbranch = "main")
    end
end

mkdocs()
