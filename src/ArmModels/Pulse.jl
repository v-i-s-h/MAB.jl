# Pulse model for Bandit Arm

type Pulse <: BanditArmBase
    step::Int64             # For tracking internally
    period::Int64           # Period of the pulse
    changePoint::Int64      # The point at which the signal goes high
    highDuration::Int64     # TIme to stay HIGH
    isRestless::Bool        # Is this a restless arm

    function Pulse( _period, _cp, _hd, _ir = true )
        new(
            0,
            _period,
            _cp,
            _hd,
            _ir
        )
    end
end

function pull!( arm::Pulse )
    arm.step    = arm.step + 1
    if arm.step > arm.period
        arm.step = 1
    end

    return ((arm.step>=arm.changePoint)&&(arm.step<=arm.changePoint+arm.highDuration))?1:0;
end

function tick!( arm::Pulse )
    if arm.isRestless
        arm.step = arm.step + 1
        if arm.step > arm.period
            arm.step = 1
        end
    end
    nothing
end

function reset!( arm::Pulse )
    arm.step    = 0
    nothing
end
