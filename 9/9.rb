require 'pairing_heap'
Block = Struct.new(:id, :start_idx, :size)
Free = Struct.new(:start_idx, :size)
@blocks = []
@frees = []
File.readlines('in.txt', chomp: true).each do |line|
  len = 0
  line.each_char.with_index do |c, idx|
    val = c.to_i
    if idx.even?
      @blocks << Block.new(idx / 2, len, val)
    else
      @frees << Free.new(len, val)
    end
    len += val
  end
end

def part_1
  blocks = @blocks.map(&:dup)
  free_idx = 0
  checksum = 0

  while blocks.any?
    block = blocks.shift
    checksum += (2 * block.id * block.start_idx + (block.size - 1) * block.id) * block.size / 2

    free = @frees[free_idx]
    free_idx += 1
    next if free.size == 0

    start_idx = free.start_idx
    size = free.size
    while blocks.any? && size > 0
      last_block = blocks.last
      ate = [last_block.size, size].min

      blocks.pop if ate == last_block.size
      last_block.size -= ate

      checksum += (2 * last_block.id * start_idx + (ate - 1) * last_block.id) * ate / 2
      start_idx += ate
      size -= ate
    end
  end
  checksum
end

def part_2
  stacks = Array.new(10) { PairingHeap::SimplePairingHeap.new }
  @frees.reverse_each do |free|
    next if free.size == 0
    stacks[free.size].push(free, free.start_idx)
  end
  checksum = 0
  @blocks.reverse_each do |block|
    found_space = nil
    block.size.upto(9) do |size|
      next if stacks[size].empty?
      cand = stacks[size].peek
      next if cand.start_idx > block.start_idx

      if found_space.nil? || cand.start_idx < found_space.start_idx
        found_space = cand
      end
    end
    unless found_space
      checksum += (2 * block.id * block.start_idx + (block.size - 1) * block.id) * block.size / 2
      next
    end

    stacks[found_space.size].pop

    checksum += (2 * block.id * found_space.start_idx + (block.size - 1) * block.id) * block.size / 2

    if (diff = found_space.size - block.size) > 0
      new_idx = found_space.start_idx + block.size
      stacks[diff].push(Free.new(new_idx, diff), new_idx)
    end
  end
  checksum
end

p part_1
p part_2
