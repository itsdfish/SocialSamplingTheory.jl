"""
#SocialSamplingTheory


# References

Brown, G. D., Lewandowsky, S., & Huang, Z. (2022). Social sampling and expressed attitudes: Authenticity preference and social extremeness aversion lead to social norm effects and polarization.
 Psychological Review, 129(1), 18.
"""
module SocialSamplingTheory
    using Distributions, Agents, Optim
    export get_utility, maximize_utility, maximize_utility!, initialize
    export update_attitudes!, judge_neighborhood!
    export SocialAgent 
    
    include("structs.jl")
    include("functions.jl")
end
