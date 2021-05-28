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

export insertionsort!, mergesort!, _binarysearch, sumfinder


end
