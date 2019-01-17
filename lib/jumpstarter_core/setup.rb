require_relative './instructions'
require_relative './parser'
require 'terminal-table'

module Jumpstarter
    FILE = 'Starter'
    GEM_LOCK_FILE = 'Gemfile.lock'
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

            def setup!()
                plugin_paths = self.find_plugins!
                parser = Jumpstarter::InstructionParser.new(plugin_paths)
                proccess_file(parser, Setup.find!)
            end

            def find_plugins!()
                # Read Gemfile.lock, finding modules with jumpstarter-plugin-api
                # dep
                outp = `gem dependency jumpstarter-plugin-api -R`
                start_cap = false
                dep = []
                outp.each_line do |line|
                    if start_cap
                        dep << outp.split().first
                    end
                    if line.include? "Used by"
                        start_cap = true
                    end
                end
                plugin_paths = []
                dep.each do |d|
                   outp = `gem which #{d}`
                   outp = outp.chomp(outp.split('-').last)
                   plugin_paths << outp
                end
                return plugin_paths
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
            def proccess_file(parser, path)
                puts "Processing file #{path}"
                cmd_file = fill_with_inst!
                File.open(path, "r") do |f|
                    f.each_line do |line|
                        inst = parser.parse(line)
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