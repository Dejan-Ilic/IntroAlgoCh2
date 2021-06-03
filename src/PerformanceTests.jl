using IntroAlgoCh2
using Plots, BenchmarkTools, Random

amounts = 1:300

insertionsort_times = zeros(length(amounts))
mergesort_times = zeros(length(amounts))
mergesort_optimized_times = zeros(length(amounts))
sort_times = zeros(length(amounts))

for N=amounts
    GC.gc()
    l = shuffle!(collect(1:N))

    a = copy(l)
    ti = @elapsed insertionsort!(a);

    GC.gc()
    b = copy(l)
    tm = @elapsed mergesort_iterative!(b);

    GC.gc()
    c = copy(l)
    tmo = @elapsed mergesort_iterative_optimized!(c);

    GC.gc()
    d = copy(l)
    ts = @elapsed sort!(d);

    insertionsort_times[N] = ti#mean(ti).time
    mergesort_times[N] = tm#mean(tm).time
    mergesort_optimized_times[N] = tmo
    sort_times[N] = ts
end

plot(amounts, insertionsort_times, label="insert");
plot!(amounts, mergesort_times, label="merge")
plot!(amounts, mergesort_optimized_times, label="merge_optimized")
plot!(amounts, sort_times, label="std sort")



if false 
s = 1:100_000 |> collect |> shuffle!
begin
    GC.gc()
    t = copy(s)
    @btime mergesort_iterative!($t)
end
begin
    GC.gc()
    t = copy(s)
    @btime mergesort_iterative_optimized!($t)
end
begin
    GC.gc()
    t = copy(s)
    @btime sort!($t)
end
end;
