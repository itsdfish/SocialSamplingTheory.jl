###################################################################################################
#                                        Load Packages
###################################################################################################
cd(@__DIR__)
using Pkg
Pkg.activate("../")
using Revise, Agents, SocialSamplingTheory, Distributions

function rand_parms()
    μ = rand(Beta(10, 10))
    n = rand(Gamma(2, 20))
    α = μ * n 
    β = (1 - μ) * n
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

function agent_step!(agent1, model)
    searching = true 
    while searching 
        agent2 = random_agent(model)
        switch_positions!(agent1, agent2)
    end
    # select random agent
    # determine whether moving increases utility 
    update_attitudes!(model)
end

model = initialize(;n_agents=100, γ = 20, w = .50)