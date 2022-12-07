using Graphs
using GraphPlot
using Compose
using Cairo
using Fontconfig

using DataStructures

abstract type State end

struct ChangeDir <: State
    path :: String
end

struct List <: State
end

struct MkDir <: State
    name :: String
end

struct Touch <: State
    name :: String
    size :: Int64
end


node_map = Dict{String, Int64}("/"=>1)
rev_node_map = Dict{Int64, String}(1=>"/")
node_is_dir = Dict{Int64, Bool}(1=>true)
node_sizes = Dict{Int64, Int64}()


file_system = DiGraph()
add_vertex!(file_system) # initialize the root node

current_node = 1
node_counter = 1

function step(cd::ChangeDir)
    global node_counter, current_node, file_system
    if cd.path == ".."
        parent = inneighbors(file_system, current_node)[1]
        current_node = parent
    else
        children = outneighbors(file_system, current_node)
        for child in children
            if rev_node_map[child] == cd.path
                current_node = child
                break
            end
        end
    end
end

function step(ls::List)
end

function step(file::Touch)
    global node_counter, current_node, file_system
    add_vertex!(file_system)
    node_counter += 1
    node_map[file.name] = node_counter
    rev_node_map[node_counter] = file.name
    node_is_dir[node_counter] = false
    node_sizes[node_counter] = file.size
    add_edge!(file_system, current_node, node_counter)
end

function step(dir::MkDir)
    global node_counter, current_node, file_system
    add_vertex!(file_system)
    node_counter += 1
    node_map[dir.name] = node_counter
    rev_node_map[node_counter] = dir.name
    node_is_dir[node_counter] = true

    add_edge!(file_system, current_node, node_counter)
end

function parse_line(line)
    if line[3] == 'c' #cd
        return ChangeDir(line[6:end])
    elseif line[3] == 'l' # ls
        return List()
    elseif line[1] == 'd' # dir
        return MkDir(line[5:end])
    else
        size, name = split(line)
        size = parse(Int64, size)
        return Touch(name, size)
    end
end


open("inputs/day7.txt") do f
    for line in readlines(f)
        step(parse_line(line))
    end
end

dfs_queue = Queue{Int}()

#initialize the stack
enqueue!(dfs_queue, 1)

while !isempty(dfs_queue)
    node = dequeue!(dfs_queue)
    children = outneighbors(file_system, node)

    redo = false
    running_sum = 0
    for child in children
        if haskey(node_sizes, child)
            running_sum += node_sizes[child]
            continue
        end
        enqueue!(dfs_queue, child)
        redo = true
    end

    if redo
        enqueue!(dfs_queue, node)
    else
        node_sizes[node] = running_sum
    end
end

total = 0
min_del_dir_size = 1e20

min_size_to_delete = - (70000000 - node_sizes[1]) + 30000000

@show min_size_to_delete

for (k,v) in node_sizes
    global min_del_dir_size
    # @show k, v
    is_dir = node_is_dir[k]

    if is_dir
        @show k, v
    end
    if v < 100000 && is_dir
        global total += v
    end

    if is_dir && v >= min_size_to_delete && v < min_del_dir_size
        min_del_dir_size = v
    end

end
@show total
@show min_del_dir_size


