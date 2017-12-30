# Base for implementing all algorithms
"""
    BanditAlgorithmBase

`BanditAlgorithmBase` defines a set of functions as well as some utility functions for 
implementing MAB algorithms. Any algorithm must be a subtype of `BanditAlgorithmBase`.

"""
abstract type BanditAlgorithmBase end

"""
    get_arm_index( agent::BanditAlgorithmBase )

Gets the index of next arm to pull.

## Example
```julia-repl

```
"""
function get_arm_index( agent::BanditAlgorithmBase )
    error( "No implementation of getArmIndex() for ", typeof(agent) );
end

"""
    update_reward!( agent::BanditAlgorithmBase, r::Real )

Updates the reward to bandit algorithm `agent`. `r` must a real number within valid range.
"""
function update_reward!( agent::BanditAlgorithmBase, r::Real )
    error( "No implementation of updateReward() for ", typeof(agent) );
end

"""
    reset!( agent::BanditAlgorithmBase )

Resets the internal statistics of the bandit algorithm, except for the number of arms and other
algorithm specific parameters. `reset!()` will make `agent` as fresh as it was first created.
"""
function reset!( agent::BanditAlgorithmBase )
    error( "No implementation of reset() for ", typeof(agent) );
end

"""
    info_str( agent::BanditAlgorithmBase, latex::Bool = false )

Return a information string about the agent and it's parameters.  If flag `latex` is set to
`true`, then the returned string will be a compactable latex string.
"""
function info_str( agent::BanditAlgorithmBase, latex::Bool = false )
    error( "No Implementation of info_str() for ", typeof(agent) );
end

# import Base.show
function Base.show( io::IO, ::MIME"text/plain", agent::BanditAlgorithmBase )
    print( io, @sprintf("Algorithm: %s",info_str(agent)) )
    for param in fieldnames(agent)
        print( @sprintf("\n    %-16s: ",param), getfield(agent,param) )
    end
end

# Functions to make instances of types
function call( ::Type{T}, params... ) where T <: BanditAlgorithmBase
    return T( params... )
end


"""
    make_agents_with_k( K::Int64, agent_list::Vector{} )

Returns a vector of agents specified in `agent_list` with `K` arms.
```julia-repl

```
"""
function make_agents_with_k( K::Int64, agent_list::Vector{} )
    agents = Vector{BanditAlgorithmBase}()
    for (agent,params) ∈ agent_list
        if params != nothing
            push!( agents, agent(K,params...) )
        else
            push!( agents, agent(K) )
        end
    end
    return agents
end

import Base: ==
"""
    ==

Can be used to compare two agents.
```julia-repl

```
"""
function ==( agent1::BanditAlgorithmBase, agent2::BanditAlgorithmBase )
    if typeof(agent1) != typeof(agent2)
        return false
    else
        for param in fieldnames(agent1)
            if getfield(agent1,param) != getfield(agent2,param)
                # info( "Failed at ", param )
                return false
            end
        end
        return true
    end
    false
end