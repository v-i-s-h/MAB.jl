# make.jl

using Documenter, MAB

makedocs(
    modules = [MAB],
    doctest = true,
    format = :html,
    sitename = "MAB.jl",
    authors = "Vishnu Raj",
    linkcheck = false,
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
            "manual/guide.md",
            "manual/contributing.md",
            "manual/ack.md"
        ],
        "Library" => Any[
            "library/common_api.md",
            "library/algorithms.md",
            "library/arm_models.md",
            "library/experiments.md"
        ]
    ],
    # Use clean URLs, unless built as a "local" build
    html_prettyurls = !("local" in ARGS),
)

deploydocs(
    repo    = "github.com/v-i-s-h/MAB.jl.git",
)
