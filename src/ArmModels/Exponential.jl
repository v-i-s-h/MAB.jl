# Exponential Arm Model

type Exponential <: BanditArmBase
    armDist::Distributions.Exponential

    function Exponential( λ::Real ) # λ is the mean parameter
        new( Distributions.Exponential(λ) )
    end
end

function pull!( arm::Exponential )
    return Distributions.rand( arm.armDist )
end

function tick!( arm::Exponential )
    # Do nothing
    nothing
end

function reset!( arm::Exponential )
    # Do nothing
    nothing
end
