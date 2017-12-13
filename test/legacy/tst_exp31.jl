using MAB

alg = Algorithms.EXP31( 3 )

# For Bernoulli Bandit
for i = 1:10
    idx = Algorithms.getArmIndex( alg )
    print( "Playing Arm#$idx .... " )
    r = rand()
    print( "Reward: $r\n" )
    Algorithms.updateReward!( alg, r )
    println( alg )
end

println( "Resetting the algorithm..." )
Algorithms.reset!( alg )

# For [0,1] Arms
for i = 1:10
    idx = Algorithms.getArmIndex( alg )
    print( "Playing Arm#$idx .... " )
    r = rand()
    print( "Reward: $r\n" )
    Algorithms.updateReward!( alg, r )
    println( alg )
end
