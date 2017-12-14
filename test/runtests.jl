using MAB
using Base.Test

macro test_nothrow(ex)
    quote
        try
            $(esc(ex))
            true
        catch e
            print( "ERROR: " )
            if isa( e, KeyError )
                println( "KeyError: key ", e.key, " not found" )
            else
                println( e )
            end
            false
        end
    end
end

tests = [
    "sanity_check",
    # Agent specific tests
    "Algorithms/epsGreedy",
    # Arm specific tests
    # Experiment specific tests
];

# if length(ARGS) > 0
#     tests = ARGS
# end

@testset "MAB Tests" begin
for test_script in tests
    fp = joinpath( dirname(@__FILE__), "$(test_script).jl" )
    # println( "Testing : ", test_script )
    # @time include( fp )
    include( fp )
end
end

nothing