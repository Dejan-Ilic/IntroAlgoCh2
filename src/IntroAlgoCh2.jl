module IntroAlgoCh2

function insertionsort!(A::Array)
    for j=2:length(A)
        key = A[j]

        i = j - 1
        while i > 0 && A[i] > key
            A[i+1] = A[i]
            i = i - 1
        end
        A[i+1] = key
    end
    return A
end

function _merge!(A::Array, p::Int, q::Int, r::Int)
    n1 = q - p + 1
    n2 = r - q

    L = A[p:q]
    R = A[q+1:r]

    i=1
    j=1

    for k=p:r
        if L[i] <= R[j]
            A[k] = L[i]
            i+=1
            if i >  n1
                A[k+1:r] .= R[j:end]
                break
            end
        else
            A[k] = R[j]
            j+=1

            if j > n2
                A[k+1:r] .= L[i:end]
                break
            end
        end
    end
end

function _mergesort!(A::Array, p::Int, r::Int)
    if p<r
        q = (p+r)÷2
        _mergesort!(A,p,q)
        _mergesort!(A,q+1,r)
        _merge!(A,p,q,r)
    end
end

function mergesort!(A::Array)
    _mergesort!(A, 1, length(A))

    return A
end

function mergesort_iterative!(A::Array)
    N = length(A)
    B = similar(A)

    #sorting
    for k=1:2:N-1
        if A[k] <= A[k+1]
            B[k] = A[k]
            B[k+1] = A[k+1]
        else
            B[k] = A[k+1]
            B[k+1] = A[k]
        end
    end
    if isodd(N)
        B[N] = A[N]
    end
    A, B = B, A #A is nu gesorteerd (deels) en B is garbage

    #merging
    mergestep = 2
    while mergestep < N
        for start = 1:mergestep*2:N
            if mergestep >= N - start
                break #er blijft nog maar een partitie over en die is al gesorteerd
            end

            p = start  #eerst index rij1
            q = start + mergestep #eerste index rij2
            r = min(q + mergestep - 1, N) #laatste index rij2

            i = p
            j = q

            for k=p:r
                if A[i] <= A[j]
                    B[k] = A[i]
                    i+=1
                    if i >= q
                        @views B[k+1:r] = A[j:r]
                        break
                    end
                else
                    B[k] = A[j]
                    j+=1

                    if j > r
                        @views B[k+1:r] =  A[i:q-1]
                        break
                    end
                end
            end
            A, B = B, A
        end
        mergestep *= 2
    end

    return A
end






function _binarysearch(S_sorted::Vector{Int}, target::Int, low::Int, high::Int)::Union{Nothing, Int}
    if low == high
        return (S_sorted[low] == target ? low : nothing)
    end

    mid = (low + high)÷2

    if S_sorted[mid] == target
        return mid
    elseif S_sorted[mid] > target
        return _binarysearch(S_sorted, target, low, mid)
    else
        return _binarysearch(S_sorted, target, mid, high)
    end
end

function sumfinder(S::Vector{Int}, x::Int)::Union{Nothing, Tuple{Int, Int}}
    mergesort!(S)

    n = length(S)

    for i=1:n-1
        idx = let
            target = x - S[i]
            low = i+1
            high = n

            _binarysearch(S, target, low, high)
        end
        if idx !== nothing
            return (i, idx)
        end
    end

    return nothing

end

export insertionsort!, mergesort!, _binarysearch, sumfinder, mergesort_iterative!


end
