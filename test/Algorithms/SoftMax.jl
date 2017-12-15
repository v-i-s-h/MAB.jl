# Tests for SoftMax

noOfArms = 5

@testset "SoftMax" begin
    agent = SoftMax( noOfArms, 1.0 )

    @test agent.noOfSteps == 0
    @test agent.noOfArms == noOfArms
    @test agent.lastPlayedArm == 0

    @test info_str( agent ) == "SoftMax (τ = 1.000)"
    @test info_str( agent, false ) == "SoftMax (τ = 1.000)"
    @test info_str( agent, true ) == "SoftMax (\$\\tau = 1.000\$)"

    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, rand() );
    end
    @test agent.noOfSteps == 10

    reset!( agent )
    @test agent == SoftMax(noOfArms,1.0)

end