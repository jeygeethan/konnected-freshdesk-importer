module FreshdeskImporter
  class UsersImporter < BaseEntity
    IMPORT_PATH = "/data/users"

    attr_accessor :users_collection

    def initialize
      super

      @users_collection = {}
    end

    def import
      import_all_files
    end

    def import_file(file)
      start_time = Time.zone.now

      xml = File.open(file)
      users = Hash.from_xml(xml)

      users["users"].each do |user_hash|
        next if user_hash['email'].nil? || user_hash['email'].blank?

        user_entity = UserEntity.from_hash(user_hash)
        save_or_update_user_entity(user_entity)

        @users_collection[user_entity.hash["id"]] = user_entity.user.id
      end

      puts "Time taken: #{(Time.zone.now - start_time)}"
    end

    def save_or_update_user_entity(user_entity)
      # puts "Creating/updating user - #{user_entity.email}"
      user_entity.save_or_update
    end

    def import_path
      BaseEntity.root_path.to_s + IMPORT_PATH + "/*.xml"
    end

    def find_by_freshdesk_id(freshdesk_user_id)
      id = @users_collection[freshdesk_user_id]
      if id.present?
        return User.find(id)
      end

      puts "*** User not found - using admin user *** - #{freshdesk_user_id}"
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
