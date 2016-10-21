# Example for using Experiments

using Bandits

bandit  = [
    Arms.Bernoulli( 0.12 ),
    Arms.Bernoulli( 0.15 ),
    Arms.Bernoulli( 0.21 ),
    Arms.Bernoulli( 0.53 )
]

noOfArms = size( bandit, 1 )

testAlgs = [
    Algorithms.epsGreedy( noOfArms, 0.05 ),
    Algorithms.epsGreedy( noOfArms, 0.20 ),
    Algorithms.UCB1( noOfArms )
]

exp1 = Experiments.Compare( bandit )
