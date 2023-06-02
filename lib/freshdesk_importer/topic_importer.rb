module FreshdeskImporter
  class TopicImporter
    attr_accessor :users_importer, :category, :topic_hash

    def initialize(users_importer:, category:, topic_hash:)
      @users_importer = users_importer
      @category = category
      @topic_hash = topic_hash
    end

    def import
      puts topic_hash.keys
    end
  end
end
