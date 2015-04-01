class Hash
  def deep_fetch(*args)
    key = args.shift
    val = self.fetch(key, nil)
    return val if args.length == 0
    return nil if val.nil? || !val.respond_to?(:deep_fetch)
    val.deep_fetch(*args)
  end
end

