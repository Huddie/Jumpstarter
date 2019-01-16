require_relative './instructions'
require_relative './parser'
require 'terminal-table'

module Jumpstarter
    FILE = 'Starter'
    class Setup
        class << self 

            ## HELPER METHOD
            def options(ops)
                rows = []
                c = 0
                ops.each do |v|
                    rows << [v, c]
                    c = c + 1
                end
                return Terminal::Table.new :rows => rows
            end

            def find!()
                ## Find path to Starter file
                file_path = ""
                path = Dir.glob("./**/#{Jumpstarter::FILE}")
                if path.length == 1
                    puts "Found Setup file at #{path[0]}"
                    file_path = path[0]
                else
                    puts "We found multiple Starter files in this directory tree"
                    puts "Please select the one you want to use by typing the number that corrisponds to that file below"
                    puts options(path)
                    puts "Choose file #"
                    num = (STDIN.gets.chomp).to_i
                    file_path = path[num]
                end
                return file_path
            end
            def setup!()
                proccess_file(Setup.find!)
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
                rel_files = [
                    "instructions.rb", 
                    "commands.rb", 
                    "commandRunner.rb",
                    "OS.rb", 
                    "xcode_helper.rb", 
                    "Writer.rb", 
                    "git.rb", 
                    "bash.rb", 
                    "xcode.rb", 
                    "pip.rb"
                ]
                rel_files.each do |f|
                    File.open(__dir__ + "/#{f}", "r") do |f|
                        f.each_line do |line|
                            text = "#{text}#{line}"
                        end
                    end
                    text = "#{text}\n"
                end

                return text
            end 
            def proccess_file(path)
                puts "Processing file #{path}"
                cmd_file = fill_with_inst!
                File.open(path, "r") do |f|
                    f.each_line do |line|
                        inst = parse_into_inst(line)
                        cmd_file = "#{cmd_file}\n#{inst}"
                    end
                end
                # Setup.eval_file(cmd_file)
                File.open("Starter.rb", 'w') { |file| file.write(cmd_file) }
                system("ruby Starter.rb")
                # File.delete("Starter.rb")
            end
            def eval_file(file_text)
                eval(cmd_file)
            end
        end
    end
end