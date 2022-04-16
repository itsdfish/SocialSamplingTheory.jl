"""
    get_utility(α, β, αn, βn, w , γ, x)

Returns the utility given a distribution of private and social attitudes. 

# Arguements 

- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `αn`: parameter of beta distribution coded as conservative for social network
- `βn`: parameter of beta distribution coded as liberal for social network 
- `w`: weight for social extremeness aversion
- `γ`: decision sensitivity parameter 
- `x`: expressed attitude in terms of a percentile
"""
function get_utility(α, β, αn, βn, w , γ, x)
    self_diff = distance(α, β, x)
    social_diff = distance(αn, βn, x)
    social_disutil = exp(γ * (social_diff - .50)) 
    self_disutil = exp(γ * (self_diff - .50))
    return 1.0 - w * social_disutil - (1 - w) * self_disutil
end

"""
    distance(α, β, x)

Returns percentile difference from the 50 percentile (at median)

# Arguements 

- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `x`: expressed attitude in terms of a percentile
"""
function distance(α, β, x)
    return abs(0.50 - cdf(Beta(α, β), x))
end

function maximize_utility!(agent)
    (;α, β, αn, βn, w , γ) = agent
    agent.public_attitude = maximize(α, β, αn, βn, w , γ)
    return nothing 
end 

"""
    maximize_utility(α, β, αn, βn, w, γ)

Returns the expressed attitude that maximizes utility. 

# Arguements 

- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `αn`: parameter of beta distribution coded as conservative for social network
- `βn`: parameter of beta distribution coded as liberal for social network 
- `w`: weight for social extremeness aversion
- `γ`: decision sensitivity parameter 
"""
function maximize_utility(α, β, αn, βn, w, γ)
    x0s = [.1,.5,.9]
    min_y = Inf
    min_x = Inf 
    for x0 in x0s
        results = optimize(x -> -get_utility(α, β, αn, βn, w , γ, x[1]), [x0],  NelderMead())
        temp_x = Optim.minimizer(results)[1]
        temp_min  = Optim.minimum(results)
        if temp_min < min_y 
            min_y = temp_min
            min_x = temp_x 
        end
    end
    return min_x
end

function initialize(;n_agents, γ = 20, w = .50)
    space = GridSpace((n_agents, n_agents); periodic = true)
    model = ABM(
        SocialAgent, space;
        scheduler = Schedulers.randomly
    )
    id = 1
    for _ in 1:n_agents, _ in 1:n_agents
        α, β = rand_parms()
        public_attitude = mean(Beta(α, β))
        agent = SocialAgent(id, (1,1); α, β, γ = 20, w = .50, public_attitude)
        add_agent_single!(agent, model)
        id += 1
    end
    map(_ -> update_attitudes!(model), 1:2)
    return model
end

"""
    update_attitudes!(model)

# Arguments

- `model` agent based model 
"""
function update_attitudes!(model)
    v = 0.0
    for agent in allagents(model)
        judge_neighborhood!(agent, model)
        a1 = agent.public_attitude
        maximize_utility!(agent)
        a2 = agent.public_attitude
        v += abs(a1 - a2)
    end
    println(v)
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
    (;α,β) = dist
    n = α + β
    if n > 20
        α = 20 * (α / n)
        β = 20 * (β / n)
    end
    agent.αn = α
    agent.βn = β
    return nothing 
end

function rand_parms()
    μ = rand(Beta(10, 10))
    n = rand(Gamma(2, 20))
    α = μ * n 
    β = (1 - μ) * n
    return α, β
end