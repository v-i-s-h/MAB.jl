# Base type for all experiments

abstract type BanditExpBase end

function run( experiment::BanditExpBase,
              noOfTimeSteps::Integer,
              noOfRounds::Integer )
    error( "[BanditExpBase]: No Implementation of run() for ", typeof(experiment) )
end
