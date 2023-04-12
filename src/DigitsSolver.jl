module DigitsSolver

using SimpleGraphs, ShowSet


export make_structures, extract!  # debug

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
                a,b = extract!(w,i,j)
                c = a+b 
                append!(w, c)
                sort!(w)
                add!(G,v,w)
                lab = "$b + $a = $c"
                edge_labels[v,w] = lab
                edge_labels[w,v] = lab
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
    deleteat!(w,(i,j))
    return a,b
end


end # module DigitsSolver
