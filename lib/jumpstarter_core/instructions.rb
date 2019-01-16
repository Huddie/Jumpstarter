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

    # I_Instrcutions
    # This is an abstract class. And should not be init.
    # This lays out the blueprint for all instructions
    # The only method that must be overwritten is the run!
    # method.
    class I_Instructions
        def initialize(opts = {})
            @dec = nil
            options = DEFAULTS.merge(opts)
            options.each do |k, v|
                v = self.clean_value(v)
                @dec = "#{@dec}\n\t#{k}: #{v},"
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
            message = ""
            if not @msg_success or @msg_success.empty?
                message = "[Success]"
            end
            message = @msg_success
            return message       
        end

        def error_message!()
            message = ""
            if  not @msg_error or @msg_error.empty?
                message "[Error]"
            end
            message = @msg_success
            return message
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
            str = "_inst_ret = #{self.class}.new(#{@dec.chomp(',')}".chomp()
            str = "#{str}\n).run!"
            str = "#{str}\nif _inst_ret"
            str = "#{str}\n\tJumpstarter::Writer.show_success(message: self.success_message!)"
            str = "#{str}\nelse"
            str = "#{str}\n\tJumpstarter::Writer.show_error(message: self.success_message!)"
            str = "#{str}\nend"
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