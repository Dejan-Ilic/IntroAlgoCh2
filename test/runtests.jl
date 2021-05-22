using IntroAlgoCh2
using Test
using Random

@testset "IntroAlgoCh2.jl" begin
    r = 1:1000 |> collect |> shuffle!
    @test issorted(insertionsort(r)) == true
end
