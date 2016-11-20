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
