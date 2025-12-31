#!/usr/bin/env ruby
# A Brainfuck program has an implicit byte pointer, called "the pointer", which is free to move around within an array of 30000 bytes, initially all set to zero. The pointer itself is initialized to point to the beginning of this array.
pointer, array = 0, Array.new(30000, 0)

source = ARGV[0]

# Computes and stores forward and backward matching brackets.
# A stack of positions of opening brackets.
open_brackets = []
forward_matching = {}
backward_matching = {}
source.each_char.each_with_index do |c, i|
  case c
  when "["
    open_brackets.push(i)
  when "]"
    open_pos = open_brackets.pop
    forward_matching[open_pos] = i
    backward_matching[i] = open_pos
  end
end

# Current instruction index.
i = 0

# The Brainfuck programming language consists of eight commands, each of which is represented as a single character.
commands = {
  ">" => ->() { pointer += 1 },
  "<" => ->() { pointer -= 1 },
  "+" => ->() { array[pointer] += 1 },
  "-" => ->() { array[pointer] -= 1 },
  "." => ->() { print array[pointer].chr },
  "," => ->() { array[pointer] = STDIN.getc.ord },
  "[" => ->() { i = forward_matching[i] if array[pointer] == 0 },
  "]" => ->() { i = backward_matching[i] if array[pointer] != 0 },
}

while i < source.length
  pre = i
  c = commands[source[i]]
  c.call if c
  i += 1 if pre == i
end

