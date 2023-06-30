# name: freshdesk-importer
# about: Import freshdesk export into the discourse
# version: 0.0.1
# authors: Konnected Inc
# url: https://github.com/jeygeethan/basic-plugin

require_relative 'lib/freshdesk_importer/base_entity'
require_relative 'lib/freshdesk_importer/users_importer'
require_relative 'lib/freshdesk_importer/user_entity'
require_relative 'lib/freshdesk_importer/forums_importer'
require_relative 'lib/freshdesk_importer/categories_importer'
require_relative 'lib/freshdesk_importer/topic_importer'
require_relative 'lib/freshdesk_importer/seo_paths'
require_relative 'lib/freshdesk_importer/attachments_lister'
require_relative 'data/konnected'

gem 'httparty', '0.21.0', {require: false }
gem 'csv', '3.2.7', {require: false }

require 'httparty'
require 'nokogiri'
