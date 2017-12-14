# Beta Distributed Arm

type Beta <: BanditArmBase
    armDist::Distributions.Beta

    function Beta( α::Real, β::Real )
        new( Distributions.Beta( α, β ) )
    end
end

function pull!( arm::Beta )
    return Distributions.rand( arm.armDist )
end

function tick!( arm::Beta )
    # Do nothing
    nothing
end

function reset!( arm::Beta )
    # Do nothing
    nothing
end
