require_relative 'questions_database'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'user'
require_relative 'reply'
# require_relative 'model_base'

class Question
    attr_reader :id
    attr_accessor :title, :body, :author_id
    
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def self.find_by_id(id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil unless questions.length > 0
        Question.new(questions.first)
    end

    def self.find_by_author_id(author_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL

        questions.map {|question_data| Question.new(question_data)}
    end

    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        QuestionFollow.followers_for_question_id(id)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

    def likers
        QuestionLike.likers_for_question_id(id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(id)
    end

    def self.most_liked(n)
        QuestionLike.most_liked_questions(n)
    end

    def save
        title = @title
        body = @body
        author_id = @author_id
        if(id)
            question_id = id
            QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id, question_id)
                UPDATE
                    questions
                SET
                    title = ?, body = ?, author_id = ?
                WHERE
                    questions.id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
                INSERT INTO
                    questions(title, body, author_id)
                VALUES
                    (?,?,?)
            SQL
            @id = QuestionsDatabase.last_insert_row_id
        end
    end
end