module Jumpstarter
    class Git
        #******************#
        #   Instructions   #
        #******************#
        class Install < Jumpstarter::I_Instructions
            def run!()
                # install pip
                CommandRunner.execute(
                        command: Commands::Git::Install,
                        error: nil
                )
                return true
            end
        end

        class Fork < I_Instructions
            def run!()
                # Check if git is installed
                if not Jumpstarter::Git.installed!
                    # Install git
                    CommandRunner.execute(
                        command: Commands::Git::Install,
                        error: nil
                    )
                end
                # clone
                CommandRunner.execute(
                    command: "curl -u #{@username}:#{@password} https://api.github.com/repos/#{@remote}/forks -d ''",
                    error: nil
                )
                return true
            end
        end

        class Pull < I_Instructions
            def run!()
                # Check if git is installed
                if not Jumpstarter::Git.installed!
                    # Install git
                    CommandRunner.execute(
                        command: Commands::Git::Install,
                        error: nil
                    )
                end
                # clone
                CommandRunner.execute(
                    command: "git pull #{@remote} #{@branch}",
                    error: nil
                )
                return true
            end
        end

        class Clone < I_Instructions
            def run!()
                # Check if git is installed
                if not Jumpstarter::Git.installed!
                    # Install git
                    CommandRunner.execute(
                        command: Commands::Git::Install,
                        error: nil
                    )
                end
                # clone
                CommandRunner.execute(
                    command: "git clone https://github.com/#{@username}/#{@remote}.git",
                    error: nil
                )
                return true
            end
        end
        class << self
            #*****************#
            #  Class Methods  #
            #*****************#
            def installed!()
                # Run version
                version = CommandRunner.execute(
                    command: Commands::Git::Version, 
                    error: nil
                )
                return (/git version (\d+)(.\d+)?(.\d+)?/ =~ version) 
            end

            def required_imports
                ['instructions', 'writer.rb', 'commandRunner.rb']
            end
        end
    end
end