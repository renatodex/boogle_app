class CustomString < String
  def to_word_array
    self.no_case.no_punctuation.split_spaces
  end

  def no_punctuation
    self.gsub(/[^[[:word:]]\s]/, '')
  end

  def no_case
    self.downcase
  end

  def split_spaces
    self.split(' ')
  end
end
