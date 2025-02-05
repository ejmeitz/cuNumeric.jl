# Examples


## DAXPY
include("../../../../examples/daxpy.jl")

## Monte-Carlo Integration

Most integrals can be estimated with a basic Monte-Carlo estimator:

```math
\hat{I}_N = \frac{\Omega}{N}\sum_{i=1}^Nf(x_i)
```
where `N` is the number of samples, ``\Omega`` is the volume of the domain and ``x_i`` are sampled indpendently and uniformly at random from the domain. This estimator is guranteed to converge (subject to some minor constraints) at a rate independent of the dimension and is embaressingly parallel to compute!

In the example below, we estimate the integral:
```math
I = \int_{-\infty}^{\infty}e^{-x^2}.
```

Since we cannot uniformly sample form negative to positive infinity, we truncate the domain between -5 and 5. This is ok since the integrand exponentially decays and we won't be off by much in the end.

include("../../../../examples/integration.jl")

## Gray Scott Reaction Diffusion

include("../../../../examples/gray-scott.jl")

![Simulation Output](../../../../examples/gray-scott.gif)
