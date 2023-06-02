require 'nokogiri'

desc "Import users and forums"
task "freshdesk-importer:import" => [:environment] do
  users_importer = FreshdeskImporter::UsersImporter.new
  users_importer.import
end
