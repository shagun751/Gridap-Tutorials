using Gridap
using Gridap.Geometry

#cd(pwd()*"/examples/03-elasticity/")

model = DiscreteModelFromFile("../../models//solid.json")

writevtk(model,"model")

labels = get_face_labeling(model)
println(labels)
dimension = 3
tags = get_face_tag(labels,dimension)

println(get_tag_from_name(labels,"material_1"))