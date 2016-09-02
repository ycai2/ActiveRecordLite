require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map(&:to_sym)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

  end

  def self.finalize!
    columns.each do |method_name|
      define_method("#{method_name}=") do |arg|
        attributes[method_name] = arg
      end
      define_method(method_name) { attributes[method_name] }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ? @table_name : self.name.downcase.tableize
  end

  def self.all
    data = DBConnection.execute2(<<-SQL).drop(1)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    parse_all(data)
  end

  def self.parse_all(results)
    objects = []
    results.each do |row|
      objects << new(row)
    end
    objects
  end

  def self.find(id)
    obj = DBConnection.execute2(<<-SQL, id).drop(1)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL
    parse_all(obj).first
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
      send("#{attr_name}=", val)

    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end

  def insert
    cols = self.class.columns.drop(1)
    col_names = cols.join(", ")
    question_marks = (["?"] * cols.count).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns.drop(1)

    set_clause = cols.map { |name| name.to_s << " = ?" }.join(", ")
    attrs = attribute_values.drop(1)

    DBConnection.execute(<<-SQL, *attrs, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_clause}
      WHERE
        id = ?
    SQL
  end

  def save
    if attributes.include?(:id)
      update
    else
      insert
    end
  end
end
