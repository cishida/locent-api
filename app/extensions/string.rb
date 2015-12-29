class String
  def snake_case
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
  end

  def redact values_hash
    text = self
    puts "LOL " + self
    values_hash.each do |key, value|
      to_be_replaced = "{#{key.to_s.upcase}}"
      text.gsub!(to_be_replaced, value)
    end
    puts "hahahaha " + text
    return text
  end
end