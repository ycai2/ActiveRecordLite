require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_clause = []
    params.keys.each do |k|
      where_clause << "#{k.to_s} = ?"
    end
    where_line = where_clause.join(" AND ")

    result = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    parse_all(result)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
