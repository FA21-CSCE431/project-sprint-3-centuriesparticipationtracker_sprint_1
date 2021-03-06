# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

def login_as_admin
  use_admin
  visit '/'
  click_on 'Login with Google'
  expect(page).not_to have_content('Login with Google')
end

def login_as_user
  use_user
  visit '/'
  click_on 'Login with Google'
  # puts page.body
  expect(page).not_to have_content('Login with Google')
end

def force_white_list
  whitelist_data = [
    'paul-b-tamu@tamu.edu',
    'centurymens.social@gmail.com',
    'ammar918@gmail.com',
    'siddiqi918@tamu.edu',
    'siddiqi91899@gmail.com',
    'deananderson@tamu.edu',
    'andersondeant@gmail.com',
    'mivoli98@tamu.edu',
    'mibeophi2@gmail.com'
  ]

  whitelist_data.each do |email|
    Whitelist.create(email: email) if Whitelist.find_by(email: email).nil?
  end

  tp Whitelist.all
end

def force_members
  if Member.find_by(uid: 12_345_678_910).nil?
    Member.create(name: 'Ammar Siddiqi', isAdmin: true, email: 'ammar918@gmail.com',
                  uid: 12_345_678_910)
  end
  if Member.find_by(uid: 12_345_678_919).nil?
    Member.create(name: 'Paul Paul', isAdmin: false, email: 'paul-b-tamu@tamu.edu',
                  uid: 12_345_678_919)
  end

  tp Member.all
end

def use_admin
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       provider: 'google_oauth2',
                                                                       uid: '12345678910',
                                                                       info: {
                                                                         email: 'ammar918@gmail.com',
                                                                         first_name: 'Ammar',
                                                                         last_name: 'Siddiqi'
                                                                       }
                                                                     })
end

def use_user
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       provider: 'google_oauth2',
                                                                       uid: '12345678919',
                                                                       info: {
                                                                         email: 'paul-b-tamu@tamu.edu',
                                                                         first_name: 'Paul',
                                                                         last_name: 'Paul'
                                                                       }
                                                                     })
end

OmniAuth.config.test_mode = true
use_admin
force_white_list
force_members
