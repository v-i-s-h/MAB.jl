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

function get_arm_index( agent::EXP3 )
    agent.lastPlayedArm = rand( agent.pDist )
    return agent.lastPlayedArm
end

function update_reward!( agent::EXP3, r::Real )
    agent.noOfSteps     = agent.noOfSteps + 1;
    # Calculate estimated reward
    r_est = r/agent.pDist.p[agent.lastPlayedArm]

    # Update weight of arm
    agent.wVec[agent.lastPlayedArm] = agent.wVec[agent.lastPlayedArm] * exp(agent.γ*r_est/agent.noOfArms)

    # Calculate new probabilties
    p = (1-agent.γ) * agent.wVec/sum(agent.wVec) + agent.γ/agent.noOfArms

    # Make it a distrubution
    agent.pDist = Categorical( p )

    nothing
end

function reset!( agent::EXP3 )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0
    agent.wVec          = ones( agent.noOfArms )
    agent.pDist         = Categorical( 1/agent.noOfArms*ones(agent.noOfArms) )

    nothing
end

function info_str( agent::EXP3, latex::Bool )
    if latex
        return @sprintf( "EXP3 (\$\\gamma = %4.3f\$)", agent.γ )
    else
        return @sprintf( "EXP3 (γ = %4.3f)", agent.γ )
    end
end

"""
    EXP3.1 Implementation
    Based on : Fig.2 in Auer, P., Bianchi, N. C., Freund, Y., & E.Schapire, R. (2002). The Non-Stochastic Multi-Armed bandit problem. SIAM Journal of Computing, 22, 322–331. http://doi.org/10.1109/CDC.1983.269708
"""

type EXP31 <: BanditAlgorithmBase
    G_hat::Vector
    r::Int64
    g_r::Float64

    _EXP3::EXP3

    function EXP31( noOfArms )
        new( zeros( noOfArms ),
             0,
             (noOfArms*log(noOfArms))/(e-1),
             EXP3( noOfArms, 1.00 )  # Initial value for γ will simplify to 1.00
        )
    end
end

function get_arm_index( agent::EXP31 )
    get_arm_index( agent._EXP3 )
end

function update_reward!( agent::EXP31, r::Real )
    # Update G_hat for pulled arm
    agent.G_hat[agent._EXP3.lastPlayedArm] += r/agent._EXP3.pDist.p[agent._EXP3.lastPlayedArm]
    # println( "    G_hat = ", maximum(agent.G_hat), "    LHS = ", (agent.g_r - agent._EXP3.noOfArms/agent._EXP3.γ) )
    if maximum(agent.G_hat) > (agent.g_r - agent._EXP3.noOfArms/agent._EXP3.γ)
        # Calculate new g_r and reset EXP3 with new γ
        agent.r     += 1
        agent.g_r   = (agent._EXP3.noOfArms*log(agent._EXP3.noOfArms))/(e-1) * (4^agent.r)
        # println( "        g_r = ", agent.g_r )
        # println( "        New γ = ", √((agent._EXP3.noOfArms*log(agent._EXP3.noOfArms))/((e-1)*agent.g_r )) )
        agent._EXP3 = EXP3( agent._EXP3.noOfArms,
                            min(
                                1.00,
                                √((agent._EXP3.noOfArms*log(agent._EXP3.noOfArms))/((e-1)*agent.g_r ))
                            )
                        )
    else
        # Update reward to EXP3
        update_reward!( agent._EXP3, r )
    end

    nothing
end

function reset!( agent::EXP31 )
    reset!( agent._EXP3 )
    agent.G_hat = zeros( agent._EXP3.noOfArms)
    agent.r     = 0

    nothing
end

function info_str( agent::EXP31, latex::Bool )
    return @sprintf( "EXP3.1" )
end

"""
    REXP3 Implementation
    Based on Besbes, O., Gur, Y., & Zeevi, A. (2014). Stochastic Multi-Armed-Bandit Problem with Non-stationary Rewards. Advances in Neural Information Processing Systems, 2, 1–9.
"""

type REXP3 <: BanditAlgorithmBase
    noOfSteps::Int64    # Timesteps passed
    j::Int64            # Batch index
    Δ::Int64            # Batch size

    _EXP3::EXP3

    function REXP3( noOfArms::Integer, γ::Real, Δ::Integer )
        new( 0,
             1,
             Δ,
             EXP3(noOfArms,γ)
        )
    end
end

function get_arm_index( agent::REXP3 )
    get_arm_index( agent._EXP3 )
end

function update_reward!( agent::REXP3, r::Real )
    agent.noOfSteps = agent.noOfSteps + 1;
    update_reward!( agent._EXP3, r );
    # Reset if necessary
    if agent._EXP3.noOfSteps >= agent.Δ
        reset!( agent._EXP3 );
        agent.j = agent.j + 1;
    end

    nothing
end

function reset!( agent::REXP3 )
    reset!( agent._EXP3 )
    agent.noOfSteps     = 0;
    agent.j             = 1;

    nothing
end

function info_str( agent::REXP3, latex::Bool )
    if latex
        return @sprintf( "REXP3 (\$\\gamma = %4.3f, \\Delta = %d\$)", agent._EXP3.γ, agent.Δ )
    else
        return @sprintf( "REXP3 (γ = %4.3f, Δ = %d)", agent._EXP3.γ, agent.Δ )
    end
end

"""
    EXP3-IX Implementation
    Based on Neu, G. (2015). Explore no more: improved high-probability regret bounds for non-stochastic bandits. In Advances in Neural Information Processing Systems (pp. 1–9).
"""

type EXP3IX <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    η::Float64
    γ::Float64
    wVec::Vector
    pDist::Categorical

    function EXP3IX( noOfArms::Integer, η::Real, γ::Real )
        new( noOfArms,
             0,
             0,
             η,
             γ,
             ones(noOfArms),
             Categorical(1/noOfArms*ones(noOfArms))
        )
    end
end

function get_arm_index( agent::EXP3IX )
    agent.lastPlayedArm = rand( agent.pDist )
    return agent.lastPlayedArm
end

function update_reward!( agent::EXP3IX, r::Real )
    agent.noOfSteps     = agent.noOfSteps + 1;

    # Calculate loss
    l   = 1 - r

    # Calculate estimated reward
    l_est = l/(agent.pDist.p[agent.lastPlayedArm]+agent.γ)

    # Update weight of arm
    agent.wVec[agent.lastPlayedArm] = agent.wVec[agent.lastPlayedArm] * exp(-agent.η*l_est)

    # Calculate new probabilties
    p = agent.wVec/sum(agent.wVec)

    # Make it a distrubution
    agent.pDist = Categorical( p )

    nothing
end

function reset!( agent::EXP3IX )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0
    agent.wVec          = ones( agent.noOfArms )
    agent.pDist         = Categorical( 1/agent.noOfArms*ones(agent.noOfArms) )

    nothing
end

function info_str( agent::EXP3IX, latex::Bool )
    if latex
        return @sprintf( "EXP3-IX (\$\\eta = %4.3f, \\gamma = %4.3f\$)", agent.η, agent.γ )
    else
        return @sprintf( "EXP3-IX (η = %4.3f, γ = %4.3f)", agent.η, agent.γ )
    end
end
