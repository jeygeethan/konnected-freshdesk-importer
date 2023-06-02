module FreshdeskImporter
  class BaseEntity
    def self.root_path
      if Rails.env.development?
        Rails.root
      else
        '/shared'
      end
    end
  end
end
