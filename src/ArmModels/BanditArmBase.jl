# Base for Arm models

abstract type BanditArmBase end

function pull!( arm::BanditArmBase )
    error( "No Implementation of pull!() for ", typeof(arm) )
end

function tick!( arm::BanditArmBase )
    error( "No Implementation of tick!() for ", typeof(arm) )
end

function reset!( arm::BanditArmBase )
    error( "No Implementation of reset!() for ", typeof(arm) )
end
