module FreshdeskImporter
  class UserEntity
    attr_accessor :freshdesk_id, :hash, :name, :email, :user_email, :user

    def initialize(freshdesk_id:, name:, email:, hash:)
      @freshdesk_id = freshdesk_id
      @name = name
      @email = email

      @hash = hash
    end

    def save_or_update
      @user_email = UserEmail.where(email: email).first

      if user_email.present?
        @user = user_email.user
        update!
      else
        save!
      end

      # user.activate if user.persisted? && user.active == false
    end

    def save!
      @user = User.new(name: name)
      @user.username = generate_username

      @user_email = @user.build_primary_email(email: email)

      if @user.valid?
        @user.save!
      else
        puts "*** Validation error ***"
        puts hash
        puts @user.errors.full_messages
      end
    end

    def update!
      # @user.name = name
      # @user.save!
    end

    def generate_username
      initial_username = email.split("@")[0]

      initial_username = initial_username.gsub(/_+/, "_")
      initial_username = initial_username.gsub(/\.+/, ".")
      initial_username = initial_username.gsub(/\-+/, "-")
      initial_username = initial_username.gsub(/\++/, "")
      initial_username = initial_username.gsub(/\'+/, "")
      initial_username = initial_username.gsub(/\=+/, "")
      initial_username = initial_username.gsub(/\_\./, "")

      unless initial_username.last.match?(/[a-zA-Z0-9]/)
        initial_username += "u"
      end

      unless initial_username.first.match?(/[a-zA-Z0-9]/)
        initial_username = "u" + initial_username
      end

      if initial_username.size > 16
        initial_username = initial_username[0..15]
        initial_username += "u"
      elsif initial_username.size < 3
        initial_username += "user"
      end

      repeated_username = initial_username
      count = 0

      while(User.exists?(username: repeated_username))
        count += 1
        repeated_username = initial_username + count.to_s
      end

      repeated_username
    end

    def self.from_hash(hash)
      UserEntity.new(freshdesk_id: hash["id"], name: hash["name"], email: hash["email"].strip.downcase, hash: hash)
    end
  end
end
