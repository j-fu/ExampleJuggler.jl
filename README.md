[![ci](https://github.com/j-fu/ExampleJuggler.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/j-fu/ExampleJuggler.jl/actions/workflows/ci.yml)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://j-fu.github.io/ExampleJuggler.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://j-fu.github.io/ExampleJuggler.jl/dev)
[![stability-beta](https://img.shields.io/badge/stability-beta-33bbff.svg)](https://github.com/mkenney/software-guides/blob/master/STABILITY-BADGES.md#beta)

# ExampleJuggler.jl

This package also could be called "DocumenterAndTestExampleHandler.jl". It helps to maintain comprehensive complete (i.e. ready to download and run) code examples in Documenter.jl documentation.

Code examples could be in plain Julia scripts, Julia scripts containing modules or pluto notebooks and serve three purposes:
- Ready to be run by users
- Part of CI tests
- Well integrated into documenter based documentation (via [Literate.jl](https://github.com/fredrikekre/Literate.jl), [PlutoStaticHTML.jl](https://github.com/rikhuijzer/PlutoStaticHTML.jl) or [PlutoSliderServer.jl](https://github.com/JuliaPluto/PlutoSliderServer.jl))
  
Maintaining a list of examples leads to considerable boilerplate ("example juggling" - that is why the name ...) in `test/runtest.jl` and `docs/make.jl`.
This package helps to hide this boilerplate behind its API.

## Breaking changes

- v2.0.0: Moved all direct and indirect dependencies on Pluto into extensions. Correspondingly, one needs to
  explicitely import Pluto, PlutoStaticHTML or PlutoSliderServer. They are not anymore direct dependencies of
  ExampleJuggler.

## CI Tests

With this package, `test/runtests.jl` can look  as follows:

```julia
using Test
using ExampleJuggler
import Pluto

ExampleJuggler.verbose!(true)

example_dir = joinpath(@__DIR__, "..", "examples")

modules = ["ExampleModule.jl"]
notebooks = ["PlutoTemplate.jl", "ExamplePluto.jl"]
scripts = ["testscript.jl", "PlutoTemplate.jl", "ExamplePluto.jl"]

@testset "pluto notebooks" begin
    @testplutonotebooks(example_dir, notebooks)
end

@testset "module examples" begin
    @testmodules(example_dir, modules, a=2)
end

@testset "scripts + notebooks" begin
    @testscripts(example_dir, scripts)
end
```

## Documenter build
With this package, `docs/make.jl` can look  as follows (please see [`docs/make.jl`](https://github.com/j-fu/ExampleJuggler.jl/blob/main/docs/make.jl) of this
package for a more comprehensive setting):

```julia 
using Documenter, ExampleJuggler, CairoMakie

DocMeta.setdocmeta!(ExampleJuggler, :DocTestSetup, :(using ExampleJuggler); recursive = true)

example_dir = joinpath(@__DIR__, "..", "examples")

modules = ["ExampleModule.jl"]
    
notebooks = ["PlutoTemplate.jl"
                 "Example with Graphics" => "ExamplePluto.jl"]

cleanexamples()

module_examples = @docmodules(example_dir, example_modules, Plotter=CairoMakie)

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

html_examples = @docplutonotebooks(example_dir, notebooks

cleanexamples()

deploydocs(; repo = "github.com/j-fu/ExampleJuggler.jl.git", devbranch = "main")

end
```
In particular, graphics generation for module examples is supported.

