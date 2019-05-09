
Feature: authentication
  Scenario: login
      Given I am on the loginPage
      When I fill in "email" with "admin@admin.co.uk"
      When I fill in "password" with "admin"
      When I press "SEND" within "form"
      Then I should be on the startupPage
      
  Scenario: logged_in_user_buttons
      When I login as "user"
      Then I should see "LOGOUT"      
      Then I should see "PROFILE"
      Then I should not see "MODERATOR"
      Then I should not see "USERS"
      Then I should not see "LOGIN"
      Then I should not see "Register" within "div#about"
  
  Scenario: logged_in_moderator_buttons
      When I login as "moderator"
      Then I should see "LOGOUT"      
      Then I should see "PROFILE"
      Then I should see "MODERATOR"
      Then I should see "USERS"
      Then I should not see "LOGIN"
      Then I should not see "Register" within "div#about"
  
  Scenario: logged_in_admin_buttons
      When I login as "admin"
      Then I should see "LOGOUT"      
      Then I should see "PROFILE"
      Then I should see "MODERATOR"
      Then I should see "USERS"
      Then I should not see "LOGIN"
      Then I should not see "Register" within "div#about"

  
  Scenario: logout
      When I login as "user"
      Then I should be on the startupPage
      When I follow "LOGOUT" within "div#myNavbar"
      Then I should be on the startupPage
      Then I should see "LOGIN"
      Then I should not see "LOGOUT"
      Then I should not see "PROFILE"
      Then I should see "Register" within "div#about"
   
  Scenario: register_existing_account
      Given I am on the registerPage
      When I fill in "email" with "user@user.co.uk"
      When I fill in "name" with "User"
      When I fill in "password" with "secret"
      When I fill in "new_password_confirm" with "secret"
      When I press "SEND" within "form"
      Then I should be on the registerPage
      
  Scenario: register_new_account
      Given I am on the registerPage
      When I fill in "email" with "user1@user.co.uk"
      When I fill in "name" with "User"
      When I fill in "password" with "secret"
      When I fill in "new_password_confirm" with "secret"
      When I press "SEND" within "form"
      Then I should be on the loginPage

  