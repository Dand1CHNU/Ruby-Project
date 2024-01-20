Dandi_program.config do |dandi_program|#Dandi_program модуль
    dandi_program.web_address = 'https://geekach.com.ua/nastilni-ihry/'
    dandi_program.numbers = -1 #-1 всі елементи пропарсити
    dandi_program.path = "save_files"
    dandi_program.path_to_zip = "zip"
    dandi_program.file_ext = [".txt", ".json", ".csv", ".yaml"]
    dandi_program.condition = ->(item) { item.title.match?(/unmatched/i)}# -> лямбда функціїї-парсить тільки ті ігри які мають слово (/unmatched/i-великі і малі букви)

    dandi_program.user do |user|
        user.email = "dandi.parser@gmail.com"
        user.app_password = "vxli nvne awek numj"
        user.password = "dandi01012001"
    end
    puts dandi_program
end

