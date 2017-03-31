# Experiment compare mulitple algorithms

type Compare <: BanditExpBase
    bandit::Vector{Arms.BanditArmBase}
    algorithms::Vector{Algorithms.BanditAlgorithmBase}

    function Compare{T1<:Arms.BanditArmBase,T2<:Algorithms.BanditAlgorithmBase}(
        _bandit::Vector{T1},
        _algo::Vector{T2}
        )
        new( _bandit, _algo )
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
                # Process tick() for all arms except the pulled arm
                for arm in experiment.bandit
                    if arm == experiment.bandit[armToPull]
                        continue
                    else
                        Arms.tick( arm )
                    end
                end
            end
        end
        avgReward = mean( observations, 2 )
        result[Algorithms.info_str(alg,true)] = avgReward
    end
    return result
end
