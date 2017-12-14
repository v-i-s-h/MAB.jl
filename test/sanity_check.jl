# Perform Sanity Tests for Agents, Arm models and Experiments

@testset "Sanity Checks" begin

# ---------------------------------- Tests for Agents --------------------------------------
# Get all algorithms
list_algorithms     = subtypes( MAB.BanditAlgorithmBase )

basefn__get_arm_index   = which( get_arm_index,
                                    Tuple{MAB.Algorithms.BanditAlgorithmBase} )
basefn__update_reward   = which( update_reward!, 
                                    Tuple{MAB.Algorithms.BanditAlgorithmBase,Real} )
basefn__reset           = which( reset!,
                                    Tuple{MAB.Algorithms.BanditAlgorithmBase} )
basefn__info_str        = which( info_str,
                                    Tuple{MAB.Algorithms.BanditAlgorithmBase,Bool} )

@testset "Algorithms" begin
    for a ∈ list_algorithms
        @testset "$(a)" begin
            # Test whether each of the algorithm implements all the required methods
            fn__get_arm_index   = which( get_arm_index, Tuple{a} )
            fn__update_reward   = which( update_reward!, Tuple{a,Real} )
            fn__reset           = which( reset!, Tuple{a} )
            fn__info_str        = which( info_str, Tuple{a,Bool} )
            @test fn__get_arm_index != basefn__get_arm_index
            # Implement atleast on of these methods
            @test basefn__update_reward != which( update_reward!, Tuple{a,Real} ) ||
                  basefn__update_reward != which( update_reward!, Tuple{a,Int} ) ||
                  basefn__update_reward != which( update_reward!, Tuple{a,Float64} )
            @test fn__reset != basefn__reset
            @test fn__info_str != basefn__info_str
        end
    end
end

# -------------------------------- Tests for Arm Models ------------------------------------
list_arms           = subtypes( MAB.Arms.BanditArmBase )

basefn__pull!   = which( Arms.pull!, Tuple{Arms.BanditArmBase} )
basefn__tick!   = which( Arms.tick!, Tuple{Arms.BanditArmBase} )
basefn__reset!  = which( Arms.reset!, Tuple{Arms.BanditArmBase} )

@testset "Arms" begin
    for arm ∈ list_arms
        @testset "$(arm)" begin
        fn__pull!   = which( Arms.pull!, Tuple{arm} )
        fn__tick!   = which( Arms.tick!, Tuple{arm} )
        fn__reset!  = which( Arms.reset!, Tuple{arm} )
        
        @test basefn__pull! != fn__pull!
        @test basefn__tick! != fn__tick!
        @test basefn__reset!    != fn__reset!
        end
    end
end

# ------------------------------- Tests for Experiments ------------------------------------
list_experiments    = subtypes( MAB.Experiments.BanditExpBase )
#TODO

end
