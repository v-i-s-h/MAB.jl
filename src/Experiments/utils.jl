# This file include the utils for starting an experiment
# Use ```include("utils.jl")``` in your experiments

import Base: run
using Requires
@require Plots using Plots
using ..BanditExpBase
using ...Algorithms
using ...Arms
using ...Algorithms: make_agents_with_k
# using ..BanditExpBase: run