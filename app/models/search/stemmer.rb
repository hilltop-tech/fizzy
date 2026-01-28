module Search::Stemmer
  extend self

  STEMMER = Mittens::Stemmer.new

  def stem(value)
    if value.present?
      value.gsub(/[^\p{Word}\s]/, "").split(/\s+/).map { |word| stem_word(word) }.join(" ")
    else
      value
    end
  end

  private
    def stem_word(word)
      if word.match?(/\A[\x00-\x7F]+\z/)
        STEMMER.stem(word.downcase)
      else
        word
      end
    end
end
