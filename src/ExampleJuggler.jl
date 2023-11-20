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

include("literate.jl")
export docmodule, docmodules

include("macros.jl")
export @testscript, @testscripts
export @testmodule, @testmodules
export @plotmodule, @plotmodules

include("pluto.jl")
export testplutonotebook, testplutonotebooks

include("plutostatichtml.jl")
export docplutostatichtml

include("plutosliderserver.jl")
export docpluto

end
