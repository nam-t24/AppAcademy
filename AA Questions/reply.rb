require_relative 'questions_database'
require_relative 'question'
require_relative 'user'

class Reply
    attr_reader :id
    attr_accessor :question_id, :parent_reply_id, :author_id, :body
    
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
        @body = options['body']
    end

    def self.find_by_id(id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil unless replies.length >0
        Reply.new(replies.first)
    end

    def self.find_by_user_id(user_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                author_id = ?
        SQL

        replies.map {|reply_data| Reply.new(reply_data)}
    end

    def self.find_by_question_id(question_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        replies.map{|reply_data| Reply.new(reply_data)}
    end

    def author
        User.find_by_id(author_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_reply_id)
    end

    def child_replies
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        return nil unless replies.length > 0
        replies.map {|reply_data| Reply.new(reply_data)}
    end

    def save
        question_id = @question_id
        parent_reply_id = @parent_reply_id
        author_id = @author_id
        body = @body
        if(@id)
            id = @id
            QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_reply_id, author_id, body, id)
                UPDATE
                    replies
                SET
                    question_id = ?, parent_reply_id = ?, author_id = ?, body = ?
                WHERE
                    replies.id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_reply_id, author_id, body)
                INSERT INTO
                    replies
                VALUES
                    (?,?,?,?)
            SQL
            @id = QuestionsDatabase.last_insert_row_id
        end
    end
end