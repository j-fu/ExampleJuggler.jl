#=
# ExampleLiterate.jl

([source code](SOURCE_URL))

This example can be used for documentation generation with [Literate.jl](https://github.com/fredrikekre/Literate.jl)
via the [`ExampleJuggler.literate`](@ref) method.

![](mock_x.svg)

![](mock_xt.svg)

=#
module ExampleLiterate

ismakie(Plotter::Any) = false
ismakie(Plotter::Module) = isdefined(Plotter, :Makie)

using ExampleJuggler

function main(; Plotter = nothing)
    x, fx = mock_x()
    @show maximum(fx)
    if ismakie(Plotter)
        p = Plotter.lines(x, fx)
        Plotter.display(p)
        if isinteractive()
            print("press return to continue>")
            readline()
        end
    end

    x, t, fxt = mock_xt()
    if ismakie(Plotter)
        p = Plotter.heatmap(x, t, fxt)
        Plotter.display(p)
    end
    @show maximum(fxt)
    maximum(fx), maximum(fxt)
end

function genplots(dir; Plotter = nothing)
    if ismakie(Plotter)
        Plotter.activate!(; type = "svg", visible = false)
        x, fx = mock_x()
        p = Plotter.lines(x, fx)
        Plotter.save(joinpath(dir, "mock_x.svg"), p)
        x, t, fxt = mock_xt()
        p = Plotter.heatmap(x, t, fxt)
        Plotter.save(joinpath(dir, "mock_xt.svg"), p)
    end
    nothing
end

function test()
    maxfx, maxfxt = main()
    isapprox(maxfx, 1.0; rtol = 1.0e-3) && isapprox(maxfxt, 1.0; rtol = 1.0e-3)
end

end
