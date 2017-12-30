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
            "Algorithms" => Any[
                "library/Algorithms/index.md",
                "library/Algorithms/list.md",
                hide( "library/Algorithms/epsGreedy.md" )
            ],
            "library/ArmModels/index.md",
            "library/Experiments/index.md"
        ]
    ],
    # Use clean URLs, unless built as a "local" build
    html_prettyurls = !("local" in ARGS),
)

deploydocs(
    repo    = "github.com/v-i-s-h/MAB.jl.git",
    target  = "build",
    osname  = "linux",
    julia   = "release",
    deps    = nothing,
    make    = nothing
)
