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

class ScoreMachine
  class << self
    def calculate(content, query)
      content_words = content.split(' ')
      query_words = query.split(' ')

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

    it "score should ignore case"
    it "score should ignore punctuation"
    it "score should ignore word order"
    it "score should ignore frequency"
  end
end

# context "API" do
#   context "POST /index"
#   context "GET /search"
# end
