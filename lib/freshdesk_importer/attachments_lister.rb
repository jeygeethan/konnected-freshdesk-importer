module FreshdeskImporter
  class AttachmentsLister < BaseEntity
    IMPORT_PATH = "/data/forums"

    def initialize
      super

      @results = []
    end

    def list
      # list_all_files
      list_all_files

      puts ""
      puts @results.inspect
    end

    def list_file(file)
      xml = File.open(file)
      forums = Hash.from_xml(xml)

      categories = forums["forum_categories"][0]["forums"]
      categories.each do |category_hash|
        category_hash["topics"].each do |topic_hash|
          url = "https://konnected.freshdesk.com/support/discussions/topics/#{topic_hash["id"]}"
          check_for_url(url)
        end
      end
    end

    def check_for_url(url)
      result = { url: url, community_url: get_current_path(url), attachments: false, inline_images: false }
      puts "*" * 80
      puts "Checking url - #{url}"
      response = HTTParty.get(url)
      puts "Status: #{response.code}"
      page = Nokogiri::HTML4(response.body)

      pages = page.css('div.pagination li').present? ? page.css('div.pagination li').size - 2 : 0
      result[:pages] = pages

      result[:attachments] = true if check_attachment(page)
      result[:inline_images] = true if check_inline_images(page)

      (2..pages).each do |page|
        inner_page_response = HTTParty.get(url + "/page/" + page.to_s)
        puts "Pagination: Page: #{page} - Status: #{inner_page_response.code}"
        inner_page = Nokogiri::HTML4(inner_page_response.body)

        result[:attachments] = true if check_attachment(inner_page)
        result[:inline_images] = true if check_inline_images(inner_page)
      end

      @results << result
    end

    def check_attachment(page)
      page.css('div.attachment').present?
    end

    def check_inline_images(page)
      page.css('img').each do |img|
        return true if img[:src].include?("cdn.freshdesk.com")
      end

      false
    end

    def get_current_path(url)
      REDIRECTION_PATHS[url]
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
