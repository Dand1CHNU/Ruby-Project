module Dandi_program
  class MainApplication
    class << self
      def run(address: Parser_program.web_address, condition:nil)#Dandi_program.condition
        items = Parser.parse_items(address: address, condition: condition)

        #puts items[1] <=> items[2]
        #cart.show_all_items_by_title
        items
      end
    end 
  end
end