### A Pluto.jl notebook ###
# v0.20.21

using Markdown
using InteractiveUtils

# ╔═╡ b285aca3-dee5-4b77-9276-537563e8643b
begin
	using Pkg
    Pkg.activate(joinpath(@__DIR__, ".."))
    # using Revise
    using Test
    using ExampleJuggler
end;

# ╔═╡ 200a864a-d50e-45fa-915a-283c71ce8686
md"""
# Graphics example
"""

# ╔═╡ 50e60295-2bb6-4aea-aea7-e600dad18bbd
x, fx = mock_x()

# ╔═╡ 51a7525b-8afd-46cd-8334-f6acd3062bf6
y, t, fyt = mock_xt()

# ╔═╡ dd736474-3cbf-4b09-8dbb-0ab16fce6c5e
function runtests()
    # hideall
    @test isapprox(maximum(fyt), 1.0; rtol = 1.0e-3)
	@test splitpath(pwd())[end]=="examples"
    @test isapprox(maximum(fx), 1.0; rtol = 1.0e-3)
	return
end;

# ╔═╡ e87fd871-04be-4dbc-b933-3daeb11002b9
runtests()

# ╔═╡ Cell order:
# ╟─200a864a-d50e-45fa-915a-283c71ce8686
# ╠═b285aca3-dee5-4b77-9276-537563e8643b
# ╠═50e60295-2bb6-4aea-aea7-e600dad18bbd
# ╠═51a7525b-8afd-46cd-8334-f6acd3062bf6
# ╠═dd736474-3cbf-4b09-8dbb-0ab16fce6c5e
# ╠═e87fd871-04be-4dbc-b933-3daeb11002b9
