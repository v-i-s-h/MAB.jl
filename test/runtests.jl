using Bandits
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
    "UCB"
];

if length(ARGS) > 0
    tests = ARGS
end

for t in tests
    fp = joinpath( dirname(@__FILE__), "$t.jl" );
    println( "Testing : ", t );
    @time include( fp );
end
