require_relative './instructions'

module Jumpstarter
    class Setup
        class << self 

            FILE = 'Starter'

            def setup!()
                ## Find path to maintainfile
                path = Dir.glob("./**/#{FILE}")
                if path.length == 1
                    puts "Found Setup file at #{path[0]}"
                    proccess_file(path[0])
                end
            end

            def parse_into_inst(line)
                return Jumpstarter::InstructionParser.parse(line)
            end

            def process_instruction(inst)
                puts "[Next Instruction]"
                result = inst.run!
                return result
            end
            def proccess_file(path)
                File.open(path, "r") do |f|
                    f.each_line do |line|
                        inst = parse_into_inst(line)
                        result = process_instruction(inst)
                        if result
                            # Success
                            puts "#{inst.success_message!}"
                        else
                            # Error
                            puts "#{inst.error_message!}"
                            if inst.crash_on_error!
                                # CRASH
                            end
                        end
                    end
                end
            end
        end
    end
end