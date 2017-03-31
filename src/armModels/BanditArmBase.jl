# Base for Arm models

abstract BanditArmBase

function pull( arm::BanditArmBase )
    error( "[BanditArmBase]: No Implementation of pull() for ", typeof(arm) )
end

function tick( arm::BanditArmBase )
    # This should do nothing if the specific arm model miss tick()
end

function reset( arm::BanditArmBase )
    error( "[BanditArmBase]: No Implementation of reset() for ", typeof(arm) )
end
