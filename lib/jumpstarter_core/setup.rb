require_relative './instructions'
require 'terminal-table'

module Jumpstarter
    class Setup
        class << self 

            FILE = 'Starter'

            def options(ops)
                rows = []
                c = 1
                ops.each do |v|
                    rows << [v, c]
                    c = c + 1
                end
                return Terminal::Table.new :rows => rows
            end

            def setup!()
                ## Find path to maintainfile
                path = Dir.glob("./**/#{FILE}")
                if path.length == 1
                    puts "Found Setup file at #{path[0]}"
                    proccess_file(path[0])
                end

                puts "We found multiple Starter files in this directory tree"
                puts "Please select the one you want to use by typing the number that corrisponds to that file below"
                puts options(path)
                puts "Choose file #"
                num = (STDIN.gets.chomp).to_i
                
                proccess_file(path[num])
            end

            def parse_into_inst(line)
                return Jumpstarter::InstructionParser.parse(line)
            end

            def process_instruction(inst)
                puts "[Next Instruction]"
                result = inst.run!
                return result
            end

            def fill_with_inst!()
                text = ""
                File.open(__dir__ + '/instructions.rb', "r") do |f|
                    f.each_line do |line|
                        text = "#{text}#{line}"
                    end
                end
                text = "#{text}\n"
                File.open(__dir__ + '/commands.rb', "r") do |f|
                    f.each_line do |line|
                        text = "#{text}#{line}"
                    end
                end
                text = "#{text}\n"
                File.open(__dir__ + '/commandRunner.rb', "r") do |f|
                    f.each_line do |line|
                        text = "#{text}#{line}"
                    end
                end
                text = "#{text}\n"
                File.open(__dir__ + '/OS.rb', "r") do |f|
                    f.each_line do |line|
                        text = "#{text}#{line}"
                    end
                end
                return text
            end 
            def proccess_file(path)
                cmd_file = fill_with_inst!
                File.open(path, "r") do |f|
                    f.each_line do |line|
                        inst = parse_into_inst(line)
                        cmd_file = "#{cmd_file}\n#{inst}"
                    end
                end
                eval(cmd_file)
                # File.open("Starter.rb", 'w') { |file| file.write(cmd_file) }
                # system("ruby Starter.rb")
                # File.delete("Starter.rb")
            end
        end
    end
end