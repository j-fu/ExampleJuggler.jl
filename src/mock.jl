"""
$(SIGNATURES)

Generate n-Vector `X` and return `X, f.(X)` for some function f;
"""
function mock_x(; n = 100, f = x -> sin(3x))
    X = range(-1.0, 1.0; length = n)
    X, f.(X)
end

"""
$(SIGNATURES)

        Generate n-Vector `X`, m-Vector `T` and return `X,T,[f(x,t) for x ∈ X, t∈T]` for some function f;
"""
function mock_xt(; n = 100, m = 100, f = (x, t) -> sin(3(x - t)))
    X = range(-1.0, 1.0; length = n)
    T = range(0, 10.0; length = m)
    X, T, [f(x, t) for x ∈ X, t ∈ T]
end
