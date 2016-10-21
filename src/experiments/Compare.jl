"""
    compare.jl : Basic comaprison experiment for mulitple bandit algorithms
"""

type Compare <: BanditExpBase
    bandit::Vector{BanditArmBase}
    algorithms::Vector{BanditAlgorithmBase}

    function Compare( _bandit::Vector{BanditArmBase} )
        new(
            _bandit
        )
    end
end

function run( _exp::Compare, _n::Integer, _r::Integer )
    print( "[Compare]: Running Experiment ", typeof(_exp), "\n" )
    print( "Arms: \n" )
    for _a ∈ _exp.bandit
        print( "    ", _a, "    ::[", typeof(_a), "]\n")
    end
    print( "Algorithms: \n" )
    for _alg ∈ _exp.algorithms
        print( "    ",info_str(_alg), "    ::[", typeof(_alg), "]\n" )
    end
    print( "Timesteps: ", _n, "\n" )
    print( "Rounds: ", _r, "\n" )
end
