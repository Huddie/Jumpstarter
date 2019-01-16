require_relative './git'
require_relative './pip'
require_relative './bash'
require_relative './xcode'

module Jumpstarter
    class InstructionParser
        class << self

            # Gets the arguments of a line
            # --foo = variable/boolean/number
            # --"foo" = String
            # --"foo bar baz" = String
            def get_args(line)
                return Hash[line.scan(/--?([^=\s]+)(?:=(\"[^\"]+\"|\S+))?/)]
            end

            # Parse each line individually
            # If the command is recognized, create the corrisponding
            # instruction class and call `compose!` on it
            # 
            # `compose!` returns a string that is valid
            # ruby code and can such be run 
            def parse(line)

                inst_elm = line.split

                ## Read the command
                cmd = inst_elm[0]

                ## Parse the arguments
                args = InstructionParser.get_args(line)

                ## Arguments that apply to all commands
                msg_success = args["msg_success"]
                msg_error = args["msg_error"]
                should_crash = args["should_crash"]

                # Switch over the command finding the appropiate
                # instruction. Once found, process the remaining
                # inst_elm or args and feed them into the class
                case cmd
                when "pip"
                    package = inst_elm[1]
                    return Jumpstarter::Pip::Install.new(
                        package: package, 
                        msg_success: msg_success, 
                        msg_error: msg_error, 
                        should_crash: should_crash
                    ).compose!
                when "git"
                    subcmd = inst_elm[1]
                    remote = inst_elm[2] 
                    branch = inst_elm[3] if inst_elm[3]
                    case subcmd
                    when "fork"
                        return Jumpstarter::Git::Fork.new(
                            remote: remote, 
                            username: args["username"], 
                            password: args["password"], 
                            msg_success: msg_success, 
                            msg_error: msg_error, 
                            should_crash: should_crash
                        ).compose!
                    when "pull"
                        return Jumpstarter::Git::Pull.new(
                            remote: remote, 
                            branch: branch, 
                            msg_success: msg_success, 
                            msg_error: msg_error, 
                            should_crash: should_crash
                        ).compose!
                    when "clone"
                        return Jumpstarter::Git::Clone.new(
                            remote: remote, 
                            username: args["username"], 
                            msg_success: msg_success, 
                            msg_error: msg_error, 
                            should_crash: should_crash
                        ).compose!
                    else
                    end
                when "bash"
                    return Jumpstarter::Bash::Run.new(
                        cmd: args["cmd"], 
                        msg_success: msg_success, 
                        msg_error: msg_error, 
                        should_crash: should_crash
                    ).compose!
                when "cd"
                    path = inst_elm[1]
                    return Jumpstarter::Bash::CD.new(
                        path: path, 
                        msg_success: msg_success, 
                        msg_error: msg_error, 
                        should_crash: should_crash
                    ).compose!
                when "xcode"
                    subcmd = inst_elm[1]
                    case subcmd
                    when "scheme"
                        action = args["action"]
                        case action
                        when "edit"
                            return Jumpstarter::Xcode::EditSchemeEnvVars.new(
                                    proj_path: args["path"],
                                    scheme_name: args["scheme_name"], 
                                    shared: args["shared"],
                                    key: args["env_var_key"],
                                    value: args["env_var_val"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).compose!
                        when "duplicate"
                            return Jumpstarter::Xcode::DuplicateScheme.new(
                                    proj_path: args["path"],
                                    original_scheme_name: args["original_scheme_name"], 
                                    new_scheme_name: args["new_scheme_name"], 
                                    original_shared: args["original_shared"],
                                    new_shared: args["new_shared"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).compose!
                        when "create"
                            return Jumpstarter::Xcode::CreateScheme.new(
                                    proj_path: args["path"],
                                    scheme_name: args["scheme_name"], 
                                    shared: args["shared"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).compose!
                        else
                        end
                    when "target"
                        action = args["action"]
                        case action
                        when "edit"
                            return Jumpstarter::Xcode::EditTargetBundleID.new(
                                    proj_path: args["path"],
                                    bundle_id: args["bundle_id"],
                                    team_id: args["team_id"],
                                    code_siging_identity: args["code_siging_identity"],
                                    msg_success: msg_success,
                                    msg_error: msg_error,
                                    should_crash: should_crash
                            ).compose!
                        else
                        end
                    else
                    end
                else
                    # In a case where the command is not understood
                    # assume the line is a ruby line and simply return
                    # that line to the starter.rb file to run normally
                    return "#{line}"
                end
            end
        end
    end
end