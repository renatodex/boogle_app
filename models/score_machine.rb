class ScoreMachine
  class << self
    def calculate(content, query)
      content = (CustomString.new content).to_word_array
      query = (CustomString.new query).to_word_array

      (content & query).count
    end
  end
end
