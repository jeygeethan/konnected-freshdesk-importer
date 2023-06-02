module FreshdeskImporter
  class CategoriesImporter
    attr_accessor :users_importer, :category_hash, :category

    def initialize(users_importer:, category_hash:)
      @users_importer = users_importer
      @category_hash = category_hash
    end

    def import
      create_or_update_category
      delete_all_topics_except_pinned

      category_hash["topics"].each do |topic_hash|
        topic_importer = TopicImporter.new(users_importer: users_importer, category: category, topic_hash: topic_hash)
        topic_importer.import

        break
      end
    end

    private

    def create_or_update_category
      @category = Category.where(name: category_hash["name"]).first

      if category.present?
        category.update!(description: category_hash["description_html"])
      else
        @category = Category.new(name: category_hash["name"], description: category_hash["description_html"],
                                 user: FreshdeskImporter::BaseEntity.admin_user)
        @category.save!
      end
    end

    def delete_all_topics_except_pinned
      category.topics.where(pinned_at: nil).destroy_all
    end
  end
end
