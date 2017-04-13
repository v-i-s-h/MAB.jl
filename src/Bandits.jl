module Bandits

module Algorithms
    using Distributions
    #--------------------------- Import Algorithms Here ---------------------------#
    include( "algorithms/BanditAlgorithmBase.jl" )
    include( "algorithms/UniformStrategy.jl" )
    include( "algorithms/UCB.jl" )
    include( "algorithms/epsGreedy.jl" )
    include( "algorithms/EXP.jl" )
    include( "algorithms/TS.jl" )
    include( "algorithms/KLMANB.jl" )
    include( "algorithms/SoftMax.jl" )
end

module Arms
    using Distributions
    #--------------------------- Import Arm Models Here ---------------------------#
    include( "armModels/BanditArmBase.jl" )
    include( "armModels/Bernoulli.jl" )
    include( "armModels/Normal.jl" )
    include( "armModels/Beta.jl" )
    include( "armModels/Sinusoidal.jl" )
    include( "armModels/Pulse.jl" )

end

module Experiments
    using Distributions
    import Bandits.Arms
    import Bandits.Algorithms
    # include( "algorithms/BanditAlgorithmBase.jl" )
    # include( "armModels/BanditArmBase.jl" )
    #--------------------------- Import Experiments Here --------------------------#
    include( "experiments/BanditExpBase.jl" )
    include( "experiments/Compare.jl" )
end

export
    # Export algorithms
    Algorithms,
    # Export Arm models
    Arms,
    # Export Experiments
    Experiments
end # module
