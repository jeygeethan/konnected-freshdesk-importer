module FreshdeskImporter
  class TopicImporter
    attr_accessor :users_importer, :category, :topic_hash

    def initialize(users_importer:, category:, topic_hash:)
      @users_importer = users_importer
      @category = category
      @topic_hash = topic_hash
    end

    def import
      user = users_importer.find_by_freshdesk_id(topic_hash["user_id"])
      topic = category.topics.new(title: topic_hash["title"], user: user, created_at: topic_hash["created_at"],
                                  updated_at: topic_hash["updated_at"], bumped_at: topic_hash["updated_at"])
      topic.save(validate: false)
      topic.touch(time: topic_hash["updated_at"])

      topic_hash["posts"].each do |post_hash|
        user = users_importer.find_by_freshdesk_id(post_hash["user_id"])
        post = topic.posts.new(user: user, raw: post_hash["body_html"], created_at: post_hash["created_at"],
                               updated_at: post_hash["updated_at"])
        post.save(validate: false)
        post.touch(time: post_hash["updated_at"])
      end
    end
  end
end
