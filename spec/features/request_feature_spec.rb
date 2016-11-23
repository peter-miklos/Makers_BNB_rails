require "rails_helper"

feature "request" do
  let!(:user1){ User.create(email: "test1@test.com", password: 123456)}
  let!(:user2){ User.create(email: "test2@test.com", password: 123456)}
  let!(:space1){ Space.create(name: "nice little room", price: 99, description: "test", user_id: user1.id) }
  let!(:date1) { SpaceDate.create(date: "2116-11-01", status: "open", space_id: space1.id) }
  let!(:date2) { SpaceDate.create(date: "2116-11-02", status: "booked", space_id: space1.id) }

  context "user logged in" do
    before {sign_in}

    context "create request" do
      scenario "users can add request to other users' spaces" do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/"
        click_link "Spaces"
        click_link "nice little room"

        expect(page).to have_content "Add request"

        click_link "Add request"
        fill_in("message", with: "I want to go there")
        click_button "Submit"

        expect(page).to have_content(user2.email)
        expect(page).to have_content("I want to go there")
      end

      scenario "users cannot see add request link at their own spaces" do
        visit "/"
        click_link "Spaces"
        click_link "nice little room"

        expect(page).not_to find_link("Add request")
      end

      scenario "user cannot add request to a space more than once" do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/"
        click_link "Spaces"
        click_link "nice little room"
        click_link "Add request"
        fill_in("message", with: "I want to go there")
        click_button "Submit"
        visit "/"
        click_link "Spaces"
        click_link "nice little room"

        expect(page).not_to find_link "Add request"
      end
    end
  end

  context "user logged out" do

    context "create request" do

      scenario "user cannot see add request link if logged out" do
        visit "/"
        click_link "Spaces"
        click_link "nice little room"

        expect(current_path).to eq "/spaces/#{space1.id}"
        expect(page).not_to have_content("Add request")
      end

      scenario "user cannot add a request if logged out" do
        visit "/spaces/#{space1.id}/requests/new"

        expect(page).to have_content("no permission")
      end

    end
  end
end
