# Experiment compare mulitple algorithms

type Compare <: BanditExpBase
    bandit::Vector{Arms.BanditArmBase}
    algorithms::Vector{BanditAlgorithmBase}

    function Compare{T1<:Arms.BanditArmBase,T2<:BanditAlgorithmBase}(
        _bandit::Vector{T1},
        _algo::Vector{T2}
        )
        new( _bandit, _algo )
    end
end

function run( experiment::Compare, noOfTimeSteps::Integer, noOfRounds::Integer )

    result = Dict{String,Array{Float64,2}}()
    for alg ∈ experiment.algorithms
        srand( 1729 );  # "Magic" Seed initialization for RNG - across all algorithms
        observations = zeros( noOfTimeSteps, noOfRounds )
        for _round = 1:noOfRounds
            reset!( alg )
            # Reset arms of the bandit
            for arm ∈ experiment.bandit
                Arms.reset!( arm )
            end
            for _n = 1:noOfTimeSteps
                armToPull   = get_arm_index( alg )
                reward      = Arms.pull!( experiment.bandit[armToPull] )
                update_reward!( alg, reward )
                observations[_n,_round] = reward
                # Process tick() for all arms except the pulled arm
                for arm in experiment.bandit
                    if arm == experiment.bandit[armToPull]
                        continue
                    else
                        Arms.tick!( arm )
                    end
                end
            end
        end
        avgReward = mean( observations, 2 )
        result[info_str(alg,true)] = avgReward
    end
    return result
end
