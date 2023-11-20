using Pkg
using PkgDependency
PkgDependency.tree()
@info "testscript: $(Base.active_project())"
using AbstractTrees, Test
x = 1
@test x == 1
function runtests(; kwargs...)
    println("runtests from  testscript")
    @test x == 1
end
