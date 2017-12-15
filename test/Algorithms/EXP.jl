# Tests for EXP3 agents

@testset "EXP" begin

noOfArms = 5

# EXP3 agnet
@testset "EXP3" begin

    srand(1729)
    agent = EXP3( noOfArms, 0.25 )
    @test agent.noOfArms == noOfArms
    for t = 1:10
        armIdx  = get_arm_index( agent )
        update_reward!( agent, rand()  )
    end
    @test agent.noOfSteps == 10

    @test info_str( agent ) == "EXP3 (γ = 0.250)"
    @test info_str( agent, false ) == "EXP3 (γ = 0.250)"
    @test info_str( agent, true ) == "EXP3 (\$\\gamma = 0.250\$)"

    reset!( agent )
    @test ( agent.noOfArms==noOfArms &&
            agent.noOfSteps==0 &&
            agent.γ==0.25 &&
            agent.wVec==ones(noOfArms)  &&
            agent.pDist.p==1/noOfArms*ones(noOfArms) )

    # With γ = 1.0, EXP3 will be like uniform strategy
    srand(1729)
    agent = EXP3( noOfArms, 1.00 )
    for t = 1:10
        armIdx = get_arm_index( agent )
        update_reward!( agent, rand() )
    end
    @test( agent.pDist.p == 1/noOfArms*ones(noOfArms) )
end

# EXP3.1 agent
@testset "EXP3.1" begin
    srand(1729)
    agent = EXP31( noOfArms )
    # No need to test sub agent EXP3 here again
    @test info_str( agent ) == "EXP3.1"
    @test info_str( agent, false ) == "EXP3.1"
    @test info_str( agent, true ) == "EXP3.1"

    reset!( agent )
    @test ( agent.G_hat == zeros(noOfArms) &&
            agent.r == 0 &&
            agent.g_r == (noOfArms*log(noOfArms))/(e-1) )

end

# REXP3 agent
@testset "REXP3" begin
    srand(1729)
    agent = REXP3( noOfArms, 0.25, 10 )

    @test info_str( agent ) == "REXP3 (γ = 0.250, Δ = 10)"
    @test info_str( agent, false ) == "REXP3 (γ = 0.250, Δ = 10)"
    @test info_str( agent, true ) == "REXP3 (\$\\gamma = 0.250, \\Delta = 10\$)"

    # Take 9 steps and agent shouldn't be reset
    for t = 1:9
        get_arm_index( agent )
        update_reward!( agent, rand() )
    end
    @test agent._EXP3.noOfSteps == 9 
    @test agent.noOfSteps == 9 
    @test agent.j == 1
    # Take one more step and agent should reset
    get_arm_index( agent ); update_reward!( agent, rand() )
    @test agent._EXP3.noOfSteps == 0
    @test agent.noOfSteps == 10
    @test agent.j == 2
    # Take one more step and it should not reset
    get_arm_index( agent ); update_reward!( agent, rand() )
    @test agent._EXP3.noOfSteps == 1
    @test agent.noOfSteps == 11
    @test agent.j == 2
    
end

# EXP3-IX agent
@testset "EXP3-IX" begin

    srand(1729)
    agent = EXP3IX( noOfArms, 0.20, 0.15 )

    @test info_str( agent ) == "EXP3-IX (η = 0.200, γ = 0.150)"
    @test info_str( agent, false ) == "EXP3-IX (η = 0.200, γ = 0.150)"
    @test info_str( agent, true ) == "EXP3-IX (\$\\eta = 0.200, \\gamma = 0.150\$)"

    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, rand() )
    end
    @test agent.noOfSteps == 10

    reset!( agent )
    @test agent.noOfSteps == 0 &&
            agent.lastPlayedArm == 0 &&
            agent.wVec == ones( noOfArms ) &&
            agent.pDist.p == 1/noOfArms*ones(noOfArms) &&
            agent.η == 0.200 &&
            agent.γ == 0.150

    # With η = 0, weights shouldn't change
    agent = EXP3IX( noOfArms, 0.00, 0.10 )
    for t = 1:5
        get_arm_index( agent ); update_reward!( agent, rand() )
    end
    @test agent.wVec == ones( noOfArms )
    @test agent.pDist.p == 1/noOfArms * ones(noOfArms)
end

end