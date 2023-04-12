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
* Starting vertex
* Ending vertex 
* Graph 
* Edge labels
"""
function make_structures(goal::Int, elements::Vtype)
    start_vertex = sort(elements)
    last_vertex = Int[]

    G = UG{Vtype}()
    edge_labels = Dict{Tuple{Vtype,Vtype},String}()

    todo = Set{Vtype}()  # vertices that need to be expanded
    push!(todo, start_vertex)
    add!(G, start_vertex)

    while !isempty(todo)
        v = first(todo)
        delete!(todo, v)

        if goal ∈ v
            last_vertex = v
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
                if b%a != 0
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

    return start_vertex, last_vertex, G, edge_labels
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
    digits_solver(goal::Int, digits::Vector{Int})

Solve a *New York Times* digits problem. `goal` is the number to 
achieve and `digits` is a list (vector) containing the values with
which to work.

Example:
```
julia> digits_solver(264, [4,5,6,7,9,25])
[4, 5, 6, 7, 9, 25] → 25 × 6 = 150 → [4, 5, 7, 9, 150]
[4, 5, 7, 9, 150] → 9 × 4 = 36 → [5, 7, 36, 150]
[5, 7, 36, 150] → 7 - 5 = 2 → [2, 36, 150]
[2, 36, 150] → 150 × 2 = 300 → [36, 300]
[36, 300] → 300 - 36 = 264 → [264]
```
"""
function digits_solver(goal::Int, digits::Vector{Int})
    start_vertex, last_vertex, G, edge_labels = make_structures(goal,digits);

    P = find_path(G, start_vertex,last_vertex)
    n = length(P)-1

    for k=1:n 
        print(P[k], " → ")
        print(edge_labels[P[k],P[k+1]], " → ")
        println(P[k+1])
    end

end

digits_solver(n::Int, thing) = digits_solver(n, collect(thing))

end # module DigitsSolver
