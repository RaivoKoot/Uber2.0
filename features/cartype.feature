Feature: car type
  Scenario: right page
	  When I login as "moderator"
	  Given I am on the cartypePage
	  Then I should see "Current Car Types"
  Scenario: add car type without an image
	  When I login as "moderator"
	  Given I am on the cartypePage
	  When I fill in "cartype_name" with "medium"
	  When I fill in "description" with "A medium type car include Volkswagen, Honda etc..."
	  When I press "Save"
	  Then I should see "Something went wrong adding that car type"

  Scenario: activate and deactivate a car type
	  When I login as "moderator"
	  Given I am on the cartypePage 
	  When I press first button "Deactivate" within "taxi-container"
	  Then I should see "Activate" button
	  When I press first button "Activate" within "taxi-container"
	  Then I should see "Deactivate" button