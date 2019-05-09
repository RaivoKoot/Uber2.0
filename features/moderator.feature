Feature: ModeratorFunctions
  Scenario: Take request
    When I login as "moderator"
    Then I should be on the startupPage
    When I follow "MODERATOR"
    Then I should be on the moderatorPage
    When I press first button "TAKE" within "#take_form"
    Then I should see "RaivoEli" within "#request_pane"
    
  Scenario: Take request and then close request
    When I login as "moderator"
    Then I should be on the startupPage
    When I follow "MODERATOR"
    Then I should be on the moderatorPage
    When I press first button "TAKE" within "#take_form"
    Then I should see "RaivoEli" within "#myrequests"
    When I press first button "CLOSE" within "#request_pane"
    Then I should see "Pickup location"
    When I fill in "pickup_location" with "some location to pick up at"
    When I fill in "destination" with "some location to arrive at"
    When I press "CLOSE"
    Then I should see "RaivoEli" within "#closedrequests"
    
   Scenario: Set taxi to free and then to busy
     When I login as "moderator"
     Then I should be on the startupPage
     When I follow "MODERATOR"
     Then I should be on the moderatorPage
     When I press "Mark as Free" within ".driver_status_form"
     Then I should see "FREE - CAR TYPE"
     When I press "Mark as Busy" within ".driver_status_form"
     Then I should see "BUSY - CAR TYPE"
     
    Scenario: Select a request and put it back without viewing conversation
       When I login as "moderator"
       Then I should be on the startupPage
       When I follow "MODERATOR"
       Then I should be on the moderatorPage
       When I press first button "TAKE" within "#take_form"
       Then I should see "RaivoEli" within "#request_pane .content"
       When I press first button "PUT BACK" within "#request_pane"
       Then I should not see "RaivoEli" within "#request_pane .content"
       
     Scenario: Select a request and view the message in the conversation
       When I login as "moderator"
       Then I should be on the startupPage
       When I follow "MODERATOR"
       Then I should be on the moderatorPage
       When I press first button "TAKE" within "#take_form"
       Then I should see "RaivoEli" within "#request_pane .content"
       When I press first button "SELECT" within "#request_pane"
       Then I should see "@ise19team25" within ".content-conversation"