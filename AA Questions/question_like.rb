require_relative 'questions_database'
require_relative 'user'
require_relative 'question'

class QuestionLike
    attr_reader :id
    attr_accessor :user_id, :question_id

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id['question_id']
    end

    def self.find_by_id(id)
        likes = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL
        return nil unless likes.length > 0
        QuestionLike.new(likes.first)
    end

    def self.likers_for_question_id(question_id)
        users= QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                users.*
            FROM
                users
            JOIN
                question_likes ON question_likes.user_id = users.id
            WHERE
                question_likes.question_id = ?
        SQL
        return nil unless users.length>0
        users.map{|user_data| User.new(user_data)}
    end

    def self.num_likes_for_question_id(question_id)
        arr = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                COUNT(*) AS count
            FROM
                question_likes
            WHERE
                question_likes.question_id = ?
        SQL
        #arr is an array with count hash
        arr[0]['count']
    end

    def self.liked_questions_for_user_id(user_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes ON question_likes.question_id = questions.id
            WHERE
                question_likes.user_id = ?
        SQL
        return nil unless questions.length > 0
        questions.map{|question_data| Question.new(question_data)}
    end

    def self.most_liked_questions(n)
        questions = QuestionsDatabase.instance.execute(<<-SQL, n)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes ON question_likes.question_id = questions.id
            GROUP BY
                question_likes.question_id
            ORDER BY
                count(question_likes.question_id) DESC
            LIMIT
                ?
        SQL
        questions.map{|question_data| Question.new(question_data)}
    end
end