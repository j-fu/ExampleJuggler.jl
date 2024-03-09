"""
    ExampleJuggler

$(read(joinpath(@__DIR__,"..","README.md"),String))
"""
module ExampleJuggler
import Literate
import Pkg
using Test: @test
using DocStringExtensions: SIGNATURES
using UUIDs: uuid1
using Compat: @compat

if  !isdefined(Base, :get_extension)
    using Requires
end

include("common.jl")
@compat public verbose!

include("mock.jl")
export mock_x, mock_xt

include("modules.jl")
export @docmodules, @testmodules

include("scripts.jl")
export @docscripts, @testscripts

include("plutoext.jl")
export testplutonotebooks, @testplutonotebooks, docplutonotebooks, @docplutonotebooks


@static if  !isdefined(Base, :get_extension)
    function __init__()
        @require Pluto =  "c3e4b0f8-55cb-11ea-2926-15256bba5781"  begin
            include("../ext/ExampleJugglerPlutoExt.jl")
        end
        @require PlutoStaticHTML = "359b1769-a58e-495b-9770-312e911026ad"  begin
            include("../ext/ExampleJugglerPlutoStaticHTMLExt.jl")
        end
        @require PlutoSliderServer =  "2fc8631c-6f24-4c5b-bca7-cbb509c42db4"  begin
            include("../ext/ExampleJugglerPlutoSliderServerExt.jl")
        end
    end
end


end
