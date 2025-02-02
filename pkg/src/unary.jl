global const unary_op_map = Dict{Function, Int}(
    Base.abs => Int(cuNumeric.ABSOLUTE),
    Base.angle => Int(cuNumeric.ANGLE),
    Base.acos => Int(cuNumeric.ARCCOS),
    Base.acosh => Int(cuNumeric.ARCCOSH),
    Base.asin => Int(cuNumeric.ARCSIN),
    Base.asinh => Int(cuNumeric.ARCHSINH),
    Base.atan => Int(cuNumeric.ARCTAN),
    Base.atanh => Int(cuNumeric.ARCTANH),
    Base.cbrt => Int(cuNumeric.CBRT),
    Base.ceil => Int(cuNumeric.CEIL),
    Base.clamp => Int(cuNumeric.CLIP),
    Base.conj => Int(cuNumeric.CONJ),
    # missing => Int(cuNumeric.COPY), # CHECK WHAT THIS DOES
    Base.cos => Int(cuNUMERIC.COS),
    Base.cosh => Int(cuNumeric.COSH),
    Base.deg2rad => Int(cuNumeric.DEG2RAD),
    Base.exp => Int(cuNumeric.EXP),
    Base.exp2 => Int(cuNumeric.EXP2),
    Base.expm1 => Int(cuNumeric.EXPM1),
    Base.floor => Int(cuNumeric.FLOOR),
    Base.frexp => Int(cuNumeric.FREXP),
    #missing => Int(cuNumeric.GETARG), #not in numpy?
    Base.imag => Int(cuNumeric.IMAG),
    #missing => Int(cuNumerit.INVERT), # 1/x or inv(A)?
    Base.isfinite => Int(cuNumeric.ISFINITE),
    Base.isinf => Int(cuNumeric.ISINF),
    Base.isnan => Int(cuNumeric.ISNAN),
    Base.log => Int(cuNumeric.LOG),
    Base.log10 => Int(cuNumeric.LOG10),
    Base.log1p => Int(cuNumeric.LOG1P),
    Base.log2 => Int(cuNumeric.LOG2),
    Base.:! => Int(cuNumeric.LOGICAL_NOT),
    Base.modf => Int(cuNumeric.MODF),
    Base.:- => Int(cuNumeric.NEGATIVE), 
    #missing => Int(cuNumeric.POSITIVE), #What is this even for
    Base.rad2deg => Int(cuNumeric.RAD2DEG),
    #missing => Int(cuNumeric.RINT), #figure out which version of round 
    #missing => Int(cuNumeric.ROUND), #figure out which version of round
    Base.sign => Int(cuNumeric.SIGN),
    Base.signbit => Int(cuNumeric.SIGNBIT),
    Base.sin => Int(cuNumeric.SIN),  
    Base.sinh => Int(cuNumeric.SINH),  
    Base.sqrt => Int(cuNumeric.SQRT),  # HAS SPECIAL MEANING FOR MATRIX
    #missing => Int(cuNumeric.SQUARE), # just define as ^2?
    Base.tan => Int(cuNumeric.TAN),  
    Base.tanh => Int(cuNumeric.TANH),  
    Base.trunc => Int(cuNumeric.TRUNC)  
)

# Could implement most of the missing functions here
# global const unary_reduction_map = Dict{Function, Int}(
#     Base.all => Int(cuNumeric.ALL),
#     Base.any => Int(cuNumeric.ANY),
#     Base.argmax => Int(cuNumeric.ARGMAX), # WILL BE OFF BY 1
#     Base.argmin => Int(cuNumeric.ARGMIN), # WILL BE OFF BY 1
#     #missing => Int(cuNumeric.CONTAINS), # strings or also integral types
#     #missing => Int(cuNumeric.COUNT_NONZERO),
#     Base.maximum => Int(cuNumeric.MAX),
#     Base.minimum => Int(cuNumeric.MIN),
#     #missing => Int(cuNumeric.NANARGMAX),
#     #missing => Int(cuNumeric.NANARGMIN),
#     #missing => Int(cuNumeric.NANMAX),
#     #missing => Int(cuNumeric.NANMIN),
#     #missing => Int(cuNumeric.NANPROD),
#     Base.prod => Int(cuNumeric.PROD),
#     Base.sum => Int(cuNumeric.SUM),
#     #missing => Int(cuNumeric.SUM_SQUARES),
#     #missing => Int(cuNumeric.VARIANCE)
# )


# Generate code for all unary operators
for (base_func, op_code) in unary_op_map
    @eval begin
        @doc """
            $($base_func) : A unary operation acting on an NDArray
        """
        function $(base_func)(input::NDArray)
            out = cuNumeric.zeros(eltype(input), size(input)) # not sure this is ok for performance
            return unary_op(out, op_code, input)
        end
    end
end


# #*TODO HOW TO GET THESE ACTING ON CERTAIN DIMS
# # Generate code for all unary reductions.
# for (base_func, op_code) in unary_reduction_map
#     @eval begin
#         @doc """
#             $($base_func) : A unary reduction acting on NDArrays
#         """
#         function $(base_func)(input::NDArray)
#             out = cuNumeric.zeros(eltype(input), size(input)) # not sure this is ok for performance
#             return unary_reduction(out, op_code, input)
#         end
#     end
# end


#### PROVIDE A MORE "JULIAN" WAY OF DOING THINGS
#### WHEN YOU CALL MAP YOU EXPECT BROADCASTING
#### THIS HAS SOME EXTRA OVERHEAD THOUGH SINCE
#### YOU HAVE TO LOOK UP THE OP CODE AND CHECK IF ITS VALID


#* TODO Overload broadcasting to just call this
#* e.g. sin.(ndarray) should call this or the proper generated func
function Base.map(f::Function, arr::NDArray)
    return f(arr) # Will try to call one of the functions generated above
end


# function get_unary_op(f::Function)
#     if haskey(unary_op_map, f)
#         return unary_op_map[f]
#     else
#         throw(KeyError("Unsupported unary operation : $(f)"))
#     end
# end

# function Base.map(f::Function, arr::NDArray)
#     out = cuNumeric.zeros(eltype(arr), size(arr)) # not sure this is ok for performance
#     op_code = get_unary_op(f)
#     return unary_op(out, op_code, arr)
# end