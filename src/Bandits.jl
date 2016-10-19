module Bandits

using Distributions

export
    # Export algorithms
    BanditAlgorithmBase,
    UCB1

    # Export Arm models

    # Export Experiments

#--------------------------- Import Algorithms Here ---------------------------#
include( "algorithms/BanditAlgorithmBase.jl" )
include( "algorithms/UCB.jl" )

#--------------------------- Import Arm Models Here ---------------------------#

#--------------------------- Import Experiments Here --------------------------#

end # module
