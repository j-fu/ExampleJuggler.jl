module ExampleJuggler

using Test: @test
import Literate
using DocStringExtensions: SIGNATURES

include("mock.jl")
export mock_x, mock_xt

include("literate.jl")
export docliterate, testliterate

end
