"""
    Implements Thompson Sampling for Bandits with r ∈ [ 0,1]
"""

type TS <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    cummSuccess::Vector{Int64}
    cummFailure::Vector{Int64}

    samplingDist::Vector{Distributions.Beta}

    function TS( noOfArms )
        new( noOfArms,
             0,
             0,
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms),
             fill(Distributions.Beta(1,1),noOfArms)
        )
    end
end

function getArmIndex( agent::TS )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function updateReward( agent::TS, r::Int64 )
    # Update S and F
    agent.cummSuccess[agent.lastPlayedArm] += (r==1?1:0)
    agent.cummFailure[agent.lastPlayedArm] += (r==0?1:0)

    # Update Distributions
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Beta(
                                                agent.cummSuccess[agent.lastPlayedArm]+1,
                                                agent.cummFailure[agent.lastPlayedArm]+1
                                            )

    # Update time steps
    agent.noOfSteps += 1
end

function updateReward( agent::TS, r::Float64 )
    rTilde = rand( Distributions.Bernoulli(r) )
    updateReward( agent, rTilde )
end

function reset( agent::TS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummSuccess   = zeros( Float64, agent.noOfArms )
    agent.cummFailure   = zeros( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Beta(1,1), agent.noOfArms )
end

function info_str( agent::TS )
    return @sprintf( "Thompson Sampling" )
end
