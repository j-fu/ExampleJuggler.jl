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
