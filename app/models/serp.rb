
require 'google_search_results'

class Serp

  def self.api_key
    "3a5aa598e52d5aee64cbec960a73e81647517f94631945c94d98d4c517936d1b"
  end

  def self.search (q)
    params = {
      engine: "google",
      q:  q,
      api_key: api_key
    }

    search = GoogleSearch.new(params)

    [search.get_hash[:organic_results], search.get_hash[:related_questions]]
  end
end