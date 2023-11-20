[![ci](https://github.com/j-fu/ExampleJuggler.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/j-fu/ExampleJuggler.jl/actions/workflows/ci.yml)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://j-fu.github.io/ExampleJuggler.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://j-fu.github.io/ExampleJuggler.jl/dev)

# ExampleJuggler.jl

This package is still in alpha status.

Following the [DRY mantra](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), provide tools for handling
code examples in  various Julia packages.

Aims of this package are:
- Allow easy download and running of examples for users in form of Pluto notebooks or Julia scripts with modules.
- Provide an easy ways to run examples in CI tests
- Provide different ways to generate documentation from examples:
   - `*.jl |> Literate.jl |> *.md`
   - `pluto*.jl |> PlutoStaticHTML.jl |> *.md`
   - `pluto*.jl |> PlutoSliderServer.jl |> *.html` with iframe embedding into markdown pages
