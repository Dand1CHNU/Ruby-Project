module Dandi_program
  class SendMail
    class << self
      # Надсилає архів як вкладення в електронному листі
      def send_archive(name_of_archive = '\data.zip')
        # Перевірка наявності файлу архіву
        archive_path = "#{Dandi_program.path_to_zip}#{name_of_archive}"
        raise "Archive file not found: #{archive_path}" unless File.exist?(archive_path)

        Pony.mail({
          :to => 'dandi.palam@gmail.com', # Змініть на реальну адресу отримувача
          :via => :smtp,
          :via_options => smtp_options,
          :subject => 'Archive with file.',
          :body => 'Attached to this letter is an archive with the file.',
          :attachments => {"#{name_of_archive}" => File.read(archive_path)}
        }) 
      rescue StandardError => e
        puts "Failed to send email: #{e.message}"
      end

      private

      # Параметри SMTP
      def smtp_options
        {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => Dandi_program::User.email, 
          :password             => Dandi_program::User.app_password,
          :authentication       => :plain, 
          :domain               => "gmail.com" 
        }
      end
    end
  end
end
