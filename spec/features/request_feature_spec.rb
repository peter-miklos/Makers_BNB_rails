require "rails_helper"

feature "request" do
  let!(:user1){ User.create(email: "test1@test.com", password: 123456)}
  let!(:user2){ User.create(email: "test2@test.com", password: 123456)}
  let!(:user3){ User.create(email: "test3@test.com", password: 123456)}
  let!(:space1){ Space.create(name: "nice little room", price: 99, description: "test", user_id: user1.id) }
  let!(:date1) { SpaceDate.create(date: "2116-11-01", status: "open", space_id: space1.id) }
  let!(:date2) { SpaceDate.create(date: "2116-11-02", status: "booked", space_id: space1.id) }
  let!(:date3) { SpaceDate.create(date: "2116-11-03", status: "open", space_id: space1.id) }

  context "user logged in" do
    before {sign_in(email: "test2@test.com")}

    context "create request" do
      scenario "users can add request to other users' spaces after choosing a date" do
        find_space_and_click

        expect(page).to have_content "Add request"

        click_link "Add request"

        expect(page).to have_content "Sunday, 01/11/2116"
        fill_in("Message", with: "I want to go there")
        click_button "Submit"

        expect(page).to have_css("table#my_sent_requests", text: "open")
        expect(page).to have_css("table#my_sent_requests", text: "I want to go there")
      end

      scenario "users can add request to an already requested space, but for another date" do
        find_space_and_add_request
        find_space_and_add_request(search_date: "2116-11-03", message: "I want to go there again")
        expect(page).to have_css("table#my_sent_requests", text: "open")
        expect(page).to have_css("table#my_sent_requests", text: "I want to go there again")
      end

      scenario "user cannot add a request if no date is choosen" do
        visit "/"
        click_link "Spaces"
        click_link "nice little room"
        click_link "Add request"

        expect(current_path).to eq("/spaces/#{space1.id}")
        expect(page).to have_css("div#alert", text: "You cannot create a request without choosing a date")
      end

      scenario "users cannot see add request link at their own spaces" do
        sign_out
        sign_in
        visit "/"
        click_link "Spaces"
        click_link "nice little room"

        expect(page).not_to have_content("Add request")
      end

      scenario "user cannot add request to a space for a specific date more than once" do
        find_space_and_add_request
        find_space_and_click
        click_link "Add request"

        expect(page).to have_css("div#alert", text: "You've already created a request")
      end
    end

    context "show my received requests" do
      before { visit "/" }

      scenario "informs user if there is no received request" do
        click_link "My requests"
        expect(page).to have_content("No received requests found")
      end

      scenario "shows the received requests" do
        find_space_and_add_request(message: "I like your place")
        sign_out
        sign_in
        click_link "My requests"

        expect(page).not_to have_css("table#my_sent_requests", text: "I like your place")
        expect(page).to have_css("table#my_received_requests", text: "I like your place")
        expect(page).to have_css("table#my_received_requests", text: "01/11/2116")
        expect(page).to have_css("table#my_received_requests", text: "$99")
      end
    end

    context "manage received requests" do
      before do
        find_space_and_add_request(message: "Test One")
        sign_out
        sign_in(email: "test3@test.com")
        find_space_and_add_request(message: "Test Two")
        sign_out
        sign_in
      end

      scenario "user can reject a received request, the rest of the requests will not be changed" do
        request1 = Request.find_by(message: "Test One")
        request2 = Request.find_by(message: "Test Two")
        click_link "My requests"
        click_button("reject_#{request1.id}")

        expect(page).to have_css("tr#request_#{request1.id}", text: "rejected")
        expect(find_button("accept_#{request2.id}")).to be_true
        expect(find_button("reject_#{request2.id}")).to be_true
      end

      scenario "user can accept a request and rest for the same day/space will be rejected" do
        request1 = Request.find_by(message: "Test One")
        request2 = Request.find_by(message: "Test Two")
        click_link "My requests"
        click_button("accept_#{request1.id}")

        expect(page).to have_css("tr#request_#{request1.id}", text: "accepted")
        expect(page).to have_css("tr#request_#{request2.id}", text: "rejected")
      end


    end

    context "show my sent requests" do
      scenario "informs user if there is no sent requests" do
        visit "/"
        click_link "My requests"

        expect(page).to have_content "No sent requests found"
      end

      scenario "shows the available sent requests" do
        find_space_and_add_request(message: "I like your place")
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
