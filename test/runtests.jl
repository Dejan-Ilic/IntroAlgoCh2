using IntroAlgoCh2
using Test
using Random, Plots

@testset "IntroAlgoCh2.jl" begin
    r = 1:1000 |> collect |> shuffle!
    @test issorted(insertionsort!(r)) == true
    @test issorted(mergesort!(r)) == true
end
