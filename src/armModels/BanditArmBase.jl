# Base for Arm models

abstract BanditArmBase

function pull( arm::BanditArmBase )
    error( "[BanditArmBase]: No Implementation of pull() for ", typeof(arm) )
end

function reset( arm::BanditArmBase )
    error( "[BanditArmBase]: No Implementation of reset() for ", typeof(arm) )
end
