###################################################################################################
#                                        Load Packages
###################################################################################################
cd(@__DIR__)
using Pkg
Pkg.activate("../")
using Revise, SocialSamplingTheory, Agents, Distributions, Plots

# 
α = 4
β = 9
αn = 6
βn = 2.2
γ = 20.0
ws = range(0, 1, length=100)

attitude = maximize_utility.(α, β, αn, βn, ws, γ)

plot(
    ws, 
    attitude, 
    ylims = (0,1),
    color = :black,
    xlabel = "social weight (1 - w) ",
    ylabel = "Utility maximizing expressed attitude",
    legend = false, 
    grid = false
)

###################################################################################################
#                                        Backfire Effect
###################################################################################################
α = 4
β = 9
αn = 6.0
βn = 2.2
γ = 20.0
ws = .1:.05:.9

function sim_backfire(α, β, αn, βn, w, γ)
    K = .40:.025:6
    n = length(K)
    attitudes = fill(0.0, n)
    precisions = fill(0.0, n)
    target_median = median(Beta(αn, βn))
    for (i,k) in enumerate(K)
        α′ = k * αn
        β′ = (α′ - 1 / 3) / target_median + 2/3 - α′
        attitude = maximize_utility(α, β, α′, β′ , w, γ)
        σ² = var(Beta(α′, β′))
        precisions[i] = 1 / σ²
        attitudes[i] = attitude
    end
    return precisions, attitudes
end

data = sim_backfire.(α, β, αn, βn, ws, γ)
precision = data[1][1]
attitude = map(x -> x[2], data)

plot(
    precision,
    attitude,
    ylims = (.25,.76),
    colors = ws,
    xlabel = "Social Concensus (1 / σ²)",
    ylabel = "Utility maximizing expressed attitude",
    legend = false, 
    grid = false,
    palette = :tab10
)