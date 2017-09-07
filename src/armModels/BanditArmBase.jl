# Base for Arm models

abstract type BanditArmBase end

function pull!( arm::BanditArmBase )
    error( "No Implementation of pull() for ", typeof(arm) )
end

function tick!( arm::BanditArmBase )
    # This should do nothing if the specific arm model miss tick()
end

function reset!( arm::BanditArmBase )
    error( "No Implementation of reset() for ", typeof(arm) )
end
