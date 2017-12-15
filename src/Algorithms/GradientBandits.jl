# Gradient Bandits
"""
    Gradient Bandit

    Based on: Sec 2.8, R. S. Sutton, A. G. Barto, and A. B. Book, Reinforcement Learning : An Introduction, Second Edi. The MIt Press, 2017.
"""
type GradientBandit <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    α::Float64
    avgValue::Float64
    preference::Vector{Float64}
    pDist::Categorical

    function GradientBandit( noOfArms::Integer, α::Real )
        new( noOfArms,
             0,
             0,
             α,
             0,
             zeros( Float64, noOfArms ),
             Categorical( 1/noOfArms*ones(noOfArms) ) )
    end
end

function get_arm_index( agent::GradientBandit )
    agent.lastPlayedArm = rand( agent.pDist )
    return agent.lastPlayedArm
end

function update_reward!( agent::GradientBandit, r::Real )
    agent.avgValue = (agent.avgValue*agent.noOfSteps+r)/(agent.noOfSteps+1)
    agent.noOfSteps += 1

    # Update for all arms
    agent.preference -= (agent.α*(r-agent.avgValue).*agent.pDist.p)
    # Perform update for selected arm
    agent.preference[agent.lastPlayedArm] += agent.α*(r-agent.avgValue)

    agent.pDist = Categorical( exp.(agent.preference)/sum(exp.(agent.preference)) )

    nothing
end

function reset!( agent::GradientBandit )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.avgValue      = 0
    agent.preference    = zeros( Float64, agent.noOfArms )
    agent.pDist         = Categorical( 1/agent.noOfArms*ones(agent.noOfArms) )

    nothing
end

function info_str( agent::GradientBandit, latex::Bool )
    if latex
        return @sprintf( "GradientBandit (\$\\alpha=%4.3f\$)", agent.α )
    else
        return @sprintf( "GradientBandit (α=%4.3f)", agent.α )
    end
end