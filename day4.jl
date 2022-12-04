


open("inputs/day4.txt") do f

    full_overlap = 0

    partial_overlap = 0

    for line in readlines(f)
        (a1,a2) = split(line,",")

        rng1 = parse.(Int64, split(a1, "-"))
        rng2 = parse.(Int64, split(a2, "-"))

        fo_check1 = rng1[1] >= rng2[1] && rng1[2] <= rng2[2]
        fo_check2 = rng2[1] >= rng1[1] && rng2[2] <= rng1[2]
        full_overlap += (fo_check1 || fo_check2)

        po_check1 = rng1[1] <= rng2[2] && rng1[1] >= rng2[1]
        po_check2 = rng2[1] <= rng1[2] && rng2[1] >= rng1[1]
        partial_overlap += (po_check1 || po_check2)

    end

    @show full_overlap, partial_overlap
end

