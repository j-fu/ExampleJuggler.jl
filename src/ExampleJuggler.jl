"""
    ExampleJuggler

$(read(joinpath(@__DIR__, "..", "README.md"), String))
"""
module ExampleJuggler
import Literate
import Pkg
using Test: @test
using UUIDs: uuid1

include("common.jl")
VERSION >= v"1.11.0-DEV.469" && eval(Meta.parse("public verbose!"))

include("mock.jl")
export mock_x, mock_xt

include("modules.jl")
export @docmodules, @testmodules

include("scripts.jl")
export @docscripts, @testscripts

include("plutoext.jl")
export testplutonotebooks, @testplutonotebooks, docplutonotebooks, @docplutonotebooks

end
