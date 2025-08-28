require "spec_helper"

RSpec.describe "Google Search", type: :feature do
  it "faz uma busca" do
    visit "/"
    fill_in "q", with: "Capybara Ruby"
    find("input[name='btnK']").click
    expect(page).to have_content("Capybara")
  end
end
