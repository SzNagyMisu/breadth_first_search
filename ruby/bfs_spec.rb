require_relative 'bfs'

RSpec.describe GridBFS do
  describe '#grid' do
    it 'is and attribute reader for the init value.' do
      bfs = GridBFS.new([[1,1,1], [2,1,2]])
      expect(bfs.grid).to eq [[1,1,1], [2,1,2]]
    end
  end

  describe '#distances_from coord' do
    it 'raises ArgumentError if coords are not on the grid.' do
      bfs = GridBFS.new([[1,2], [2,1]])
      expect { bfs.distances_from [1, 2] }.to raise_exception ArgumentError
      expect { bfs.distances_from [2, 0] }.to raise_exception ArgumentError
    end

    it 'returns a grid with the distances from the coord.' do
      bfs = GridBFS.new([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
      expect(bfs.distances_from [1, 1]).to eq [[2, 1, 2], [1, 0, 1], [2, 1, 2]]
      expect(bfs.distances_from [0, 0]).to eq [[0, 1, 2], [1, 2, 3], [2, 3, 4]]
      expect(bfs.distances_from [1, 0]).to eq [[1, 2, 3], [0, 1, 2], [1, 2, 3]]
    end
  end

  describe '#weighted_distances_from coord' do
    it 'raises ArgumentError if coords are not on the grid.' do
      bfs = GridBFS.new([[1,2], [2,1]])
      expect { bfs.weighted_distances_from [1, 2] }.to raise_exception ArgumentError
      expect { bfs.weighted_distances_from [2, 0] }.to raise_exception ArgumentError
    end

    it 'returns a grid with the distances from the coord.' do
      bfs = GridBFS.new([[2, 2, 4], [5, 1, 0], [3, 7, 8]])
      expect(bfs.weighted_distances_from [1, 1]).to eq [[3, 1, 1], [1, 0, 1], [6, 1, 1]]
      expect(bfs.weighted_distances_from [0, 0]).to eq [[0, 2, 4], [2, 4, 5], [7, 5, 5]]
      expect(bfs.weighted_distances_from [1, 0]).to eq [[5, 6, 6], [0, 5, 6], [5, 6, 6]]
    end
  end
end
