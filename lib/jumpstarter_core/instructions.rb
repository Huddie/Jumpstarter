require 'io/console'
require 'xcodeproj'
require 'plist'
require 'terminal-table'

module Jumpstarter

    DEFAULTS = {
        msg_success: 'Success',
        msg_error:  'Error',
        should_crash: false,
    }

    def true?(obj)
        obj.to_s == "true"
    end

    class I_Instructions

        def initialize(opts = {})
            @dec = nil
            options = DEFAULTS.merge(opts)
            options.each do |k, v|
                v = self.clean_value(v)
                @dec = "#{@dec}\n#{k}: #{v},"
                instance_variable_set("@#{k}", v)
                self.class.send(:attr_reader, k)
            end
        end

        def run!()
            return true
        end

        def crash_on_error!()
            return @should_crash
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

        def clean_value(arg)
            
            if arg == nil
                return "''"
            end

            if  !!arg == arg or (not "#{arg}".match(" "))
                return arg
            end
            
            return "'#{arg}'"
        end

        def to_s!()
            str = "#{self.class}.new(#{@dec.chomp(',')}).run!"
            return str
        end

        def options(ops)
            rows = []
            c = 0
            ops.each do |v|
                rows << [v, c]
                c = c + 1
            end
            return Terminal::Table.new :rows => rows
        end

    end

    class PIPInstall < I_Instructions

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

    end

    class GITFork < I_Instructions

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

        def run!()
            system(@cmd)
            return true
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Success] #{@cmd}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Error] #{@cmd}"
            end
            return "#{@msg_error}"
        end
    end

    #############################
    ###  xcode instructions   ###
    #############################
    class XcodeCreateScheme < I_Instructions

        def run!()
            new_scheme = Xcodeproj::XCScheme.new()
            new_scheme.save_as(@proj_path, @scheme_name, @shared)
            return true
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

    class XcodeDuplicateScheme < I_Instructions

        def run!()
            existing_scheme_path = @original_shared ? Xcodeproj::XCScheme.shared_data_dir(@proj_path) : Xcodeproj::XCScheme.user_data_dir(@proj_path)
            existing_scheme = "#{existing_scheme_path}/#{@original_scheme_name}.xcscheme"
            new_scheme = Xcodeproj::XCScheme.new(existing_scheme)
            new_scheme.save_as(@proj_path, @new_scheme_name, @new_shared)
            return true
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

    class XcodeEditSchemeEnvVars < I_Instructions

        def run!()
            existing_scheme_path = @shared ? Xcodeproj::XCScheme.shared_data_dir(@proj_path) : Xcodeproj::XCScheme.user_data_dir(@proj_path)
            existing_scheme = "#{existing_scheme_path}/#{@scheme_name}.xcscheme"
            scheme = Xcodeproj::XCScheme.new(existing_scheme)
            environment_variables = scheme.launch_action.environment_variables
            environment_variables.assign_variable(:key => @key, :value => @value) 
            scheme.launch_action.environment_variables = environment_variables
            scheme.save!
            return true
        end

        def crash_on_error!()
            return false
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully edited scheme] #{@scheme_name}"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Failed to edit scheme] #{@scheme_name}"
            end
            return "#{@msg_error}"
        end
    end

    class XcodeEditTargetBundleID < I_Instructions

        def run!()
            project = Xcodeproj::Project.open(@proj_path)

            unless project.root_object.attributes["TargetAttributes"]
                puts "Your file format is old, please update and try again"
            return false
            end
    
            target_dictionary = project.targets.map { |f| { name: f.name, uuid: f.uuid, build_configuration_list: f.build_configuration_list } }
            changed_targets = []
            project.root_object.attributes["TargetAttributes"].each do |target, sett|
                found_target = target_dictionary.detect { |h| h[:uuid] == target }
                style_value = @code_sign_style == "manual" ? 'Manual' : 'Automatic'
                build_configuration_list = found_target[:build_configuration_list]
                build_configuration_list.set_setting("CODE_SIGN_STYLE", style_value)
                sett["ProvisioningStyle"] = style_value
        
                if not @team_id.empty?
                    sett["DevelopmentTeam"] = @team_id
                    build_configuration_list.set_setting("DEVELOPMENT_TEAM",  @team_id)
                else 
                    teams = Jumpstarter::XCHelper.teams!
                    puts "Provisioning Profile"
                    puts options(teams)
                    print "Please select the team for #{found_target[:name]}: "
                    num = (STDIN.gets.chomp).to_i
                    team = teams[num]
                    build_configuration_list.set_setting("DEVELOPMENT_TEAM",  team)
                end
                if @code_siging_identity
                    build_configuration_list.set_setting("CODE_SIGN_IDENTITY", @code_siging_identity)
                end
                if @bundle_id
                    build_configuration_list.set_setting("PRODUCT_BUNDLE_IDENTIFIER", @bundle_id)
                end
                changed_targets << found_target[:name]
            end
            project.save
    
            changed_targets.each do |target|
                puts "Updated Target: #{target}"
            end

            return true
        end

        def success_message!()
            if not @msg_success or @msg_success.empty?
                return "[Successfully edited bundle]"
            end
            return "#{@msg_success}"
        end

        def error_message!()
            if  not @msg_error or @msg_error.empty?
                return "[Failed to edit bundle]"
            end
            return "#{@msg_error}"
        end
    end

    class InstructionParser
        class << self
            def get_args(line)
                return Hash[line.scan(/--?([^=\s]+)(?:=(\"[^\"]+\"|\S+))?/)]
            end
            def parse(line)
                inst_elm = line.split
                cmd = inst_elm[0]
                args = InstructionParser.get_args(line)
                puts args
                msg_success = args["msg_success"]
                msg_error = args["msg_error"]
                should_crash = args["should_crash"]
                case cmd
                when "pip"
                    package = inst_elm[1]
                    return PIPInstall.new(
                        package: package, 
                        msg_success: msg_success, 
                        msg_error: msg_error, 
                        should_crash: should_crash
                    ).to_s!
                when "git"
                    subcmd = inst_elm[1]
                    remote = inst_elm[2] 
                    branch = inst_elm[3] if inst_elm[3]
                    case subcmd
                    when "fork"
                        print "github username: "
                        username = STDIN.gets.chomp
                        password = STDIN.getpass("Password: ")
                        return GITFork.new(
                            remote: remote, 
                            username: username, 
                            password: password, 
                            msg_success: msg_success, 
                            msg_error: msg_error, 
                            should_crash: should_crash
                        ).to_s!
                    when "pull"
                        return GITPull.new(
                            remote: remote, 
                            branch: branch, 
                            msg_success: msg_success, 
                            msg_error: msg_error, 
                            should_crash: should_crash
                        ).to_s!
                    when "clone"
                        puts "github username: "
                        username = STDIN.gets.chomp
                        return GITClone.new(
                            remote: remote, 
                            username: username, 
                            msg_success: msg_success, 
                            msg_error: msg_error, 
                            should_crash: should_crash
                        ).to_s!
                    else
                    end
                when "bash"
                    return BashRun.new(
                        cmd: args["cmd"], 
                        msg_success: msg_success, 
                        msg_error: msg_error, 
                        should_crash: should_crash
                    ).to_s!
                when "xcode"
                    subcmd = inst_elm[1]
                    case subcmd
                    when "scheme"
                        action = args["action"]
                        case action
                        when "edit"
                            return XcodeEditSchemeEnvVars.new(
                                    proj_path: args["path"],
                                    scheme_name: args["scheme_name"], 
                                    shared: args["shared"],
                                    key: args["env_var_key"],
                                    value: args["env_var_val"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).to_s!
                        when "duplicate"
                            return XcodeDuplicateScheme.new(
                                    proj_path: args["path"],
                                    original_scheme_name: args["original_scheme_name"], 
                                    new_scheme_name: args["new_scheme_name"], 
                                    original_shared: args["original_shared"],
                                    new_shared: args["new_shared"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).to_s!
                        when "create"
                            return XcodeCreateScheme.new(
                                    proj_path: args["path"],
                                    scheme_name: args["scheme_name"], 
                                    shared: args["shared"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).to_s!
                        else
                        end
                    when "target"
                        action = args["action"]
                        case action
                        when "edit"
                            puts args["team_id"]
                            return XcodeEditTargetBundleID.new(
                                    proj_path: args["path"],
                                    bundle_id: args["bundle_id"],
                                    team_id: args["team_id"],
                                    code_siging_identity: args["code_siging_identity"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).to_s!
                        else
                        end
                    else
                    end
                else
                    return "#{line}"
                end
            end
        end
    end
end