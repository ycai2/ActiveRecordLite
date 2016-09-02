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
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      unless columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
