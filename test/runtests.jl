using SafeTestsets

@safetestset "maximum utility" begin
    @safetestset "1" begin
        using Test
        using Distributions
        using SocialSamplingTheory
        α = 4
        β = 9
        αn = 6
        βn = 2.2
        γ = 20.0
        w = 0.5
        max_a, _ = maximize_utility(α, β, αn, βn, w, γ)
        @test max_a ≈ 0.484 atol = 5e-2
    end

    @safetestset "2" begin
        #https://sstmodel.shinyapps.io/one_agent/
        using Test
        using Distributions
        using SocialSamplingTheory
        α = 1
        β = 1
        αn = 9
        βn = 4
        γ = 5
        w = 0.30
        max_a, _ = maximize_utility(α, β, αn, βn, w, γ)
        @test max_a ≈ 0.66 atol = 5e-2
    end

    @safetestset "3" begin
        #https://sstmodel.shinyapps.io/one_agent/
        using Test
        using Distributions
        using SocialSamplingTheory
        α = 1
        β = 1
        αn = 1
        βn = 1
        γ = 5
        w = 0.50
        max_a, _ = maximize_utility(α, β, αn, βn, w, γ)
        @test max_a ≈ 0.50 atol = 5e-2
    end

    @safetestset "4" begin
        #https://sstmodel.shinyapps.io/one_agent/
        using Test
        using Distributions
        using SocialSamplingTheory
        α = 10
        β = 10
        αn = 1
        βn = 4
        γ = 4
        w = 0.60
        max_a, _ = maximize_utility(α, β, αn, βn, w, γ)
        @test max_a ≈ 0.16 atol = 5e-2
    end
end
