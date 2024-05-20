"""
    get_utility(α, β, αn, βn, w , γ, x)

Returns the utility given a distribution of private and social attitudes. 

# Arguments 

- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `αn`: parameter of beta distribution coded as conservative for social network
- `βn`: parameter of beta distribution coded as liberal for social network 
- `w`: weight for social extremeness aversion
- `γ`: decision sensitivity parameter 
- `x`: publicly expressed attitude
"""
function get_utility(α, β, αn, βn, w , γ, x)
    self_diff = distance(α, β, x)
    social_diff = distance(αn, βn, x)
    self_disutil = exp(γ * self_diff)
    social_disutil = exp(γ * social_diff)
    return w * social_disutil + (1 - w) * self_disutil
end

"""
    distance(α, β, x)

Returns percentile difference from the 50 percentile (at median)

# Arguments 

- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `x`: expressed attitude
"""
function distance(α, β, x)
    return abs(0.50 - cdf(Beta(α, β), x))
end

"""
    maximize_utility(α, β, αn, βn, w, γ)

Returns the expressed attitude that maximizes utility and the associated utility value. 

# Arguments 

- `α`: parameter of beta distribution coded as conservative
- `β`: parameter of beta distribution coded as liberal 
- `αn`: parameter of beta distribution coded as conservative for social network
- `βn`: parameter of beta distribution coded as liberal for social network 
- `w`: weight for social extremeness aversion
- `γ`: decision sensitivity parameter 
"""
function maximize_utility(α, β, αn, βn, w, γ)
    x0s = [.1,.5,.9]
    min_u = Inf
    max_a = Inf 
    for x0 in x0s
        results = optimize(x -> get_utility(α, β, αn, βn, w , γ, x[1]), [x0],  NelderMead())
        temp_x = Optim.minimizer(results)[1]
        temp_min  = Optim.minimum(results)
        if temp_min < min_u 
            min_u = temp_min
            max_a = temp_x 
        end
    end
    return (;max_a,max_u=-min_u)
end