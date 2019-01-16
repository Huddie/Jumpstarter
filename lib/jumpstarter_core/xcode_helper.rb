    require 'xcodeproj'
    require 'plist'
    require 'shellwords'

    module Jumpstarter
        class XCHelper
            class << self
                def teams!()
                    teams = []
                    path = File.expand_path("~") + "/Library/MobileDevice/Provisioning Profiles/"
                    output_plist_file = "profile.plist"
                    Dir.foreach(path) do |f|
                        file_path = File.expand_path("~") + "/Library/MobileDevice/Provisioning\\ Profiles/#{f}"
                        if File.extname(file_path) == '.mobileprovision'
                            system("security cms -D -i #{file_path} > #{output_plist_file}")
                            profile_plist = Plist.parse_xml("profile.plist")
                            team = profile_plist['TeamIdentifier'].first
                            teams << team
                            File.delete("#{output_plist_file}")
                        end
                    end
                    return teams
                end
            end
        end
    end