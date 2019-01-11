module Jumpstarter
    class OS
        class << self 

            def unix?
                !OS.isWindows?
            end

            def isLinix?
                OS.unix? and not OS.isMac?
            end

            def isMac?
                (/darwin/ =~ RUBY_PLATFORM) != nil
            end

            def isWindows?
                (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
            end
        end
    end
end