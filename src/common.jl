global verbosity = false

verbose() = verbosity
function verbose!(v::Bool)
    global verbosity
    verbosity = v
end

const script_examples = "script_examples"
const module_examples = "module_examples"
const pluto_examples = "pluto_examples"
const plutostatichtml_examples = "plutostatichtml_examples"
const all_examples = [module_examples, pluto_examples, plutostatichtml_examples, script_examples]

function cleanexamples()
    for examples in all_examples
        md_dir = example_md_dir(examples)
        if verbose()
            @info "removing $(md_dir)"
        end
        rm(md_dir; recursive = true, force = true)
    end
end

export cleanexamples

function example_md_dir(subdir)
    if basename(pwd()) == "docs" # run from docs subdirectory, e.g, during developkment
        return mkpath(joinpath("src", subdir))
    else # standard case with ci
        return mkpath(joinpath("docs", "src", subdir))
    end
end

homogenize_entry(p::Pair) = p
homogenize_entry(s::String) = Pair(splitext(basename(s))[1], s)
homogenize_notebooklist(list = Vector{Union{String}, Pair{String, String}}) = homogenize_entry.(list)
