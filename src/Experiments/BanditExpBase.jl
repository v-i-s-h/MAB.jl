# Base type for all experiments
import Base: run
abstract type BanditExpBase end

function run( experiment::BanditExpBase,
              noOfTimeSteps::Integer,
              noOfRounds::Integer )
    error( "[BanditExpBase]: No Implementation of run() for ", typeof(experiment) )
end
