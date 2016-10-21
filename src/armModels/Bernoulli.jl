# Bernoulli Arm Model

type Bernoulli <: BanditArmBase
    armDist::Distributions.Bernoulli

    function Bernoulli( p::Real )
        new( Distributions.Bernoulli(p) )
    end
end

function pull( arm::Bernoulli )
    return Distributions.rand(arm.armDist)
end

function reset( arm::Bernoulli )
    # Do nothing
end
