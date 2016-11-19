require "rails_helper"

feature "spaces" do

  context "no spaces have been added" do

    scenario "informs user that there is no space available" do
      visit "/spaces"
      expect(page).to have_content "No spaces found"
      expect(page).to have_link "Add space"
    end

  end
end
