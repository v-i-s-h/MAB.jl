# Base for implementing all algorithms
abstract type BanditAlgorithmBase end

function get_arm_index( agent::BanditAlgorithmBase )
    error( "No implementation of getArmIndex() for ", typeof(agent) );
end

function update_reward!( agent::BanditAlgorithmBase, r::Real )
    error( "No implementation of updateReward() for ", typeof(agent) );
end

function reset!( agent::BanditAlgorithmBase )
    error( "No implementation of reset() for ", typeof(agent) );
end

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
function ==( agent1::BanditAlgorithmBase, agent2::BanditAlgorithmBase )
    if typeof(agent1) != typeof(agent2)
        return false
    else
        for param in fieldnames(agent1)
            if getfield(agent1,param) != getfield(agent2,param)
                return false
            end
        end
        return true
    end
    false
end