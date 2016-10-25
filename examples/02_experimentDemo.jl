# Example for using Experiments

using Bandits
import PyPlot

bandit  = [
    Arms.Bernoulli( 0.12 ),
    Arms.Bernoulli( 0.90 ),
    Arms.Normal( 0.36, 1.00 ),
    Arms.Normal( 0.20, 1.00 )
    # Arms.Beta( 0.60, 0.40 ),
    # Arms.Beta( 0.70, 0.20 )
]

noOfArms = size( bandit, 1 )

testAlgs = [
    Algorithms.EXP3( noOfArms, 0.05 ),
    Algorithms.EXP3( noOfArms, 0.10 ),
    Algorithms.EXP3( noOfArms, 0.15 ),
    Algorithms.EXP3( noOfArms, 0.20 ),
    Algorithms.EXP3( noOfArms, 0.25 ),
]

exp1 = Experiments.Compare( bandit, testAlgs )
# run
noOfRounds      = 2000
noOfTimeSteps   = 2500
result = Experiments.run( exp1, noOfTimeSteps, noOfRounds )

fig = PyPlot.figure()
## Plot avg rewards
for alg in keys(result)
    PyPlot.plot( 1:noOfTimeSteps, result[alg], label = alg )
end

PyPlot.xlabel( "Timesteps" )
PyPlot.ylabel( "Avg. Reward" )
ax = PyPlot.gca()
ax[:set_ylim]( [0.00,1.00] )
PyPlot.legend()
