using Documenter, ExampleJuggler, CairoMakie

function mkdocs()
    DocMeta.setdocmeta!(ExampleJuggler, :DocTestSetup, :(using ExampleJuggler); recursive = true)

    example_sources = [joinpath(@__DIR__, "..", "examples", "ExampleLiterate.jl")]

    literate_examples = literate(example_sources;
                                 info = true,
                                 Plotter = CairoMakie)

    makedocs(; sitename = "ExampleJuggler.jl",
             modules = [ExampleJuggler],
             clean = false,
             warnonly = true,
             doctest = true,
             authors = "J. Fuhrmann",
             repo = "https://github.com/j-fu/ExampleJuggler.jl",
             pages = [
                 "Home" => "index.md",
                 "api.md",
                 "mock.md",
                 "Literate" => literate_examples,
             ])
    if !isinteractive()
        deploydocs(; repo = "github.com/j-fu/ExampleJuggler.jl.git", devbranch = "main")
    end
end

mkdocs()
