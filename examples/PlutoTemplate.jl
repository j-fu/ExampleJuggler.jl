### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 3eef08af-f6ba-4874-82c0-65ff53e7f7da
begin
    using Revise
    using ExampleJuggler
    using Test
end

# ╔═╡ b285aca3-dee5-4b77-9276-537563e8643b
begin
    import Pkg as _Pkg
    haskey(ENV, "PLUTO_PROJECT") && _Pkg.activate(ENV["PLUTO_PROJECT"])
    _Pkg.status()
end;

# ╔═╡ ee83bbd2-9216-4027-a86b-1b0a95358cbb
Base.active_project()

# ╔═╡ Cell order:
# ╠═b285aca3-dee5-4b77-9276-537563e8643b
# ╠═3eef08af-f6ba-4874-82c0-65ff53e7f7da
# ╠═ee83bbd2-9216-4027-a86b-1b0a95358cbb
