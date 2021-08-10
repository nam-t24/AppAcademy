require_relative 'questions_database'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'reply'

class User
    attr_reader :id
    attr_accessor :fname, :lname
    
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        users = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        return nil unless users.length > 0
        User.new(users.first)
    end

    def self.find_by_name(fname, lname)
        users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                USERS
            WHERE
                fname = ? AND lname = ?
        SQL
        return nil unless users.length > 0
        User.new(users.first)
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user(id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(id)
    end

    def average_karma
        user_id = id
        questions_and_likes = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                CAST(COUNT(DISTINCT(questions.id)) AS FLOAT) AS questionCount, SUM(CASE WHEN question_likes.id IS NULL then 0 else 1 end ) AS likeCount
            FROM
                questions
            LEFT OUTER JOIN
                question_likes ON question_likes.question_id = questions.id
            WHERE
                questions.author_id = ?
        SQL
        questions_and_likes[0]['likeCount']/questions_and_likes[0]['questionCount']
    end

    def save
        fn = fname
        ln = lname
        if (id)
            user_id = id
            QuestionsDatabase.instance.execute(<<-SQL, fn, ln, user_id) 
                UPDATE
                    users
                SET
                    fname = ?, lname = ?
                WHERE
                    users.id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, fn, ln)
            INSERT INTO
                users(fname, lname)
            VALUES
                (?, ?)
            SQL
            @id = QuestionsDatabase.last_insert_row_id
        end
    end
end
