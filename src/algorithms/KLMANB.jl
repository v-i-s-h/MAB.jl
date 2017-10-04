"""
    Implements KLMANB
"""

type KLMANB <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    μ::Vector{Float64}
    σ_sq::Vector{Float64}
    ObsVar::Float64
    TrVar::Float64

    samplingDist::Vector{Distributions.Normal}

    function KLMANB( noOfArms::Int64, ObsVar::Float64, TrVar::Float64 )
        new( noOfArms,
             0,
             0,
             zeros(Float64,noOfArms),
             10000 * ones(Float64,noOfArms),
             ObsVar,
             TrVar,
             fill(Distributions.Normal(0,10000),noOfArms)
        )
    end
end

function get_arm_index( agent::KLMANB )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function update_reward!( agent::KLMANB, r::Real )
    # Update mean and variance
    agent.μ[agent.lastPlayedArm] = (((agent.σ_sq[agent.lastPlayedArm] + agent.TrVar)*r) + (agent.ObsVar * agent.μ[agent.lastPlayedArm])) / (agent.σ_sq[agent.lastPlayedArm] + agent.TrVar + agent.ObsVar)
    agent.σ_sq[agent.lastPlayedArm] = ((agent.σ_sq[agent.lastPlayedArm] + agent.TrVar)* agent.ObsVar) / (agent.σ_sq[agent.lastPlayedArm] + agent.TrVar + agent.ObsVar)

    # Update Distributions
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Normal(
                                                  agent.μ[agent.lastPlayedArm],
                                                  agent.σ_sq[agent.lastPlayedArm]
                                              )
    # Update time steps
    agent.noOfSteps += 1
end

function reset!( agent::KLMANB )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.μ      = zeros( Float64, agent.noOfArms )
    agent.σ_sq   = 10000 * ones( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Normal(0,10000), agent.noOfArms )
end

function info_str( agent::KLMANB )
    return @sprintf( "KLMANB" )
end
