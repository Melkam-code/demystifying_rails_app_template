class BaseModel
    attr_reader :errors

    def self.table_name
        to_s.pluralize.downcase
    end
    
      def self.all
        # use it in our SQL
        record_hashes = connection.execute("SELECT * FROM #{table_name}")
        record_hashes.map do |record_hash|
          new record_hash
        end
      end
  
    def new_record?
      @id.blank?
    end
  
    def save
      return false unless valid?
      if new_record?
        insert
      else
        update
      end
      true
    end
  
    def self.connection
      db_connection = SQLite3::Database.new 'db/development.sqlite3'
      db_connection.results_as_hash = true
      db_connection
    end
  
    def connection
      self.class.connection
    end
  end