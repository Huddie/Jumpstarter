module Jumpstarter
    class Bash
        #******************#
        #   Instructions   #
        #******************#
        class Run < I_Instructions
            def run!()
                system(@cmd)
                return true
            end
        end

        class CD < I_Instructions
            def run!()
                Dir.chdir "#{@path}"
                return true
            end
        end
        class << self
            #*****************#
            #  Class Methods  #
            #*****************#
            def self.installed!()
                # Run version
                version = CommandRunner.execute(
                    command: Commands::Pip::Version, 
                    error: nil
                )
                return (/pip (\d+)(.\d+)?(.\d+)?/ =~ version) 
            end
                    
            def required_imports
                ['instructions', 'writer.rb', 'commandRunner.rb']
            end
        end
    end
end