module MAB

module Algorithms
    using Distributions
    #--------------------------- Import Algorithms Here ---------------------------#
    include( "Algorithms/BanditAlgorithmBase.jl" )
    include( "Algorithms/UniformStrategy.jl" )
    include( "Algorithms/UCB.jl" )
    include( "Algorithms/epsGreedy.jl" )
    include( "Algorithms/EXP.jl" )
    include( "Algorithms/TS.jl" )
    include( "Algorithms/KLMANB.jl" )
    include( "Algorithms/SoftMax.jl" )
end

module Arms
    using Distributions
    #--------------------------- Import Arm Models Here ---------------------------#
    include( "ArmModels/BanditArmBase.jl" )
    include( "ArmModels/Bernoulli.jl" )
    include( "ArmModels/Exponential.jl" )
    include( "ArmModels/Normal.jl" )
    include( "ArmModels/Beta.jl" )
    include( "ArmModels/Sinusoidal.jl" )
    include( "ArmModels/Pulse.jl" )
    include( "ArmModels/Square.jl" )
    include( "ArmModels/Variational.jl" )
end

module Experiments
    using Distributions
    import MAB.Arms
    import MAB.Algorithms
    # include( "algorithms/BanditAlgorithmBase.jl" )
    # include( "armModels/BanditArmBase.jl" )
    #--------------------------- Import Experiments Here --------------------------#
    include( "Experiments/BanditExpBase.jl" )
    include( "Experiments/Compare.jl" )
end

export
    # Export algorithms
    Algorithms,
    # Algorithms - functions
    BanditAlgorithmBase,
    get_arm_index, update_reward!, reset!,
    info_str, show,
    # Algorithms - Agents
    UniformStrategy, 
    # Export Arm models
    Arms,
    # Export Experiments
    Experiments
end # module
