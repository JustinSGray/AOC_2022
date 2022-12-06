using StaticArrays

mutable struct PacketSniffer
    window::Vector{Char}
    idx::Int64
    size::Int64
    market::Int64
end

function Base.push!(ps::PacketSniffer, val::Char)
    ps.window[ps.idx] = val
    ps.idx = mod1(ps.idx+1,ps.size)
    return
end

function sniff(ps::PacketSniffer)
    return length(Set{Char}(ps.window)) == ps.size
end

ps4 = PacketSniffer(Vector{Char}(undef,4), 1, 4)
ps14 = PacketSniffer(Vector{Char}(undef,14), 1, 14)

open("inputs/day6_test.txt") do f
    stream = readline(f)
    packet_sniffer = ps14

    for (i,letter) in enumerate(stream)
        push!(packet_sniffer, letter)
        if i <= packet_sniffer.size # need to fully load the first window before we sniff
            continue
        end

        if sniff(packet_sniffer)
            @show i, packet_sniffer.window
            break
        end
    end
end
