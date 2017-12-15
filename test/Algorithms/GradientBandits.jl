# Tests for Gradient Bandits

@testset "Gradient Bandits" begin

noOfArms = 5

@testset "Gradient Bandit" begin
    srand(1729)
    agent = GradientBandit( noOfArms, 0.1 )

    @test agent.noOfSteps == 0
    @test agent.lastPlayedArm == 0
    @test agent.avgValue == 0
    @test agent.pDist.p == 1/noOfArms * ones(noOfArms)

    @test info_str( agent ) == "GradientBandit (α=0.100)"
    @test info_str( agent, false ) == "GradientBandit (α=0.100)"
    @test info_str( agent, true ) == "GradientBandit (\$\\alpha=0.100\$)"

    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, rand() )
    end
    @test agent.noOfSteps == 10

    reset!( agent )
    @test agent.noOfSteps == 0 &&
            agent.lastPlayedArm == 0 &&
            agent.avgValue == 0 &&
            agent.pDist.p == 1/noOfArms * ones(noOfArms) &&
            agent.α == 0.100 &&
            agent.preference == zeros(noOfArms)
end

end