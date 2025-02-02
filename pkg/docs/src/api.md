
# Public API

User facing functions supported by cuNumeric.jl

```@contents
Pages = ["api.md"]
Depth = 2:2
```

## Unary Operations

All unary operations will return a new NDArray and are broadcast over an NDarray even without the `.` broadcasting syntax. In the current state, `.` broadcasting syntax will not work (e.g. `sin.(arr)`).

Unary operators can also be called with `map`. For example
```julia
arr = cuNumeric.rand(NDArray, 100)

res1 = sqrt(arr)
res2 = map(sqrt, arr)
```

#### Implemented Unary Operations
- `Base.abs`
- `Base.acos`
- `Base.asin`
- `Base.asinh`
- `Base.atanh`
- `Base.cbrt`
- `Base.conj`
- `Base.cos`
- `Base.cosh`
- `Base.deg2rad`
- `Base.exp`
- `Base.expm1`
- `Base.floor`
- `Base.log`
- `Base.log10`
- `Base.log1p`
- `Base.log2`
- `Base.:(-)`
- `Base.rad2deg`
- `Base.sin`
- `Base.sinh`
- `Base.sqrt`
- `Base.tan`
- `Base.tanh`


## Binary Operations

All binary operations will return a new NDArray and are broadcast over an NDarray even without the `.` broadcasting syntax. In the current state, `.` broadcasting syntax will not work (e.g. `sin.(arr)`).

Binary operators can also be called with `map`. For example
```julia
arr1 = cuNumeric.rand(NDArray, 100)
arr2 = cuNumeric.rand(NDArray, 100)

res1 = arr1*arr2
res2 = map(*, arr1, arr2)
```

#### Implemented Binary Operations
- `Base.:(+)`
- `Base.atan`
- `Base.:(/)`
- `Base.:(^)`
- `Base.div`
- `Base.hypot`
- `Base.:(*)`
- `Base.(-)`