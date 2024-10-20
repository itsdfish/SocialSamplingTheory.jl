###################################################################################################
#                                        Load Packages
###################################################################################################
cd(@__DIR__)
using Pkg
Pkg.activate("../")
using Revise, SocialSamplingTheory, Distributions, Plots
###################################################################################################
#                                        Backfire Effect
###################################################################################################
# parameter of beta distribution coded as conservative
α = 4
# parameter of beta distribution coded as liberal 
β = 9
# parameter of beta distribution coded as conservative for social network
αn = 6.0
# parameter of beta distribution coded as liberal for social network 
βn = 2.2
# utility sensitivity parameter 
γ = 20.0
#  weights for social extremeness aversion
ws = 0.1:0.05:0.9

function sim_backfire(α, β, αn, βn, w, γ)
    K = 0.40:0.025:6
    n = length(K)
    attitudes = fill(0.0, n)
    precisions = fill(0.0, n)
    target_median = median(Beta(αn, βn))
    for (i, k) in enumerate(K)
        α′ = k * αn
        β′ = (α′ - 1 / 3) / target_median + 2 / 3 - α′
        attitude, _ = maximize_utility(α, β, α′, β′, w, γ)
        σ² = var(Beta(α′, β′))
        precisions[i] = 1 / σ²
        attitudes[i] = attitude
    end
    return precisions, attitudes
end

data = sim_backfire.(α, β, αn, βn, ws, γ)
precision = data[1][1]
attitude = map(x -> x[2], data)

pyplot()
plot(
    precision,
    attitude,
    ylims = (0.25, 0.76),
    xtickfontsize = 10,
    ytickfontsize = 10,
    xguidefontsize = 12,
    yguidefontsize = 12,
    legendfontsize = 8,
    colorbar_title = "w",
    colors = ws,
    xlabel = "Social Concensus (1 / σ²)",
    ylabel = "Utility Maximizing 
    Expressed Attitude",
    grid = false,
    label = "",
    lc = cgrad(:acton, [ws;]'; rev = true),
    line_z = (ws)',
    size = (600, 300),
    dpi = 800
)
savefig("backfire.png")
