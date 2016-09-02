class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |method_name|
      define_method("#{method_name}=") do |arg|
        instance_variable_set("@#{method_name}", arg)
      end
      define_method(method_name) { instance_variable_get("@#{method_name}") }
    end
  end
end
