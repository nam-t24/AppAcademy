class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    return false if include?(key)
    self[key.hash] << key
    @count += 1
    resize! if num_buckets < self.count
  end

  def include?(key)
    self[key.hash].include?(key)
  end

  def remove(key)
    if (include?(key))
      self[key.hash].delete(key)
      @count -= 1
    end
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num%num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    old = @store
    @count=0
    @store = Array.new(num_buckets * 2) { Array.new }

    old.flatten.each{|key| insert(key)}

  end
end
