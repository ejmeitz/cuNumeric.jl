# Examples


## DAXPY
```julia
using cuNumeric

arr = cuNumeric.rand(NDArray, 20)

α = 1.32
b = 2.0

arr2 = α*arr + b
```

## Monte-Carlo Integration

```julia
using cuNumeric

integrand = (x) -> exp(-square(x))

N = 10_000_000

# Choose truncated domain to generate samples from
x_max = 5.0
domain = [-x_max, x_max]

# Domain volume
Ω = domain[2] - domain[1]

# Sample domain uniformly at random
samples = Ω*cuNumeric.rand(NDArray, N) - x_max 

# Estimate integral with Monte-Carlo Estimator
estimate = (Ω/N) * sum(integrand(samples))

println("Monte-Carlo Estimate: $(estimate)")
println("Analytical: $(sqrt(pi))")

```