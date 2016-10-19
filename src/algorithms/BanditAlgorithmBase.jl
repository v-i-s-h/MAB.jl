# Base for implementing all algorithms
abstract BanditAlgorithmBase

function getArmIndex( agent::BanditAlgorithmBase )
    error( "[BanditAlgorithmBase]: No implamentation of getArmIndex() for ", typeof(agent) );
end

function updateReward( agent::BanditAlgorithmBase, r::Float64 )
    error( "[BanditAlgorithmBase]: No implamentation of updateReward() for ", typeof(agent) );
end
