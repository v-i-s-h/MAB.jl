# Test for Pulse arm

using Bandits
import PyPlot

# Create different Sinusoidal arms
a1  = Arms.Pulse( 30, 5, 6 )
a2  = Arms.Pulse( 60, 10, 15 )

# Plot the rewards
noOfTimeSteps   = 120
fig     = PyPlot.figure()
PyPlot.plot( 1:noOfTimeSteps, [ Arms.pull(a1) for i=1:noOfTimeSteps ], label = "a1" )
PyPlot.plot( 1:noOfTimeSteps, [ Arms.pull(a2) for i=1:noOfTimeSteps ], label = "a2" )
ax = PyPlot.gca()
PyPlot.grid()
ax[:set_ylim]( [-1.20,+1.20] )
PyPlot.legend()
