require "rails_helper"

feature "spaces" do

  let!(:user1){ User.create(email: "test1@test.com", password: 123456)}
  let!(:user2){ User.create(email: "test2@test.com", password: 123456)}
  let!(:space1){ Space.create(name: "nice little room", price: 99, description: "test", user_id: user1.id) }
  let!(:space_date1){ SpaceDate.create(date: "2116-11-01", status: "open", space_id: space1.id) }
  let!(:space_date2){ SpaceDate.create(date: "2116-11-02", status: "booked", space_id: space1.id) }


  context "user logged in" do

    before {sign_in}

    context "add new space" do

      scenario "adds a space and register it in a database" do
        skip
        click_link("Add space")
        fill_in("Name", with: "Test apartment")
        fill_in("Price", with: 98)
        fill_in("Available from", with: "2116-01-01")
        fill_in("Available to", with: "2116-05-01")
        fill_in("Description", with: "nice apartment available for a weekend")
        click_button("List my space")

        expect(current_path).to eq "/spaces"

        fill_in("search_date_field", with: "2116-11-02")
        expect(page).to have_content("Test apartment")
        expect(page).to have_content(98)
        expect(page).to have_content("nice apartment available for a weekend")

        visit "/spaces/#{space1.id}?date=2116-11-01"
        expect(page).to have_content("2116-01-01")
        expect(page).to have_content("2116-05-01")
      end

      scenario "user cannot add space w/o price" do
        click_link("Add space")
        fill_in("Name", with: "Test apartment")
        fill_in("Available from", with: "2116-01-01")
        fill_in("Available to", with: "2116-05-01")
        fill_in("Description", with: "nice apartment available for a weekend")
        click_button("List my space")

        expect(page).to have_css("section#errors", text: "Price can't be blank")
      end

      scenario "user cannot add space w/o description" do
        click_link("Add space")
        fill_in("Name", with: "Test apartment")
        fill_in("Price", with: 98)
        fill_in("Available from", with: "2116-01-01")
        fill_in("Available to", with: "2116-05-01")
        click_button("List my space")

        expect(page).to have_css("section#errors", text: "Description can't be blank")
      end

      scenario "user cannot add spec w/o name" do
        click_link("Add space")
        fill_in("Price", with: 98)
        fill_in("Available from", with: "2116-01-01")
        fill_in("Available to", with: "2116-05-01")
        fill_in("Description", with: "nice apartment available for a weekend")
        click_button("List my space")

        expect(page).to have_css("section#errors", text: "Name can't be blank")
      end

    end

    context "show space details" do
      scenario "user can see the details of a space if logged in" do
        visit "/spaces/#{space1.id}"

        expect(page).to have_content "nice little room"
        expect(page).to have_content "test"
      end

      scenario "user can see the non-booked dates only at spaces/show" do
        visit "/spaces/#{space1.id}"

        expect(page).to have_content("2116-11-01")
        expect(page).not_to have_content("2116-11-02")
      end
    end

    context "edit space" do
      scenario "users can access and modify their own spaces" do
        visit "/spaces/#{space1.id}"
        click_link("Edit space")

        expect(current_path).to eq "/spaces/#{space1.id}/edit"

        fill_in("Name", with: "Updated name")
        fill_in("Price", with: 110)
        fill_in("Description", with: "Updated description")
        click_button("Update")

        expect(current_path).to eq "/spaces/#{space1.id}"
        expect(page).to have_css("div#notice", text: "Space successfully updated")
        expect(page).to have_content("Updated name")
        expect(page).to have_content(110)
        expect(page).to have_content("Updated description")
      end

      scenario "user can go back to previous page before submitting any change" do
        visit "/spaces/#{space1.id}"
        click_link("Edit space")
        click_link("Cancel")

        expect(page).to have_content "nice little room"
      end

      scenario "users cannot access edit link at other users' spaces" do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/spaces/#{space1.id}"

        expect(page).not_to have_content("Edit space")
      end

      scenario "users cannot edit other users' spaces" do
        # skip
        sign_out
        sign_in(email: "test2@test.com")
        # visit "/spaces/#{space1.id}?date=2116-11-01"
        visit "/spaces/#{space1.id}/edit"
        fill_in("Description", with: "Updated description")
        click_button "Update"

        expect(page).to have_css("div#alert", text: "You cannot update this space")
        expect(page).not_to have_content("Updated description")
      end

    end

    context "search available spaces" do
      scenario "only those spaces are shown that are available on the specified date" do
        skip
        visit "/"
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-01")

        expect(page).to have_content "nice little room"
        expect(page).to have_content "99"
      end

      scenario "user is informed if there is no space available on the specified date" do
        skip
        visit "/"
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-02")

        expect(page).to have_content("Available spaces on Monday, 02/11/2116")
        expect(page).to have_content "No spaces found"
        expect(page).not_to have_content "nice little room"
        expect(page).not_to have_content "99"
      end

      scenario "user cannot search for historical date" do
        skip
        # visit "/"
        # click_link "Spaces"
        # fill_in("search_date_field", with: "2010-01-02")
        visit "/spaces/#{space1.id}?date=2010-01-02"
        visit "/"
        click_link "Spaces"

        expect(current_path).to eq "/spaces"
        expect(page).to have_css("div#alert", text: "Date cannot be in the past")
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

    context "edit space" do
      scenario "user cannot edit space if logged out" do
        visit "/spaces/#{space1.id}"

        expect(page).not_to have_content "Edit space"
      end
    end

    context "show space" do
      scenario "user can see the content of a posted space if logged out" do
        visit "/spaces/#{space1.id}"

        expect(page).to have_content "nice little room"
        expect(page).to have_content "test"
      end

      context "no spaces have been added" do
        scenario "informs user that there is no space available" do
          SpaceDate.destroy_all
          Space.destroy_all
          visit "/spaces"
          expect(page).to have_content "No spaces found"
        end
      end
    end
  end
end
