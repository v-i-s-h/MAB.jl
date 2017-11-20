# To recreate Fig 2.2
type fig_2_2 <: BanditExpBase

    # List of new algorithms to compare - in case you don't know the number of arms
    #   and later create in run() create the actual objects
    # >> agents::Vector{Tuple{DataType,Any}}
    # But here we know the number of arms = 10; so we can create them 
    # in constructor;
    
    agents::Vector{BanditAlgorithmBase}
    
    default_agents::Vector{BanditAlgorithmBase}
    
    # function fig_2_2(; agents::Vector{Tuple{DataType,Any}} = nothing )
    function fig_2_2(;agents::Vector{} = Vector{}() )
        K = 10
        _agents = make_agents_with_k( K, agents )
        new(
            _agents,
            # Here goes the default agents
            [ epsGreedy(K,ϵ) for ϵ ∈ (0.00,0.01,0.10) ]
        )
    end
end

function run( xp::fig_2_2;
                T::Integer = 1000,
                rounds::Integer = 2000,
                run_default::Bool = true,
                seed::Int64 = 1729 )
    result = Dict{String,Dict{String,Vector{Float64}}}()
    result["Avg. Mean"]         = Dict{String,Vector{Float64}}()
    result["Optimal Actions"]   = Dict{String,Vector{Float64}}()

    # Run 
    r = run_env( xp.agents, T, rounds, seed )
    merge!( result["Avg. Mean"], r["Avg. Mean"] )
    merge!( result["Optimal Actions"], r["Optimal Actions"] )
    if run_default
        r = run_env( xp.default_agents, T, rounds, seed )
        merge!( result["Avg. Mean"], r["Avg. Mean"] )
        merge!( result["Optimal Actions"], r["Optimal Actions"] )
    end

    # Plot results
    fig_2_1_a = plot( title = "Average Reward", 
            xlabel  = "Timesteps", ylabel = "Avg. Reward", 
            ylim    = (0,1.5),
            yticks  = 0.0:0.5:1.5 )
    for (_agent,_result) ∈ result["Avg. Mean"]
        plot!( 1:T, _result, label = _agent )
    end

    fig_2_1_b = plot( title = "% Optimal Arms",
                        xlabel  = "Timesteps", ylabel = "% optimal arm",
                        ylim    = (0,100),
                        yticks  = 0:20:100 )
    for (_agent,_result) ∈ result["Optimal Actions"]
        plot!( 1:T, _result, label = _agent )
    end

    return fig_2_1_a, fig_2_1_b
end

# This will be specific to experiments
function run_env( agents::Vector{BanditAlgorithmBase},
                    T::Int64, rounds::Int64, seed::Int64  )
    result = Dict{String,Dict{String,Vector{Float64}}}()
    result["Avg. Mean"]         = Dict{String,Vector{Float64}}()
    result["Optimal Actions"]   = Dict{String,Vector{Float64}}()

    for alg ∈ agents
        srand( seed );  # Seed initialization for RNG - across all algorithms
        r = zeros( T )
        a = zeros( T )

        for _round = 1:rounds
            reset!( alg )
            # Create a new bandit
            arm_mean    = randn( 10 )
            bandit = [ Arms.Normal(μ,1.0) for μ ∈ arm_mean ]
            optimal_arm = findmax(arm_mean)[2]
            for _n = 1:T
                armToPull   = get_arm_index( alg )
                reward      = Arms.pull!( bandit[armToPull] )
                update_reward!( alg, reward )
                r[_n] += reward
                a[_n] += (armToPull==optimal_arm)?1:0
                # Process tick() for all arms except the pulled arm
                for arm in bandit
                    if arm == bandit[armToPull]
                        continue
                    else
                        Arms.tick!( arm )
                    end
                end
            end
        end
        avgReward   = r ./ rounds # mean( r, 2 )
        optimArm    = 100 * a ./ rounds # 100 * mean( a, 2 )
        result["Avg. Mean"][info_str(alg)] = avgReward
        result["Optimal Actions"][info_str(alg)] = optimArm
    end
    return result
end
