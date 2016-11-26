def sign_in(email: "test1@test.com", password: 123456)
  visit "/"
  click_link("Sign in")
  fill_in("user_email", with: email)
  fill_in("user_password", with: password)
  click_button("Log in")
end

def sign_out
  visit "/"
  click_link "Sign out"
end

def find_space_and_add_request(search_date: "2116-11-01", message: "I want to go there", space: "nice little room")
  find_space_and_click(search_date: search_date, space: space)
  click_link "Add request"
  fill_in("Message", with: message)
  click_button "Submit"
end

def find_space_and_click(search_date: "2116-11-01", space: "nice little room")
  visit "/"
  click_link "Spaces"
  fill_in("search_date_field", with: search_date)
  click_button "space_search_button"
  click_link space
end
