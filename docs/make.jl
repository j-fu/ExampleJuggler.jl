using Documenter, ExampleJuggler, CairoMakie

ExampleJuggler.verbose!(true)

function mkdocs()
    DocMeta.setdocmeta!(ExampleJuggler, :DocTestSetup, :(using ExampleJuggler); recursive = true)

    example_modules = [joinpath(@__DIR__, "..", "examples", "ExampleLiterate.jl")]
    example_notebooks = joinpath.(@__DIR__, "..", "examples", ["PlutoTemplate.jl", "ExamplePluto.jl"])

    cleanexamples()

    module_examples = docmodules(example_modules)
    @plotmodules(example_modules, Plotter=CairoMakie)
    plutostatichtml_examples = String[]
    plutostatichtml_examples = docplutostatichtml(example_notebooks)
    pluto_examples = docpluto(example_notebooks)

    makedocs(; sitename = "ExampleJuggler.jl",
             modules = [ExampleJuggler],
             clean = false,
             doctest = true,
             format = Documenter.HTML(; size_threshold_ignore = plutostatichtml_examples,
                                      mathengine = MathJax3()),
             authors = "J. Fuhrmann",
             repo = "https://github.com/j-fu/ExampleJuggler.jl",
             pages = [
                 "Home" => "index.md",
                 "api.md",
                 "mock.md",
                 "Modules" => module_examples,
                 "Notebooks1" => plutostatichtml_examples,
                 "Notebooks2" => pluto_examples,
                 "internal.md",
             ])

    cleanexamples()

    if !isinteractive()
        deploydocs(; repo = "github.com/j-fu/ExampleJuggler.jl.git", devbranch = "main")
    end
end

mkdocs()
