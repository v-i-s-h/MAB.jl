# Tests for Thompson Sampling agents

noOfArms = 5

@testset "Thompson Sampling" begin

@testset "TS" begin
    agent = TS( noOfArms )

    @test agent.noOfArms == noOfArms
    @test agent.noOfSteps == 0
    @test agent.lastPlayedArm == 0

    @test info_str( agent ) == "Thompson Sampling"
    @test info_str( agent, false ) == "Thompson Sampling"
    @test info_str( agent, true ) == "Thompson Sampling"

    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, rand() );
    end
    @test agent.noOfSteps == 10
    @test sum(agent.cummSuccess+agent.cummFailure) == 10
    @test sum(agent.cummSuccess+agent.cummFailure+agent.α0+agent.β0) == 10+2noOfArms

    reset!( agent )
    @test agent == TS(noOfArms)

    # With different prior
    agent = TS( [ (1,2), (2,3), (3,4) ] )
    @test agent.noOfArms == 3
    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, rand() )
    end
    @test sum(agent.cummSuccess+agent.cummFailure+agent.α0+agent.β0) == 10+1+2+2+3+3+4
    @test [ agent.α0+agent.cummSuccess, agent.β0+agent.cummFailure ] == 
            [ [agent.samplingDist[i].α for i = 1:3], [agent.samplingDist[i].β for i = 1:3]  ]
    reset!( agent )
    @test agent == TS([(1,2),(2,3),(3,4)])
end

@testset "DynamicTS" begin
    agent = DynamicTS( noOfArms, 10 )
    @test agent.noOfArms == noOfArms
    @test agent.noOfSteps == 0
    @test agent.lastPlayedArm == 0

    @test info_str( agent ) == "Dynamic Thompson Sampling (C = 10.000)"
    @test info_str( agent, false ) == "Dynamic Thompson Sampling (C = 10.000)"
    @test info_str( agent, true ) == "Dynamic Thompson Sampling (\$C = 10.000\$)"

    for t = 1:10
        get_arm_index( agent ); update_reward!( agent, rand() )
    end
    @test agent.noOfSteps == 10

    reset!( agent )
    @test agent == DynamicTS(noOfArms,10)
end

@testset "OTS" begin

end

@testset "TSNormal" begin

end

@testset "Discounted TS" begin

end

@testset "Discounted OTS" begin

end

@testset "RestartTS" begin

end

@testset "TSGaussPrior" begin

end

end