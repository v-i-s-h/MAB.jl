# Adding new Agents

using MAB
using PyPlot

import MAB.Algorithms: BanditAlgorithmBase, get_arm_index, update_reward!, reset!, info_str

# ------------------------------------------------------------------------------
type MyAwesomeAlgorithm <: BanditAlgorithmBase
    noOfArms::Int64
    noOfSteps::Int64
    lastPlayedArm::Int64

    function MyAwesomeAlgorithm( noOfArms::Int64 )
        new( noOfArms,
             0,
             0
        )
    end
end
function get_arm_index( agent::MyAwesomeAlgorithm )
    return rand( 1:agent.noOfArms )
end
function update_reward!( agent::MyAwesomeAlgorithm, r::Real )
    # Do nothing
    nothing
end
function reset!( agent::MyAwesomeAlgorithm )
    # Do nothing
    nothing
end
function info_str( agent::MyAwesomeAlgorithm, latex::Bool )
    return @sprintf( "My Awesome Algorithm" )
end
# ------------------------------------------------------------------------------

bandit = [ Arms.Bernoulli( 0.3 ),
           Arms.Bernoulli( 0.4 ),
           Arms.Bernoulli( 0.5 ) ];

testAlgs = [ epsGreedy( length(bandit), 0.1 ),
             MyAwesomeAlgorithm( length(bandit) ) ];

exp1 = Experiments.Compare( bandit, testAlgs )
# run
noOfRounds      = 1000
noOfTimeSteps   = 1000
result = Experiments.run( exp1, noOfTimeSteps, noOfRounds )

fig = PyPlot.figure()
## Plot avg rewards
for alg in keys(result)
    PyPlot.plot( 1:noOfTimeSteps, cumsum(result[alg])./collect(1:noOfTimeSteps), label = alg )
end

PyPlot.xlabel( "Timesteps" )
PyPlot.ylabel( "Avg. Reward" )
PyPlot.title( "Average Reward (Normalized for $noOfRounds rounds)")
# ax = PyPlot.gca()
# ax[:set_ylim]( [0.00,1.00] )
PyPlot.legend()
PyPlot.grid()