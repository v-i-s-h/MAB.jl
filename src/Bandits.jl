module Bandits

module Algorithms
    using Distributions
    #--------------------------- Import Algorithms Here ---------------------------#
    include( "algorithms/BanditAlgorithmBase.jl" )
    include( "algorithms/UCB.jl" )
    include( "algorithms/epsGreedy.jl" )
end

module Arms
    using Distributions
    #--------------------------- Import Arm Models Here ---------------------------#
    include( "armModels/BanditArmBase.jl" )
    include( "armModels/Bernoulli.jl" )
    include( "armModels/Normal.jl" )
end


#--------------------------- Import Experiments Here --------------------------#

export
    # Export algorithms
    Algorithms,
    # Export Arm models
    Arms
    # Export Experiments

end # module
