"""
    SocialAgent

A social agent for Social Sampling Theory which can be used with Agents.jl 

# Fields 

- `id`: unique agent id 
- `pos`: agent position 
- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `αn`: parameter of beta distribution coded as conservative for social network
- `βn`: parameter of beta distribution coded as liberal for social network 
- `w`: weight for social extremeness aversion
- `γ`: decision sensitivity parameter 
- `public_attitude`: the expressed attitude which is visible to other social agents 

# References

Brown, G. D., Lewandowsky, S., & Huang, Z. (2022). Social sampling and expressed attitudes: 
Authenticity preference and social extremeness aversion lead to social norm effects and polarization.
Psychological review, 129(1), 18.
"""
mutable struct SocialAgent <: AbstractAgent
    id::Int
    pos::NTuple{2,Int}
    α::Float64
    β::Float64
    αn::Float64
    βn::Float64
    w::Float64
    γ::Float64
    public_attitude::Float64
    utility::Float64
end

"""
    SocialAgent(id, pos; α, β, αn=1.0, βn=1.0, w, γ, public_attitude=0.0) 

A constructor for a social agent which can be used with Agents.jl 

# Arguments 

- `id`: unique agent id 
- `pos`: agent position 

# Keywords 

- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `αn=1.0`: parameter of beta distribution coded as conservative for social network
- `βn=1.0`: parameter of beta distribution coded as liberal for social network 
- `w`: weight for social extremeness aversion
- `γ`: decision sensitivity parameter 
- `public_attitude=0.0`: the expressed attitude which is visible to other social agents 

# References

Brown, G. D., Lewandowsky, S., & Huang, Z. (2022). Social sampling and expressed attitudes: 
Authenticity preference and social extremeness aversion lead to social norm effects and polarization.
Psychological review, 129(1), 18.
"""
function SocialAgent(id, pos; α, β, αn=1.0, βn=1.0, w, γ, public_attitude=0.0) 
    return SocialAgent(id, pos, α, β, αn, βn, w, γ, public_attitude, 0.0)
end