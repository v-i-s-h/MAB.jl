# Base for implementing all algorithms
abstract type BanditAlgorithmBase end

function get_arm_index( agent::BanditAlgorithmBase )
    error( "No implementation of getArmIndex() for ", typeof(agent) );
end

function update_reward!( agent::BanditAlgorithmBase, r::Real )
    error( "No implementation of updateReward() for ", typeof(agent) );
end

function reset!( agent::BanditAlgorithmBase )
    error( "No implementation of reset() for ", typeof(agent) );
end

function info_str( agent::BanditAlgorithmBase, latex::Bool = false )
    error( "No Implementation of info_str() for ", typeof(agent) );
end

# import Base.show
function Base.show( io::IO, ::MIME"text/plain", agent::BanditAlgorithmBase )
    print( io, @sprintf("Algorithm: %s",info_str(agent)) )
    for param in fieldnames(agent)
        print( @sprintf("\n    %-16s: ",param), getfield(agent,param) )
    end
end
