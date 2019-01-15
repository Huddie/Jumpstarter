require_relative './commandRunner'
require_relative './commands'
require 'io/console'
require 'nokogiri'

module Jumpstarter

    class I_Instructions

        def initialize(msg_success, msg_error, should_crash)
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
        end

        def run!()
            return true
        end

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Success]"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error]"
            end
            return "#{@msg_error}"
        end

    end

    class PIPInstall < I_Instructions

        def initialize(pkg, msg_success, msg_error, should_crash)
            @package = pkg
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
        end

        def run!()
            # Check if pip is installed
            if not InstallPIP.installed!
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

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Installed] #{@package}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error] #{@package}"
            end
            return "#{@msg_error}"
        end
    end

    
    class InstallPIP < I_Instructions

        def self.installed!()

            # Run version
            version = CommandRunner.execute(
                command: Commands::Pip::Version, 
                error: nil
            )
            return (/pip (\d+)(.\d+)?(.\d+)?/ =~ version) 
        end

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

    class InstallGIT < I_Instructions

        def self.installed!()

            # Run version
            version = CommandRunner.execute(
                command: Commands::Git::Version, 
                error: nil
            )
            return (/git version (\d+)(.\d+)?(.\d+)?/ =~ version) 
        end

        def run!()
            # install pip
            CommandRunner.execute(
                    command: Commands::Git::Install,
                    error: nil
            )
            return true
        end

        def crash_on_error!()
            return false
        end
    end

    class GITFork < I_Instructions

        def initialize(remote, username, password, msg_success, msg_error, should_crash)
            @remote = remote
            @username = username
            @password = password
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
        end

        def run!()
            # Check if git is installed
            if not InstallGIT.installed!
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

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully forked] #{@remote}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error] #{@remote}"
            end
            return "#{@msg_error}"
        end
    end

    class GITPull < I_Instructions

        def initialize(remote, branch, msg_success, msg_error, should_crash)
            @remote = remote
            @branch = branch
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
        end

        def run!()
            # Check if git is installed
            if not InstallGIT.installed!
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

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully pulled] #{@remote}/#{@branch}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error] #{@remote}"
            end
            return "#{@msg_error}"
        end
    end

    class GITClone < I_Instructions

        def initialize(remote, username, msg_success, msg_error, should_crash)
            @remote = remote
            @username = username
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
        end

        def run!()
            # Check if git is installed
            if not InstallGIT.installed!
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

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully pulled] #{@username}/#{@remote}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error] #{@username}/#{@remote}"
            end
            return "#{@msg_error}"
        end
    end

    class BashRun < I_Instructions

        def initialize(path, msg_success, msg_error, should_crash)
            @path = path
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
        end

        def run!()
            CommandRunner.execute(
                command: "bash #{@path}",
                error: nil
            )
            return true
        end

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully Exec] #{@path}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error exec] #{@path}"
            end
            return "#{@msg_error}"
        end
    end

    class CDInst < I_Instructions

        def initialize(path, msg_success, msg_error, should_crash)
            @path = path
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
        end

        def run!()
            Dir.chdir "#{@path}"
            return true
        end

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully moved to] #{@path}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error moving to] #{@path}"
            end
            return "#{@msg_error}"
        end
    end

    #############################
    ###  xcode instructions   ###
    #############################
    class XcodeDuplicateScheme < I_Instructions

        def initialize(proj_path, scheme_name, msg_success, msg_error, should_crash)
            @proj_path = proj_path
            @scheme_name = scheme_name
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
            @original_dir = Dir.pwd
        end

        def run!()
            Dir.chdir "#{@proj_path}"
            scheme_file_path = Dir.glob("./**/#{@scheme_name}".xcscheme)
            dir_of_scheme = File.dirname(scheme_file_path)
            File.rename(scheme_file_path, dir_of_scheme + File::SEPARATOR + "Copy of " + scheme_file_path)
            return true
        end

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully duplicated scheme] #{@scheme_name}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Failed to duplicate scheme] #{@scheme_name}"
            end
            return "#{@msg_error}"
        end
    end

    class XcodeAddPairToScheme < I_Instructions

        def initialize(proj_path, scheme_name, order_hint, msg_success, msg_error, should_crash)
            @proj_path = proj_path
            @scheme_name = scheme_name
            @msg_success = msg_success
            @msg_error = msg_error
            @should_crash = should_crash
            @original_dir = Dir.pwd
            @order_hont = order_hint
        end

        def run!()
            Dir.chdir "#{@proj_path}"
            scheme_file_path = Dir.glob("./**/#{@scheme_name}.xcscheme")
            dir_of_scheme = File.dirname(scheme_file_path)
            File.rename(scheme_file_path, dir_of_scheme + File::SEPARATOR + "Copy of " + scheme_file_path)
            Dir.chdir "#{@original_dir.chdir}"
            managment_file_path = Dir.glob("./**/xcschememanagement.plist")
            file = File.read(managment_file_path)
            xml = Nokogiri::XML(file)
            scheme_state = xml.at('SchemeUserState')
            node = "<key>Copy of #{@scheme_name}.xcscheme</key>
                    <dict>
                        <key>orderHint</key>
                        <integer>3</integer>
                    </dict>"
            scheme_state.add_child(Nokogiri::XML::Node.new(node, xml))
            puts xml
            return true
        end

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully duplicated scheme] #{@scheme_name}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Failed to duplicate scheme] #{@scheme_name}"
            end
            return "#{@msg_error}"
        end
    end

    class InstructionParser
        class << self
            def parse(line)
                inst_elm = line.split
                cmd = inst_elm[0]
                case cmd
                when "pip"
                    package = inst_elm[1]
                    msg_success = inst_elm[2] if inst_elm[2]
                    msg_error =  inst_elm[3] if inst_elm[3]
                    should_crash = inst_elm[4] == "true" if inst_elm[4]
                    return PIPInstall.new(
                        package, 
                        msg_success, 
                        msg_error, 
                        should_crash
                    )
                when "git"
                    subcmd = inst_elm[1]
                    remote = inst_elm[2]
                    branch = inst_elm[3] if inst_elm[3]
                    case subcmd
                    when "fork"
                        puts "github username: "
                        username = STDIN.gets.chomp
                        password = STDIN.getpass("Password: ")
                        return GITFork.new(
                            remote, 
                            username, 
                            password, 
                            msg_success, 
                            msg_error, 
                            should_crash
                        )
                    when "pull"
                        return GITPull.new(
                            remote, 
                            branch, 
                            msg_success, 
                            msg_error, 
                            should_crash
                        )
                    when "clone"
                        puts "github username: "
                        username = STDIN.gets.chomp
                        return GITClone.new(
                            remote, 
                            username, 
                            msg_success, 
                            msg_error, 
                            should_crash
                        )
                    else
                    end
                when "bash"
                    subcmd = inst_elm[1]
                    path = inst_elm[2]
                    case subcmd
                    when "run"
                        return BashRun.new(
                            path, 
                            msg_success, 
                            msg_error, 
                            should_crash
                        )
                    else
                    end
                when "cd"
                    path = inst_elm[1]
                    return CDInst.new(
                        path, 
                        msg_success, 
                        msg_error, 
                        should_crash
                    )
                when "xcode"
                    subcmd = inst_elm[1]
                    proj_path   = inst_elm[2]
                    scheme_name = inst_elm[3]
                    case subcmd
                    when "duplicate-scheme"
                        return GITPull.new(
                            proj_path, 
                            scheme_name, 
                        )
                    when "edit-scheme"
                        order_hint = inst_elm[4]
                        return XcodeAddPairToScheme.new(
                            proj_path, 
                            scheme_name, 
                            order_hint,
                        )
                    else
                    end
                else
                    puts "The command #{cmd} is not supported"
                end
            end
        end
    end
end