module ExampleJugglerPlutoExt
import Pluto

import ExampleJuggler: testplutonotebook, verbose

using Test

function testplutonotebook(notebookname::String; pluto_project = Base.active_project())
    if verbose()
        @info "running notebook $(basename(notebookname))"
    end
    if pluto_project != nothing
        ENV["PLUTO_PROJECT"] = pluto_project
    end
    session = Pluto.ServerSession()
    session.options.server.disable_writing_notebook_files = true
    session.options.server.show_file_system = false
    session.options.server.launch_browser = false
    session.options.server.dismiss_update_notification = true
    session.options.evaluation.capture_stdout = false
    session.options.evaluation.workspace_use_distributed = false

    wd = pwd()
    t = @elapsed notebook = Pluto.SessionActions.open(session, notebookname; run_async = false)
    if verbose()
        @info "notebook executed in $(round(t, sigdigits = 4)) seconds"
    end
    cd(wd)

    errored = false
    for c in notebook.cells
        if c.errored
            errored = true
            @error """Error in cell $(c.cell_id): $(c.output.body[:msg])

               ----------------------------------------------------      
               $(c.code)
               ----------------------------------------------------
            """
        end
    end
    ENV["PLUTO_PROJECT"] = nothing
    return !errored
end


end
