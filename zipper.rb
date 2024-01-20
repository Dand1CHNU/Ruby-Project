module Dandi_program
  class Zipper
    class << self
      # Створення ZIP-архіву з вказаними файлами
      def create_archive(name_of_archive = '/data.zip', allowed_extensions = Dandi_program.file_ext)
        archive_path = "#{Dandi_program.path_to_zip}#{name_of_archive}"

        # Перевірка існування директорії для архіву
        ensure_directory_exists(Dandi_program.path_to_zip)

        # Відкриття або створення нового ZIP-файлу
        Zip::File.open(archive_path, Zip::File::CREATE) do |zipfile|
          process_entries(zipfile, allowed_extensions)
        end
      end

      private

      # Обробка файлів для додавання у ZIP-архів
      def process_entries(zipfile, allowed_extensions)
        entries = Dir.entries(Dandi_program::path) - %w[. ..]

        entries.each do |entry|
          next unless file_allowed?(entry, allowed_extensions)

          entry_path = File.join(Dandi_program::path, entry)
          
          # Заміна існуючого або додавання нового файлу
          if zipfile.find_entry(entry)
            replace_existing_file(zipfile, entry, entry_path)
          else
            add_new_file(zipfile, entry, entry_path)
          end
        end
      end

      # Перевірка, чи файл дозволений для додавання у архів
      def file_allowed?(entry, allowed_extensions)
        File.file?(File.join(Dandi_program::path, entry)) && 
          allowed_extensions.include?(File.extname(entry))
      end

      def replace_existing_file(zipfile, entry, entry_path)
        puts "Replacing existing file: #{entry}"
        zipfile.replace(entry, entry_path)
      end

      def add_new_file(zipfile, entry, entry_path)
        puts "Adding new file: #{entry}"
        zipfile.add(entry, entry_path)
      end

      # Перевірка і створення директорії, якщо вона не існує
      def ensure_directory_exists(directory_path)
        Dir.mkdir(directory_path) unless Dir.exist?(directory_path)
      end
    end
  end
end
