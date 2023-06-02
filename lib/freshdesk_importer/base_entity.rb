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
      if Rails.env.development?
        UserEmail.where(email: 'jeyb2b@gmail.com').first.user
      else
        UserEmail.where(email: 'nate@konnected.io').first.user
      end
    end
  end
end
