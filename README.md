# MAB.jl - A Package for Bandit Experiments
This package provide a framework for developing and comparing various Bandit algorithms

## Available Algorithms
0. Uniform Strategy (Randomly picking some arm)
1. ϵ-greedy
   1. ϵ-greedy
   2. ϵ_n greedy
2. Upper Confidence Bound Policies
   1. UCB1
   2. UCB-Normal
   3. UCB-V
   4. Bayes-UCB (For Bernoulli Rewards)
   5. KL-UCB
   6. Discounted-UCB
   7. Sliding Window UCB
3. Thompson Sampling
   1. Thompson Sampling
   2. Dynamic Thompson Sampling
   3. Optimistic Thompson Sampling
   4. TSNormal (Thompson Sampling for Gaussian distributed rewards)
   5. Restarting Thompson Sampling
   6. TS With Gaussian Prior
4. EXP3
   1. EXP3
   2. EXP3.1
   3. EXP3-IX
5. SoftMax
6. REXP3
7. Gradient Bandit

## Available Arm Models
1. Bernoulli
2. Beta
3. Normal
4. Sinusoidal (without noise)
5. Pulse (without noise)
6. Square
7. Variational (without noise)
