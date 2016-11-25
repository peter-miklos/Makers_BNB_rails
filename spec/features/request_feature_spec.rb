require "rails_helper"

feature "request" do
  let!(:user1){ User.create(email: "test1@test.com", password: 123456)}
  let!(:user2){ User.create(email: "test2@test.com", password: 123456)}
  let!(:space1){ Space.create(name: "nice little room", price: 99, description: "test", user_id: user1.id) }
  let!(:date1) { SpaceDate.create(date: "2116-11-01", status: "open", space_id: space1.id) }
  let!(:date2) { SpaceDate.create(date: "2116-11-02", status: "booked", space_id: space1.id) }
  let!(:date3) { SpaceDate.create(date: "2116-11-03", status: "open", space_id: space1.id) }

  context "user logged in" do
    before {sign_in}

    context "create request" do
      scenario "users can add request to other users' spaces after choosing a date" do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/"
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-01")
        click_button "space_search_button"
        click_link "nice little room"

        expect(page).to have_content "Add request"

        click_link "Add request"

        expect(page).to have_content "Sunday, 01/11/2116"
        fill_in("Message", with: "I want to go there")
        click_button "Submit"

        expect(page).to have_css("table#my_sent_requests", text: "open")
        expect(page).to have_css("table#my_sent_requests", text: "I want to go there")
      end

      scenario "users can add request to an already requested space, but for another date" do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/"
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-01")
        click_button "space_search_button"
        click_link "nice little room"
        click_link "Add request"
        fill_in("Message", with: "I want to go there")
        click_button "Submit"
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-03")
        click_button "space_search_button"
        click_link "nice little room"
        click_link "Add request"
        fill_in("Message", with: "I want to go there again")
        click_button "Submit"
        expect(page).to have_css("table#my_sent_requests", text: "open")
        expect(page).to have_css("table#my_sent_requests", text: "I want to go there again")
      end

      scenario "user cannot add a request if no date is choosen" do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/"
        click_link "Spaces"
        click_link "nice little room"
        click_link "Add request"

        expect(current_path).to eq("/spaces/#{space1.id}")
        expect(page).to have_css("div#alert", text: "You cannot create a request without choosing a date")
      end

      scenario "users cannot see add request link at their own spaces" do
        visit "/"
        click_link "Spaces"
        click_link "nice little room"

        expect(page).not_to have_content("Add request")
      end

      scenario "user cannot add request to a space for a specific date more than once" do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/"
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-01")
        click_button "space_search_button"
        click_link "nice little room"
        click_link "Add request"
        fill_in("Message", with: "I want to go there")
        click_button "Submit"
        visit "/"
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-01")
        click_button "space_search_button"
        click_link "nice little room"
        click_link "Add request"

        expect(page).to have_css("div#alert", text: "You've already created a request")
      end
    end

    context "show my received requests" do

      before do
        sign_out
        sign_in(email: "test2@test.com")
        visit "/"
      end

      scenario "informs user if there is no received request" do
        click_link "My requests"
        expect(page).to have_content("No received requests found")
      end

      scenario "shows the received requests" do
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-01")
        click_button "space_search_button"
        click_link "nice little room"
        click_link "Add request"
        fill_in("Message", with: "I like your place")
        click_button "Submit"
        sign_out
        sign_in
        click_link "My requests"

        expect(page).not_to have_css("table#my_sent_requests", text: "I like your place")
        expect(page).to have_css("table#my_received_requests", text: "I like your place")
        expect(page).to have_css("table#my_received_requests", text: "01/11/2116")
        expect(page).to have_css("table#my_received_requests", text: "$99")
      end
    end

    context "show my sent requests" do
      scenario "informs user if there is no sent requests" do
        visit "/"
        click_link "My requests"

        expect(page).to have_content "No sent requests found"
      end

      scenario "shows the available sent requests" do
        sign_out
        sign_in(email: "test2@test.com")
        click_link "Spaces"
        fill_in("search_date_field", with: "2116-11-01")
        click_button "space_search_button"
        click_link "nice little room"
        click_link "Add request"
        fill_in("Message", with: "I like your place")
        click_button "Submit"
        click_link "My requests"

        expect(page).not_to have_content "No sent requests"
        expect(page).to have_css("table#my_sent_requests", text: "I like your place")
        expect(page).to have_css("table#my_sent_requests", text: "01/11/2116")
        expect(page).to have_css("table#my_sent_requests", text: "open")
        expect(page).to have_css("table#my_sent_requests", text: "$99")
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

        expect(page).to have_content("You need to sign in or sign up before continuing.")
        expect(current_path).to eq "/users/sign_in"
      end

    end
  end
end
