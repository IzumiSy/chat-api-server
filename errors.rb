module Error
  class InternalServerError < StandardError
    class << self
      def code
        500
      end

      def message
        "Internal Server Error"
      end
    end
  end

  class Unauthorized < StandardError
    class << self
      def code
        401
      end

      def message
        "Unauthorized"
      end
    end
  end

  class Conflict < StandardError
    class << self
      def code
        409
      end

      def message
        "Conflict"
      end
    end
  end

  class NotFound < StandardError
    class << self
      def code
        404
      end

      def message
        "Not Found"
      end
    end
  end

  class BadRequest < StandardError
    class << self
      def code
        400
      end

      def message
        "Bad Request"
      end
    end
  end
end
