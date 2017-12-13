using MAB

alg = Algorithms.SWUCB( 3, 5 )

println( Algorithms.info_str(alg,false) )
for i = 1:10
    idx = Algorithms.getArmIndex( alg )
    r   = rand()
    Algorithms.updateReward!( alg, r )
    println( "i = $i" )
    println( "\tnoOfSteps       : ", alg.noOfSteps )
    println( "\tlastPlayedArm   : ", alg.lastPlayedArm )
    println( "\tcummReward      : ", alg.cummReward )
    println( "\tcount           : ", alg.count )
    println( "\tswCount         : ", alg.swCount )
    println( "\tarmsInWindow    : ", alg.armsInWindow )
    println( "\trewardsInWindow : ", alg.rewardsInWindow )
    println( "\tindices         : ", alg.indices)
end
Algorithms.reset!( alg )
println( Algorithms.info_str(alg,false) )
for i = 1:10
    idx = Algorithms.getArmIndex( alg )
    r   = rand()
    Algorithms.updateReward!( alg, r )
    println( "i = $i" )
    println( "\tnoOfSteps       : ", alg.noOfSteps )
    println( "\tlastPlayedArm   : ", alg.lastPlayedArm )
    println( "\tcummReward      : ", alg.cummReward )
    println( "\tcount           : ", alg.count )
    println( "\tswCount         : ", alg.swCount )
    println( "\tarmsInWindow    : ", alg.armsInWindow )
    println( "\trewardsInWindow : ", alg.rewardsInWindow )
    println( "\tindices         : ", alg.indices)
end
Algorithms.reset!( alg )
