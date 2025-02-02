
# Unary Operations
The following unary operations from Base are re-implemented in cuNumeric.jl. All unary operations will return a new NDArray.

All unary operations are broadcast over an NDarray even without the `.` broadcasting syntax. In the current state, `.` broadcasting syntax will not work (e.g. `sin.(arr)`).

Unary operators can also be called with `map`. For example
```julia
arr = cuNumeric.rand(NDArray, 100)

res1 = sqrt.(arr)
res2 = map(sqrt, arr)
```

```@docs
Base.abs
Base.acos
Base.asin
Base.asinh
Base.atanh
Base.cbrt
Base.conj
Base.cos
Base.cosh
Base.deg2rad
Base.exp
Base.expm1
Base.floor
Base.log
Base.log10
Base.log1p
Base.log2
Base.:-
Base.rad2deg
Base.sin
Base.sinh
Base.sqrt
Base.tan
Base.tanh
```

# Binary Operations
The following binary operations from Base are re-implemented in cuNumeric.jl. All binary operations will return a new NDArray.

All binary operations are broadcast over an NDarray even without the `.` broadcasting syntax. In the current state, `.` broadcasting syntax will not work (e.g. `sin.(arr)`).

Binary operators can also be called with `map`. For example
```julia
arr1 = cuNumeric.rand(NDArray, 100)
arr2 = cuNumeric.rand(NDArray, 100)

res1 = arr1*arr2
res2 = map(*, arr1, arr2)
```

```@docs
Base.:+
Base.atan
Base.:/
Base.:^
Base.div
Base.hypot
Base.:*
Base.-
```