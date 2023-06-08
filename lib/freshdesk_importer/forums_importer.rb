module FreshdeskImporter
  class ForumsImporter < BaseEntity
    IMPORT_PATH = "/data/forums"

    attr_accessor :users_importer, :seo_paths

    def initialize(users_importer:)
      super()

      @users_importer = users_importer
      @seo_paths = SeoPaths.new
    end

    def import
      import_all_files
    end

    def import_file(file)
      xml = File.open(file)
      forums = Hash.from_xml(xml)

      categories = forums["forum_categories"][0]["forums"]
      categories.each do |category_hash|
        categories_importer = CategoriesImporter.new(users_importer: users_importer, category_hash: category_hash, seo_paths: seo_paths)
        categories_importer.import
      end
    end

    def import_path
      BaseEntity.root_path.to_s + IMPORT_PATH + "/*.xml"
    end

    private

    def import_all_files
      Dir[import_path].each do |file|
        puts "Importing file - " + file
        import_file(file)
      end
    end
  end
end
