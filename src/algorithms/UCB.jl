"""
    UCB1 Implementation
"""

type UCB1 <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    cummReward::Vector{Float64}
    count::Vector{Int64}
    ucbIndices::Vector{Float64}

    function UCB1( noOfArms::Int )
        new( noOfArms,
             0,
             0,
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function getArmIndex( agent::UCB1 )
    if any(agent.count.==0)
        agent.lastPlayedArm =  find(agent.count.==0)[1]
    else
        agent.lastPlayedArm = findmax(agent.ucbIndices)[2]
    end
    return agent.lastPlayedArm
end

function updateReward( agent::UCB1, r::Float64 )
    # Update cummulative reward
    agent.cummReward[agent.lastPlayedArm] += r

    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1

    # Update number of steps played
    agent.noOfSteps += 1

    # Update UCB indices
    agent.ucbIndices = agent.cummReward./agent.count +
                        √(2*log(agent.noOfSteps)./agent.count)
end

function whoami( agent::UCB1 )
    return "UCB1"
end

"""
    UCB2 Implementation
"""
type UCB2 <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64
    α::Float64

    cummReward::Vector{Float64}
    count::Vector{Int64}

    function UCB2( noOfArms::Int, α::Float64 )
        new( noOfArms,
             0,
             0,
             α,
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms)
        )
    end
end

# function getArmIndex( agent::UCB2 )
#
# end
#
# function updateReward( agent::UCB2, r::Float64 )
#
# end
