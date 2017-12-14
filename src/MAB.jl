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
        get_arm_index, update_reward!, reset!, info_str, 
        show,
        # Agents
        BanditAlgorithmBase,
        epsGreedy, epsNGreedy,
        EXP3, EXP31, REXP3, EXP3IX,
        KLMANB,
        SoftMax,
        TS, DynamicTS, OTS, TSNormal, dTS, dOTS, RestartTS, TSGaussPrior,
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

    # export
        # Export only methods, not Arm types to avoid collision with Distributions
        # pull!, tick!, reset!
end

module Experiments
    using Distributions
    using Requires
    # import Base: run
    # using Plots
    @require Plots using Plots
    # info( "Some functionalities of MAB.Experiments will not be available until you load Plots.jl",
    #         prefix = "MAB: " )
    using ..Algorithms
    using ..Algorithms: make_agents_with_k  # Util for making agents inside Experiments
    using ..Arms
    # import
    #--------------------------- Import Experiments Here --------------------------#
    include( "Experiments/BanditExpBase.jl" )
    # include( "Experiments/utils.jl" )
    include( "Experiments/Compare.jl" )
    include( "Experiments/Sutton2017/Sutton2017.jl" )

    export
        # Methods
        run,
        # Experiments
        Sutton2017, run
end

    using .Algorithms
    using .Arms
    using .Experiments
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
        TS, DynamicTS, OTS, TSNormal, dTS, dOTS, RestartTS, TSGaussPrior,
        UCB1, UCBNormal, DUCB, SWUCB, UCBV, BayesUCB, KLUCB,
        UniformStrategy,
        # Export Arm models
        Arms,
        # Methods 
        # pull!, tick!, reset!,  # Causes ambiguation with Algorithms.reset!
        # Export Experiments
        Experiments,
        # Methods
        run,
        # Experiments
        Sutton2017
end # module
