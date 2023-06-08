class GridBFS
  attr_reader :grid

  def initialize grid
    @grid = grid
  end

  def distances_from coord
    raise ArgumentError unless in_grid? coord

    x, y = coord
    dist_grid = Array.new(@grid.size) { Array.new @grid.first.size }
    dist_grid[x][y] = 0
    queue = [[x, y]]

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

  def weighted_distances_from coord
    raise ArgumentError unless in_grid? coord

    x, y = coord
    time = 0
    dist_grid = Array.new(@grid.size) { Array.new @grid.first.size }
    queue = [[x, y, time]]

    until queue.empty?
      while coord_ready = queue.find { |x, y, duration| duration == 0 }
        x_curr, y_curr = coord_ready
        if dist_grid[x_curr][y_curr].nil?
          dist_grid[x_curr][y_curr] = time
          [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |x_dir, y_dir|
            x_next, y_next = x_curr + x_dir, y_curr + y_dir
            if in_grid?([x_next, y_next]) && dist_grid[x_next][y_next].nil?
              queue << [x_next, y_next, @grid[x_curr][y_curr]]
            end
          end
        end
        queue.reject! { |x, y, duration| [x, y] == [x_curr, y_curr] }
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
