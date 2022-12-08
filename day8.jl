let

    function check_viz!(row, labels, scores)
        n = length(row)

        row_labels = Vector{Bool}(undef, n)
        row_labels .= false # initialize array to false
        row_labels[1] = true
        labels[1] = true

        for i in 2:n
            for j in i-1:-1:1
                if row[i] <= row[j] # stop because we're not visible
                    scores[i] = i-j
                    break
                elseif row_labels[j] # short circuit the checks because we know we're taller than a visible tree
                    labels[i] = true # globally true
                    row_labels[i] = true # locally true
                    scores[i] = i-1
                    break
                end
            end
        end
    end


    # load the data into an array
    n_grid, tree_map, visible_map = open("inputs/day8.txt") do f
        lines = readlines(f)
        n_grid = length(lines)


        tm = Matrix{Int}(undef, n_grid, n_grid)
        vm = Matrix{Bool}(undef, n_grid, n_grid)

        for i in 1:n_grid
            for j in 1:n_grid
                tm[i,j] = parse(Int,lines[i][j])
                vm[i,j] = false
            end
        end

        return n_grid, tm, vm
    end

    scores1 = fill(0, n_grid, n_grid)
    scores2 = fill(0, n_grid, n_grid)
    scores3 = fill(0, n_grid, n_grid)
    scores4 = fill(0, n_grid, n_grid)

    tree_map_rev = tree_map[end:-1:1,end:-1:1]
    visible_map_rev = visible_map[end:-1:1,end:-1:1]

    for i in 1:n_grid
        row = @view tree_map[i,:]
        labels = @view visible_map[i,:]
        scores = @view scores1[i,:]
        check_viz!(row, labels, scores)

        col = @view tree_map[:,i]
        labels = @view visible_map[:,i]
        scores = @view scores2[:,i]
        check_viz!(col, labels, scores)

        row = @view tree_map_rev[i,:]
        labels = @view visible_map_rev[i,:]
        scores = @view scores3[i,:]
        check_viz!(row, labels, scores)

        col = @view tree_map_rev[:,i]
        labels = @view visible_map_rev[:,i]
        scores = @view scores4[:,i]
        check_viz!(col, labels, scores)
    end



    # tree_map

    # re-invert the rev label and boolean them
    visible_map_rev_flip = visible_map_rev[end:-1:1,end:-1:1]
    scores3_flip = scores3[end:-1:1,end:-1:1]
    scores4_flip = scores4[end:-1:1,end:-1:1]
    visible_map = visible_map .|| visible_map_rev_flip

    # visible_map

    scores = scores1 .* scores2 .* scores3_flip .* scores4_flip
    # @show visible_map
    @show sum(visible_map)
    @show maximum(scores)

end