
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

    max_count_of_retries = 3
    retry_count = 0

    begin
      search = GoogleSearch.new(params)
      raise StandardError if search.get_hash[:organic_results].length == 0
      return [search.get_hash[:organic_results], (search.get_hash[:related_questions] || [])]
    rescue => e
      puts e
      retry_count += 1
      if retry_count <= max_count_of_retries
        retry
      end
    end

  end
end