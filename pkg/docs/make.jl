using Documenter
# using cuNumeric

makedocs(
    sitename = "cuNumeric.jl",
    authors = "Ethan Meitz and David Krasowska",

    format = Documenter.HTML(
        prettyurls = true
    ), 
    pages = [
        "Home" => "index.md",
        "Benchmarking" => "benchmark.md"
    ]
)

deploydocs(
    repo="github.com/ejmeitz/cuNumeric.jl.git",
    push_preview = true,
    devbranch = "main"
)