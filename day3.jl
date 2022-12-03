abet = "abcdefghijklmnopqrstuvwxyz"
abet *= uppercase(abet) #string concatenation

priority = Dict(zip(abet, 1:52))

open("inputs/day3.txt") do f
    score1 = 0
    score2 = 0
    group_cnt = 1
    group_sets = [Set{Char}(), Set{Char}(), Set{Char}()]
    for line in readlines(f)
        split = length(line) ÷ 2
        c1 = line[1:split]
        c2 = line[split+1:end]
        sc1 = Set(c1)
        sc2 = Set(c2)

        #assume there is only 1
        duplicate = only(intersect(sc1, sc2))
        score1 += priority[duplicate]

        group_sets[group_cnt] = Set{Char}(line)
        if group_cnt == 3
            badge = only(intersect(group_sets...))
            score2 += priority[badge]
        end
        group_cnt = mod1(group_cnt+1, 3)
    end
    println("part 1: $score1")
    println("part 1: $score2")
end
