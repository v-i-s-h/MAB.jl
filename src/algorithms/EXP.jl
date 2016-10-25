"""
    EXP3 Implementation
"""

type EXP3 <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    γ::Float64
    wVec::Vector
    pDist::Categorical

    function EXP3( noOfArms::Integer, γ::Real )
        new( noOfArms,
             0,
             0,
             γ,
             ones(noOfArms),
             Categorical(1/noOfArms*ones(noOfArms))
        )
    end
end

function getArmIndex( agent::EXP3 )
    agent.lastPlayedArm = rand( agent.pDist )
    return agent.lastPlayedArm
end

function updateReward( agent::EXP3, r::Real )
    # Calculate estimated reward
    r_est = r/agent.pDist.p[agent.lastPlayedArm]

    # Update weight of arm
    agent.wVec[agent.lastPlayedArm] = agent.wVec[agent.lastPlayedArm] * exp(agent.γ*r_est/agent.noOfArms)

    # Calculate new probabilties
    p = (1-agent.γ) * agent.wVec/sum(agent.wVec) + agent.γ/agent.noOfArms

    # Make it a distrubution
    agent.pDist = Categorical( p )
end

function reset( agent::EXP3 )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0
    agent.wVec          = ones( agent.noOfArms )
    agent.pDist         = Categorical( 1/agent.noOfArms*ones(agent.noOfArms) )
end

function info_str( agent::EXP3 )
    return @sprintf( "EXP3 γ = %4.3f", agent.γ )
end
