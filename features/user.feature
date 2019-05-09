Feature: testUser
  Scenario: serachUser
    When I login as "moderator"
    Given I am on the userPage
    When I fill in "email_filter" with "admin@admin.co.uk"
    When I fill in "name_filter" with "admin"
    When I press "Search for User" 
    Then I should see "admin"
    
  Scenario: block
    When I login as "moderator"
    Given I am on the userPage
    When I press first button "Block" within ".controls:nth-child(1)"
    Then I should see "Blocked: true"
    
  Scenario: unblock
    When I login as "moderator"
    Given I am on the userPage
    When I press first button "Unblock" within ".controls:nth-child(1)"
    Then I should see "Blocked: false"
    
  Scenario: promote
    When I login as "admin"
    Given I am on the userPage
    When I press first button "Promote" within ".controls:nth-child(1)"
    Then I should see "moderator"
    
  Scenario: demote
    When I login as "admin"
   Given I am on the userPage
   When I press first button "Demote" within ".controls:nth-child(1)"
   Then I should see "user"
    


    
