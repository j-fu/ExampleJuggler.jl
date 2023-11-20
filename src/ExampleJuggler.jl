module ExampleJuggler
import Literate
import Pkg
import Pluto
using PlutoStaticHTML: OutputOptions, documenter_output, BuildOptions, build_notebooks
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

const example_subdir = "_examples"

function cleanexamples()
    md_dir = example_md_dir()
    if verbose()
        @info "removing $(md_dir)"
    end
    rm(md_dir; recursive = true, force = true)
end
export cleanexamples

function example_md_dir()
    if basename(pwd()) == "docs" # run from docs subdirectory, e.g, during developkment
        return mkpath(joinpath("src", example_subdir))
    else # standard case with ci
        return mkpath(joinpath("docs", "src", example_subdir))
    end
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

include("pluto.jl")
export testplutonotebook, testplutonotebooks

include("plutostatichtml.jl")
export docplutostatichtml

end
