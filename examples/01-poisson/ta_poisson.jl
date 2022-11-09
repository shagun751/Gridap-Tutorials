using Gridap

## Import mesh
joinpath( pwd() * "/examples/01-poisson")

msh = DiscreteModelFromFile("model.json")

writevtk(msh, "msh")


## Define test and trial functions
refTest = ReferenceFE(lagrangian, Float64, 1)
V0 = TestFESpace(msh, refTest; conformity=:H1, dirichlet_tags="sides")

g(x) = 2
Ug = TrialFESpace(V0, g)


## Define the integration space
Ω = Triangulation(msh)
dΩ = Measure( Ω, 2 )

Γ = BoundaryTriangulation(msh, tags = ["circle", "triangle", "square"])
dΓ = Measure(Γ, 2)


## Weak form
f(x) = 1.0
h(x) = 3.0
a(u,v) = ∫( ∇(v)⋅∇(u) )*dΩ
b(v) = ∫( v * f )*dΩ + ∫( v*h )dΓ


## Set FE Problem
op = AffineFEOperator(a, b, Ug, V0)


## Set up Solver
ls = LUSolver()
solver = LinearFESolver(ls)


## Solution loop
uh = solve(solver, op)


## Postprocess
writevtk(Ω, "results", cellfields=["uh"=>uh])

