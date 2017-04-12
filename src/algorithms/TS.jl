"""
    Implements Thompson Sampling for Bandits with r ∈ [ 0,1]
"""

type TS <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    α0::Vector{Int64}
    β0::Vector{Int64}
    cummSuccess::Vector{Int64}
    cummFailure::Vector{Int64}

    samplingDist::Vector{Distributions.Beta}

    function TS( noOfArms::Integer )
        new( noOfArms,
             0,
             0,
             ones(Int64,noOfArms),
             ones(Int64,noOfArms),
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms),
             fill(Distributions.Beta(1,1),noOfArms)
        )
    end

    function TS( armParams::Array{Tuple{Int64,Int64},1} )
        _noOfArms   = length( armParams )
        _priorDist  = [ Distributions.Beta(armParams[idx][1],armParams[idx][2]) for idx=1:_noOfArms ]
        new( _noOfArms,
             0,
             0,
             [ armParams[idx][1] for idx=1:_noOfArms ],
             [ armParams[idx][2] for idx=1:_noOfArms ],
             zeros(Float64,_noOfArms),
             zeros(Float64,_noOfArms),
             _priorDist
        )
    end
end

function getArmIndex( agent::TS )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function updateReward( agent::TS, r::Int64 )
    # Update S and F
    agent.cummSuccess[agent.lastPlayedArm] += (r==0?0:1)
    agent.cummFailure[agent.lastPlayedArm] += (r==0?1:0)

    # Update Distributions
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Beta(
                                                agent.cummSuccess[agent.lastPlayedArm]+agent.α0[agent.lastPlayedArm],
                                                agent.cummFailure[agent.lastPlayedArm]+agent.β0[agent.lastPlayedArm]
                                            )

    # Update time steps
    agent.noOfSteps += 1
end

function updateReward( agent::TS, r::Float64 )
    rTilde = rand( Distributions.Bernoulli(r) )
    updateReward( agent, rTilde )
end

function reset( agent::TS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummSuccess   = zeros( Float64, agent.noOfArms )
    agent.cummFailure   = zeros( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Beta(1,1), agent.noOfArms )
end

function info_str( agent::TS, latex::Bool )
    return @sprintf( "Thompson Sampling" )
end


"""-----------------------------------------------------------------------------
    Dynamic Thompson Sampling
    Based on: Gupta, N., Granmo, O. C., & Agrawala, A. (2011). Thompson sampling for dynamic multi-armed bandits. Proceedings - 10th International Conference on Machine Learning and Applications, ICMLA 2011, 1, 484–489. http://doi.org/10.1109/ICMLA.2011.144
"""

type DynamicTS <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    α::Vector{Float64}
    β::Vector{Float64}
    C::Float64

    samplingDist::Vector{Distributions.Beta}

    function DynamicTS( noOfArms, _C )
        new( noOfArms,
             0,
             0,
             2*ones(Float64,noOfArms),
             2*ones(Float64,noOfArms),
             _C,
             fill(Distributions.Beta(2,2),noOfArms)
        )
    end
end

function getArmIndex( agent::DynamicTS )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function updateReward( agent::DynamicTS, r::Integer )
    # Update reward to arm played
    if agent.α[agent.lastPlayedArm]+agent.β[agent.lastPlayedArm] < agent.C
        agent.α[agent.lastPlayedArm]    += (r==0?0:1)
        agent.β[agent.lastPlayedArm]    += (r==0?1:0)
    else
        agent.α[agent.lastPlayedArm]    = (agent.α[agent.lastPlayedArm]+(r==0?0:1)) * agent.C/(agent.C+1)
        agent.β[agent.lastPlayedArm]    = (agent.β[agent.lastPlayedArm]+(r==0?1:0)) * agent.C/(agent.C+1)
    end

    # Update arm's distribution
    agent.samplingDist[agent.lastPlayedArm]  = Distributions.Beta(
                                                agent.α[agent.lastPlayedArm],
                                                agent.β[agent.lastPlayedArm]
                                            )

    # Update time steps
    agent.noOfSteps += 1
end

function updateReward( agent::DynamicTS, r::AbstractFloat )
    updateReward( agent, rand(Distributions.Bernoulli(r)) )   # Do a Bernoulli Trial to update the posterior
end

function reset( agent::DynamicTS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.α             = 2 * ones( Float64, agent.noOfArms )
    agent.β             = 2 * ones( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Beta(2,2), agent.noOfArms )
end

function info_str( agent::DynamicTS, latex::Bool )
    if latex
        return @sprintf( "Dynamic Thompson Sampling (\$C = %4.3f\$)", agent.C )
    else
        return @sprintf( "Dynamic Thompson Sampling (C = %4.3f)", agent.C )
    end
end

"""-----------------------------------------------------------------------------
    Optimistic Thompson Sampling
    Based on: May, B. C., Korda, N., Lee, A., & Leslie, D. S. (2012). Optimistic bayesian sampling in contextual-bandit problems. Journal of Machine Learning Research, 13, 2069–2106.
"""

type OTS <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    α0::Vector{Int64}
    β0::Vector{Int64}
    cummSuccess::Vector{Int64}
    cummFailure::Vector{Int64}

    samplingDist::Vector{Distributions.Beta}

    function OTS( noOfArms::Integer )
        new( noOfArms,
             0,
             0,
             ones(Int64,noOfArms),
             ones(Int64,noOfArms),
             zeros(Float64,noOfArms),
             zeros(Float64,noOfArms),
             fill(Distributions.Beta(1,1),noOfArms)
        )
    end

    function OTS( armParams::Array{Tuple{Int64,Int64},1} )
        _noOfArms   = length( armParams )
        _priorDist  = [ Distributions.Beta(armParams[idx][1],armParams[idx][2]) for idx=1:_noOfArms ]
        new( _noOfArms,
             0,
             0,
             [ armParams[idx][1] for idx=1:_noOfArms ],
             [ armParams[idx][2] for idx=1:_noOfArms ],
             zeros(Float64,_noOfArms),
             zeros(Float64,_noOfArms),
             _priorDist
        )
    end
end

function getArmIndex( agent::OTS )
    agent.lastPlayedArm = findmax( [ max(mean(armSample),rand(armSample)) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function updateReward( agent::OTS, r::Int64 )
    # Update S and F
    agent.cummSuccess[agent.lastPlayedArm] += (r==1?1:0)
    agent.cummFailure[agent.lastPlayedArm] += (r==0?1:0)

    # Update Distributions
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Beta(
                                                agent.cummSuccess[agent.lastPlayedArm]+agent.α0[agent.lastPlayedArm],
                                                agent.cummFailure[agent.lastPlayedArm]+agent.β0[agent.lastPlayedArm]
                                            )
    # Update time steps
    agent.noOfSteps += 1
end

function updateReward( agent::OTS, r::Float64 )
    rTilde = rand( Distributions.Bernoulli(r) )
    updateReward( agent, rTilde )
end

function reset( agent::OTS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummSuccess   = zeros( Float64, agent.noOfArms )
    agent.cummFailure   = zeros( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Beta(1,1), agent.noOfArms )
end

function info_str( agent::OTS, latex::Bool )
    return @sprintf( "Optimistic Thompson Sampling" )
end
