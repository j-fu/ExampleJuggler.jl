# Changelog

All notable changes to this project will be documented in this file.

## [2.4.0] - 2025-10-31
- Improve error output for script testing
- get rid of Base.get_extension

## [2.3.1] - 2025-10-22

 - use `invokelatest` in `plotmodule` to be in line with strict world age semantics from Julia 1.12 (see [Julia#58511](github.com/JuliaLang/julia/issues/58511))

## [2.3.0] - 2025-07-04

- Update notebook environments
- Improve documentation
- Runic formatting
- Allow parallel execution of notebooks in @docplutosliderserver
  - Use asyncmap and ChunkSplitters.chunks to organize this
  - Add ntasks option to @docplutonotebook (default value is Threads.@nthreads)
- Minimum Julia 1.9 
  - remove support of Requires
  
## [2.2.0] - 2025-02-12

- More invokelatest statements to satisfy 1.12
  Needed also now for accessing newly defined module, not only its functions.

## [2.1.0] - 2024-11-05

- Update to PlutoStaticHTML v7 and Pluto v0.20
- Add `append_build_context` option
- Allow PlutoSliderSever v1
- Pass append_build_context to PlutoStaticHTML

## [2.0.1] - 2024-03-09

- CI on apple silicon
- Added aqua test, undocumented docstrings test

## [2.0.0] - 2024-02-20

- Breaking: One needs to  import Pluto, PlutoStaticHTML  or PlutoSliderServer
- Move all direct and indirect dependencies on Pluto into extensions. 

## [1.0.0] - 2024-02-02

- Use distributed for static html generation from notebooks
- Add `use_module_titles` flag for @docmodules
- Set version to 1.0.0 for full SemVer

