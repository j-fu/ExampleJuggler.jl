global verbosity = false

verbose() = verbosity

"""
    verbose(true_or_false)

Set verbosity
"""
function verbose!(v::Bool)
    global verbosity
    verbosity = v
    startroot!(pwd())
end

const script_examples = "script_examples"
const module_examples = "module_examples"
const pluto_examples = "pluto_examples"
const plutostatichtml_examples = "plutostatichtml_examples"
const all_examples = [module_examples, pluto_examples, plutostatichtml_examples, script_examples]

startroot=""
"""
    startroot!(dir)

Assume `dir` is the directory from which `make.jl` has been invoked
(normally, package root or the `docs` subdirectory). Used in [`example_md_dir`](@ref).
"""
function startroot!(dir)
    global startroot
    if startroot==""
        if verbose()
            @info "Set startroot=$dir"
        end
        startroot=dir
    end
end


"""
    cleanexamples()

Clean intermediate files from example documentation.
"""
function cleanexamples()
    startroot!(pwd())
    for examples in all_examples
        md_dir = example_md_dir(examples)
        if verbose()
            @info "removing $(md_dir)"
        end
        rm(md_dir; recursive = true, force = true)
    end
end

export cleanexamples

"""
     example_md_dir(subdir)

Return full path to the subdirectory of docs/src where the markdown
files should be placed which later will be scanned by Documenter.
Creates the directory if it doesn't already exist.
"""
function example_md_dir(subdir)
    if basename(startroot) == "docs" # run from docs subdirectory, e.g, during developkment
        docsdir=startroot
    else # standard case with github ci
        docsdir=joinpath(startroot, "docs")
    end
    
    if !isfile(joinpath(docsdir,"make.jl"))
        error("no make.jl found in $docsdir")
    end
    return mkpath(joinpath(docsdir,"src", subdir))
end

homogenize_entry(p::Pair) = p
homogenize_entry(s::String) = Pair(splitext(basename(s))[1], s)
homogenize_notebooklist(list = Vector{Union{String}, Pair{String, String}}) = homogenize_entry.(list)
