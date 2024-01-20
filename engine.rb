module Dandi_program
  class Engine
    def run
      cart = Cart.new

      # Створення потоків для паралельного виконання завдань
      threads = create_threads(cart)

      # Логування активних потоків
      log_active_threads

      # Зачекайте завершення всіх потоків та обробіть винятки
      handle_thread_completion(threads)

      # Збереження даних у різних форматах
      save_data_in_formats(cart)

      # Створення архіву
      Dandi_program::Zipper.create_archive()
      Dandi_program::SendMail.send_archive()
    end

    private

    def create_threads(cart)#Парсяться сторінки які вказані в цьому діапазоні 1-3
      (1..2).map do |i|
        Thread.new do
          thread_name = "Thread#{i}"
          Thread.current[:name] = thread_name
          puts "=> #{thread_name} has been created"
          
          items = Dandi_program::MainApplication.run(address: "#{Dandi_program.web_address}filter/page=#{i+1}/")# :: звертання до кконкретних класів, модулів в собі
          cart.add_items(items)
        end
      end
    end

    def log_active_threads
      puts "=> Start main thread"
      Thread.list.each { |t| puts "=> Active Thread: #{t.inspect}" }
    end

    def handle_thread_completion(threads)
      begin
        threads.map(&:join)
      rescue => ex
        puts "=> Exception in Thread: #{ex.inspect}"
      ensure#це точно виконинеться
        threads.each { |t| puts "=> #{t[:name]} - finished" }
        puts "=> The main thread is complete"
      end
    end

    def save_data_in_formats(cart)
      Dandi_program.file_ext.each do |format|
        case format
        when ".txt"
          cart.save_to_file
        when ".csv"
          cart.save_to_csv
        when ".json"
          cart.save_to_json
        when ".yaml"
          cart.save_to_yaml
        else
          puts "=> Invalid format: #{format}"
        end
      end
    end
  end
end
