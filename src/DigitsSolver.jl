module DigitsSolver

using SimpleGraphs

export digits_solver

export make_structures  # debug

# The vertex type for a Digits graph is a Vector{Int} in which we
# keep the elements in increasing order.
Vtype = Vector{Int}

# The edge labels (kept in a dictionary) are String's. 
# For example, "12 + 2 = 14" or "12 ÷ 2 = 6"

"""
    make_structures(goal::Int, elements::Vtype)

Create the necessary graph and edge labels to solve the puzzle.
Returns a tuple with the following elements:
* Graph 
* Edge labels
"""
function make_structures(goal::Int, elements::Vtype, quick_stop::Bool = false)
    start_vertex = sort(elements)

    G = UG{Vtype}()
    edge_labels = Dict{Tuple{Vtype,Vtype},String}()

    todo = Set{Vtype}()  # vertices that need to be expanded
    push!(todo, start_vertex)
    add!(G, start_vertex)

    while !isempty(todo)
        v = first(todo)
        delete!(todo, v)

        if quick_stop && goal ∈ v
            break
        end

        sz = length(v)
        # ADDITION
        for i = 1:sz-1
            for j = i+1:sz
                w = copy(v)
                a, b = extract!(w, i, j)
                c = a + b
                append!(w, c)
                sort!(w)
                add!(G, v, w)
                lab = "$b + $a = $c"
                edge_labels[v, w] = lab
                edge_labels[w, v] = lab
                push!(todo, w)

            end
        end

        # MUTIPLICATION
        for i = 1:sz-1
            for j = i+1:sz
                w = copy(v)
                a, b = extract!(w, i, j)
                c = b * a
                append!(w, c)
                sort!(w)
                add!(G, v, w)
                lab = "$b × $a = $c"
                edge_labels[v, w] = lab
                edge_labels[w, v] = lab
                push!(todo, w)
            end
        end

        # SUBTRACTION
        for i = 1:sz-1
            for j = i+1:sz
                w = copy(v)
                a, b = extract!(w, i, j)
                c = b - a
                append!(w, c)
                sort!(w)
                add!(G, v, w)
                lab = "$b - $a = $c"
                edge_labels[v, w] = lab
                edge_labels[w, v] = lab
                push!(todo, w)
            end
        end

        # DIVISION
        for i = 1:sz-1
            for j = i+1:sz
                w = copy(v)
                a, b = extract!(w, i, j)
                if a == 0
                    continue
                end
                if b % a != 0
                    continue
                end
                c = b ÷ a
                append!(w, c)
                sort!(w)
                add!(G, v, w)
                lab = "$b ÷ $a = $c"
                edge_labels[v, w] = lab
                edge_labels[w, v] = lab
                push!(todo, w)
            end
        end
    end

    # add edges to [goal]

    v_goal = [goal]

    VV = vlist(G)
    for v ∈ VV
        if goal ∈ v
            add!(G, v, v_goal)
        end
    end
    add!(G, v_goal) # just in case unreachable

    return G, edge_labels
end

"""
    extract!(w::Vtype, i, j)::Tuple{Int,Int}

Given a list of integers `w` remove elements `i` and `j` from `w`
(modifying `w`) and return the values at indices `i` and `j`.
"""
function extract!(w::Vtype, i, j)::Tuple{Int,Int}
    a = w[i]
    b = w[j]
    deleteat!(w, (i, j))
    return a, b
end


"""
    digits_solver(goal::Int, digits::Vector{Int}, quick_stop::Bool = true)

Solve a *New York Times* digits problem. `goal` is the number to 
achieve and `digits` is a list (vector) containing the values with
which to work.

With `quick_stop` set to `true`, the computer will stop at the first 
possible solution to the problem. If set to `false`, the process will 
likely take longer, but a shorter solution might be found. 

Example:
```
julia> digits_solver(264, [4,5,6,7,9,25])
[4, 5, 6, 7, 9, 25] → 25 + 5 = 30 → [4, 6, 7, 9, 30]
[4, 6, 7, 9, 30] → 30 × 9 = 270 → [4, 6, 7, 270]
[4, 6, 7, 270] → 270 - 6 = 264 → [4, 7, 264]
```
"""
function digits_solver(goal::Int, digits::Vector{Int}, quick_stop::Bool = true)
    digits = sort(digits)

    if goal ∈ digits
        print("$goal already in $digits")
        return
    end

    G, edge_labels = make_structures(goal, digits, quick_stop)

    if deg(G, [goal]) == 0
        println("No solution")
        return
    end

    P = find_path(G, digits, [goal])
    n = length(P) - 1

    for k = 1:n
        print(P[k], " → ")
        print(edge_labels[P[k], P[k+1]], " → ")
        println(P[k+1])
        if goal ∈ P[k+1]
            break
        end
    end

end

digits_solver(n::Int, thing, quick_stop::Bool = true) =
    digits_solver(n, collect(thing), quick_stop)

digits_solver(a::Int, args...) = digits_solver(a, [args...])

end # module DigitsSolver
