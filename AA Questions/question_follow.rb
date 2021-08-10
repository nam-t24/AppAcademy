require_relative 'questions_database'
require_relative 'user'
require_relative 'question'

class QuestionFollow
    attr_reader :id
    attr_accessor :user_id, :question_id
    
    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id['question_id']
    end

    def self.find_by_id(id)
        follows = QuestionsDatabase.instnace.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL
        return nil unless follows.length > 0
        QuestionFollow.new(follows.first)
    end

    def self.followers_for_question_id(question_id)
        users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT DISTINCT
                users.*
            FROM
                users
            JOIN
                question_follows ON users.id = question_follows.user_id
            WHERE
                question_follows.question_id = ?
        SQL
        return nil unless users.length > 0
        users.map {|user_data| User.new(user_data)}
    end

    def self.followed_questions_for_user(user_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_follows ON questions.id = question_follows.question_id
            WHERE
                question_follows.user_id = ?
        SQL
        return nil unless questions.length > 0
        questions.map{|question_data| Question.new(question_data)}
    end

    def self.most_followed_questions(n)
        questions_arr = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_follows ON questions.id = question_follows.question_id
            GROUP BY
                question_follows.question_id
            ORDER BY
                COUNT(question_follows.question_id) DESC
            LIMIT
                ?
        SQL
        questions_arr.map{|question_data| Question.new(question_data)}
    end

end