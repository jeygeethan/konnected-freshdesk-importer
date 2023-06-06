module FreshdeskImporter
  class UsersImporter < BaseEntity
    IMPORT_PATH = "/data/users"

    attr_accessor :users_collection

    def initialize
      super

      @users_collection = []
    end

    def import
      import_all_files
      save_or_update_users
    end

    def import_file(file)
      xml = File.open(file)
      users = Hash.from_xml(xml)

      users["users"].each do |user_hash|
        next if user_hash['email'].nil? || user_hash['email'].blank?

        @users_collection << UserEntity.from_hash(user_hash)
      end
    end

    def save_or_update_users
      @users_collection.each do |user_entity|
        puts "Creating/updating user - #{user_entity.email}"
        user_entity.save_or_update
      end
    end

    def import_path
      BaseEntity.root_path.to_s + IMPORT_PATH + "/*.xml"
    end

    def find_by_freshdesk_id(freshdesk_user_id)
      @users_collection.each do |user_entity|
        if user_entity.hash["id"] == freshdesk_user_id
          return user_entity.user
        end
      end

      puts "*** User not found - using admin user ***"
      BaseEntity.admin_user
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
