module poisson_test
using Gridap

## Import mesh
#cd( pwd() * "/examples/01-poisson")

msh = DiscreteModelFromFile("model.json")

writevtk(msh, "msh")


## Define test and trial functions
refTest = ReferenceFE(lagrangian, Float64, 1)
V0 = TestFESpace(msh, refTest; conformity=:H1, dirichlet_tags=["triangle", "square"])

g1(x) = 2.0
g2(x) = 3.0
Ug = TrialFESpace(V0, [g1,g2])


## Define the integration space
Ω = Triangulation(msh)
dΩ = Measure( Ω, 2 )

Γ1 = BoundaryTriangulation(msh, tags = "sides")
dΓ1 = Measure(Γ1, 2)

Γ2 = BoundaryTriangulation(msh, tags = "circle")
dΓ2 = Measure(Γ2, 2)


## Weak form
f(x) = 1.0
h1(x) = 3.0
h2(x) = 5.0
a(u,v) = ∫( ∇(v)⋅∇(u) )*dΩ
b(v) = ∫( v * f )*dΩ + ∫( v*h1 )dΓ1 + ∫( v*h2 )dΓ2


## Set FE Problem
op = AffineFEOperator(a, b, Ug, V0)


## Set up Solver
ls = LUSolver()
solver = LinearFESolver(ls)


## Solution loop
uh = solve(solver, op)


## Postprocess
writevtk(Ω, "results", cellfields=["uh"=>uh])

end