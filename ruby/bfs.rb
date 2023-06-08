class GridBFS
  attr_reader :grid

  def initialize grid
    @grid = grid
  end

  def distances_from coord
    raise ArgumentError unless in_grid? coord

    queue = [coord]
    dist_grid = Array.new(@grid.size) { Array.new @grid.first.size }
    x, y = coord
    dist_grid[x][y] = 0

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

  private

  def in_grid? coord
    x, y = coord
    !!(x >= 0 && y >= 0 && @grid[x] && @grid[x][y])
  end
end
