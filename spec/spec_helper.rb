require 'active_record/safe_initialize'

ActiveRecord::Base.configurations = {
  'test' => {
    'adapter'   => 'sqlite3',
    'database'  => ':memory:',
    'verbosity' => 'quiet'
  }
}

ActiveRecord::Base.establish_connection :test

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(version: 20150830080017) do

  create_table "posts", force: true do |t|
    t.string "title"
    t.text   "body"
    t.string "uuid"
  end

end

class Post < ActiveRecord::Base; end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
