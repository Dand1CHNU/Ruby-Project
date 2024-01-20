module Dandi_program#logger зберігає всі дії які були використані на сайті в mechanize.log
  class PageLogger
    # Створюємо і налаштовуємо agent Mechanize
    def self.log_in_to_site(address, email, password)
      agent = create_agent
      page = agent.get(address)

      login_form = find_login_form(page)
      submit_login_form(login_form, email, password) if login_form

    rescue StandardError => e
      # Логування помилок у процесі авторизації
      agent.log.error "An error occurred: #{e.message}"
      nil
    end

    private

    # Ініціалізація та налаштування agent'а Mechanize
    def self.create_agent
      agent = Mechanize.new
      agent.user_agent_alias = 'Windows Edge'
      agent.log = Logger.new('mechanize.log')
      agent.log.level = Logger::INFO
      agent
    end

    # Знаходимо форму для авторизації на сторінці
    def self.find_login_form(page)
      if page.link_with(text: /\s*Вхід\s*/)
        # Пошук форми з полями email та пароль
        page.forms.find do |f| 
          f.fields.any? { |field| field.name == 'user[email]' } && 
          f.fields.any? { |field| field.name == 'user[pass]' }
        end
      else
        # Якщо посилання на вхід не знайдено
        puts "Authorization link not found."
        nil
      end
    end

    # Заповнюємо та відправляємо форму авторизації
    def self.submit_login_form(form, email, password)
      if form
        form['user[email]'] = email
        form['user[pass]'] = password
        # Відправка форми та повернення відповідної сторінки
        form.submit
      else
        # Якщо форма авторизації не знайдена
        puts "Authorization form not found."
        nil
      end
    end
  end
end
