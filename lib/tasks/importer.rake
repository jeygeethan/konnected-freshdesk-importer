require 'nokogiri'

desc "Import users and forums"
task "freshdesk-importer:import" => [:environment] do
  users_importer = FreshdeskImporter::UsersImporter.new
  users_importer.import

  forums_importer = FreshdeskImporter::ForumsImporter.new(users_importer: users_importer)
  forums_importer.import

  puts "### Done ###"
  puts forums_importer.seo_paths.mappings.inspect
end

task "freshdesk-importer:attachments" => [:environment] do
  lister = FreshdeskImporter::AttachmentsLister.new
  lister.list
end
