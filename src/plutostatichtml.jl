"""
    docplutostatichtml(example_dir, notebooks; pluto_project)

Document notebooks via  [PlutoStaticHTML.jl](https://github.com/rikhuijzer/PlutoStaticHTML.jl).
"""
function docplutostatichtml(example_dir, notebooks; pluto_project = Base.active_project())
    project = Base.active_project()
    if pluto_project != nothing
        Pkg.activate(pluto_project)
        ENV["PLUTO_PROJECT"] = pluto_project
    end

    notebookmd = [splitext(notebook)[1] * ".md" for notebook in notebooks]

    oopts = OutputOptions(; append_build_context = true)
    bopts = BuildOptions(example_dir; output_format = documenter_output)
    session = Pluto.ServerSession()
    session.options.server.disable_writing_notebook_files = true
    session.options.server.show_file_system = false
    session.options.server.launch_browser = false
    session.options.server.dismiss_update_notification = true
    # session.options.evaluation.capture_stdout = false
    #    session.options.evaluation.workspace_use_distributed = false # this makes it fast

    build_notebooks(bopts, notebooks, oopts; session)
    for nb in notebookmd
        mv(joinpath(example_dir, nb), joinpath(example_md_dir(plutostatichtml_examples), nb))
    end
    Pkg.activate(project)
    joinpath.(plutostatichtml_examples, notebookmd)
end
