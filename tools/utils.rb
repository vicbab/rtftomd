module Utils
    def generate_code(number)
        charset = Array('A'..'Z') + Array('a'..'z')
        Array.new(number) { charset.sample }.join
    end

    module_function :generate_code
end