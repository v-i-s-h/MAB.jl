# To test Square Arm model

using MAB
import PyPlot
using Distributions

# Create different Sinusoidal arms
a1  = Arms.Square( 25, Dict([(5,0.3),(10,0.6),(18,0.85)]) )
a2  = Arms.Square( 25, Dict([(1,1.0),(10,0.3),(15,0.1)]) )

# Plot the rewards
noOfTimeSteps   = 100
noOfIterations  = 1000
rAvg1   = zeros( Float64, noOfTimeSteps )
rAvg2   = zeros( Float64, noOfTimeSteps )
for i ∈ 1:noOfIterations
    rAvg1   = rAvg1 + [ rand(Distributions.Bernoulli(Arms.pull!(a1))) for i=1:noOfTimeSteps ];
    rAvg2   = rAvg2 + [ rand(Distributions.Bernoulli(Arms.pull!(a2))) for i=1:noOfTimeSteps ];
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
