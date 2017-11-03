# This examples show how to run a simple test

using MAB
import PyPlot

# Create 5 Bernoulli arms
armRewards = [ 0.15, 0.20, 0.22, 0.65, 0.12 ]
arms = []
for p in armRewards
    push!( arms, Arms.Bernoulli(p) )
end

# Initiate eps Greedy algorithms
noOfArms = size( armRewards, 1 )
alg11 = epsGreedy( noOfArms, 0.05 )
alg12 = epsGreedy( noOfArms, 0.25 )
alg13 = epsGreedy( noOfArms, 0.50 )
alg14 = epsGreedy( noOfArms, 0.65 )
alg2  = UCB1( noOfArms )

algorithms = [ alg11 alg12 alg13 alg14 alg2 ]


# Number Runs
noOfRounds      = 1000
noOfTimeSteps   = 2000

fig = PyPlot.figure()

for _alg ∈ algorithms
    observations    = zeros( noOfTimeSteps, noOfRounds )
    for _round = 1:noOfRounds
        Algorithms.reset!( _alg )    # Start by resetting the memory
        for _time = 1:noOfTimeSteps
            armToPull = get_arm_index( _alg )
            reward    = Arms.pull!( arms[armToPull] )
            update_reward!( _alg, reward )

            # print( @sprintf("    [%03d:%03d]: arm = %2d, reward = %3.2f ",_round,_time,armToPull,reward) )
            # print( @sprintf( "    Arm Values: [") )
            # print( [@sprintf("%4.3f ",x) for x in alg.avgValue]..., "]\n" )

            # Update observations
            observations[_time,_round] = reward
            # print( observations )
        end
    end
    avgReward = mean( observations, 2 );
    PyPlot.plot( 1:noOfTimeSteps, avgReward, label = Algorithms.info_str(_alg) )
end

PyPlot.ylabel( "Avg. Reward" )
PyPlot.xlabel( "Timesteps" )
PyPlot.title( "Comparison Plot (Averaged over $noOfRounds runs)" )
ax = PyPlot.gca()
ax[:set_ylim]( [0.00, 1.00] )
PyPlot.legend()
