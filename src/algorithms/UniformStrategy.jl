"""
    An Uniform playing strategy for Bandits
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

function getArmIndex( agent::UniformStrategy )
    return rand( 1:agent.noOfArms )
end

function updateReward( agent::UniformStrategy, r::Real )
    # Do nothing
end

function reset( agent::UniformStrategy )
    # Do nothing
end

function info_str( agent::UniformStrategy, latex::Bool )
    return @sprintf( "Uniform Strategy" )
end
