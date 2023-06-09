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

    it 'works with multiple starting points' do
      bfs = GridBFS.new([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
      expect(bfs.distances_from [0, 1], [1, 2]).to eq [[1, 0, 1], [2, 1, 0], [3, 2, 1]]
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

    it 'works with multiple starting points.' do
      bfs = GridBFS.new([[2, 2, 4], [5, 1, 0], [3, 7, 1]])
      expect(bfs.weighted_distances_from [0, 1], [2, 2]).to eq [[2, 0, 1], [2, 1, 1], [7, 1, 0]]
    end
  end
end

RSpec.describe GraphBFS do
  describe 'initialization' do
    it 'stores given nodes and links in the #graph hash.' do
      bfs = GraphBFS.new [0, 0, 0], [[0, 1], [0, 2], [1, 2]]
      expect(bfs.graph).to eq nodes: [0, 0, 0], links: [[0, 1], [0, 2], [1, 2]]
    end

    it 'raises ArgumentError if not all links connect to existing nodes.' do
      expect { GraphBFS.new [0, 0, 0], [[0, 1], [0, 3]] }.to raise_exception ArgumentError
    end
  end

  describe '#distances_from idx' do
    it 'raises ArgumentError if index given is not in the nodes.' do
      bfs = GraphBFS.new [0, 0, 0], [[0, 1], [1, 2]]
      expect { bfs.distances_from 3 }.to raise_exception ArgumentError
      expect { bfs.distances_from -1 }.to raise_exception ArgumentError
    end

    it 'returns the list of distances when there is only one way.' do
      bfs = GraphBFS.new [0, 0, 0], [[0, 1], [1, 2]]
      expect(bfs.distances_from 0).to eq [0, 1, 2]
      expect(bfs.distances_from 1).to eq [1, 0, 1]
    end

    it 'returns the list of distances when there are more ways.' do
      bfs = GraphBFS.new [0] * 5, [[0, 1], [0, 2], [1, 3], [3, 4], [2, 4]]
      expect(bfs.distances_from 0).to eq [0, 1, 1, 2, 2]
    end

    it 'gives nil for nodes that are not reachable.' do
      bfs = GraphBFS.new [0] * 5, [[0, 1], [0, 2], [2, 4]]
      expect(bfs.distances_from 0).to eq [0, 1, 1, nil, 2]
    end

    it 'works with mulptiple starting points.' do
      bfs = GraphBFS.new [0] * 5, [[0, 1], [0, 2], [1, 3], [3, 4], [2, 4]]
      expect(bfs.distances_from 0, 3).to eq [0, 1, 1, 0, 1]
    end
  end

  describe '#weighted_distances_from idx' do
    it 'raises ArgumentError if index given is not in the nodes.' do
      bfs = GraphBFS.new [3, 2, 0], [[0, 1], [1, 2]]
      expect { bfs.weighted_distances_from 3 }.to raise_exception ArgumentError
      expect { bfs.weighted_distances_from -1 }.to raise_exception ArgumentError
    end

    it 'returns the list of distances when there is only one way.' do
      bfs = GraphBFS.new [3, 2, 0], [[0, 1], [1, 2]]
      expect(bfs.weighted_distances_from 0).to eq [0, 3, 5]
      expect(bfs.weighted_distances_from 1).to eq [2, 0, 2]
    end

    it 'returns the list of distances when there are more ways.' do
      bfs = GraphBFS.new [2, 1, 7, 2, 3], [[0, 1], [0, 2], [1, 3], [3, 4], [2, 4]]
      expect(bfs.weighted_distances_from 0).to eq [0, 2, 2, 3, 5]
    end

    it 'works with multiple starting points.' do
      bfs = GraphBFS.new [2, 1, 7, 2, 1], [[0, 1], [0, 2], [1, 3], [3, 4], [2, 4]]
      expect(bfs.weighted_distances_from 0, 4).to eq [0, 2, 1, 1, 0]
    end
  end
end
