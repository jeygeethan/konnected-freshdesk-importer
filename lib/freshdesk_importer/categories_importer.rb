module FreshdeskImporter
  class CategoriesImporter
    attr_accessor :users_importer, :category_hash

    def initialize(users_importer:, category_hash:)
      @users_importer = users_importer
      @category_hash = category_hash
    end
  end
end
