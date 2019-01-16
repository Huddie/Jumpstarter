module Jumpstarter
    class Commands
        class Pip
            class Install
                class << self 
                    def requires_sudo!()
                        return true
                    end
                    def command!()
                        if OS.isLinix?
                            return ['apt install python3-pip']
                        elsif OS.isMac?
                            return ['brew install python', 'brew unlink python && brew link python']
                        elsif OS.isWindows?
                            puts "Windows is not currently supported"
                        end
                    end
                end
            end
            class Uninstall
                class << self 
                    def dependencies()

                    end
                    def requires_sudo!()
                        return true
                    end
                    def command!()
                        return ['gem uninstall cocoapods']
                    end
                end
            end
            class Version
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['pip3 --version']
                    end
                end
            end
            class Update
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['pip3 update']
                    end
                end
            end
        end

        class Cocoapods
            class Install
                class << self 
                    def requires_sudo!()
                        return true
                    end
                    def command!()
                        return ['gem install cocoapods']
                    end
                end
            end
            class Uninstall
                class << self 
                    def requires_sudo!()
                        return true
                    end
                    def command!()
                        return ['gem uninstall cocoapods']
                    end
                end
            end
            class Version
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['pod --version']
                    end
                end
            end
            class Init
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['pod init']
                    end
                end
            end
            class Update
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['pod update']
                    end
                end
            end
        end

        class Git
            class Install
                class << self 
                    def requires_sudo!()
                        return true
                    end
                    def command!()
                        if OS.isLinix?
                            return ['sudo apt update', 'sudo apt install git']
                        elsif OS.isMac?
                            return ['git --version']
                        elsif OS.isWindows?
                            puts "Windows is not currently supported"
                        end
                    end
                end
            end
            class Version
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['git --version']
                    end
                end
            end
            class Init
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['git init']
                    end
                end
            end
            class Update
                class << self 
                    def requires_sudo!()
                        return false
                    end
                    def command!()
                        return ['sudo apt install git']
                    end
                end
            end
        end
    end
end