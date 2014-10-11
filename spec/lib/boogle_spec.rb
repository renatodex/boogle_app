require 'spec_helper'

# MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')
# MongoMapper.database = ENV['MONGODB_DB'] || "boogle"

class SomeClass
  def self.method_to_retrieve_data(q)
  end
end

describe "Boogle" do

  let(:pages) {[
    { :pageId => 300, :content => "the quick brown fox jumped over the lazy dog" }, #2
    { :pageId => 301, :content => "brown is the fox, red is the chicken"}, #3
    { :pageId => 302, :content => "Set was the operationg king, he has single purposes" }, #1
    { :pageId => 303, :content => "I wanted him to return, due to everything he had given to me"}, #0
  ]}

  context "API Handling" do
    it "should return score json given a set pages and a single query" do
      query = "the fox is a very weaken mind man"
      allow(SomeClass).to receive(:method_to_retrieve_data).and_return(pages)

      expect(Boogle::API.search(query)).to eq({"matches" => [
          {"pageId" => 301, "score" => 3},
          {"pageId" => 300, "score" => 2},
          {"pageId" => 302, "score" => 1}
        ]
      })
    end

    it "should return score json given a set pages and a single query" do
      query = "brown fox jumped"

      allow(SomeClass).to receive(:method_to_retrieve_data).and_return(pages)
      expect(Boogle::API.search(query)).to eq({"matches" => [
          {"pageId" => 300, "score" => 3},
          {"pageId" => 301, "score" => 2}
        ]
      })
    end

    it "should return no matches when query does not match anything" do
      query = "golden dolphins"

      allow(SomeClass).to receive(:method_to_retrieve_data).and_return(pages)
      expect(Boogle::API.search(query)).to eq({
        "matches" => []
      })
    end
  end

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
