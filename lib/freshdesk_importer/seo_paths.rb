module FreshdeskImporter
  class SeoPaths
    attr_accessor :mappings

    def initialize
      @mappings = {}
    end

    def add(old, new)
      mappings[old_host + old] = new_host + new
    end

    def old_host
      if Rails.env.production?
        "https://help.konnected.io"
      else
        "https://help.konnected.io"
      end
    end

    def new_host
      if Rails.env.production?
        "https://community.konnected.io"
      else
        "http://localhost:4200"
      end
    end
  end
end
