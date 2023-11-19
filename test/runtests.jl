using Test
using ExampleJuggler

ExampleJuggler.verbose!(true)

example_sources = joinpath.(@__DIR__, "..", "examples", ["ExampleLiterate.jl"])
example_notebooks = joinpath.(@__DIR__, "..", "examples", ["PlutoTemplate.jl", "ExamplePluto.jl"])
example_scripts = joinpath.(@__DIR__, "..", "examples", ["testscript.jl", "PlutoTemplate.jl", "ExamplePluto.jl"])
plutoenv = joinpath(@__DIR__, "..", "examples", "plutoenv")

@testset "pluto notebooks" begin
    testplutonotebooks(example_notebooks; plutoenv)
end

@testset "literate examples" begin
    @testmodules(example_sources, a=2)
end

@testset "scripts" begin
    @testscripts(example_scripts, a=3)
end
