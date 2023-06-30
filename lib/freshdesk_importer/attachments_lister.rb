module FreshdeskImporter
  class AttachmentsLister < BaseEntity
    IMPORT_PATH = "/data/forums"

    def initialize()
      super()
    end

    def list
      list_all_files
    end

    def list_file(file)
      xml = File.open(file)
      forums = Hash.from_xml(xml)

      categories = forums["forum_categories"][0]["forums"]
      categories.each do |category_hash|
        category_hash["topics"].each do |topic_hash|
          url = "https://konnected.freshdesk.com/support/discussions/topics/#{topic_hash["id"]}"
          check_for_url(url)
          break
        end

        break
      end
    end

    def check_for_url(url)
      puts "Checking url - #{url}"
      response = HTTParty.get(url)
      puts response.code
    end

    private

    def path
      BaseEntity.root_path.to_s + IMPORT_PATH + "/*.xml"
    end

    def list_all_files
      Dir[path].each do |file|
        puts "Importing file - " + file
        list_file(file)
      end
    end
  end
end
