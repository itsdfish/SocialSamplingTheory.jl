"""
#SocialSamplingTheory


# References

Brown, G. D., Lewandowsky, S., & Huang, Z. (2022). Social sampling and expressed attitudes: Authenticity preference and social extremeness aversion lead to social norm effects and polarization.
 Psychological Review, 129(1), 18.
"""
module SocialSamplingTheory
    using Distributions
    using Optim

    export get_utility
    export maximize_utility
    export maximize_utility!

    
    include("functions.jl")
end
