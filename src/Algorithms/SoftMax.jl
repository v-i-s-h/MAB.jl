# SoftMax Arm selection algorithm

"""
    SoftMax Arm Selection
"""
type SoftMax <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    τ::Float64              # temparature parameter
    play_count::Vector{Int64}    # Number of times each arm is played
    avgValue::Vector{Float64}   # Average value of each arm

    function SoftMax( noOfArms::Integer, τ::AbstractFloat )
        new( noOfArms,
             0,
             0,
             τ,
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function get_arm_index( agent::SoftMax )
    pVec    = exp.(agent.avgValue/agent.τ) / sum(exp.(agent.avgValue/agent.τ))
    agent.lastPlayedArm = rand( Categorical(pVec) )
    return agent.lastPlayedArm
end

function update_reward!( agent::SoftMax, r::Real )
    agent.avgValue[agent.lastPlayedArm] = (agent.play_count[agent.lastPlayedArm]*agent.avgValue[agent.lastPlayedArm] + r) / (agent.play_count[agent.lastPlayedArm]+1)
    agent.play_count[agent.lastPlayedArm] += 1
    agent.noOfSteps += 1

    nothing
end

function reset!( agent::SoftMax )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.play_count    = zeros( Int64, agent.noOfArms )
    agent.avgValue      = zeros( Float64, agent.noOfArms )

    nothing
end

function info_str( agent::SoftMax, latex::Bool )
    if latex
        return @sprintf( "SoftMax (\$\\tau = %4.3f\$)", agent.τ )
    else
        return @sprintf( "SoftMax (τ = %4.3f)", agent.τ )
    end
end
