### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ b285aca3-dee5-4b77-9276-537563e8643b
begin
    import Pkg as _Pkg
    haskey(ENV, "PLUTO_PROJECT") && _Pkg.activate(ENV["PLUTO_PROJECT"])
    using Revise
    using Test
    using ExampleJuggler
    using CairoMakie
    CairoMakie.activate!(; type = "svg", visible = false)
end;

# ╔═╡ 50e60295-2bb6-4aea-aea7-e600dad18bbd
x, fx = mock_x()

# ╔═╡ 3eef08af-f6ba-4874-82c0-65ff53e7f7da
@test isapprox(maximum(fx), 1.0; rtol = 1.0e-3)

# ╔═╡ c63e2859-d97d-4a96-a37b-02865d279d4d
let
    fig = Figure(; resolution = (600, 300))
    lines!(Axis(fig[1, 1]), x, fx)
    fig
end

# ╔═╡ 51a7525b-8afd-46cd-8334-f6acd3062bf6
y, t, fyt = mock_xt()

# ╔═╡ fdd4d16c-aecf-467c-a82f-5cf1dbb80027
@test isapprox(maximum(fyt), 1.0; rtol = 1.0e-3)

# ╔═╡ 0a190d57-c0c6-4091-bf61-bd546526da23
let
    fig = Figure(; resolution = (300, 300))
    heatmap!(Axis(fig[1, 1]), y, t, fyt)
    fig
end

# ╔═╡ Cell order:
# ╠═b285aca3-dee5-4b77-9276-537563e8643b
# ╠═50e60295-2bb6-4aea-aea7-e600dad18bbd
# ╠═3eef08af-f6ba-4874-82c0-65ff53e7f7da
# ╠═c63e2859-d97d-4a96-a37b-02865d279d4d
# ╠═51a7525b-8afd-46cd-8334-f6acd3062bf6
# ╠═fdd4d16c-aecf-467c-a82f-5cf1dbb80027
# ╠═0a190d57-c0c6-4091-bf61-bd546526da23
