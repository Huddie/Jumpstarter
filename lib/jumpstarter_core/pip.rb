module Jumpstarter
    class Pip
        #******************#
        #   Instructions   #
        #******************#
        class Install < I_Instructions
            def run!()
                # Check if pip is installed
                if not Jumpstarter::Pip.installed!
                    # Install PIP
                    CommandRunner.execute(
                        command: Commands::Pip::Install,
                        error: nil
                    )
                end
                # pip is installed
                CommandRunner.execute(
                    command: "pip3 install #{@package}",
                    error: nil
                )
                return true
            end
        end

        class InstallPIP < I_Instructions
            def run!()
                # install pip
                CommandRunner.execute(
                        command: Commands::Pip::Install,
                        error: nil
                )
                return true
            end
    
            def crash_on_error!()
                return false
            end
        end
        class << self
            #*****************#
            #  Class Methods  #
            #*****************#
            def installed!()
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