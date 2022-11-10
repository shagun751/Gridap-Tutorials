using Gridap

#cd( pwd()* "/examples/17-poisson-transient/")

model = CartesianDiscreteModel((0,1,0,1), (20,20))
Ω = Interior(model)
dΩ = Measure(Ω,2)

V = TestFESpace(model, 
    ReferenceFE(lagrangian, Float64, 1), dirichlet_tags="boundary")

g(x,t::Real) = 0.0
g(t::Real) = x -> g(x,t)
U = TransientTrialFESpace(V, g)

κ(t) = 1.0 + 0.95*sin(2π*t)
f(t) = sin(π*t)
res(t,u,v) = ∫( ∂t(u)*v + κ(t)*(∇(u)⋅∇(v)) - f(t)*v ) * dΩ

op = TransientFEOperator(res, U, V)

# Solver setup
lin_solver = LUSolver() #Lin solver for each time-step
∇t = 0.05
θ = 0.5
ode_solver = ThetaMethod(lin_solver, ∇t, θ)

# Initial condition
u0 = interpolate_everywhere(0.0, U(0.0))
t0 = 0.0
uht = solve(ode_solver, op, u0, t0, 10)



createpvd("poisson_transient_solution") do pvd
    cnt=0
    for (uh,t) in uht            
      cnt = cnt+1      
      if(cnt%10==0)
        pvd[t] = createvtk(Ω,"poisson_transient_solution_$cnt"*".vtu",cellfields=["u"=>uh])      
      end
    end
  end

