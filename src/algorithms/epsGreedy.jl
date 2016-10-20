"""
    ϵ-Greedy Implementation
"""

type epsGreedy <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    ϵ::Float64
    cummReward::Vector{Float64}
    count::Vector{Int64}
    avgValue::Vector{Float64}

    function epsGreedy( noOfArms::Int64, ϵ )
        new( noOfArms,
             0,
             0,
             ϵ,
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function getArmIndex( agent::epsGreedy )
    if any(agent.count.==0)
        agent.lastPlayedArm = find(agent.count.==0)[1]
    else
        if rand() > agent.ϵ
            agent.lastPlayedArm = findmax(agent.avgValue)[2]
        else
            agent.lastPlayedArm = rand(1:agent.noOfArms)
        end
    end
    return agent.lastPlayedArm
end

function updateReward( agent::epsGreedy, r::Real )
    agent.cummReward[agent.lastPlayedArm] += r
    agent.count[agent.lastPlayedArm] += 1
    agent.noOfSteps += 1

    agent.avgValue[agent.lastPlayedArm] = agent.cummReward[agent.lastPlayedArm] ./
                                            agent.count[agent.lastPlayedArm]
end

function reset( agent::epsGreedy )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummReward    = zeros( Float64, agent.noOfArms )
    agent.count         = zeros( Int64, agent.noOfArms )
    agent.avgValue      = zeros( Float64, agent.noOfArms )
end
