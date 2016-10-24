# Experiment compare mulitple algorithms

type Compare <: BanditExpBase
    bandit::Vector{Arms.BanditArmBase}
    algorithms::Vector{Algorithms.BanditAlgorithmBase}

    function Compare( _b,   # ::Vector{Arms.BanditArmBase}
                      _a)   # ::Vector{Algorithms.BanditAlgorithmBase}
        new(
            _b,
            _a
        )
    end
end

function run( experiment::Compare, noOfTimeSteps::Integer, noOfRounds::Integer )

    result = Dict{String,Array{Float64,2}}()
    for alg ∈ experiment.algorithms
        observations = zeros( noOfTimeSteps, noOfRounds )
        for _round = 1:noOfRounds
            Algorithms.reset( alg )
            for _n = 1:noOfTimeSteps
                armToPull   = Algorithms.getArmIndex( alg )
                reward      = Arms.pull( experiment.bandit[armToPull] )
                Algorithms.updateReward( alg, reward )
                observations[_n,_round] = reward
            end
        end
        avgReward = mean( observations, 2 )
        result[Algorithms.info_str(alg)] = avgReward
    end
    return result
end
