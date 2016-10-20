# Normal Arm Model

type Normal <: BanditArmBase
    armDist::Distributions.Normal

    function Normal( μ::Float64, σ::Float64 )
        new(
            Distributions.Normal( μ, σ )
        )
    end
end

function pull( arm::Normal )
    return rand( arm.armDist )
end

function reset( arm::Normal )
    # Do nothing
end
