module Boogle
  class API
    class << self
      def search(query)

        raw_result = ::SomeClass.method_to_retrieve_data(query)

        matches = build_matches(query, raw_result)
        sorted_matches = matches.sort {|p, n| n["score"] <=> p["score"]  }

        { "matches" => sorted_matches }
      end

      def build_matches(query, raw_result)
        result = raw_result.inject([]) do |arr, p|
          score = ScoreMachine.calculate(p[:content], query)
          if score > 0
            arr << single_match(p[:pageId],score)
          end
          arr
        end
      end

      def single_match(pageId, score)
        { "pageId" => pageId, "score" => score}
      end
    end
  end
end
