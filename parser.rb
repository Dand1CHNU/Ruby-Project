module Dandi_program
  class Parser 
    # Парсинг елементів з веб-сторінки
    def self.parse_items(address: "https://geekach.com.ua/nastilni-ihry/", condition: nil)
      page = Dandi_program::PageLogger.log_in_to_site(address, Dandi_program::User.email, Dandi_program::User.password)
      doc = Nokogiri::HTML(page.body)
      rows = doc.css("div.catalog__content li.catalog-grid__item")

      items = if Dandi_program.numbers == -1 #-1 викачуються всі елементи
                rows.map { |row| Item.new(parse_row(row)) }
              else
                rows.take(Dandi_program.numbers).map { |row| Item.new(parse_row(row)) }
              end

      items.select! { |item| condition.call(item) } if condition
      items
    end

    private

    # Парсинг окремого рядка
    def self.parse_row(row)
      article = row.css("div.catalogCard-code").text.strip[/Артикул:\s*(\w+)/, 1]
      title = row.css("div.catalogCard-title").text.strip
      price = row.css("div.catalogCard-price").text.strip
      avaible = row.css("div.catalogCard-availability").text.strip
      comments = row.css("div.catalogCard-comments").text.strip

      {article: article, title: title, price: price, avaible: avaible, comments: comments,}
    end
  end
end

