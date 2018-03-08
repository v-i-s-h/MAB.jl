"""
    UCB1 Implementation
    Based on: Figure-1, Auer, P., Bianchi, N. C., & Fischer, P. (2002). Finite time analysis of the multiarmed bandit problem. Machine Learning, 47, 235–256.
"""

type UCB1 <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    c::Float64

    cummReward::Vector{Float64}
    count::Vector{Int64}
    ucbIndices::Vector{Float64}

    function UCB1( noOfArms::Int, c::Real = √2 )
        new( noOfArms,
             0,
             0,
             c,
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function get_arm_index( agent::UCB1 )
    if any(agent.count.==0)
        agent.lastPlayedArm =  rand( find(agent.count.==0) )
    else
        agent.lastPlayedArm = findmax(agent.ucbIndices)[2]
    end

    return agent.lastPlayedArm
end

function update_reward!( agent::UCB1, r::Real )

    # Update cummulative reward
    agent.cummReward[agent.lastPlayedArm] += r

    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1

    # Update number of steps played
    agent.noOfSteps += 1

    # Update UCB indices
    agent.ucbIndices = agent.cummReward./agent.count +
                        agent.c * sqrt.(log(agent.noOfSteps)./agent.count)

    nothing
end

function reset!( agent::UCB1 )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummReward    = zeros( Float64, agent.noOfArms )
    agent.count         = zeros( Int64, agent.noOfArms )
    agent.ucbIndices    = zeros( Float64, agent.noOfArms )

    nothing
end

function info_str( agent::UCB1, latex::Bool )
    if agent.c == √2
        return @sprintf( "UCB1" )
    else
        return @sprintf( "UCB1 (c=%3.2f)", agent.c )
    end
end

# """
#     UCB2 Implementation
#     Based on: Figure-2, Auer, P., Bianchi, N. C., & Fischer, P. (2002). Finite time analysis of the multiarmed bandit problem. Machine Learning, 47, 235–256.
# """
# type UCB2 <: BanditAlgorithmBase
#     noOfArms::Int64
#     noOfSteps::Int64
#     lastPlayedArm::Int64
#     α::Float64
#
#     cummReward::Vector{Float64}
#     count::Vector{Int64}
#
#     function UCB2( noOfArms::Int, α::Float64 )
#         new( noOfArms,
#              0,
#              0,
#              α,
#              zeros(Float64,noOfArms),
#              zeros(Int64,noOfArms)
#         )
#     end
# end

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

function get_arm_index( agent::UCBNormal )
    tmp_lb      = ceil( 8 * log(agent.noOfSteps) )  # Quantity for comparison
    tmp_lbArms  = find( agent.count .< tmp_lb )     # Find index of under played arms
    if( size(tmp_lbArms,1) > 0 )    # if any machine is played less than ceil(8 log n), play that arm
        agent.lastPlayedArm = rand( tmp_lbArms )    # Randomly play one of those arms
    else    # else play arm with highest UCB index
        agent.lastPlayedArm = findmax(agent.ucbIndices)[2]
    end
    return agent.lastPlayedArm
end

function update_reward!( agent::UCBNormal, r::Real )
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

    nothing
end

function reset!( agent::UCBNormal )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummReward    = zeros( Float64, agent.noOfArms )
    agent.count         = zeros( Int64, agent.noOfArms )
    agent.cummSqReward  = zeros( Float64, agent.noOfArms )
    agent.ucbIndices    = zeros( Float64, agent.noOfArms )

    nothing
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

function get_arm_index( agent::DUCB )
    if any(agent.count.==0)
        agent.lastPlayedArm =  rand( find(agent.count.==0) )
    else
        agent.lastPlayedArm = findmax(agent.indices)[2]
    end

    return agent.lastPlayedArm
end

function update_reward!( agent::DUCB, r::Real )
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

    nothing
end

function reset!( agent::DUCB )
    agent.noOfSteps     = 0;
    agent.lastPlayedArm = 0;

    agent.cummReward    = zeros( Float64, agent.noOfArms );
    agent.discCumReward = zeros( Float64, agent.noOfArms );
    agent.count         = zeros( Int64, agent.noOfArms );
    agent.discCount     = zeros( Float64, agent.noOfArms );
    agent.indices       = zeros( Float64, agent.noOfArms );

    nothing
end

function info_str( agent::DUCB, latex::Bool )
    if latex
        return @sprintf( "Discounted-UCB\$(\\gamma = %4.3f,\\xi = %4.3f)\$", agent.γ, agent.ξ );
    else
        return @sprintf( "Discounted-UCB(γ = %4.3f, ξ = %4.3f)", agent.γ, agent.ξ );
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

function get_arm_index( agent::SWUCB )
    if any(agent.swCount.==0)
        agent.lastPlayedArm =  rand( find(agent.swCount.==0) )
    else
        agent.lastPlayedArm = findmax(agent.indices)[2]
    end
    return agent.lastPlayedArm
end

function update_reward!( agent::SWUCB, r::Real )
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
                        sqrt.(agent.ξ*log(min(agent.noOfSteps,agent.τ))./agent.swCount)

    nothing
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

    nothing
end

function info_str( agent::SWUCB, latex::Bool )
    if latex
        return @sprintf( "SW-UCB\$(\\tau = %3.2f,\\xi = %3.2f)\$", agent.τ, agent.ξ );
    else
        return @sprintf( "SW-UCB(τ = %3.2f, ξ = %3.2f)", agent.τ, agent.ξ );
    end
end


"""
    UCB-V: Variance Aware UCB Implementation
    Based on: Audibert, J. Y., Munos, R., & Szepesvári, C. (2009). Exploration-exploitation tradeoff using variance estimates in multi-armed bandits. Theoretical Computer Science, 410(19), 1876–1902. http://doi.org/10.1016/j.tcs.2009.01.016
"""

type UCBV <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    # Parameters
    ζ::Float64
    c::Float64
    b::Float64

    empiricalMean::Vector{Float64}
    empiricalVariance::Vector{Float64}
    count::Vector{Int64}
    ucbIndices::Vector{Float64}

    function UCBV( noOfArms::Int; ζ::Real = 1.0, c::Real = 1/3, b::Real = 1.0 )
        new( noOfArms,
             0,
             0,
             ζ,
             c,
             b,
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function get_arm_index( agent::UCBV )
    if any(agent.count.==0)
        agent.lastPlayedArm =  rand( find(agent.count.==0) )
    else
        agent.lastPlayedArm = findmax(agent.ucbIndices)[2]
    end

    return agent.lastPlayedArm
end

function update_reward!( agent::UCBV, r::Real )

    # Save old mean
    μ = agent.empiricalMean[agent.lastPlayedArm]

    # Update cummulative reward
    agent.empiricalMean[agent.lastPlayedArm] = (agent.empiricalMean[agent.lastPlayedArm]*agent.count[agent.lastPlayedArm]+r) /
                                                    (agent.count[agent.lastPlayedArm]+1)
    # Update empirical Variance : Based on (30) in http://mathworld.wolfram.com/SampleVarianceComputation.html
    if agent.count[agent.lastPlayedArm] != 0
        agent.empiricalVariance[agent.lastPlayedArm] = (agent.count[agent.lastPlayedArm]-1)/agent.count[agent.lastPlayedArm] *
                                                            agent.empiricalVariance[agent.lastPlayedArm] +
                                                        1/(agent.count[agent.lastPlayedArm]+1) * (r-μ)^2
    end

    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1

    # Update number of steps played
    agent.noOfSteps += 1

    # Update UCB indices
    agent.ucbIndices = agent.empiricalMean +
                        sqrt.(2*agent.ζ*log(agent.noOfSteps)*agent.empiricalVariance./agent.count) +
                            3*agent.c*agent.b*log(agent.noOfSteps)./agent.count
    nothing
end

function reset!( agent::UCBV )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.empiricalMean     = zeros( Float64, agent.noOfArms )
    agent.empiricalVariance = zeros( Float64, agent.noOfArms )
    agent.count             = zeros( Int64, agent.noOfArms )
    agent.ucbIndices        = zeros( Float64, agent.noOfArms )

    nothing
end

function info_str( agent::UCBV, latex::Bool )
    if latex
        return @sprintf( "UCB-V(\$\\zeta=%3.2f,c=%3.2f,b=%3.2f\$)", agent.ζ, agent.c, agent.b )
    else
        return @sprintf( "UCB-V(ζ=%3.2f,c=%3.2f,b=%3.2f)", agent.ζ, agent.c, agent.b )
    end
end



"""
    Bayes-UCB Implementation
    Based on: Kaufmann, E., Cappé, O., & Garivier, A. (2012). On Bayesian upper confidence bounds for bandit problems. International Conference on Artificial Intelligence and Statistics, 592–600.
    Using 1 - 1/t as quantile
"""
type BayesUCB <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    count::Vector{Int64}
    α0::Vector{Int64}
    β0::Vector{Int64}
    cummSuccess::Vector{Int64}
    cummFailure::Vector{Int64}

    samplingDist::Vector{Distributions.Beta}

    function BayesUCB( noOfArms::Integer )
        new( noOfArms,
             0,
             0,
             zeros(Int64,noOfArms),
             ones(Int64,noOfArms),
             ones(Int64,noOfArms),
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms),
             fill(Distributions.Beta(1,1),noOfArms)
        )
    end

    function BayesUCB( armParams::Array{Tuple{Int64,Int64},1} )
        _noOfArms   = length( armParams )
        _priorDist  = [ Distributions.Beta(armParams[idx][1],armParams[idx][2]) for idx=1:_noOfArms ]
        new( _noOfArms,
             0,
             0,
             zeros(Int64,noOfArms),
             [ armParams[idx][1] for idx=1:_noOfArms ],
             [ armParams[idx][2] for idx=1:_noOfArms ],
             zeros(Float64,_noOfArms),
             zeros(Float64,_noOfArms),
             _priorDist
        )
    end
end

function get_arm_index( agent::BayesUCB )
    if any(agent.count.==0)
        agent.lastPlayedArm =  rand( find(agent.count.==0) )
    else
        agent.lastPlayedArm = findmax(  map(dist->quantile(dist,1-1/agent.noOfSteps),agent.samplingDist) )[2]
    end
    return agent.lastPlayedArm
end

function update_reward!( agent::BayesUCB, r::Int64 )
    # Update S and F
    agent.cummSuccess[agent.lastPlayedArm] += (r==0?0:1)
    agent.cummFailure[agent.lastPlayedArm] += (r==0?1:0)

    # Update Distributions
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Beta(
                                                agent.cummSuccess[agent.lastPlayedArm]+agent.α0[agent.lastPlayedArm],
                                                agent.cummFailure[agent.lastPlayedArm]+agent.β0[agent.lastPlayedArm]
                                            )

    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1

    # Update time steps
    agent.noOfSteps += 1

    nothing
end

function reset!( agent::BayesUCB )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.count         = zeros( Int64, agent.noOfArms )
    agent.cummSuccess   = zeros( Float64, agent.noOfArms )
    agent.cummFailure   = zeros( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Beta(1,1), agent.noOfArms )

    nothing
end

function info_str( agent::BayesUCB, latex::Bool )
    return @sprintf( "Bayes UCB" )
end

"""
    KL-UCB Implementation
    Based on: Garivier, A., & Cappe, O. (2011). The KL-UCB Algorithm for Bounded Stochastic Bandits and Beyond. In CoLT (Vol. 24).
"""
type KLUCB <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    cummReward::Vector{Float64}
    count::Vector{Int64}
    ucbIndices::Vector{Float64}

    function KLUCB( noOfArms::Int )
        new( noOfArms,
             0,
             0,
             zeros(Float64,noOfArms),
             zeros(Int64,noOfArms),
             zeros(Float64,noOfArms)
        )
    end
end

function get_arm_index( agent::KLUCB )
    if any(agent.count.==0)
        agent.lastPlayedArm =  rand( find(agent.count.==0) )
    else
        agent.lastPlayedArm = findmax(agent.ucbIndices)[2]
    end

    return agent.lastPlayedArm
end

function update_reward!( agent::KLUCB, r::Real )

    # Update cummulative reward
    agent.cummReward[agent.lastPlayedArm] += r

    # Update play count for arm
    agent.count[agent.lastPlayedArm] += 1

    # Update number of steps played
    agent.noOfSteps += 1

    # Update UCB indices
    agent.ucbIndices = find_q.( agent.cummReward, agent.count, agent.noOfSteps )

    nothing
end

function reset!( agent::KLUCB )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummReward    = zeros( Float64, agent.noOfArms )
    agent.count         = zeros( Int64, agent.noOfArms )
    agent.ucbIndices    = zeros( Float64, agent.noOfArms )

    nothing
end

function info_str( agent::KLUCB, latex::Bool )
    return @sprintf( "KL-UCB" )
end

# Utility functions
function kl_div( p::Float64, q::Float64 )
    if p==q
        return 0.00
    elseif p == 0.0
        return -log(1-q)
    elseif p == 1.0
        return -log(q)
    else
        return p*log(p/q) + (1-p)*log((1-p)/(1-q))
    end
end

function kl_div( X1::Distributions.Bernoulli, X2::Distributions.Bernoulli )
   kl_div( X1.p, X2.p )
end

function find_q( sa, na, t; ϵ = 1e-5 )
    lQ = sa/na
    uQ = min( 1, sa/na+√(log(t)/na/2))      # Applying Pinkser's Inequality
    q̄ = 1.0
    q  = (lQ+uQ)/2
    while abs(q̄-q) > ϵ
        q̄  = q
        # print( @sprintf( "lQ = %f, q = %f, uQ = %f", lQ, q, uQ ) )
        klDiv = kl_div( sa/na, q )
        # println( @sprintf( "    kl = %f, d = %f", klDiv, log(t)/na ))
        if klDiv < (log(t)/na)
            lQ = q
        else
            uQ = q
        end
        q  = (lQ+uQ)/2
    end
    return lQ
end

"""
    M-UCB
    Based on: Cao, Y., Zheng, W., Kveton, B., & Xie, Y. (2018). Nearly Optimal Adaptive Procedure for Piecewise-Stationary Bandit: a Change-Point Detection Approach. Retrieved from http://arxiv.org/abs/1802.03692
"""

type MUCB <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    # Algorithm params
    w::Int              # Test window length - Should be a even number
    b::Float64          # Test threshold
    γ::Float64          # Expoloration parameter

    # Internal
    τ::Int              # Last detected change point
    _ucb::UCB1          # UCB agent to run
    rew::Vector{Vector{Float64}}    # Past rewards from each arm

    function MUCB( noOfArms::Int, w::Int, b::Float64, γ::Float64 )
        new(
            noOfArms,
            0,
            0,
            w,
            b,
            γ,
            0,
            UCB1(noOfArms),
            [ Vector{Float64}() for k = 1:noOfArms ]
        )
    end
end

function get_arm_index( agent::MUCB )
    A = (agent.noOfSteps-agent.τ) % floor(agent.noOfArms/agent.γ)
    if A < agent.noOfArms   # Uniform Exploration
        agent.lastPlayedArm = A+1
        agent._ucb.lastPlayedArm = agent.lastPlayedArm
    else
        agent.lastPlayedArm = get_arm_index( agent._ucb )
    end
    return agent.lastPlayedArm
end

function update_reward!( agent::MUCB, r::Real )
    agent.noOfSteps += 1
    push!( agent.rew[agent.lastPlayedArm], r )
    update_reward!( agent._ucb, r )
    if length(agent.rew[agent.lastPlayedArm]) > agent.w # If the window length is reached
        # Then discard the oldest reward
        shift!( agent.rew[agent.lastPlayedArm] )
        # Also do the test
        if mucb_cd( agent.rew[agent.lastPlayedArm], agent.b )   # If test detects a change
            # Reset UCB1
            reset!( agent._ucb )
            # Update last detection point
            agent.τ = agent.noOfSteps
            agent.rew = [ Vector{Float64}() for k = 1:agent.noOfArms ]
        end
    end
    nothing
end

function reset!( agent::MUCB )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0
    agent.τ             = 0
    agent.rew           = [ Vector{Float64}() for k = 1:agent.noOfArms ]

    reset!( agent._ucb )    # Reset internal UCB1 agent also
end

function info_str( agent::MUCB, latex::Bool )
    if latex
        return @sprintf( "M-UCB( w = %d, b = %4.3f, \$\\gamma\$ = %4.3f )", agent.w, agent.b, agent.γ )
    else
        return @sprintf( "M-UCB( w = %d, b = %4.3f, γ = %4.3f )", agent.w, agent.b, agent.γ )
    end
end

#=
    Change Detection algorithm for M-UCB
        b - detection threshold
        rew - list of rewards; must be of length 'w' an even number
=#
function mucb_cd( rew::Vector{Float64}, b::Float64 )
    l = length( rew )
    assert( l%2 == 0 )
    return abs( sum(rew[1:Int(l/2)])-sum(rew[Int(l/2)+1:end]) ) > b
end
