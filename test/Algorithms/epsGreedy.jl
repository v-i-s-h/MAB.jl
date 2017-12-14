# Tests for ϵ-greedy agents

@testset "ϵ-greedy" begin

noOfArms  = 5

# ϵ-greedy agent
@testset "ϵ-greedy" begin
    agent = epsGreedy( noOfArms, 0.25 )
    @test agent.noOfArms == noOfArms
    for t = 1:10
        armIdx = get_arm_index( agent )
        update_reward!( agent, rand() )
    end
    @test agent.noOfSteps == 10

    @test info_str( agent ) == "ϵ-Greedy (ϵ = 0.250)"
    @test info_str( agent, false ) == "ϵ-Greedy (ϵ = 0.250)"
    @test info_str( agent, true ) == "\$\\epsilon\$-Greedy (\$\\epsilon = 0.250\$)"

    reset!( agent )
    @test agent == epsGreedy(noOfArms,0.25)
end

# ϵₙ-greedy
@testset "ϵₙ-greedy" begin
    agent = epsNGreedy( noOfArms, 0.10, 0.25 )
    @test agent.noOfArms == noOfArms
    for t = 1:10
        armIdx = get_arm_index( agent )
        update_reward!( agent, rand() )
    end
    @test agent.noOfSteps == 10

    @test info_str( agent ) == "ϵₙ-Greedy (c = 0.100, d = 0.250)"
    @test info_str( agent, false ) == "ϵₙ-Greedy (c = 0.100, d = 0.250)"
    @test info_str( agent, true ) == "\$\\epsilon_n\$-Greedy (\$c = 0.100, d = 0.250\$)"

    reset!( agent )
    @test agent == epsNGreedy(noOfArms,0.10,0.25)
end

end