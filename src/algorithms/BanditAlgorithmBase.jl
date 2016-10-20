# Base for implementing all algorithms
abstract BanditAlgorithmBase

function getArmIndex( agent::BanditAlgorithmBase )
    error( "[BanditAlgorithmBase]: No implementation of getArmIndex() for ", typeof(agent) );
end

function updateReward( agent::BanditAlgorithmBase, r::Float64 )
    error( "[BanditAlgorithmBase]: No implementation of updateReward() for ", typeof(agent) );
end
