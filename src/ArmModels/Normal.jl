# Normal Arm Model

type Normal <: BanditArmBase
    armDist::Distributions.Normal

    function Normal( μ::Real, σ::Real )
        new(
            Distributions.Normal( μ, σ )
        )
    end
end

function pull!( arm::Normal )
    return rand( arm.armDist )
end

function tick!( arm::Normal )
    # Do nothing
    nothing
end

function reset!( arm::Normal )
    # Do nothing
    nothing
end
