# Code for Figure 2.4

type fig_2_4 <: BanditExpBase
    # Reuse the test bed from Fig2.2
    _exp::fig_2_2
    
    function fig_2_4(;agents::Vector{} = Vector{}() )
        xp = fig_2_2( agents = agents )
        # Change default agents
        K = xp.default_agents[1].noOfArms
        xp.default_agents = [
            epsGreedy( K, 0.1 ),
            UCB1( K, 2 )
        ]
        new( fig_2_2(xp) )
    end
end

function run( xp::fig_2_4;
                T::Integer = 1000,
                rounds::Integer = 1000,
                run_default::Bool = true,
                seed::Int64 = 1729 )
    return run( xp._exp, T = T, rounds = rounds, 
                run_default = run_default, seed = seed )
end