# Test for Thompson Sampling

# Bernouli Arm Case

using MAB

ts1 = Algorithms.TS( 4 )

# For Bernoulli Bandit
for i = 1:10
    idx = Algorithms.getArmIndex( ts1 )
    print( "Playing Arm#$idx .... " )
    r = rand( Distributions.Bernoulli(0.5) )
    print( "Reward: $r\n" )
    Algorithms.updateReward!( ts1, r )
    println( ts1 )
end

Algorithms.reset!( ts1 )

# For [0,1] Arms
for i = 1:10
    idx = Algorithms.getArmIndex( ts1 )
    print( "Playing Arm#$idx .... " )
    r = rand()
    print( "Reward: $r\n" )
    Algorithms.updateReward!( ts1, r )
    println( ts1 )
end
