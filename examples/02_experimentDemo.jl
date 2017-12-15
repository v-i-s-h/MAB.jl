# Example for using Experiments

using MAB
import PyPlot

bandit  = [
    Arms.Bernoulli( 0.90 ),
    Arms.Bernoulli( 0.85 ),
    Arms.Bernoulli( 0.80 ),
    Arms.Bernoulli( 0.75 )
    # Arms.Normal( 0.36, 1.00 ),
    # Arms.Normal( 0.20, 1.00 ),
    # Arms.Normal( 0.81, 1.00 ),
    # Arms.Normal( 0.56, 1.00 ),
    # Arms.Exponential( 1.2 ),
    # Arms.Exponential( 2.3 ),
    # Arms.Exponential( 3.4 ),
    # Arms.Exponential( 4.5 )
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
    # UniformStrategy( noOfArms ),
    # epsGreedy( noOfArms, 0.05 ),
    # epsGreedy( noOfArms, 1.00 ),
    # epsNGreedy( noOfArms, 5, 0.05 ),
    # epsNGreedy( noOfArms, 1/noOfArms, 1.0 ),
    # epsNGreedy( noOfArms ),
    # EXP3( noOfArms, 0.05 ),
    # EXP3( noOfArms, 0.10 ),
    # UCB1( noOfArms, 1/8 ),
    # UCB1( noOfArms, 1/4 ),
    # UCB1( noOfArms, 1/2 ),
    # UCB1( noOfArms, 1/√2 ),
    # UCB1( noOfArms, 1 ),
    # UCB1( noOfArms, √2 ),
    # UCB1( noOfArms, 2 ),
    # TS( noOfArms ),
    # OTS( noOfArms ),
    # DynamicTS( noOfArms, 10 ),
    # UCBNormal( noOfArms ),
    # EXP31( noOfArms ),
    # SoftMax( noOfArms, 0.008 ),
    # SoftMax( noOfArms, 0.009 ),
    # SoftMax( noOfArms, 0.010 ),
    # UniformStrategy( noOfArms ),
    # epsGreedy( noOfArms, 0.01 ),
    # epsGreedy( noOfArms, 0.05 ),
    # EXP3( noOfArms, 0.10 ),
    # REXP3( noOfArms, 0.10, 100 ),
    # UCB1( noOfArms ),
    # DUCB( noOfArms, 1.00, 0.5 ),
    # DUCB( noOfArms, 0.99 ),
    # DUCB( noOfArms, 0.99, 5.0 ),
    # EXP3( noOfArms, 0.90 ),
    # EXP3IX( noOfArms, 0.90, 0.60 )
    # TSNormal( noOfArms, 1 ),
    # TSNormal( noOfArms, 10 ),
    # TSNormal( noOfArms, 100 )
    # UCBV( noOfArms ),
    # UCBV( noOfArms, ζ = 1, c = 1),
    # UCBV( noOfArms, ζ = 2.0, c = 1),
    # BayesUCB( noOfArms ),
    # KLUCB( noOfArms )
    # TS( noOfArms ),
    # OTS( noOfArms ),
    # dTS( noOfArms ),
    # dOTS( noOfArms ),
    # dTS( noOfArms, 0.90 ),
    # dOTS( noOfArms, 0.90 ),
    # TSGaussPrior( noOfArms )
    GradientBandit( noOfArms, 0.1 ),
    KLMANB( noOfArms, 2.0, 0.0 )
]

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
