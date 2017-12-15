# Tests for KLMANB

noOfArms = 5

@testset "KLMANB" begin
    agent = KLMANB( noOfArms, 3.0, 4.0 )

    @test agent.noOfArms == noOfArms
    @test agent.σₒ² == 3.0
    @test agent.σₜ² == 4.0
    @test agent.noOfSteps == 0

    @test info_str( agent ) == "KLMANB (σₒ² = 3.000, σₜ² = 4.000)"
    @test info_str( agent, false ) == "KLMANB (σₒ² = 3.000, σₜ² = 4.000)"
    @test info_str( agent, true ) == "KLMANB \$(\\sigma_{o}^2 = 3.000, \\sigma_{t}^2 = 4.000)\$"

    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, randn() );
    end
    @test agent.noOfSteps == 10

    reset!( agent )
    @test agent.noOfArms == noOfArms &&
            agent.σₒ² == 3.0 &&
            agent.σₜ² == 4.0 &&
            agent.noOfSteps == 0
end