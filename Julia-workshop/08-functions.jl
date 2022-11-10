# functions

function function_name(x)
    println(x)
    return 0
end


# short form

short_function() = "Very short function"

# positional arguments versus keyword arguments

function fnc_with_Keywords(x::Float64, y, z=1000; key1=10, key2 ,key3::Float64=20.0)
    return( sum([x, y, z, key1, key2, key3]) )
end

fnc_with_Keywords(1.0, 2, key2=10)

# return type

function fnc_with_ret_typ(x::Float64, y::Float64)::Int64
    return floor(x+y)
end

# function vs methods

# multiple dispatch

# anonymous functions
(x -> x + 1)(5)

filter( x -> iseven(x), 1:10 )

filter( isodd, 1:10 )

# map/reduce/mapreduce

# functions Exercises

# Make a function `round_number` that rounds a number x as input.
# It should have two methods:
# 1. Float64 should use the `round` function
# 2. Int64 should just return the input (noop)

# Write a function to multiply all the numbers in a vector

