"""
    testplutonotebook(notebookname; plutoenv = nothing)

Test pluto notebook in a Pluto session.
"""
function testplutonotebook(notebookname; plutoenv = nothing)
    if verbose()
        @info "running notebook $(basename(notebookname))"
    end
    if plutoenv != nothing
        ENV["PLUTO_PROJECT"] = plutoenv
    end
    session = Pluto.ServerSession()
    session.options.server.disable_writing_notebook_files = true
    session.options.server.show_file_system = false
    session.options.server.launch_browser = false
    session.options.server.dismiss_update_notification = true
    session.options.evaluation.capture_stdout = false
    session.options.evaluation.workspace_use_distributed = false # this makes it fast

    wd = pwd()
    t = @elapsed notebook = Pluto.SessionActions.open(session, notebookname; run_async = false)
    if verbose()
        @info "notebook executed in $(round(t,sigdigits=4)) seconds"
    end
    cd(wd)
    errored = false
    for c in notebook.cells
        if occursin("@test", c.code)
            @test !c.errored
        end
        if c.errored
            errored = true
            @error "Error in  $(c.cell_id): $(c.output.body[:msg])\n\n $(c.code)\n"
        end
    end
    ENV["PLUTO_PROJECT"] = nothing
    !errored
end

"""
     testplutonotebooks(notebooks; kwargs...)

Test pluto notebooks via [`testplutonotebook`](@ref).
"""
function testplutonotebooks(notebooks; kwargs...)
    for notebook in notebooks
        testplutonotebook(notebook; kwargs...)
    end
end
