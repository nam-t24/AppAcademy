require 'set'

class WordChain
    attr_reader :dictionary , :current

    def initialize(dictionary)
        words=File.read(dictionary).split
        @dictionary = Set.new(words)
    end

    def adjacent_words(current)
        #based on length
        words=Set.new(dictionary.select {|word| word.length == current.length})
        #based on letters off
        words.select! do |word|
            count=0
            (0...current.length).each do |i|
                count +=1 if current[i]!=word[i];
            end
            count<=1
        end
        words
    end

    def run(source, target)
        @current_words=[source]
        @all_seen_words={source=>nil}

        while !@current_words.empty? && !@all_seen_words.include?(target)
            self.explore_current_words
        end
        build_path(target)
    end

    def explore_current_words()
        new_current_words=[]
        @current_words.each do |word|
            adjacent_words(word).each do |adjacent_word|
                new_current_words << adjacent_word if !@all_seen_words.key? (adjacent_word)
                @all_seen_words[adjacent_word]=word if !@all_seen_words.key? (adjacent_word)
            end
        end
        @current_words=new_current_words
    end

    def build_path(target)
        path=[]
        while target != nil
            path << target
            target = @all_seen_words[target]
        end
        path.reverse
    end
end

word=WordChain.new("dictionary.txt")
p word.run("market", "guitar")