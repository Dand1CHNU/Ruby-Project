module Dandi_program
  class Cart
    include ItemContainer 

    def initialize
      @items = []
    end
  
    def save_to_file(number:'')
      return if empty_cart?
      File.open(file_path("data#{number}.txt"), "w") do |file|
        file.puts "Cart contents:"
        file.puts "-" * 80
        file.puts @items
        file.puts "-" * 80
        file.puts "Total items: #{total_items}"
      end
    end
  
    def save_to_json(number:'')
      return if empty_cart?
      File.open(file_path("data#{number}.json"), "w") do |file|
        file.puts JSON.pretty_generate(to_h)
      end
    end
  
    def save_to_csv(number:'')
      return if empty_cart?
      attributes = @items.first.to_h.keys
      CSV.open(file_path("data#{number}.csv"), "w") do |csv|
        csv << attributes
        @items.each do |item|
          csv << item.to_h.values
        end
      end
    end

    def save_to_yaml(number:'')
      return if empty_cart?
      File.open(file_path("data#{number}.yaml"), "w") do |file|
        file.puts YAML.dump(to_h)
      end
    end

    private

    def empty_cart?
      @items.empty?
    end

    def file_path(filename)
      "#{Dandi_program.path}/#{filename}"
    end
  end  
end
