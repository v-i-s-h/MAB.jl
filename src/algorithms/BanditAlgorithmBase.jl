# Base for implementing all algorithms
abstract BanditAlgorithmBase

function getArmIndex( agent::BanditAlgorithmBase )
    error( "[BanditAlgorithmBase]: No implementation of getArmIndex() for ", typeof(agent) );
end

function updateReward( agent::BanditAlgorithmBase, r::Real )
    error( "[BanditAlgorithmBase]: No implementation of updateReward() for ", typeof(agent) );
end

function reset( agent::BanditAlgorithmBase )
    error( "[BanditAlgorithmBase]: No implementation of reset() for ", typeof(agent) );
end
