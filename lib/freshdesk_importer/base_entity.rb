module FreshdeskImporter
  class BaseEntity
    def self.root_path
      if Rails.env.development?
        Rails.root
      else
        '/shared'
      end
    end

    def self.admin_user
      User.find(-1)
    end
  end
end
