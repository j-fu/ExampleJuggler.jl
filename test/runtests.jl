using Test
using ExampleJuggler

ExampleJuggler.verbose!(true)

example_dir = joinpath(@__DIR__, "..", "examples")

modules = ["ExampleLiterate.jl"]
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
