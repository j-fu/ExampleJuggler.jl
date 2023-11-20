module ExampleJuggler
import Literate
import Pkg
import Pluto
using PlutoStaticHTML: OutputOptions, documenter_output, BuildOptions, build_notebooks
using PlutoSliderServer: export_directory
using Test: @test
using DocStringExtensions: SIGNATURES
using UUIDs: uuid1
using Compat: @compat

include("common.jl")
@compat public verbose!

include("mock.jl")
export mock_x, mock_xt

include("modules.jl")
export @docmodules, @testmodules

include("scripts.jl")
export @testscripts

include("pluto.jl")
export testplutonotebooks, @testplutonotebooks, docplutonotebooks, @docplutonotebooks

include("plutostatichtml.jl")
include("plutosliderserver.jl")

end
