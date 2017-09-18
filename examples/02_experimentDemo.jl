# Example for using Experiments

using Bandits
import PyPlot

bandit  = [
    # Arms.Bernoulli( 0.20 ),
    # Arms.Bernoulli( 0.90 ),
    # Arms.Bernoulli( 0.10 ),
    # Arms.Bernoulli( 0.15 )
    Arms.Normal( 0.36, 1.00 ),
    Arms.Normal( 0.20, 1.00 ),
    Arms.Normal( 0.81, 1.00 ),
    Arms.Normal( 0.56, 1.00 ),
    # Arms.Beta( 0.60, 0.40 ),
    # Arms.Sinusoidal( 800, 0 ),
    # Arms.Sinusoidal( 800, π ),
    # Arms.Sinusoidal( 800, π/2 ),
    # Arms.Sinusoidal( 800, 3*π/4 )
    # Arms.Pulse( 1000, 820, 100 ),
    # Arms.Pulse( 1000, 700, 100 ),
    # Arms.Pulse( 1000, 520, 100 )
    # Arms.Square( 200, Dict([(1,0.5),(40, 0.8),(120,0.25),(180,0.40)])),
    # Arms.Square( 200, Dict([(20, 0.3),(80,0.90),(150,0.40),(176,0.10)])),
]

noOfArms = length( bandit )

testAlgs = [
    # Algorithms.UniformStrategy( noOfArms ),
    # Algorithms.epsGreedy( noOfArms, 0.05 ),
    # Algorithms.epsGreedy( noOfArms, 1.00 ),
    # Algorithms.epsNGreedy( noOfArms, 5, 0.05 ),
    # Algorithms.epsNGreedy( noOfArms, 1/noOfArms, 1.0 ),
    # Algorithms.epsNGreedy( noOfArms ),
    # Algorithms.EXP3( noOfArms, 0.05 ),
    # Algorithms.EXP3( noOfArms, 0.10 ),
    # Algorithms.UCB1( noOfArms ),
    # Algorithms.TS( noOfArms ),
    # Algorithms.OTS( noOfArms ),
    # Algorithms.DynamicTS( noOfArms, 10 ),
    Algorithms.UCBNormal( noOfArms ),
    # Algorithms.EXP31( noOfArms ),
    # Algorithms.SoftMax( noOfArms, 0.008 ),
    # Algorithms.SoftMax( noOfArms, 0.009 ),
    # Algorithms.SoftMax( noOfArms, 0.010 ),
    # Algorithms.UniformStrategy( noOfArms ),
    # Algorithms.epsGreedy( noOfArms, 0.01 ),
    # Algorithms.epsGreedy( noOfArms, 0.05 ),
    # Algorithms.EXP3( noOfArms, 0.10 ),
    # Algorithms.REXP3( noOfArms, 0.10, 100 ),
    # Algorithms.UCB1( noOfArms ),
    # Algorithms.DUCB( noOfArms, 1.00, 0.5 ),
    # Algorithms.DUCB( noOfArms, 0.99 ),
    # Algorithms.DUCB( noOfArms, 0.99, 5.0 ),
    # Algorithms.EXP3( noOfArms, 0.90 ),
    # Algorithms.EXP3IX( noOfArms, 0.90, 0.60 )
    Algorithms.TSNormal( noOfArms, 1 ),
    Algorithms.TSNormal( noOfArms, 10 ),
    Algorithms.TSNormal( noOfArms, 100 )
]

exp1 = Experiments.Compare( bandit, testAlgs )
# run
noOfRounds      = 1000
noOfTimeSteps   = 1000
result = Experiments.run( exp1, noOfTimeSteps, noOfRounds )

fig = PyPlot.figure()
## Plot avg rewards
for alg in keys(result)
    PyPlot.plot( 1:noOfTimeSteps, result[alg], label = alg )
end

PyPlot.xlabel( "Timesteps" )
PyPlot.ylabel( "Avg. Reward" )
PyPlot.title( "Average Reward (Normalized for $noOfRounds rounds)")
ax = PyPlot.gca()
ax[:set_ylim]( [0.00,1.00] )
PyPlot.legend()
PyPlot.grid()
