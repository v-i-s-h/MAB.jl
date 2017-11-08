# Gradient Bandits

type GradientBandit <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    α::Float64
    avgValue::Vector{Float64}
    playCount::Vector{Int64}
    preference::Vector{Float64}
    pDist::Categorical

    function GradientBandit( noOfArms::Integer, α::Real )
        new( noOfArms,
             0,
             0,
             α,
             zeros( Int64, noOfArms ),
             zeros( Float64, noOfArms ),
             zeros( Float64, noOfArms ),
             Categorical( 1/noOfArms*ones(noOfArms) ) )
    end
end

function get_arm_index( agent::GradientBandit )
    agent.lastPlayedArm = rand( agent.pDist )
    return agent.lastPlayedArm
end

function update_reward!( agent::GradientBandit, r::Real )
    agent.avgValue[agent.lastPlayedArm] = (agent.avgValue[agent.lastPlayedArm]*agent.playCount[agent.lastPlayedArm]+r)/(agent.playCount[agent.lastPlayedArm]+1)
    agent.playCount[agent.lastPlayedArm] += 1

    # Update for all arms
    agent.preference -= (agent.α*(r-agent.avgValue).*agent.pDist.p)
    # Perform update for selected arm
    agent.preference[agent.lastPlayedArm] += (agent.α*(r-agent.avgValue[agent.lastPlayedArm])*agent.pDist.p[agent.lastPlayedArm])

    agent.pDist = Categorical( exp.(agent.preference)/sum(exp.(agent.preference)) )

    agent.noOfSteps += 1

    nothing
end

function reset!( agent::GradientBandit )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.avgValue      = zeros( Float64, agent.noOfArms )
    agent.playCount     = zeros( Int64, agent.noOfArms )
    agent.preference    = zeros( Float64, agent.noOfArms )
    agent.pDist         = Categorical( 1/agent.noOfArms*ones(agent.noOfArms) )

    nothing
end

function info_str( agent::GradientBandit, latex::Bool )
    if latex
        return @sprintf( "GradientBandit (\$\\alpha=%3.2f\$)", agent.α )
    else
        return @sprintf( "GradientBandit (α=%3.2f)", agent.α )
    end
end