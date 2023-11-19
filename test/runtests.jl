using Test
using ExampleJuggler

ExampleJuggler.verbose!(true)
@info ExampleJuggler.verbose()

example_sources = joinpath.(@__DIR__, "..", "examples", ["ExampleLiterate.jl"])
example_notebooks = joinpath.(@__DIR__, "..", "notebooks", ["PlutoTemplate.jl", "ExamplePluto.jl"])
example_scripts = joinpath.(@__DIR__, "..", "examples", ["testscript.jl", "PlutoTemplate.jl", "ExamplePluto.jl"])
plutoenv = joinpath(@__DIR__, "..", "examples", "plutoenv")

@testset "literate examples" begin
    @testmodules(example_sources, a=2)
end

@testset "scripts" begin
    @testscripts(example_scripts, a=3)
end
