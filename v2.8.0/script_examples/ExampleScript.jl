#=
# Script example
=#

#
# Import stuff
#
using Pkg
using ExampleJuggler
import CairoMakie
using Test
#
# Run stuff
#

x, fx = mock_x()
maxfx = maximum(fx)

#
# Plot of the  result
# ![](ExampleScript.svg)
#
# We can test when the script runs
@test isapprox(maxfx, 1.0; rtol = 1.0e-3)

# If we don't want the tests in the script we
# can test in the runtests function
function runtests(; kwargs...)
    println("runtests from  testscript")
    return @test isapprox(maxfx, 1.0; rtol = 1.0e-3)
end

# Here we generate plots
function generateplots(dir; kwargs...)
    CairoMakie.activate!(; type = "svg", visible = false)
    p = CairoMakie.lines(x, fx)
    return CairoMakie.save(joinpath(dir, "ExampleScript.svg"), p)
end
