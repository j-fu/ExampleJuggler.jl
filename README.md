[![ci](https://github.com/j-fu/ExampleJuggler.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/j-fu/ExampleJuggler.jl/actions/workflows/ci.yml)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://j-fu.github.io/ExampleJuggler.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://j-fu.github.io/ExampleJuggler.jl/dev)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

# ExampleJuggler.jl

This package also could be called "DocumenterAndTestExampleHandler.jl". It helps to maintain comprehensive complete (i.e. ready to download and run) code examples in Documenter.jl documentation.

Code examples could be in plain Julia scripts, Julia scripts containing modules or pluto notebooks and serve three purposes:
- Ready to be run by users
- Part of CI tests
- Well integrated into documenter based documentation (via [Literate.jl](https://github.com/fredrikekre/Literate.jl), [PlutoStaticHTML.jl](https://github.com/rikhuijzer/PlutoStaticHTML.jl) or [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl))
  
Maintaining a list of examples leads to considerable boilerplate ("example juggling" - that is why the name ...) in `test/runtest.jl` and `docs/make.jl`.
This package helps to hide this boilerplate behind its API.

## CI Tests

With this package, `test/runtests.jl` can look  as follows(please see [`test/runtests.jl`](https://github.com/j-fu/ExampleJuggler.jl/blob/main/test/runtests.jl) of this
package for a more comprehensive setting):

```julia
using Test
using ExampleJuggler
import Pluto

ExampleJuggler.verbose!(true)

example_dir = joinpath(@__DIR__, "..", "examples")

modules = ["ExampleModule.jl"]
notebooks = ["PlutoTemplate.jl", "ExamplePluto.jl"]
scripts = ["testscript.jl", "PlutoTemplate.jl", "ExamplePluto.jl"]

# This needs `import Pluto`
@testset "pluto notebooks" begin
    @testplutonotebooks(example_dir, notebooks)
end

@testset "module examples" begin
    @testmodules(example_dir, modules, a=2)
end

# This tests Pluto notebooks as scripts and doesn't need Pluto
@testset "scripts + notebooks" begin
    @testscripts(example_dir, scripts)
end
```

## Documenter build
With this package, `docs/make.jl` can look  as follows (please see [`docs/make.jl`](https://github.com/j-fu/ExampleJuggler.jl/blob/main/docs/make.jl) of this
package for a more comprehensive setting):

```julia 
using Documenter, ExampleJuggler, CairoMakie
import PlutoStaticHTML

DocMeta.setdocmeta!(ExampleJuggler, :DocTestSetup, :(using ExampleJuggler); recursive = true)

example_dir = joinpath(@__DIR__, "..", "examples")

modules = ["ExampleModule.jl"]
    
notebooks = ["PlutoTemplate.jl"
                 "Example with Graphics" => "ExamplePluto.jl"]

cleanexamples()

module_examples = @docmodules(example_dir, example_modules, Plotter=CairoMakie)

# This needs to load PlutoStaticHTML
html_examples = @docplutonotebooks(example_dir, notebooks)

makedocs(; sitename = "ExampleJuggler.jl",
           modules = [ExampleJuggler],
           format = Documenter.HTML(; size_threshold_ignore = last.(html_examples),
                                      mathengine = MathJax3()),
             authors = "J. Fuhrmann",
             repo = "https://github.com/j-fu/ExampleJuggler.jl",
             pages = [
                 "api.md",
                 "Modules" => module_examples,
                 "Notebooks" => html_examples,
             ])


cleanexamples()

deploydocs(; repo = "github.com/j-fu/ExampleJuggler.jl.git", devbranch = "main")

end
```
In particular, graphics generation for module and script examples is supported.

