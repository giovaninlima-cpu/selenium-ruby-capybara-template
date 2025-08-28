require "capybara"
require "capybara/rspec"
require "selenium-webdriver"

Capybara.configure do |config|
  config.default_driver = :selenium_chrome
  config.app_host = ENV["BASE_URL"] || "https://www.google.com"
  config.default_max_wait_time = 5
end
