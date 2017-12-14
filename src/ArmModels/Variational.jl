# Arm with Variation V_t as mentioned in
#       Besbes, O., Gur, Y., & Zeevi, A. (2014). Optimal Exploration-Exploitation in a Multi-Armed-Bandit Problem with Non-stationary Rewards, 1–20.

type Variational <: BanditArmBase
    step::Int64         # Time step
    variation::Float64  # Variation of the arms
    period::Float64     # Period of the sinusoidal wave
    isRestless::Bool    # Is this arm restless - True by default
    offset::Float64     # Initial pahse, random by default

    function Variational( _variation::Float64, _period::Float64, )
        new(
            0,
            _variation,
            _period,
            true,
            2*π*rand()
        )
    end

    function Variational( _variation::Float64, _period::Float64, _isRestless::Bool )
        new(
            0,
            _variation,
            _period,
            _isRestless,
            2*π*rand()
        )
    end

    function Variational( _variation::Float64, _period::Float64, _offset::Real )
        new(
            0,
            _variation,
            _period,
            true,
            _offset
        )
    end

    function Variational( _variation::Float64, _period::Int64, _isRestless::Bool, _offset::Real )
        new(
            0,
            _variation,
            _period,
            _isRestless,
            _offset
        )
    end
end

function pull!( arm::Variational )
    arm.step = arm.step + 1
    return 1/2 + 1/2 * sin( arm.variation * π * (arm.step-1)/arm.period + arm.offset )  # To limit rewards between 0 and 1
end

function tick!( arm::Variational )
    if arm.isRestless
        arm.step = arm.step + 1
    end
    nothing
end

function reset!( arm::Variational )
    arm.step = 0
    nothing
end
