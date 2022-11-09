#module validation_test

# cd(pwd() * "/examples/02-validation/")

using Gridap
import Gridap: ∇
using Plots

p=1
u(x) = x[1] + x[2]
#f(x) = p*(p-1)*(x[1]^(p-2) + x[2]^(p-2))
f(x) = 0.0

# If you know the analytical derivative then you can 
# ask Gridap to use the analytical expression instead of the
# automated calculation of the derivative using the following commands
# ∇ua(x) = VectorValue(p*x[1]^(p-1), p*x[2]^(p-1) )
∇u(x) = VectorValue(1,1)
∇(::typeof(u)) = ∇u
#println(∇(u) === ∇u)


# Function to run
function run(n, k)
    
    # Generate the Cartesian grid
    domain = (0,1,0,1)
    partition = (n,n)
    model = CartesianDiscreteModel(domain,partition)

    writevtk(model, "model")

    # FE Setup
    reffe = ReferenceFE(lagrangian, Float64, k)
    V0 = TestFESpace( model, reffe, conformity=:H1, 
        dirichlet_tags = "boundary" )
    U = TrialFESpace( V0, u)

    # Define integration space
    Ω = Triangulation(model)
    dΩ = Measure(Ω, 2) #choice of the Gauss quadrature order = 2

    # Weak form
    a(u,v) = ∫( ∇(v) ⋅ ∇(u) )*dΩ
    b(v) = ∫( v*f )*dΩ

    op = AffineFEOperator(a, b, U, V0)

    uh = solve(op)

    # Error analysis
    e = u - uh
    errl2 = sqrt( sum( ∫(e*e)*dΩ ) )
    errh2 = sqrt( sum( ∫(e*e + ∇(e)⋅∇(e) )*dΩ ) )
    writevtk(Ω, "error", cellfields=["e"=>e, "uh"=>uh])

    return (errl2, errh2)
end

#run(4,1)

function conv_test(ns, k)

    el2m = Float64[]
    eh2m = Float64[]
    hm = Float64[]

    for n in ns
        el2, eh2 = run(n,k)
        h = 1.0/n

        push!(el2m, el2)
        push!(eh2m, eh2)
        push!(hm, h)
    end
    
    (el2m, eh2m, hm)
end

res = conv_test([4,8,16,32,64,128,256],1)
println(res)

plot(res[3], [res[1], res[2]],
    xaxis=:log, yaxis=:log,
    label=["L2 k=1" "H1 k=1" "L2 k=2" "H1 k=2"],
    shape=:auto,
    xlabel="h",ylabel="error norm")

#@assert errl2 < 1.0e-10
#@assert errh2 < 1.0e-10

#end
