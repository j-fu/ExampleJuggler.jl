module ExampleJuggler
import Literate
import Pkg
import Pluto
using Test: @test
using DocStringExtensions: SIGNATURES
using UUIDs: uuid1
using Compat: @compat

global verbosity = false

verbose() = verbosity
function verbose!(v::Bool)
    global verbosity
    verbosity = v
end

@compat public verbose!

include("mock.jl")
export mock_x, mock_xt

include("literate.jl")
export docliterate, cleanliterate

include("macros.jl")
export @testscript, @testscripts
export @testmodule, @testmodules
export @plotmodule, @plotmodules

end
