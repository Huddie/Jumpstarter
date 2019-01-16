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
                def update_targets_plist_ids(project, bundleName)
                    target = project.targets.first
                    files = target.source_build_phase.files.to_a.map do |pbx_build_file|
                        pbx_build_file.file_ref.real_path.to_s
                    end.select do |path|
                        path.end_with?(".plist")
                    end.select do |path|
                        File.exists?(path)
                    end
                    files.each do |f|
                        profile_plist = Plist.parse_xml(f)
                        current = profile_plist['NSExtension']['NSExtensionAttributes']['WKAppBundleIdentifier'] 
                    end
                end
            end
        end
    end