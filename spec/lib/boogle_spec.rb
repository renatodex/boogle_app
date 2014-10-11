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
  def no_punctuation
    self.gsub(/[^[[:word:]]\s]/, '')
  end

  def no_case
    self.downcase
  end
end

class ScoreMachine
  class << self
    def calculate(content, query)
      f_content = ScoreString.new content
      f_query = ScoreString.new query

      content_words = f_content.no_punctuation.no_case.split(' ')
      query_words = f_query.no_punctuation.no_case.split(' ')

      (query_words & content_words).count
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
  end
end

# context "API" do
#   context "POST /index"
#   context "GET /search"
# end
