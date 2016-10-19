module Bandits

using Distributions

#--------------------------- Import Algorithms Here ---------------------------#
include( "algorithms/BanditAlgorithmBase.jl" )
include( "algorithms/UCB.jl" )
include( "algorithms/epsGreedy.jl" )

#--------------------------- Import Arm Models Here ---------------------------#

#--------------------------- Import Experiments Here --------------------------#

export
    # Export algorithms
    BanditAlgorithmBase,
    UCB1,
    epsGreedy

    # Export Arm models

    # Export Experiments

end # module
