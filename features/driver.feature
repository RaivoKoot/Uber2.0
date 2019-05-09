
Feature: driver
  Scenario: addDriver
      When I login as "admin"
      Given I am on the driverPage
      When I fill in "driver_name" with "kang"
      When I fill in "car_name" with "BMW"
      When I fill in "license_plate" with "B19 KFR"
      When I press "SEND" within "form"
      Then I should be on the driverPage
      Then I should see "kang" within "div.item"
  