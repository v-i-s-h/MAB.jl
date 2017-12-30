# Algorithms

Algorithms module includes a set of widely used MAb algorithms as weel as a common API to
access them.

All the algorithms **must** be a subtype of `MAB.Algorithms.BanditAlgorithmBase`. See
[List of Agents](@ref) for the list of available agents.

```@docs
BanditAlgorithmBase
```

## High Level interface
The folowing methods are defined for all MAB agents.
```@docs
get_arm_index
update_reward!
reset!
info_str
```

## Utility Functions
Further, `Algorithms` module provides the following utility functions, but are not exported
implicitly. They must be referred in their full scope on call or must be explicitly imported
to user scripts.
```@docs
MAB.Algorithms.make_agents_with_k
==
```