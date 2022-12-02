my_score = Dict("X" => 1, "Y" => 2, "Z" => 3)
their_score = Dict("A" => 1, "B" => 2, "C" => 3)
my_action = Dict("X" => -1, "Y" => 0, "Z" => 1)

function match(ts, ms)
    if ts == ms
       return 3
    elseif mod1(ts+1,3) == ms
       return 6
    else
       return 0
    end
end

function score_round_1(them, me)
    ts = their_score[them]
    ms = my_score[me]

    return match(ts,ms) + ms
end

# x loose, y draw, z win
function score_round_2(them, me)
    ts = their_score[them]
    mc = my_action[me]
    ms = mod1(ts+mc,3)

    return match(ts,ms) + ms

end

open("inputs/day2.txt") do f
    total_score_1 = 0
    total_score_2 = 0

    for line in readlines(f)
        them, me = split(line, " ")
        total_score_1 += score_round_1(them, me)
        total_score_2 += score_round_2(them, me)
    end

    @show total_score_1, total_score_2
end