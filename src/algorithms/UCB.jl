"""
    UCB1 Implementation
    Based on: Figure-1, Auer, P., Bianchi, N. C., & Fischer, P. (2002). Finite time analysis of the multiarmed bandit problem. Machine Learning, 47, 235–256.
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
        agent.lastPlayedArm =  rand( find(agent.count.==0) )
    else
        agent.lastPlayedArm = findmax(agent.ucbIndices)[2]
    end

    return agent.lastPlayedArm
end

function updateReward( agent::UCB1, r::Real )

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

function reset( agent::UCB1 )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummReward    = zeros( Float64, agent.noOfArms )
    agent.count         = zeros( Int64, agent.noOfArms )
    agent.ucbIndices    = zeros( Float64, agent.noOfArms )
end

function info_str( agent::UCB1, latex::Bool )
    return @sprintf( "UCB1" )
end

"""
    UCB2 Implementation
    Based on: Figure-2, Auer, P., Bianchi, N. C., & Fischer, P. (2002). Finite time analysis of the multiarmed bandit problem. Machine Learning, 47, 235–256.
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


"""
    UCB-Normal Implementation
    Based on: Figure-4, Auer, P., Bianchi, N. C., & Fischer, P. (2002). Finite time analysis of the multiarmed bandit problem. Machine Learning, 47, 235–256.
"""

type UCBNormal <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    cummReward::Vector{Float64}
    count::Vector{Int64}
    cummSqReward::Vector{Float64}
    ucbIndices::Vector{Float64}

    function UCBNormal( noOfArms::Int )
        new( noOfArms,
             0,
             0,
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function getArmIndex( agent::UCBNormal )
    tmp_lb      = ceil( 8 * log(agent.noOfSteps) )  # Quantity for comparison
    tmp_lbArms  = find( agent.count .< tmp_lb )     # Find index of under played arms
    if( size(tmp_lbArms,1) > 0 )    # if any machine is played less than ceil(8 log n), play that arm
        agent.lastPlayedArm = rand( tmp_lbArms )    # Randomly play one of those arms
    else    # else play arm with highest UCB index
        agent.lastPlayedArm = findmax(agent.ucbIndices)[2]
    end
    return agent.lastPlayedArm
end

function updateReward( agent::UCBNormal, r::Real )
    # Update cummulative reward
    agent.cummReward[agent.lastPlayedArm] += r
    # Update squared cummulative reward
    agent.cummSqReward[agent.lastPlayedArm] += (r^2)
    # Update count for last played arm
    agent.count[agent.lastPlayedArm] += 1
    # Update number of steps
    agent.noOfSteps += 1
    # Update UCB indices
    agent.ucbIndices    = agent.cummReward ./ agent.count +
                            √(16 *
                                (agent.cummSqReward-((agent.cummReward).^2)./agent.count) ./ (agent.count-1) *
                                log(agent.noOfSteps-1)./agent.count )
end

function reset( agent::UCBNormal )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummReward    = zeros( Float64, agent.noOfArms )
    agent.count         = zeros( Int64, agent.noOfArms )
    agent.cummSqReward  = zeros( Float64, agent.noOfArms )
    agent.ucbIndices    = zeros( Float64, agent.noOfArms )
end

function info_str( agent::UCBNormal, latex::Bool )
    return @sprintf( "UCB Normal" )
end
