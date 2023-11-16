var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/#Documentation","page":"API","title":"Documentation","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"docliterate","category":"page"},{"location":"api/#ExampleJuggler.docliterate","page":"API","title":"ExampleJuggler.docliterate","text":"     literate(example_sources;\n              with_plots = false,\n              Plotter = nothing,\n              example_subdir = \"literate_examples\",\n              source_prefix = \"https://github.com/j-fu/ExampleJuggler.jl/blobs/main/examples\",\n              info = false,\n              clean = true)\n\nGenerate markdown files for use with documenter from list of Julia code examples. See ExampleLiterate.jl for an example.\n\n\n\n\n\n","category":"function"},{"location":"api/#Testing","page":"API","title":"Testing","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"testliterate","category":"page"},{"location":"api/#ExampleJuggler.testliterate","page":"API","title":"ExampleJuggler.testliterate","text":"testliterate(example_sources;\n             info = false,\n             with_timing = false)\n\nTest the literate files by calling the the test() method of the module.\n\n\n\n\n\n","category":"function"},{"location":"internal/#Internal-API","page":"Internal API","title":"Internal API","text":"","category":"section"},{"location":"internal/","page":"Internal API","title":"Internal API","text":"ExampleJuggler.replace_source_url","category":"page"},{"location":"internal/#ExampleJuggler.replace_source_url","page":"Internal API","title":"ExampleJuggler.replace_source_url","text":"replace_source_url(input, source_url)\n\n\nReplace SOURCE_URL marker with url of source. Used for preprocessing the input of Literate.markdown in ExampleJuggler.docliterate.\n\n\n\n\n\n","category":"function"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"EditURL = \"../../../examples/ExampleLiterate.jl\"","category":"page"},{"location":"literate_examples/ExampleLiterate/#ExampleLiterate.jl","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"","category":"section"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"(source code)","category":"page"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"This example can be used for documentation generation with Literate.jl via the ExampleJuggler.docliterate method.","category":"page"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"(Image: )","category":"page"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"(Image: )","category":"page"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"module ExampleLiterate\n\nismakie(Plotter::Any) = false\nismakie(Plotter::Module) = isdefined(Plotter, :Makie)\n\nusing ExampleJuggler\n\nfunction main(; Plotter = nothing)\n    x, fx = mock_x()\n    @show maximum(fx)\n    if ismakie(Plotter)\n        p = Plotter.lines(x, fx)\n        Plotter.display(p)\n        if isinteractive()\n            print(\"press return to continue>\")\n            readline()\n        end\n    end\n\n    x, t, fxt = mock_xt()\n    if ismakie(Plotter)\n        p = Plotter.heatmap(x, t, fxt)\n        Plotter.display(p)\n    end\n    @show maximum(fxt)\n    maximum(fx), maximum(fxt)\nend\n\nfunction genplots(dir; Plotter = nothing)\n    if ismakie(Plotter)\n        Plotter.activate!(; type = \"svg\", visible = false)\n        x, fx = mock_x()\n        p = Plotter.lines(x, fx)\n        Plotter.save(joinpath(dir, \"mock_x.svg\"), p)\n        x, t, fxt = mock_xt()\n        p = Plotter.heatmap(x, t, fxt)\n        Plotter.save(joinpath(dir, \"mock_xt.svg\"), p)\n    end\n    nothing\nend\n\nfunction test()\n    maxfx, maxfxt = main()\n    isapprox(maxfx, 1.0; rtol = 1.0e-3) && isapprox(maxfxt, 1.0; rtol = 1.0e-3)\nend\n\nend","category":"page"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"","category":"page"},{"location":"literate_examples/ExampleLiterate/","page":"ExampleLiterate.jl","title":"ExampleLiterate.jl","text":"This page was generated using Literate.jl.","category":"page"},{"location":"mock/#Mock-methods","page":"Mock methods","title":"Mock methods","text":"","category":"section"},{"location":"mock/","page":"Mock methods","title":"Mock methods","text":"Modules = [ExampleJuggler]\nPages = [\"mock.jl\"]","category":"page"},{"location":"mock/#ExampleJuggler.mock_x-Tuple{}","page":"Mock methods","title":"ExampleJuggler.mock_x","text":"mock_x(; n, f)\n\n\nGenerate n-Vector X and return X, f.(X) for some function f;\n\n\n\n\n\n","category":"method"},{"location":"mock/#ExampleJuggler.mock_xt-Tuple{}","page":"Mock methods","title":"ExampleJuggler.mock_xt","text":"mock_xt(; n, m, f)\n\n\n    Generate n-Vector `X`, m-Vector `T` and return `X,T,[f(x,t) for x ∈ X, t∈T]` for some function f;\n\n\n\n\n\n","category":"method"},{"location":"","page":"Home","title":"Home","text":"using Markdown\nMarkdown.parse(\"\"\"\n$(read(\"../../README.md\",String))\n\"\"\")","category":"page"}]
}
