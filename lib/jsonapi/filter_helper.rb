module JSONAPI
  module FilterHelper

    OPERATORS = {
      like: 'like',
      not_like: 'not like',
      gt:  '>',
      lt:  '<',
      gte: '>=',
      lte: '<='
    }

    def parse_filter_keys filters = {}
      std_filters = filters.slice!(:not, :like, :not_like, :gt, :gte, :lt, :lte)
      filters.merge!({std: std_filters})
    end

    def filter_query_string(field, value, operator = :std)
      case operator.to_sym
      when :like, :not_like
        op = OPERATORS[operator.to_sym]
        if value.is_a? Array
          value.map {|regex| "#{field} #{op} '#{regex}'"}.join(" or ")
        else
          "#{field} #{op} '#{value}'"
        end
      when :gt, :lt, :gte, :lte
        op = OPERATORS[operator.to_sym]
        val = value.is_a?(Array) ? value.first : value
        "#{field} #{op} '#{val}'"
      else
        raise 'Invalid op'
      end
    end

  end
end
