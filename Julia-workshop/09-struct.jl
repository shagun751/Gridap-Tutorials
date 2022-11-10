# struct

struct Person
    name::String
    age::Int64
    info
end

shagun = Person("Shagun", 28, "this can be Any type")

shagun.name

# fields

fieldnames(Person)

fieldtypes(Person)

# mutable structs
# Note that normal strcuts are not mutable, 
# so once initialised the obj cannot be modified.
# mutable allow obj that can be changed
mutable struct PersonMutable
    name::String
    age::Int64
    info
end

delft = PersonMutable("Delft", 30, 2611)
delft.age = 100

# It is not possible to associate fncs with strcuts
# However you can specify structs as specific arguments for fncs
function setzeroage!(x::PersonMutable)
    x.age=0
end

setzeroage!(delft)
delft.age

# abstract types

abstract type Pet end

struct Dog <: Pet end

struct Cat <: Pet end

struct Goat <: Pet end

function encounter(x::Pet, y::Pet)
    println("Do nothing")
end

function encounter(x::Dog, y::Cat)
    println("Bark!")
end

function encounter(x::Cat, y::Dog)
    println("Mew!")
end

dd = Dog()
cc = Cat()
gg = Goat()

encounter(dd, cc)
encounter(cc, dd)
encounter(cc, gg)

#exit()
