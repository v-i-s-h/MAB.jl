# Tests for UCB Algorithms

@testset "UCB" begin

bandit1 = [
    Arms.Bernoulli( 0.45 ),
    Arms.Bernoulli( 0.60 ),
    Arms.Bernoulli( 0.65 )
];

@testset "UCB1" begin
    e1  = Experiments.Compare( bandit1, [ Algorithms.UCB1(length(bandit1)) ] )
    @test @test_nothrow r1  = Experiments.run( e1, 100, 100 )
end

@testset "D-UCB" begin
    e2  = Experiments.Compare( bandit1, [Algorithms.DUCB(length(bandit1),0.9) ] )
    @test @test_nothrow r2  = Experiments.run( e2, 100, 100 )
end

@testset "SW-UCB" begin
    e3  = Experiments.Compare( bandit1, [Algorithms.SWUCB(length(bandit1),10) ] )
    @test @test_nothrow r2  = Experiments.run( e3, 100, 100 )
end

end

nothing
