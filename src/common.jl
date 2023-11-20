global verbosity = false

verbose() = verbosity
function verbose!(v::Bool)
    global verbosity
    verbosity = v
end

const example_subdir = "_examples"

function cleanexamples()
    md_dir = normpath(joinpath(example_md_dir("nothing"), ".."))
    if verbose()
        @info "removing $(md_dir)"
    end
    rm(md_dir; recursive = true, force = true)
end
export cleanexamples

function example_md_dir(subdir)
    if basename(pwd()) == "docs" # run from docs subdirectory, e.g, during developkment
        return mkpath(joinpath("src", example_subdir, subdir))
    else # standard case with ci
        return mkpath(joinpath("docs", "src", example_subdir, subdir))
    end
end
