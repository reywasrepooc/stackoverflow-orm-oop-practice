require 'bundler'
Bundler.require

require_relative '../lib/answer'
require_relative '../lib/question'

DB = { conn: SQLite3::Database.new("db/stackoverflow.db") }
