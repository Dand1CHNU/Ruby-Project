module Dandi_program
    class << self# << стосується самого класу
        attr_accessor :web_address, :numbers, :path, :path_to_zip, :file_ext, :condition, :user #attr_accessor автоматично set і get
        
        def config
            return to_s unless block_given?
            yield self if @dandi_program.nil?
            @dandi_program ||= self
        end
        
        def user(&block)
            @user ||= User.config(&block)
        end
        
        private 

        def to_s
            str = "\nParser program config:\n"
            str += "    web address: #{@web_address}\n" if @web_address
            str += "    file path: #{@path}\n" if @path
            str += "    zip file path: #{@path_to_zip}\n" if @path_to_zip
            str += @user.config if @user
            str
        end 

    end
    
    class User 
        class << self
            attr_accessor :email, :password, :app_password
            
            def config(&block)
                return to_s unless block_given?
                
                return @user if @user
                
                yield self
                @user ||= self
                @user.freeze
            end
            
            private 
            
            def to_s
                str = "\nUser config:\n"
                str += "    email: #{@email}\n\n"
            end

        end
    end

end