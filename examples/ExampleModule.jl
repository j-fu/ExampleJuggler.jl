#=
# ExampleModule.jl

([source code](@__SOURCE_URL__))

This example can be used for documentation generation with [Literate.jl](https://github.com/fredrikekre/Literate.jl)
via the [`ExampleJuggler.docmodules`](@ref) method.

![](mock_x.svg)

![](mock_xt.svg)

=#
module ExampleModule

ismakie(Plotter::Any) = false
ismakie(Plotter::Module) = isdefined(Plotter, :Makie)

using PkgDependency
using ExampleJuggler
using Test

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
    return maximum(fx), maximum(fxt)
end

function generateplots(dir; Plotter = nothing)                    #hide
    if ismakie(Plotter)                                      #hide
        Plotter.activate!(; type = "svg", visible = false)   #hide
        x, fx = mock_x()                                     #hide
        p = Plotter.lines(x, fx)                             #hide
        Plotter.save(joinpath(dir, "mock_x.svg"), p)         #hide
        x, t, fxt = mock_xt()                                #hide
        p = Plotter.heatmap(x, t, fxt)                       #hide
        Plotter.save(joinpath(dir, "mock_xt.svg"), p)        #hide
    end                                                      #hide
    return nothing                                                  #hide
end                                                          #hide
#hide
function runtests(; a = 1)                                              #hide
    @info a                                                  #hide
    maxfx, maxfxt = main()                                   #hide
    @test isapprox(maxfx, 1.0; rtol = 1.0e-3)                #hide
    return @test isapprox(maxfxt, 1.0; rtol = 1.0e-3)               #hide
end                                                          #hide

end
