function docplutostatichtml(notebooks; plutoenv = nothing)
    project = Base.active_project()
    if plutoenv != nothing
        @info normpath(plutoenv)
        Pkg.activate(normpath(plutoenv))
        ENV["PLUTO_PROJECT"] = normpath(plutoenv)
        Pkg.status()
    end
    notebookdir = dirname(notebooks[1])
    notebookjl = basename.(notebooks)
    notebookmd = [split(notebook, ".")[1] * ".md" for notebook in notebookjl]

    oopts = OutputOptions(; append_build_context = true)
    bopts = BuildOptions(notebookdir; output_format = documenter_output)
    session = Pluto.ServerSession()
    session.options.server.disable_writing_notebook_files = true
    session.options.server.show_file_system = false
    session.options.server.launch_browser = false
    session.options.server.dismiss_update_notification = true
    # session.options.evaluation.capture_stdout = false
    #    session.options.evaluation.workspace_use_distributed = false # this makes it fast

    build_notebooks(bopts, notebookjl, oopts; session)
    for nb in notebookmd
        mv(joinpath(notebookdir, nb), joinpath(example_md_dir("plutostatichtml"), nb))
    end
    Pkg.activate(project)
    joinpath.(example_subdir, "plutostatichtml", notebookmd)
end
