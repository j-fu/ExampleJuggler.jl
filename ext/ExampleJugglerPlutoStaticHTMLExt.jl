module ExampleJugglerPlutoStaticHTMLExt

import Pkg
import ExampleJuggler: docplutostatichtml, verbose, example_md_dir, plutostatichtml_examples
using PlutoStaticHTML: OutputOptions, documenter_output, BuildOptions, build_notebooks
isdefined(Base, :get_extension) ? import PlutoStaticHTML : import ..PlutoStaticHTML


function docplutostatichtml(
        example_dir,
        notebooks;
        append_build_context = true,
        distributed = true,
        force = true,
        pluto_project = Base.active_project(),
        ntasks = Threads.nthreads()
    )
    project = Base.active_project()
    if pluto_project != nothing
        Pkg.activate(pluto_project)
        ENV["PLUTO_PROJECT"] = pluto_project
    end

    notebookmd = [splitext(notebook)[1] * ".md" for notebook in notebooks]

    oopts = OutputOptions(; append_build_context)
    bopts = BuildOptions(
        example_dir;
        output_format = documenter_output,
        max_concurrent_runs = ntasks
    )
    session = PlutoStaticHTML.Pluto.ServerSession()
    session.options.server.disable_writing_notebook_files = true
    session.options.server.show_file_system = false
    session.options.server.launch_browser = false
    session.options.server.dismiss_update_notification = true
    # session.options.evaluation.capture_stdout = false
    session.options.evaluation.workspace_use_distributed = distributed
    build_notebooks(bopts, notebooks, oopts; session)
    for nb in notebookmd
        mv(joinpath(example_dir, nb), joinpath(example_md_dir(plutostatichtml_examples), nb); force)
    end
    Pkg.activate(project)
    return joinpath.(plutostatichtml_examples, notebookmd)
end


end
