Feature: API Settings
  In order to configure my API usage
  As a provider
  I want to have a nice API settings control panel

  Background:
    Given a provider "foo.3scale.localhost"
    And current domain is the admin domain of provider "foo.3scale.localhost"
    And apicast registry is stubbed

  Scenario: Referrer filtering on backend v2
    Given provider "foo.3scale.localhost" uses backend v2 in his default service
      And I log in as provider "foo.3scale.localhost"
      And I go to the usage rules settings for service "API"
     And I check "Require referrer filtering"
     And I press "Update Product"
    Then I should see "Product information updated"
