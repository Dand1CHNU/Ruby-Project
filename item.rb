module Dandi_program
  class Item

    include Comparable#імпорт з модуля

    def initialize(attributes = {})#конкструкто динамічно ствроює атрибути
      attributes.each do |k, v|
          instance_variable_set "@#{k}", v
          self.class.send(:attr_accessor, k)
      end
    end
  
    def info
      yield self if block_given?
    end
  
    def to_s#to_s перезагрузка puts
      self.instance_variables.inject("") do |result_str, attr|
        value = self.instance_variable_get "#{attr}"
        attr_key = attr[1..].capitalize
        result_str + "#{attr_key}: #{value}; "
      end
    end
    
    def to_h
      instance_variables.each_with_object({}) do |attr, result_hash|
        value = instance_variable_get "#{attr}"
        attr_key = attr.to_s[1..].to_sym
        result_hash[attr_key] = value
      end
    end

    def <=>(other_item)#повертає -1 якщо зліва більше 0 якщо рівні і 1 якщо справа
      if self.respond_to?(:title) && other_item.respond_to?(:title)
        title <=> other_item.title
      else
        raise ArgumentError, "Attribute 'title' does not exist in both objects."
      end
    end

  end
end
