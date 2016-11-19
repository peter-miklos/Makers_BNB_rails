require "rails_helper"

feature "spaces" do

  context "no spaces have been added" do
    scenario "informs user that there is no space available" do
      visit "/spaces"
      expect(page).to have_content "No spaces found"
      expect(page).to have_link "Add space"
    end
  end

  context "space is added" do
    before { Space.create(name: "nice little room") }
    scenario "display spaces" do
      visit "/spaces"
      expect(page).to have_content "nice little room"
      expect(page).not_to have_content "No spaces found"
    end
  end
end
