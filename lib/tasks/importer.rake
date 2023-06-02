require 'nokogiri'

desc "Import users and forums"
task "freshdesk-importer:import" => [:environment] do
  users_importer = FreshdeskImporter::UsersImporter.new
  users_importer.import

  forums_importer = FreshdeskImporter::ForumsImporter.new(users_importer: users_importer)
  forums_importer.import
end
