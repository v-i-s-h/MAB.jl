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

function updateReward!( agent::UCB1, r::Real )

    # Update cummulative reward
    agent.cummReward[agent.lastPlayedArm] += r

    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1

    # Update number of steps played
    agent.noOfSteps += 1

    # Update UCB indices
    agent.ucbIndices = agent.cummReward./agent.count +
                        sqrt.(2*log(agent.noOfSteps)./agent.count)
end

function reset!( agent::UCB1 )
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

function updateReward!( agent::UCBNormal, r::Real )
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
                            sqrt.(16 *
                                (agent.cummSqReward-((agent.cummReward).^2)./agent.count) ./ (agent.count-1) *
                                log(agent.noOfSteps-1)./agent.count )
end

function reset!( agent::UCBNormal )
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

"""
    Discounted UCB
    Based on: Moulines, E., & Paristech, T. (2008). On Upper-Confidence Bound Policies for Non-Stationary Bandit Problems. arXiv Preprint, (2008), 1–24.
"""

type DUCB <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    γ::Float64                      # Discouting factor
    ξ::Float64                      # Confidence Scale Parameter
    cummReward::Vector{Float64}     # Cummulattive Reward from each arm
    discCumReward::Vector{Float64}  # Discounted reward
    count::Vector{Int64}            # Count of how many time an arm is pulled
    discCount::Vector{Float64}      # Discounted Count
    indices::Vector{Float64}        # Calculated Indices

    function DUCB( noOfArms::Int, γ::Float64, ξ::Float64 = 0.5 )
        new( noOfArms,
             0,
             0,
             γ,
             ξ,
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function getArmIndex( agent::DUCB )
    if any(agent.count.==0)
        agent.lastPlayedArm =  rand( find(agent.count.==0) )
    else
        agent.lastPlayedArm = findmax(agent.indices)[2]
    end

    return agent.lastPlayedArm
end

function updateReward!( agent::DUCB, r::Real )
    # Update cummulative reward
    agent.cummReward[agent.lastPlayedArm] += r
    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1
    # Update number of steps played
    agent.noOfSteps += 1
    # Update discounted cummulative reward
    agent.discCumReward *= agent.γ                  # Discount for all arms
    agent.discCumReward[agent.lastPlayedArm] += r   # Update reward to last played arm
    # Update discounted count
    agent.discCount *= agent.γ
    agent.discCount[agent.lastPlayedArm] += 1
    # Update UCB indices
    agent.indices   = agent.discCumReward./agent.discCount +
                        2*sqrt.(agent.ξ*log(sum(agent.discCount))./agent.discCount)
end

function reset!( agent::DUCB )
    agent.noOfSteps     = 0;
    agent.lastPlayedArm = 0;

    agent.cummReward    = zeros( Float64, agent.noOfArms );
    agent.discCumReward = zeros( Float64, agent.noOfArms );
    agent.count         = zeros( Int64, agent.noOfArms );
    agent.discCount     = zeros( Float64, agent.noOfArms );
    agent.indices       = zeros( Float64, agent.noOfArms );
end

function info_str( agent::DUCB, latex::Bool )
    if latex
        return @sprintf( "Discounted-UCB\$(\\gamma = %3.2f,\\xi = %3.2f)\$", agent.γ, agent.ξ );
    else
        return @sprintf( "Discounted-UCB(γ = %3.2f, ξ = %3.2f)", agent.γ, agent.ξ );
    end
end

"""
    Sliding Window UCB
    Based on: Moulines, E., & Paristech, T. (2008). On Upper-Confidence Bound Policies for Non-Stationary Bandit Problems. arXiv Preprint, (2008), 1–24.
"""

type SWUCB <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    τ::Int64                        # Window Length
    ξ::Float64                      # Confidence Scale Parameter
    cummReward::Vector{Float64}     # Cummulative Reward from each arm
    count::Vector{Int64}            # Count of how many time an arm is pulled
    swCount::Vector{Int64}          # Count of how many times an arm is picked in this sliding Window
    armsInWindow::Vector{Int64}     # Vector of Arms picked in window
    rewardsInWindow::Vector{Float64}# Vector of Rewards corresponding to arms picked in this window
    swCumRew::Vector{Float64}       # Cummulative reward of arms in this window
    indices::Vector{Float64}        # Calculated Indices

    function SWUCB( noOfArms::Int, τ::Int64, ξ::Float64 = 2.0 )
        new( noOfArms,
             0,
             0,
             τ,
             ξ,
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Int64,noOfArms),
             Vector{Int64}(),
             Vector{Float64}(),
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function getArmIndex( agent::SWUCB )
    if any(agent.swCount.==0)
        agent.lastPlayedArm =  rand( find(agent.swCount.==0) )
    else
        agent.lastPlayedArm = findmax(agent.indices)[2]
    end
    return agent.lastPlayedArm
end

function updateReward!( agent::SWUCB, r::Real )
    # Update cummulative reward
    agent.cummReward[agent.lastPlayedArm] += r
    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1
    # Update number of steps played
    agent.noOfSteps += 1

    # For sliding window
    push!( agent.armsInWindow, agent.lastPlayedArm )
    push!( agent.rewardsInWindow, r )
    agent.swCount[agent.lastPlayedArm]  += 1
    agent.swCumRew[agent.lastPlayedArm] += r
    if length(agent.armsInWindow) > agent.τ
        _arm    = shift!( agent.armsInWindow )
        _r      = shift!( agent.rewardsInWindow )
        agent.swCount[_arm]     -= 1
        agent.swCumRew[_arm]    -= _r
    end

    # Sanity check
    assert( length(agent.armsInWindow) == length(agent.rewardsInWindow) <= agent.τ )

    # Update UCB indices
    agent.indices = agent.swCumRew./agent.swCount +
                        √(agent.ξ*log(min(agent.noOfSteps,agent.τ))./agent.swCount)
end

function reset!( agent::SWUCB )
    agent.noOfSteps         = 0
    agent.lastPlayedArm     = 0
    agent.cummReward        = zeros(Float64,agent.noOfArms)
    agent.count             = zeros(Int64,agent.noOfArms)
    agent.swCount           = zeros(Int64,agent.noOfArms)
    agent.armsInWindow      = Vector{Int64}()
    agent.rewardsInWindow   = Vector{Int64}()
    agent.indices           = zeros(Float64,agent.noOfArms)
end

function info_str( agent::SWUCB, latex::Bool )
    if latex
        return @sprintf( "SW-UCB\$(\\tau = %3.2f,\\xi = %3.2f)\$", agent.τ, agent.ξ );
    else
        return @sprintf( "SW-UCB(τ = %3.2f, ξ = %3.2f)", agent.τ, agent.ξ );
    end
end
