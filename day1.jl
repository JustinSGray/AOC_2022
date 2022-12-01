open("inputs/day1.txt") do f

    e_total = 0
    elfs = Int64[]
    while !eof(f)
        l = readline(f)
        if !isempty(l)
            e_total += parse(Int64,l)
        else
            push!(elfs, e_total)
            e_total = 0
        end
    end

    # part 1
    mxval, mxidx = findmax(elfs)
    @show mxval, mxidx

    p = sortperm(elfs; rev=true)
    @show sum(elfs[p[1:3]])
end