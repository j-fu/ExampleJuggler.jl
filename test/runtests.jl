using Test, Aqua
using ExampleJuggler


if isdefined(Docs, :undocumented_names) # >=1.11
    @testset "undocumented names" begin
        @test isempty(Docs.undocumented_names(ExampleJuggler))
    end
end

@testset "Aqua" begin
    Aqua.test_ambiguities(ExampleJuggler)
    Aqua.test_unbound_args(ExampleJuggler)
    Aqua.test_undefined_exports(ExampleJuggler)
    Aqua.test_project_extras(ExampleJuggler)
    Aqua.test_stale_deps(ExampleJuggler, ignore = [:ChunkSplitters])
    Aqua.test_deps_compat(ExampleJuggler)
    Aqua.test_piracies(ExampleJuggler)
    Aqua.test_persistent_tasks(ExampleJuggler)
end


ExampleJuggler.verbose!(true)

example_dir = joinpath(@__DIR__, "..", "examples")

modules = ["ExampleModule.jl"]
notebooks = ["PlutoTemplate.jl", "ExamplePluto.jl"]
scripts = ["ExampleScript.jl"]

# This kind of test needs `import Pluto`
# and has been temporarily disabled due to lacking support on Julia nightly
# @testset "pluto notebooks" begin
#    @testplutonotebooks(example_dir, notebooks)
# end

# This kind of test works without Pluto
@testset "notebooks as scripts" begin
    @testscripts(example_dir, notebooks)
end

@testset "module examples" begin
    @testmodules(example_dir, modules, a = 2)
end

@testset "scripts" begin
    @testscripts(example_dir, scripts)
end
