# Base for implementing all algorithms
abstract type BanditAlgorithmBase end

function getArmIndex( agent::BanditAlgorithmBase )
    error( "No implementation of getArmIndex() for ", typeof(agent) );
end

function updateReward!( agent::BanditAlgorithmBase, r::Real )
    error( "No implementation of updateReward() for ", typeof(agent) );
end

function reset!( agent::BanditAlgorithmBase )
    error( "No implementation of reset() for ", typeof(agent) );
end

function info_str( agent::BanditAlgorithmBase, latex::Bool = false )
    error( "No Implementation of info_str() for ", typeof(agent) );
end
