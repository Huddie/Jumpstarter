class StandardError
    def exit_status
    return -1
    end
end

module Jumpstarter
    class JumpstarterPtyError < StandardError
    attr_reader :exit_status
    def initialize(e, exit_status)
        super(e)
        set_backtrace(e.backtrace) if e
        @exit_status = exit_status
    end
    end

    class JumpstarterPty
        def self.spawn(command)
            require 'pty'
            PTY.spawn(command) do |command_stdout, command_stdin, pid|
            begin
                yield(command_stdout, command_stdin, pid)
            rescue Errno::EIO

            ensure
                begin
                    Process.wait(pid)
                rescue Errno::ECHILD, PTY::ChildExited
                # The process might have exited.
                end
            end
        end
        $?.exitstatus
        rescue LoadError
        require 'open3'
        Open3.popen2e(command) do |command_stdin, command_stdout, p| # note the inversion
            yield(command_stdout, command_stdin, p.value.pid)

            command_stdin.close
            command_stdout.close
            p.value.exitstatus
            end
        rescue StandardError => e
            puts "ERROR: #{e}"
        raise JumpstarterPtyError.new(e, $?.exitstatus)
        end
    end

    class CommandRunner

        class << self
        
            def execute_sudo(command: nil)
                system("sudo #{command}")
            end

            def execute(command: nil, error:nil)
                output = []
                if command.is_a? String
                    output <<  _execute(command: command, error: error) 
                else
                    command.command!.each do |item|
                        output <<  _execute(command: item, error: error) 
                    end
                end
                return output.join("\n")
            end

            def _execute(command: nil, error:nil)

                print_all = true
                prefix ||= {}

                output = []

                Writer.write(message: "#{command}")

                begin
                    status = Jumpstarter::JumpstarterPty.spawn(command) do |command_stdout, command_stdin, pid|
                    command_stdout.each do |l|
                        line = l.strip # strip so that \n gets removed
                        output << line

                        next unless print_all

                        # Prefix the current line with a string
                        prefix.each do |element|
                            line = element[:prefix] + line if element[:block] && element[:block].call(line)
                        end
                        Writer.write(message: "#{line}")
                    end
                end
                rescue => ex
                    # FastlanePty adds exit_status on to StandardError so every error will have a status code
                    status = ex.exit_status

                    # This could happen when the environment is wrong:
                    # > invalid byte sequence in US-ASCII (ArgumentError)
                    output << ex.to_s
                    o = output.join("\n")
                    puts(o)
                    if error
                        error.call(o, nil)
                    else
                        raise ex
                    end
                end

                # Exit status for build command, should be 0 if build succeeded
                if status != 0
                    o = output.join("\n")
                    puts(o)
                    Writer.write(message: ("Exit status: #{status}"))
                    if error
                        error.call(o, status)
                    else
                        Writer.write(message: ("Exit status: #{status}"))
                    end
                end 
                return output.join("\n")
            end
        end 
    end
end



