open("inputs/day1.txt") do f

    sum = 0
    elfs = Int64[]
    while !eof(f)
        l = readline(f)
        if !isempty(l)
            sum += parse(Int64,l)
        else
            push!(elfs, sum)
            sum = 0
        end
    end

    mxval, mxidx = findmax(elfs)
    @show mxval, mxidx
end