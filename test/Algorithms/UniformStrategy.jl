# Tests for Uniform Strategy

noOfArms = 5

@testset "Uniform Strategy" begin
    agent = UniformStrategy( noOfArms )

    @test agent.noOfArms == noOfArms
    @test agent.noOfSteps == 0
    @test agent.lastPlayedArm == 0

    @test info_str( agent ) == "Uniform Strategy"
    @test info_str( agent, false ) == "Uniform Strategy"
    @test info_str( agent, true) == "Uniform Strategy"

    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, rand() );
    end
    @test agent.noOfSteps == 10

    reset!( agent )
    @test agent == UniformStrategy(noOfArms)
end