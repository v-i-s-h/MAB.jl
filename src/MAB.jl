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

    export
        # Methods
        get_arm_index, update_reward!, reset!, info_str, show,
        # Agents
        BanditAlgorithmBase,
        epsGreedy, epsNGreedy,
        EXP3, EXP31, REXP3, EXP3IX,
        KLMANB,
        SoftMax,
        TS, DynamicTS, OTS, TSNormal, dTS, dOTS, RestartTS,
        UCB1, UCBNormal, DUCB, SWUCB, UCBV, BayesUCB, KLUCB,
        UniformStrategy
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
    using ..Algorithms
    using ..Arms
    # import
    #--------------------------- Import Experiments Here --------------------------#
    include( "Experiments/BanditExpBase.jl" )
    include( "Experiments/Compare.jl" )
end

    using .Algorithms
    export
        # Export algorithms
        Algorithms,
        # Methods
        get_arm_index, update_reward!, reset!, info_str, show,
        # Agents
        BanditAlgorithmBase,
        epsGreedy, epsNGreedy,
        EXP3, EXP31, REXP3, EXP3IX,
        KLMANB,
        SoftMax,
        TS, DynamicTS, OTS, TSNormal, dTS, dOTS, RestartTS,
        UCB1, UCBNormal, DUCB, SWUCB, UCBV, BayesUCB, KLUCB,
        UniformStrategy,
        # Export Arm models
        Arms,
        # Export Experiments
        Experiments
end # module
