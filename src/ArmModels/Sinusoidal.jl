# Sinusoidal Arm - Restless

type Sinusoidal <: BanditArmBase
    step::Int64         # Time step
    period::Int64       # Period of the sinusoidal wave
    isRestless::Bool    # Is this arm restless - True by default
    offset::Float64     # Initial pahse, random by default

    function Sinusoidal( _period::Int64 )
        new(
            0,
            _period,
            true,
            2*π*rand()
        )
    end

    function Sinusoidal( _period::Int64, _isRestless::Bool )
        new(
            0,
            _period,
            _isRestless,
            2*π*rand()
        )
    end

    function Sinusoidal( _period::Int64, _offset::Real )
        new(
            0,
            _period,
            true,
            _offset
        )
    end

    function Sinusoidal( _period::Int64, _isRestless::Bool, _offset::Real )
        new(
            0,
            _period,
            _isRestless,
            _offset
        )
    end
end

function pull!( arm::Sinusoidal )
    arm.step = arm.step + 1
    return 1/2 + 1/2 * sin( 2 * π * (arm.step-1)/arm.period + arm.offset )  # To limit rewards between 0 and 1
end

function tick!( arm::Sinusoidal )
    if arm.isRestless
        arm.step = arm.step + 1
    end
    nothing
end

function reset!( arm::Sinusoidal )
    arm.step = 0
    nothing
end
