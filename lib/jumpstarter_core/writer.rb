require 'colorize'

module Jumpstarter
    class Writer
        class << self 
            def welcome!()
                print "\nHi there!".green
                puts " Welcome to Jumpstarter 🤘\n"
                puts "\nUnsure what this is? Read below!"
            end
            def setup_guide!()
                puts "Starting setup guide...\n".green
            end
            def newline!()
                puts"\n"
            end
            def show_success(message: nil)
                puts "#{message}".green
            end
            def show_error(message: nil)
                puts "#{message}".red
            end
            def write(message: nil)
                puts message
            end
            def file_replace(filepath, regexp, *args, &block)
                content = File.read(filepath).gsub(regexp, *args, &block)
                File.open(filepath, 'wb') { |file| file.write(content) }
            end
            def file_write(filepath, text)
                filepath.puts "#{text}"
            end
        end
    end
end