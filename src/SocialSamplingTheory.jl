"""
#SocialSamplingTheory


# References

Brown, G. D., Lewandowsky, S., & Huang, Z. (2022). Social sampling and expressed attitudes: Authenticity preference and social extremeness aversion lead to social norm effects and polarization.
 Psychological Review, 129(1), 18.
"""
module SocialSamplingTheory
    using Agents: AbstractAgent
    using Distributions
    using Optim

    export AbstractSocialAgent
    export SocialAgent 

    export get_utility
    export initialize
    export judge_neighborhood!
    export maximize_utility
    export maximize_utility!
    export update_attitudes!
    
    include("structs.jl")
    include("functions.jl")
end
