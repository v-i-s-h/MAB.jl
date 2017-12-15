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

function get_arm_index( agent::TS )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function update_reward!( agent::TS, r::Int64 )
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

    nothing
end

function update_reward!( agent::TS, r::Float64 )
    rTilde = rand( Distributions.Bernoulli(r) )
    update_reward!( agent, rTilde )

    nothing
end

function reset!( agent::TS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummSuccess   = zeros( Float64, agent.noOfArms )
    agent.cummFailure   = zeros( Float64, agent.noOfArms )
    agent.samplingDist  = [ Distributions.Beta(agent.α0[idx],agent.β0[idx]) for idx=1:agent.noOfArms ]

    nothing
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

function get_arm_index( agent::DynamicTS )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function update_reward!( agent::DynamicTS, r::Integer )
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

    nothing
end

function update_reward!( agent::DynamicTS, r::AbstractFloat )
    update_reward!( agent, rand(Distributions.Bernoulli(r)) )   # Do a Bernoulli Trial to update the posterior

    nothing
end

function reset!( agent::DynamicTS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.α             = 2 * ones( Float64, agent.noOfArms )
    agent.β             = 2 * ones( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Beta(2,2), agent.noOfArms )

    nothing
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

function get_arm_index( agent::OTS )
    agent.lastPlayedArm = findmax( [ max(mean(armSample),rand(armSample)) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function update_reward!( agent::OTS, r::Int64 )
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

    nothing
end

function update_reward!( agent::OTS, r::Float64 )
    rTilde = rand( Distributions.Bernoulli(r) )
    update_reward!( agent, rTilde )

    nothing
end

function reset!( agent::OTS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummSuccess   = zeros( Float64, agent.noOfArms )
    agent.cummFailure   = zeros( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Beta(1,1), agent.noOfArms )

    nothing
end

function info_str( agent::OTS, latex::Bool )
    return @sprintf( "Optimistic Thompson Sampling" )
end


"""-----------------------------------------------------------------------------
    Thompson Sampling for Normal Rewards
    Based on: Sec 6.3, Russo, D., & Van Roy, B. (2014). Learning to Optimize Via Posterior Sampling. Mathematics of Operations Research. http://doi.org/10.1287/xxxx.0000.0000
"""

type TSNormal <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    η::Float64
    μ::Vector{Float64}
    σ::Vector{Float64}

    samplingDist::Vector{Distributions.Normal}

    function TSNormal( noOfArms::Int64, η::Real = 1 )
        new(
            noOfArms,
            0,
            0,
            η,
            zeros(Float64,noOfArms),
            100*ones(Float64,noOfArms),    # σ - Some high value
            fill(Distributions.Normal(0,100),noOfArms)
        )
    end

    function TSNormal( armParams::Array{Tuple{Real,Real},1}, η::Real = 1 )
        _K = length(armParams)
        new(
            _K,
            0,
            0,
            η,
            [ armParams[idx][1] for i = 1:_K ],
            [ armParams[idx][2] for i = 1:_K ],
            [ Distributions.Normal(armParams[idx][1],armParams[idx][2]) for i = 1:_K ]
        )
    end
end

function get_arm_index( agent::TSNormal )
    agent.lastPlayedArm = findmax( [ max(mean(armSample),rand(armSample)) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function update_reward!( agent::TSNormal, r::Float64 )

    agent.μ[agent.lastPlayedArm] = ( agent.μ[agent.lastPlayedArm]/agent.σ[agent.lastPlayedArm]^2 + r/agent.η^2 ) /
                                        ( 1/agent.σ[agent.lastPlayedArm]^2 + 1/agent.η^2 )
    agent.σ[agent.lastPlayedArm] = ( 1/agent.σ[agent.lastPlayedArm]^2 + 1/agent.η^2 )^(-1/2)

    # Update Distributions
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Normal(
                                                agent.μ[agent.lastPlayedArm],
                                                agent.σ[agent.lastPlayedArm]
                                            )

    agent.noOfSteps += 1

    nothing
end

function reset!( agent::TSNormal )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.μ   = zeros( Float64, agent.noOfArms )
    agent.σ   = 100*ones(Float64,agent.noOfArms)
    agent.samplingDist  = [ Distributions.Normal(agent.μ[i],agent.σ[i]) for i = 1:agent.noOfArms ]

    nothing
end

function info_str( agent::TSNormal, latex::Bool )
    if latex
        return @sprintf( "TS-Normal(\$\\eta=%3.2f\$)", agent.η )
    else
        return @sprintf( "TS-Normal(η=%3.2f)", agent.η )
    end
end


"""-----------------------------------------------------------------------------
    Discounted Thompson Sampling
    Based on: Vishnu Raj, Sheetal Kalyani (2017). Taming Non-stationary Bandits: A Bayesian Approach. https://arxiv.org/abs/1707.09727
"""

type dTS <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    γ::Float64                      # Discounting factor
    αₒ::Vector{Float64}             # Initial α value
    βₒ::Vector{Float64}             # Initial β value
    cummSuccess::Vector{Float64}    # Cummulative success
    cummFailure::Vector{Float64}    # Cummulative failure

    samplingDist::Vector{Distributions.Beta}    # Internal Distributions

    function dTS( noOfArms, γ::Float64 = 1.00,
                    αₒ::Float64 = 1.00, βₒ::Float64 = 1.00 )
        new( noOfArms,
             0,
             0,
             γ,
             αₒ * ones(Float64,noOfArms),
             βₒ * ones(Float64,noOfArms),
             αₒ * ones(Float64,noOfArms),
             βₒ * ones(Float64,noOfArms),
             fill(Distributions.Beta(αₒ,βₒ),noOfArms)
        )
    end

    function dTS( noOfArms, γ::Float64 ,
                    α₀::Vector{Float64}, β₀::Vector{Float64} )
        new( noOfArms,
             0,
             0,
             γ,
             α₀,
             β₀,
             α₀,
             β₀,
             Distributions.Beta.(α₀,β₀)
        )
    end
end

function get_arm_index( agent::dTS )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function update_reward!( agent::dTS, r::Int64 )
    # Update S and F
    agent.cummSuccess *= agent.γ
    agent.cummFailure *= agent.γ
    agent.cummSuccess[agent.lastPlayedArm] += (r==0?0:1)
    agent.cummFailure[agent.lastPlayedArm] += (r==0?1:0)

    # Update Distributions
    agent.samplingDist  = Distributions.Beta.(
                                                agent.cummSuccess + agent.αₒ,
                                                agent.cummFailure + agent.βₒ
                                            )

    # Update time steps
    agent.noOfSteps += 1
end

function update_reward!( agent::dTS, r::Float64 )
    rTilde = rand( Distributions.Bernoulli(r) )
    update_reward!( agent, rTilde )
end


function reset!( agent::dTS )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.cummSuccess   = copy( agent.αₒ )
    agent.cummFailure   = copy( agent.βₒ )
    agent.samplingDist  = Distributions.Beta.(agent.αₒ,agent.βₒ)
end

function info_str( agent::dTS, latex::Bool )
    if latex
        return @sprintf( "dTS(\$\\gamma = %4.3f\$)", agent.γ )
    else
        return @sprintf( "dTS(γ = %4.3f)", agent.γ )
    end
end

""" ----------------------------------------------------------------------------
    Discounted Optimistic Thompson Sampling
    Based on: Vishnu Raj, Sheetal Kalyani (2017). Taming Non-stationary Bandits: A Bayesian Approach. https://arxiv.org/abs/1707.09727
"""
type dOTS <: BanditAlgorithmBase
    _dTS::dTS

    function dOTS( noOfArms, γ::Float64 = 1.00,
                    αₒ::Float64 = 1.00, βₒ::Float64 = 1.00 )
        new(
             dTS( noOfArms, γ, αₒ, βₒ )
        )
    end
end

function get_arm_index( agent::dOTS )
    agent._dTS.lastPlayedArm = findmax( [max(rand(armSample),mean(armSample)) for armSample in agent._dTS.samplingDist] )[2]
    return agent._dTS.lastPlayedArm
end

function update_reward!( agent::dOTS, r::Int64 )
    update_reward!( agent._dTS, r )
    nothing
end

function update_reward!( agent::dOTS, r::Float64 )
    update_reward!( agent._dTS, r )
    nothing
end


function reset!( agent::dOTS )
    reset!( agent._dTS )
    nothing
end

function info_str( agent::dOTS, latex::Bool )
    if latex
        return @sprintf( "dOTS(\$\\gamma = %4.3f\$)", agent._dTS.γ )
    else
        return @sprintf( "dOTS(γ = %4.3f)", agent._dTS.γ )
    end
end


""" ----------------------------------------------------------------------------
    Restarting Thompson Sampling
    Based on:
"""

type RestartTS <: BanditAlgorithmBase
    _TS::TS
    Δ::Int64

    function RestartTS( noOfArms::Int, Δ )
        new( TS(noOfArms), Δ )
    end
end

function get_arm_index( agent::RestartTS )
    return get_arm_index( agent._TS )
end

function update_reward!( agent::RestartTS, r::Int64 )
    update_reward!( agent._TS, r )
    if agent._TS.noOfSteps >= agent.Δ
        reset!( agent._TS )
    end
    nothing
end

function update_reward!( agent::RestartTS, r::Float64 )
    update_reward!( agent._TS, r )
    if agent._TS.noOfSteps >= agent.Δ
        reset!( agent._TS )
    end
    nothing
end

function reset!( agent::RestartTS )
    reset!( agent._TS )
    nothing
end

function info_str( agent::RestartTS, latex::Bool )
    if latex
        return @sprintf( "Restarting TS(\$\\Delta = %d\$)", agent.Δ )
    else
        return @sprintf( "Restarting TS(Δ = %d)", agent.Δ )
    end
end

""" ----------------------------------------------------------------------------------------
    Thompson Sampling with Gaussian Priors
    Based on: Algorithm 2, S. Agrawal and N. Goyal, “Near-Optimal Regret Bounds for Thompson Sampling,” J. ACM, vol. 64, no. 5, 2017.
"""
type TSGaussPrior <: BanditAlgorithmBase
    noOfArms::Integer
    noOfSteps::Integer
    lastPlayedArm::Integer

    # Algorithm specific parameters
    μ::Vector{Float64}
    noOfPulls::Vector{Float64} # Even though an integer, keeping this as Float for performance

    samplingDist::Vector{Distributions.Normal}

    function TSGaussPrior( noOfArms::Integer )
        new(
            noOfArms,
            0,
            0,
            zeros( Float64, noOfArms),
            zeros( Float64, noOfArms ),
            fill( Distributions.Normal(0,1), noOfArms )
        )
    end
end

function get_arm_index( agent::TSGaussPrior )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function  update_reward!( agent::TSGaussPrior, r::Real )
    # Update observation
    agent.μ[agent.lastPlayedArm] = (agent.μ[agent.lastPlayedArm]*agent.noOfPulls[agent.lastPlayedArm]+r) / 
                                        (agent.noOfPulls[agent.lastPlayedArm]+1)
    agent.noOfPulls[agent.lastPlayedArm] += 1

    # Update distribution
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Normal(
                                                        agent.μ[agent.lastPlayedArm],
                                                        1.0/(agent.noOfPulls[agent.lastPlayedArm]+1)
                                                )

    # Update time steps
    agent.noOfSteps += 1
    
    nothing
end

function  reset!( agent::TSGaussPrior )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.μ             = zeros( Float64, agent.noOfArms )
    agent.noOfPulls     = zeros( Float64, agent.noOfArms )

    agent.samplingDist  = fill( Distributions.Normal(0,1), agent.noOfArms )
end

function  info_str( agent::TSGaussPrior, latex::Bool )
    return @sprintf( "TS Gauss Prior" )
end