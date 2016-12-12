Makers BNB - rails
=================

Description:
-------
The program acts as a little airbnb clone that allows users to post their spaces to a public stream, and create requests to other spaces. It uses Rails and optimized for both PC and mobile devices.

### Instructions for how to run the program

```
$ gem install rails
$ git clone https://github.com/peter-miklos/Makers_BNB_rails
$ rake db:create
$ rake db:migrate
$ bundle
$ rails s
```
### Used technologies
- Ruby on Rails 5
- PostgreSQL
- Rspec/Capybara for testing
- Devise for account management
- React.js on front end (only on spaces/index view)

Tests
-------
### Feature tests
```
requests
  user logged in
    create request
      users can add request to other users' spaces after choosing a date
      users can add request to an already requested space, but for another date
      user cannot add a request if no date is choosen
      users cannot see add request link at their own spaces
      user cannot add request to a space for a specific date more than once
      user cannot add request to a space for a date that is not available
    show my received requests
      informs user if there is no received request
      shows the received requests
    manage received requests
      user can reject a received request, the rest of the requests will not be changed
      user can accept a request and rest for the same day/space will be rejected
    show my sent requests
      informs user if there is no sent requests
      shows the available sent requests
  user logged out
    create request
      user cannot see add request link if logged out
      user cannot add a request if logged out

spaces
  user logged in
    add new space
      adds a space and register it in a database (PENDING: No reason given)
      user cannot add space w/o price
      user cannot add space w/o description
      user cannot add spec w/o name
    show space details
      user can see the details of a space if logged in
      user can see the non-booked dates only at spaces/show
    edit space
      users can access and modify their own spaces
      user can go back to previous page before submitting any change
      users cannot access edit link at other users' spaces
      users cannot edit other users' spaces
    search available spaces
      only those spaces are shown that are available on the specified date (PENDING: No reason given)
      user is informed if there is no space available on the specified date (PENDING: No reason given)
      user cannot search for historical date (PENDING: No reason given)
  user logged out
    add new space
      user cannot add a new space if logged out
    edit space
      user cannot edit space if logged out
    show space
      user can see the content of a posted space if logged out
      no spaces have been added
        informs user that there is no space available
```
