###################################################################################################
#                                        Load Packages
###################################################################################################
cd(@__DIR__)
using Pkg
Pkg.activate("../")
using Revise, Agents, SocialSamplingTheory, Distributions

function rand_parms()
    μ = rand(Beta(10, 10))
    n = Int(round(μ * 100))
    g = gcd(n, 100)
    α = n / g 
    β = (100 / g) - α
    return α, β
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

function switch_positions!(a1, a2)
    p1,p2 = a1.pos,a2.pos
    a1.pos = p2
    a2.pos = p1
    return nothing
end

function can_switch(a1, a2, u1, u2)
    return u1.max_u > a1.utility && u2.max_u > a2.utility 
end

function agent_step!(agent1, model)
    searching = true
    cnt = 0 
    while searching && (cnt < 10000)
        agent2 = random_agent(model)
        switch_positions!(agent1, agent2)
        u1 = maximize_utility(agent1)
        u2 = maximize_utility(agent2)
        if can_switch(agent1, agent2, u1, u2)
            searching = false 
        else
            switch_positions!(agent1, agent2)
        end
        cnt += 1
    end
    # select random agent
    # determine whether moving increases utility 
    neighbors1 = nearby_agents(agent1, model)
    update_attitudes!(model, neighbors1)
    neighbors2 = nearby_agents(agent2, model)
    update_attitudes!(model, neighbors2)
end

model = initialize(;n_agents=100, γ = 20, w = .50)