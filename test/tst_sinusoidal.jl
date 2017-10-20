# Tests for Sinusoidal arms

using MAB
import PyPlot

# Create different Sinusoidal arms
a1  = Arms.Sinusoidal( 10 )
a2  = Arms.Sinusoidal( 8 )
a3  = Arms.Sinusoidal( 12, π )
a4  = Arms.Sinusoidal( 14, π/3 )

# Plot the rewards
noOfTimeSteps   = 40
fig     = PyPlot.figure()
PyPlot.plot( 1:noOfTimeSteps, [ Arms.pull!(a1) for i=1:noOfTimeSteps ], label = "a1" )
PyPlot.plot( 1:noOfTimeSteps, [ Arms.pull!(a2) for i=1:noOfTimeSteps ], label = "a2" )
PyPlot.plot( 1:noOfTimeSteps, [ Arms.pull!(a3) for i=1:noOfTimeSteps ], label = "a3" )
PyPlot.plot( 1:noOfTimeSteps, [ Arms.pull!(a4) for i=1:noOfTimeSteps ], label = "a4" )
ax = PyPlot.gca()
PyPlot.grid()
ax[:set_ylim]( [-1.20,+1.20] )
PyPlot.legend()
