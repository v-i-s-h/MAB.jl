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
    "Algorithms/EXP",
    "Algorithms/GradientBandits",
    "Algorithms/KLMANB",
    "Algorithms/SoftMax",
    "Algorithms/UniformStrategy",
    "Algorithms/UCB"
    # Arm specific tests
    # Experiment specific tests
];


#=
Use
    ARGS = [ "sanity_check" ]; include( joinpath(Pkg.dir("MAB"),"test","runtests.jl") )
or
    ARGS = [ "Algorithms/epsGreedy" ]; include( joinpath(Pkg.dir("MAB"),"test","runtests.jl") )
from REPL.
=#
if length(ARGS) > 0
    tests = ARGS
end

@testset "MAB Tests" begin
for test_script in tests
    fp = joinpath( dirname(@__FILE__), "$(test_script).jl" )
    # println( "Testing : ", test_script )
    # @time include( fp )
    include( fp )
end
end

nothing
