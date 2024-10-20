abstract type AbstractSocialAgent <: AbstractAgent end

"""
    SocialAgent <: AbstractSocialAgent

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
mutable struct SocialAgent <: AbstractSocialAgent
    id::Int
    pos::NTuple{2, Int}
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
function SocialAgent(id, pos; α, β, αn = 1.0, βn = 1.0, w, γ, public_attitude = 0.0)
    return SocialAgent(id, pos, α, β, αn, βn, w, γ, public_attitude, 0.0)
end

function maximize_utility!(agent::AbstractSocialAgent)
    (; α, β, αn, βn, w, γ) = agent
    max_a, max_u = maximize_utility(α, β, αn, βn, w, γ)
    agent.public_attitude = max_a
    agent.utility = max_u
    return max_a, max_u
end

function maximize_utility(agent::AbstractSocialAgent)
    (; α, β, αn, βn, w, γ) = agent
    return maximize_utility(α, β, αn, βn, w, γ)
end

function update_attitudes!(model)
    update_attitudes!(model, allagents(model))
    return nothing
end

"""
    update_attitudes!(model, agents)

# Arguments

- `model` agent based model 
"""
function update_attitudes!(model, agents)
    v = 0.0
    for agent in agents
        judge_neighborhood!(agent, model)
        a1 = agent.public_attitude
        maximize_utility!(agent)
        a2 = agent.public_attitude
        v += abs(a1 - a2)
    end
    return nothing
end

"""
    judge_neighborhood!(agent, model)

# Arguments

- `agent`: a social agent 
- `model` agent based model 
"""
function judge_neighborhood!(agent, model)
    attitudes = fill(0.0, 8)
    i = 1
    for neighbor in nearby_agents(agent, model)
        attitudes[i] = neighbor.public_attitude
        i += 1
    end
    dist = fit(Beta, attitudes)
    (; α, β) = dist
    n = α + β
    if n > 20
        α = 20 * (α / n)
        β = 20 * (β / n)
    end
    agent.αn = α
    agent.βn = β
    return nothing
end
