# Square Wave Arm model

type Square <: BanditArmBase
    step::Int64                         # For internal tracking
    period::Int64                       # Period at which wave repeats
    changePoints::Dict{Int64,Float64}   # Dictionary of change points
    isRestless::Bool                    # Is this a restless arm

    function Square( _period::Int64, _cps::Dict{Int64,Float64}, _ir::Bool = true )
        new(
            0,
            _period,
            _cps,
            _ir
        )
    end
end

function pull!( arm::Square )
    arm.step    = arm.step + 1
    if arm.step > arm.period
        arm.step = 1
    end
    lastCpIndex = 0.0;
    for timeIdx in keys(arm.changePoints)
        if timeIdx <= arm.step && timeIdx > lastCpIndex
            lastCpIndex = timeIdx
        end
    end
    if lastCpIndex == 0 # No change occured
        return 0.0
    else
        return arm.changePoints[lastCpIndex]
    end
end

function tick!( arm::Square )
    if arm.isRestless
        arm.step = arm.step + 1
        if arm.step > arm.period
            arm.step = 1
        end
    end
    nothing
end

function reset!( arm::Square )
    arm.step    = 0
    nothing
end
