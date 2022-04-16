using SafeTestsets

@safetestset "maximum utility" begin
    using Test, Distributions, SocialSamplingTheory
    α = 4
    β = 9
    αn = 6
    βn = 2.2
    γ = 20.0
    w = .5
    max_a,_ = maximize_utility(α, β, αn, βn, w, γ)
    @test max_a ≈ .484 atol = 5e-2
end