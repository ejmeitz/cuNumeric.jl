global const binary_op_map = Dict{Function, Int}(
    Base.:+ => Int(cuNumeric.ADD),
    Base.atan => Int(cuNumeric.ARCTAN2),
    Base.:& => Int(cuNumeric.BITWISE_AND),
    Base.:| => Int(cuNumeric.BITWISE_OR),
    Base.:⊻ => Int(cuNumeric.XOR),
    Base.copysign => Int(cuNumeric.copysign),
    Base.:/ => Int(cuNumeric.DIVIDE),
    Base.:(==) => Int(cuNumeric.EQUAL), 
    Base.:^ => Int(cuNumeric.FLOAT_POWER),
    Base.div => Int(cuNumeric.FLOOR_DIVIDE),
    #missing => Int(cuNumeric.fmod),
    Base.gcd => Int(cuNumeric.GCD),
    Base.:> => Int(cuNumeric.GREATER),
    Base.:(>=) => Int(cuNumeric.GREATER_EQUAL),
    Base.hypot => Int(cuNumeric.HYPOT),
    Base.isapprox => Int(cuNumeric.ISCLOSE),
    Base.lcm => Int(cuNumeric.LCM),
    Base.ldexp => Int(cuNumeric.LDEXP),
    Base.:(<<) => Int(cuNumeric.LEFT_SHIFT),
    Base.:(<) => Int(cuNumeric.LESS),
    Base.:(<=) => Int(cuNumeric.LESS_EQUAL),
    #missing => Int(cuNumeric.LOGADDEXP),
    #missing => Int(cuNumeric.LOGADDEXP2),
    (:&&) => Int(cuNumeric.LOGICAL_AND),
)

#* THIS SORT OF BREAKS WHAT A JULIA USER WOULD EXPECT
#* WILL AUTOMATICALLY BROADCAST OVER ARRAY INSTEAD OF REQUIRING `.()` call sytax
#* NEED TO IMPLEMENT BROADCASTING INTERFACE
# Generate code for all binary operations.
for (base_func, op_code) in binary_op_map
    @eval begin
        @doc """
            $($base_func) A binary operator acting on NDArrays
        """
        function $(base_func)(rhs1::NDArray, rhs2::NDArray)
            out = cuNumeric.zeros(eltype(rhs1), size(rhs1)) # not sure this is ok for performance
            return binary_op(out, op_code, rhs1, rhs2)
        end
    end
end


# This is more "Julian" since a user expects map to broadcast
# their operation whereas the generated functions should technically
# only broadcast when the .() syntax is used
function Base.map(f::Function, arr1::NDArray, arr2::NDArray)
    return f(arr1, arr2) # Will try to call one of the functions generated above
end