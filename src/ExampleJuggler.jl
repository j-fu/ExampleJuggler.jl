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
export docmodule, docmodules
export @testmodule, @testmodules
export @plotmodule, @plotmodules

include("scripts.jl")
export @testscript, @testscripts

include("pluto.jl")
export testplutonotebooks, @testplutonotebooks

include("plutostatichtml.jl")
export docplutostatichtml

include("plutosliderserver.jl")
export docpluto

end
