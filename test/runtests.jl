using Test
using ExampleJuggler

example_sources = [joinpath(@__DIR__, "..", "examples", "ExampleLiterate.jl")]

@test true

testliterate(example_sources; with_timing = true, info = true)
