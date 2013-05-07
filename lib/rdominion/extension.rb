class String
  def to_idx
    self.ord - 97
  end

  def truncate(opts = {})
    opts[:omission] ||= "..."
    opts[:limit] ||= 30
    str = self
    if self.size > opts[:limit]
      max_size = opts[:limit] - opts[:omission].size
      str = str[0..max_size] + opts[:omission]
    end
    str
  end
end
