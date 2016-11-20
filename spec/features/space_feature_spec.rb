require "rails_helper"

feature "spaces" do

  let!(:user1){ User.create(email: "test1@test.com", password: 123456)}
  let!(:user2){ User.create(email: "test2@test.com", password: 123456)}

  context "show spaces" do
    context "no spaces have been added" do
      scenario "informs user that there is no space available" do
        visit "/spaces"
        expect(page).to have_content "No spaces found"
      end
    end
  end

  context "user logged in" do
    before do
      sign_in
      Space.create(name: "nice little room", price: 99, description: "test", user_id: user1.id)
    end

    context "add new space" do

      scenario "adds a space and register it in a database" do
        click_link("Add space")
        fill_in("Name", with: "Test apartment")
        fill_in("Price", with: 98)
        fill_in("Description", with: "nice apartment available for a weekend")
        click_button("List my space")

        expect(current_path).to eq "/spaces"
        expect(page).to have_content("Test apartment")
        expect(page).to have_content(98)
        expect(page).to have_content("nice apartment available for a weekend")
      end

      scenario "user cannot add space w/o price" do
        click_link("Add space")
        fill_in("Name", with: "Test apartment")
        fill_in("Description", with: "nice apartment available for a weekend")
        click_button("List my space")

        expect(page).to have_css("section#errors", text: "Price can't be blank")
      end

      scenario "user cannot add space w/o description" do
        click_link("Add space")
        fill_in("Name", with: "Test apartment")
        fill_in("Price", with: 98)
        click_button("List my space")

        expect(page).to have_css("section#errors", text: "Description can't be blank")
      end

      scenario "user cannot add spec w/o name" do
        click_link("Add space")
        fill_in("Price", with: 98)
        fill_in("Description", with: "nice apartment available for a weekend")
        click_button("List my space")

        expect(page).to have_css("section#errors", text: "Name can't be blank")
      end

    end

    context "show space" do
      scenario "user can see the details of a space if logged in" do
        space1 = Space.last
        visit "/spaces"
        click_link("nice little room")

        expect(current_path).to eq "/spaces/#{space1.id}"
        expect(page).to have_content "nice little room"
        expect(page).to have_content "test"
      end
    end
  end

  context "user logged out" do
    context "add new space" do
      scenario "user cannot add a new space if logged out" do
        visit "/"
        expect(page).not_to have_content("Add space")
      end
    end

    context "show space" do
      before { Space.create(name: "nice little room", price: 99, description: "test", user_id: user1.id) }

      scenario "user can see the content of a posted space if logged out" do
        space1 = Space.last
        visit "/spaces"
        click_link("nice little room")

        expect(current_path).to eq "/spaces/#{space1.id}"
        expect(page).to have_content "nice little room"
        expect(page).to have_content "test"
      end
    end
  end

end
