var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#MAB",
    "page": "Home",
    "title": "MAB",
    "category": "module",
    "text": "MAB.jl is a package for experimenting with multi arm bandit algorithms. This package comes with different MAB algorithms, various arm models and a module to reproduce/evaluate your own algorithms in different scenarios/experiments which are already available in literature.\n\nThis package is divied into three main modules\n\nAlgorithms\nArm Models\nExperiments\n\n\n\n"
},

{
    "location": "#MAB.jl-1",
    "page": "Home",
    "title": "MAB.jl",
    "category": "section",
    "text": "CurrentModule = MABA Julia Package for Experimenting with Multi Arm BanditsMAB"
},

{
    "location": "#Manual-1",
    "page": "Home",
    "title": "Manual",
    "category": "section",
    "text": "Pages = [\n            \"manual/guide.md\",\n            \"manual/contributing.md\",\n            \"manual/ack.md\"\n]"
},

{
    "location": "#Package-Outline-1",
    "page": "Home",
    "title": "Package Outline",
    "category": "section",
    "text": "Pages = [\n            \"library/Algorithms/index.md\",\n            \"library/ArmModels/index.md\",\n            \"library/Experiments/index.md\"\n]"
},

{
    "location": "manual/guide/#",
    "page": "Package Guide",
    "title": "Package Guide",
    "category": "page",
    "text": ""
},

{
    "location": "manual/guide/#Package-Guide-1",
    "page": "Package Guide",
    "title": "Package Guide",
    "category": "section",
    "text": ""
},

{
    "location": "manual/guide/#Installing-MAB.jl-package-1",
    "page": "Package Guide",
    "title": "Installing MAB.jl package",
    "category": "section",
    "text": ""
},

{
    "location": "manual/guide/#Usage-1",
    "page": "Package Guide",
    "title": "Usage",
    "category": "section",
    "text": ""
},

{
    "location": "manual/guide/#Accessing-documentation-from-REPL-1",
    "page": "Package Guide",
    "title": "Accessing documentation from REPL",
    "category": "section",
    "text": ""
},

{
    "location": "manual/contributing/#",
    "page": "-",
    "title": "-",
    "category": "page",
    "text": ""
},

{
    "location": "manual/ack/#",
    "page": "-",
    "title": "-",
    "category": "page",
    "text": ""
},

{
    "location": "library/Algorithms/#",
    "page": "Algorithms",
    "title": "Algorithms",
    "category": "page",
    "text": ""
},

{
    "location": "library/Algorithms/#MAB.Algorithms.BanditAlgorithmBase",
    "page": "Algorithms",
    "title": "MAB.Algorithms.BanditAlgorithmBase",
    "category": "type",
    "text": "BanditAlgorithmBase\n\nBanditAlgorithmBase defines a set of functions as well as some utility functions for  implementing MAB algorithms. Any algorithm must be a subtype of BanditAlgorithmBase.\n\n\n\n"
},

{
    "location": "library/Algorithms/#Algorithms-1",
    "page": "Algorithms",
    "title": "Algorithms",
    "category": "section",
    "text": "Algorithms module includes a set of widely used MAb algorithms as weel as a common API to access them.All the algorithms must be a subtype of MAB.Algorithms.BanditAlgorithmBase. See List of Agents for the list of available agents.BanditAlgorithmBase"
},

{
    "location": "library/Algorithms/#MAB.Algorithms.get_arm_index",
    "page": "Algorithms",
    "title": "MAB.Algorithms.get_arm_index",
    "category": "function",
    "text": "get_arm_index( agent::BanditAlgorithmBase )\n\nGets the index of next arm to pull.\n\nExample\n\n\n\n\n\n"
},

{
    "location": "library/Algorithms/#MAB.Algorithms.update_reward!",
    "page": "Algorithms",
    "title": "MAB.Algorithms.update_reward!",
    "category": "function",
    "text": "update_reward!( agent::BanditAlgorithmBase, r::Real )\n\nUpdates the reward to bandit algorithm agent. r must a real number within valid range.\n\n\n\n"
},

{
    "location": "library/Algorithms/#MAB.Algorithms.reset!",
    "page": "Algorithms",
    "title": "MAB.Algorithms.reset!",
    "category": "function",
    "text": "reset!( agent::BanditAlgorithmBase )\n\nResets the internal statistics of the bandit algorithm, except for the number of arms and other algorithm specific parameters. reset!() will make agent as fresh as it was first created.\n\n\n\n"
},

{
    "location": "library/Algorithms/#MAB.Algorithms.info_str",
    "page": "Algorithms",
    "title": "MAB.Algorithms.info_str",
    "category": "function",
    "text": "info_str( agent::BanditAlgorithmBase, latex::Bool = false )\n\nReturn a information string about the agent and it\'s parameters.  If flag latex is set to true, then the returned string will be a compactable latex string.\n\n\n\n"
},

{
    "location": "library/Algorithms/#High-Level-interface-1",
    "page": "Algorithms",
    "title": "High Level interface",
    "category": "section",
    "text": "The folowing methods are defined for all MAB agents.get_arm_index\nupdate_reward!\nreset!\ninfo_str"
},

{
    "location": "library/Algorithms/#MAB.Algorithms.make_agents_with_k",
    "page": "Algorithms",
    "title": "MAB.Algorithms.make_agents_with_k",
    "category": "function",
    "text": "make_agents_with_k( K::Int64, agent_list::Vector{} )\n\nReturns a vector of agents specified in agent_list with K arms.\n\n\n\n\n\n"
},

{
    "location": "library/Algorithms/#Base.:==",
    "page": "Algorithms",
    "title": "Base.:==",
    "category": "function",
    "text": "==\n\nCan be used to compare two agents.\n\n\n\n\n\n"
},

{
    "location": "library/Algorithms/#Utility-Functions-1",
    "page": "Algorithms",
    "title": "Utility Functions",
    "category": "section",
    "text": "Further, Algorithms module provides the following utility functions, but are not exported implicitly. They must be referred in their full scope on call or must be explicitly imported to user scripts.MAB.Algorithms.make_agents_with_k\n=="
},

{
    "location": "library/Algorithms/list/#",
    "page": "List of Agents",
    "title": "List of Agents",
    "category": "page",
    "text": ""
},

{
    "location": "library/Algorithms/list/#List-of-Agents-1",
    "page": "List of Agents",
    "title": "List of Agents",
    "category": "section",
    "text": "The following MAB algorithms are available in this package"
},

{
    "location": "library/Algorithms/list/#[ϵ-greedy-Algorithms](@ref)-1",
    "page": "List of Agents",
    "title": "ϵ-greedy Algorithms",
    "category": "section",
    "text": "EXP Algorithms\nGradient Bandits\nKL-MANB Agent\nSoftMax Agent\nThompson Sampling Agents\nUpper Confidence Bound Agents\nUniform Strategy (random baseline)"
},

{
    "location": "library/Algorithms/epsGreedy/#",
    "page": "ϵ-greedy Algorithms",
    "title": "ϵ-greedy Algorithms",
    "category": "page",
    "text": ""
},

{
    "location": "library/Algorithms/epsGreedy/#MAB.Algorithms.epsGreedy",
    "page": "ϵ-greedy Algorithms",
    "title": "MAB.Algorithms.epsGreedy",
    "category": "type",
    "text": "ϵ-Greedy Implementation\n\n\n\n"
},

{
    "location": "library/Algorithms/epsGreedy/#MAB.Algorithms.epsNGreedy",
    "page": "ϵ-greedy Algorithms",
    "title": "MAB.Algorithms.epsNGreedy",
    "category": "type",
    "text": "ϵ_n Greedy Implementation\nBased on Auer, P., Bianchi, N. C., & Fischer, P. (2002). Finite time analysis of the multiarmed bandit problem. Machine Learning, 47, 235–256.\n\n\n\n"
},

{
    "location": "library/Algorithms/epsGreedy/#ϵ-greedy-Algorithms-1",
    "page": "ϵ-greedy Algorithms",
    "title": "ϵ-greedy Algorithms",
    "category": "section",
    "text": "The following agents are availableepsGreedy\nepsNGreedy"
},

{
    "location": "library/ArmModels/#",
    "page": "Arm Models",
    "title": "Arm Models",
    "category": "page",
    "text": ""
},

{
    "location": "library/ArmModels/#Arm-Models-1",
    "page": "Arm Models",
    "title": "Arm Models",
    "category": "section",
    "text": ""
},

{
    "location": "library/Experiments/#",
    "page": "Experiments",
    "title": "Experiments",
    "category": "page",
    "text": ""
},

{
    "location": "library/Experiments/#Experiments-1",
    "page": "Experiments",
    "title": "Experiments",
    "category": "section",
    "text": ""
},

]}
