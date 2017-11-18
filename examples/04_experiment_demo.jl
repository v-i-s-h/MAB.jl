# 04_experiment_demo.jl

using Plots     # You should import PLots to use Experiments
using MAB

ex1 = Sutton.fig_2_2()
f = run( ex1, T = 100, rounds = 100 )
plot( f[1] )
plot( f[2] )