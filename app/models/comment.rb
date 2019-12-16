class Comment < BaseModel
    attr_reader :id, :body, :author, :post_id, :created_at, :errors

    def initialize(attributes={})
       @id = attributes['id'] if new_record?
       @body = attributes['body']
       @author = attributes['author']
       @post_id = attributes['post_id']
       @created_at ||= attributes['created_at']
       @errors = {}
    end

    def self.all
      comment_row_hashes = connection.execute('SELECT * FROM comments')
      comment_row_hashes.map do |comment_row_hash|
        Comment.new(comment_row_hash)
      end
    end

    def post
      Post.find(post_id)
    end

    def valid?
      @errors['body'] = "can't be blank" if body.blank?
      @errors['author'] = "can't be blank" if author.blank?
      @errors.empty?
    end
  
    def insert
      insert_comment_query = <<-SQL
        INSERT INTO comments (body, author, post_id, created_at)
        VALUES (?, ?, ?, ?)
      SQL
  
      connection.execute insert_comment_query,
        @body,
        @author,
        @post_id,
        Date.current.to_s
    end

end