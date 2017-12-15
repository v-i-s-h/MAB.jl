"""
    An Uniform playing strategy for Bandits: Can be used as benchmark
"""

type UniformStrategy <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    function UniformStrategy( noOfArms::Int64 )
        new( noOfArms,
             0,
             0
        )
    end
end

function get_arm_index( agent::UniformStrategy )
    agent.lastPlayedArm = rand( 1:agent.noOfArms )
    return agent.lastPlayedArm
end

function update_reward!( agent::UniformStrategy, r::Real )
    agent.noOfSteps += 1
    # Do nothing

    nothing
end

function reset!( agent::UniformStrategy )
    agent.lastPlayedArm = 0
    agent.noOfSteps = 0
    # Do nothing

    nothing
end

function info_str( agent::UniformStrategy, latex::Bool )
    return @sprintf( "Uniform Strategy" )
end
