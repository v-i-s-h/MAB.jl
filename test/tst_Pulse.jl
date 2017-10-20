# Test for Pulse arm

using MAB
import PyPlot

# Create different Sinusoidal arms
a1  = Arms.Pulse( 40, 0, 5 )
a2  = Arms.Pulse( 40, 20, 5 )

# Plot the rewards
noOfTimeSteps   = 100
noOfIterations  = 1000
rAvg1   = zeros( Float64, noOfTimeSteps )
rAvg2   = zeros( Float64, noOfTimeSteps )
for i ∈ 1:noOfIterations
    rAvg1   = rAvg1 + [ Arms.pull!(a1) for i=1:noOfTimeSteps ];
    rAvg2   = rAvg2 + [ Arms.pull!(a2) for i=1:noOfTimeSteps ];
    Arms.reset!( a1 );
    Arms.reset!( a2 );
end
rAvg1 = rAvg1/noOfIterations;
rAvg2 = rAvg2/noOfIterations;

fig     = PyPlot.figure()
PyPlot.plot( 1:noOfTimeSteps, rAvg1, label = "a1" )
PyPlot.plot( 1:noOfTimeSteps, rAvg2, label = "a2" )
ax = PyPlot.gca()
PyPlot.grid()
ax[:set_ylim]( [-0.20,+1.20] )
PyPlot.legend()
