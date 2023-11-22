using Test
using ExampleJuggler

ExampleJuggler.verbose!(true)

example_dir = joinpath(@__DIR__, "..", "examples")

modules = ["ExampleModule.jl"]
notebooks = ["PlutoTemplate.jl", "ExamplePluto.jl"]
scripts = ["ExampleScript.jl"]

@testset "pluto notebooks" begin
    @testplutonotebooks(example_dir, notebooks)
end

@testset "notebooks as scripts" begin
    @testscripts(example_dir, notebooks)
end

@testset "module examples" begin
    @testmodules(example_dir, modules, a=2)
end

@testset "scripts" begin
    @testscripts(example_dir, scripts)
end
