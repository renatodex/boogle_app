require 'spec_helper'
require 'pry'

# MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')
# MongoMapper.database = ENV['MONGODB_DB'] || "boogle"
#
# class Page
#   include MongoMapper::Document
#
#   key :pageId
#   key :content
# end

class ScoreString < String
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

class ScoreMachine
  class << self
    def calculate(content, query)
      content = (ScoreString.new content).to_word_array
      query = (ScoreString.new query).to_word_array

      (content & query).count
    end
  end
end

describe "Boogle" do
  context "Score" do
    it "should score page search" do
      page_content = "the quick brown fox jumped over the lazy dog"
      query = 'quick but lazy brown dog'
      expect(ScoreMachine.calculate page_content, query).to eq 4
    end

    it "score should ignore case" do
      page_content = "the QuicK bRoWn fox jumped over the lazy DOG"
      query = "quick but lazy brown dog"
      expect(ScoreMachine.calculate page_content, query).to eq 4
    end

    it "score should ignore punctuation" do
      page_content = "the QuicK, bRoWn fox. jumped over, the lazy. DOG"
      query = "quick but lazy brown dog"
      expect(ScoreMachine.calculate page_content, query).to eq 4
    end

    it "score should ignore word order" do
      page_content = "the QuicK, bRoWn fox. jumped over, the lazy. DOG"
      query = "quick but lazy brown dog"
      expect(ScoreMachine.calculate page_content, query).to eq 4
      query = "brown quick dog lazy but"
      expect(ScoreMachine.calculate page_content, query).to eq 4
    end

    it "score should ignore frequency" do
      page_content = "the QuicK quick QUICK, bRoWn broWN brown fox fox fox. jumped jum jumppepp jumped! over, the lazy!. DOG dog!"
      query = "quick but lazy brown dog"
      expect(ScoreMachine.calculate page_content, query).to eq 4

      query = "quick quick lazy lazy brown brown dog dog"
      expect(ScoreMachine.calculate page_content, query).to eq 4
    end

    it "score should ignore frequency (not convinced)" do
      page_content = "the the the the the the the the AHHH the the the the the"
      query = "the AHHH the AHHH the AHHHHHH"
      expect(ScoreMachine.calculate page_content, query).to eq 2
    end
  end
end

# context "API" do
#   context "POST /index"
#   context "GET /search"
# end
