module ItemContainer
  def self.included(base)
    base.extend ClassMethods #extend підключення для класу
    base.include InstanceMethods
  end

  module ClassMethods
        # Класові методи (якщо вони потрібні)
  end

  module InstanceMethods
    include Enumerable

    def each 
      return unless block_given?
      @items.each { |item| yield item }
    end
    
    def add_item(item)
      @items << item
    end

    def add_items(items)
      items.each do |item|
        @items << item
        item.info do |item|
          puts "Object '#{item.to_s}' added to file"
        end
      end
    end

    def remove_item(item)
      @items.delete(item)
    end

    def delete_items
      @items.clear
    end

    def to_s
      puts @items
    end

    def total_items
      @items.size
    end

    def to_h
      { items: @items.map(&:to_h), total_items: total_items }
    end

    def method_missing(method_name, *args, &block)
      if method_name == :show_all_items
        puts "Showing all items:"
        each { |item| puts item }
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name == :show_all_items || super
    end
  end 
end 
