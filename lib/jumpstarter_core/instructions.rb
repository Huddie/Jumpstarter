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
            elsif !!arg == arg or (not "#{arg}".match(" "))
                return arg
            end
            return "#{arg}"
        end

        def compose!()
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
end