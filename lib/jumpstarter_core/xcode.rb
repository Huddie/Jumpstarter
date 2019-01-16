require 'io/console'
require 'xcodeproj'
require 'plist'
module Jumpstarter
    class Xcode
        #******************#
        #   Instructions   #
        #******************#
        class CreateScheme < I_Instructions
            def run!()
                new_scheme = Xcodeproj::XCScheme.new()
                new_scheme.save_as(@proj_path, @scheme_name, @shared)
                return true
            end
        end

        class DuplicateScheme < I_Instructions
            def run!()
                existing_scheme_path = @original_shared ? Xcodeproj::XCScheme.shared_data_dir(@proj_path) : Xcodeproj::XCScheme.user_data_dir(@proj_path)
                existing_scheme = "#{existing_scheme_path}/#{@original_scheme_name}.xcscheme"
                new_scheme = Xcodeproj::XCScheme.new(existing_scheme)
                new_scheme.save_as(@proj_path, @new_scheme_name, @new_shared)
                return true
            end
        end

        class EditSchemeEnvVars < I_Instructions

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
        end

        class EditTargetBundleID < I_Instructions
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
        end
        class << self
            #*****************#
            #  Class Methods  #
            #*****************#
            def self.installed!()
                # Run version
                version = CommandRunner.execute(
                    command: Commands::Pip::Version, 
                    error: nil
                )
                return (/pip (\d+)(.\d+)?(.\d+)?/ =~ version) 
            end
                    
            def required_imports
                ['instructions', 'writer.rb', 'commandRunner.rb']
            end
        end
    end
end