using DataStructures

function parse_stack_lines!(f)
    line = readline(f)
    n_layers = 0
    # last column only has 3 chars (no trailing space)
    n_columns = ((length(line)-3) ÷ 4 ) + 1# integer division
    stacks = [Stack{Char}() for i in 1:n_columns]
    while line[2] != '1'
        n_layers += 1
        for i in 1:n_columns
            box = line[2 + (i-1)*4]
            if box != ' '
                push!(stacks[i], box)
            end
        end
        line = readline(f)
    end

    new_stacks = [Stack{Char}() for i in 1:n_columns]
    for i in 1:n_columns
        for box in stacks[i]
            push!(new_stacks[i], box)
        end
    end
    return new_stacks
end

function process_moves1!(f, stacks)
    while !eof(f)
        line = readline(f)
        row = split(line)
        n_move = parse(Int64, row[2])
        from = parse(Int64, row[4])
        to = parse(Int64, row[6])

        for i in 1:n_move
            cargo = pop!(stacks[from])
            push!(stacks[to], cargo)
        end
    end
end

function process_moves2!(f, stacks)
    crane = Stack{Char}()

    while !eof(f)
        line = readline(f)
        row = split(line)
        n_move = parse(Int64, row[2])
        from = parse(Int64, row[4])
        to = parse(Int64, row[6])

        for i in 1:n_move
            cargo  = pop!(stacks[from])
            push!(crane, cargo)
        end

        for i in 1:n_move
            cargo  = pop!(crane)
            push!(stacks[to], cargo)
        end
    end
end

open("inputs/day5.txt") do f
    stacks = parse_stack_lines!(f)
    readline(f) # one empty line

    process_moves2!(f, stacks)

    line = ""
    for stack in stacks
        line *= pop!(stack)
    end
    @show line
end