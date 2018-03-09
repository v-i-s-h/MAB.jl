# Tests for Upper Confidence bound based policies

@testset "UCB Policies" begin

@testset "UCB1" begin
end

@testset "UCBNormal" begin
end

@testset "Discounted UCB" begin
end

@testset "Sliding Window UCB" begin
end

@testset "UCB-V" begin
end

@testset "BayesUCB" begin
end

@testset "KL-UCB" begin
end

@testset "M-UCB" begin
    noOfArms    = 3
    horizon     = 100
    M           = 3     # no of change points
    γ           = 0.25

    w = 8   # Just fix
    b = 0.5 # √( w * log(noOfArms*horizon^2) )
    agent = MUCB( noOfArms, w, b, γ )

    @test agent.noOfArms    == 3
    @test agent.noOfSteps   == 0
    @test agent.lastPlayedArm   == 0
    @test agent.w           == w
    @test agent.τ           == 0
    @test agent._ucb        == UCB1(3)

    @test info_str( agent ) == "M-UCB( w = 8, b = 0.500, γ = 0.250 )"
    @test info_str( agent, false ) == info_str( agent )
    @test info_str( agent, true ) == "M-UCB( w = 8, b = 0.500, \$\\gamma\$ = 0.250 )"

    for t = 1:50
        i = get_arm_index( agent )
        if t <= noOfArms        # Should do uniform sampling
            @test i == t
        end
        update_reward!( agent, 0.10*rand() )    # All r ∈ [0,0.10]
    end
    @test agent.noOfSteps   == 50       # Should be played 50 steps
    @test agent.τ   == 0                # Shouldn't detect a change
    @test agent._ucb.noOfSteps  == 50   # Internal UCB1
    for t = 51:100
        i = get_arm_index( agent )
        update_reward!( agent, 0.50 + 0.10*rand() ) # All r ∈ [0.50,0.60]
    end
    @test agent.noOfSteps   == 100
    @test agent.τ           != 0        # Should have detected a change
    @test agent._ucb.noOfSteps  <= 50   # Should have reseted internal UCB

    reset!( agent )
    @test agent == MUCB(noOfArms,w,b,γ)    # Reseting should be equivalent to new agent
end

end
