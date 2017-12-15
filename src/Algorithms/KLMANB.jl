"""
    Implements KLMANB
"""

type KLMANB <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    μ::Vector{Float64}
    σ²::Vector{Float64}
    σₒ²::Float64
    σₜ²::Float64

    samplingDist::Vector{Distributions.Normal}

    function KLMANB( noOfArms::Int64, σₒ²::Float64, σₜ²::Float64 )
        new( noOfArms,
             0,
             0,
             zeros(Float64,noOfArms),
             1e4 * ones(Float64,noOfArms),
             σₒ²,
             σₜ²,
             fill(Distributions.Normal(0,1e2),noOfArms)
        )
    end
end

function get_arm_index( agent::KLMANB )
    agent.lastPlayedArm = findmax( [rand(armSample) for armSample in agent.samplingDist] )[2]
    return agent.lastPlayedArm
end

function update_reward!( agent::KLMANB, r::Real )
    # Update mean and variance
    agent.μ[agent.lastPlayedArm]  = ( (agent.σ²[agent.lastPlayedArm] + agent.σₜ²)*r + 
                                        (agent.σₒ² * agent.μ[agent.lastPlayedArm]) )  / 
                                      (agent.σ²[agent.lastPlayedArm] + agent.σₜ² + agent.σₒ²)
    agent.σ²[agent.lastPlayedArm] = ( (agent.σ²[agent.lastPlayedArm]+agent.σₜ²) * agent.σₒ² ) / 
                                      (agent.σ²[agent.lastPlayedArm] + agent.σₜ² + agent.σₒ²)

    # Update Distributions
    agent.samplingDist[agent.lastPlayedArm] = Distributions.Normal(
                                                  agent.μ[agent.lastPlayedArm],
                                                  agent.σ²[agent.lastPlayedArm]
                                              )
    # Update time steps
    agent.noOfSteps += 1

    nothing
end

function reset!( agent::KLMANB )
    agent.noOfSteps     = 0
    agent.lastPlayedArm = 0

    agent.μ     = zeros( Float64, agent.noOfArms )
    agent.σ²    = 1e4 * ones( Float64, agent.noOfArms )
    agent.samplingDist  = fill( Distributions.Normal(0,1e2), agent.noOfArms )

    nothing
end

function info_str( agent::KLMANB, latex::Bool )
    if latex
        return @sprintf( "KLMANB \$(\\sigma_{o}^2 = %4.3f, \\sigma_{t}^2 = %4.3f)\$", 
                            agent.σₒ², agent.σₜ² )
    else
        return @sprintf( "KLMANB (σₒ² = %4.3f, σₜ² = %4.3f)", agent.σₒ², agent.σₜ² )
    end
end
