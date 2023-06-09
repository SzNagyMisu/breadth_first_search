class GridBFS
  attr_reader :grid

  def initialize grid
    @grid = grid
  end

  def distances_from *coords
    raise ArgumentError unless coords.all? { |coord| in_grid? coord }

    dist_grid = Array.new(@grid.size) { Array.new @grid.first.size }
    queue = []
    coords.each do |x, y|
      dist_grid[x][y] = 0
      queue << [x, y]
    end

    until queue.empty?
      x_curr, y_curr = queue.shift
      [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |x_dir, y_dir|
        x_next, y_next = x_curr + x_dir, y_curr + y_dir
        if in_grid?([x_next, y_next]) && dist_grid[x_next][y_next].nil?
          queue << [x_next, y_next]
          dist_grid[x_next][y_next] = dist_grid[x_curr][y_curr] + 1
        end
      end
    end

    dist_grid
  end

  def weighted_distances_from *coords
    raise ArgumentError unless coords.all? { |coord| in_grid? coord }

    time = 0
    dist_grid = Array.new(@grid.size) { Array.new @grid.first.size }
    queue = coords.map { |x, y| [x, y, time] }

    until queue.empty?
      while coord_ready = queue.find { |x, y, duration| duration == 0 }
        x_curr, y_curr, _ = coord_ready
        queue.reject! { |x, y, duration| [x, y] == [x_curr, y_curr] }
        if dist_grid[x_curr][y_curr].nil?
          dist_grid[x_curr][y_curr] = time
          [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |x_dir, y_dir|
            x_next, y_next = x_curr + x_dir, y_curr + y_dir
            if in_grid?([x_next, y_next]) && dist_grid[x_next][y_next].nil?
              queue << [x_next, y_next, @grid[x_curr][y_curr]]
            end
          end
        end
      end

      queue.each { |item| item[2] -= 1 }
      time += 1
    end

    dist_grid
  end

  private

  def in_grid? coord
    x, y = coord
    !!(x >= 0 && y >= 0 && @grid[x] && @grid[x][y])
  end
end

class GraphBFS
  attr_reader :graph

  def initialize nodes, links
    @graph = {
      nodes: nodes,
      links: links,
    }
    validate_links!
  end

  def distances_from *indexes
    nodes_count = @graph[:nodes].size
    raise ArgumentError unless indexes.all? { |idx| (0...nodes_count) === idx }

    queue = []
    distances = Array.new nodes_count
    indexes.each do |idx|
      queue << idx
      distances[idx] = 0
    end

    until queue.empty?
      current_idx = queue.shift
      @graph[:links].each do |link|
        if link.include? current_idx
          next_idx, = link - [current_idx]
          if distances[next_idx].nil?
            queue << next_idx
            distances[next_idx] = distances[current_idx] + 1
          end
        end
      end
    end

    distances
  end

  def weighted_distances_from *indexes
    nodes = @graph[:nodes]
    nodes_count = nodes.size
    raise ArgumentError unless indexes.all? { |idx| (0...nodes_count) === idx }

    time = 0
    distances = Array.new nodes_count
    queue = []
    indexes.each do |idx|
      distances[idx] = time
      queue << [idx, nodes[idx]]
    end

    until queue.empty?
      while ready_queue_item = queue.find { |idx, duration| duration == 0 }
        current_idx, = ready_queue_item
        queue.reject! { |idx, duration| idx === current_idx }
        @graph[:links].each do |link|
          if link.include? current_idx
            next_idx, = link - [current_idx]
            if distances[next_idx].nil?
              queue << [next_idx, nodes[next_idx]]
              distances[next_idx] = time
            end
          end
        end
      end

      queue.each { |item| item[1] -= 1 }
      time += 1
    end

    distances
  end

  private

  def validate_links!
    node_idxs = @graph[:nodes].each_index.to_a
    @graph[:links].each do |link|
      raise ArgumentError unless (link - node_idxs).empty?
    end
  end
end
