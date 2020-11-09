Feature: Integration Settings
  In order to configure my Product API
  As a provider
  I want to set my API deployment and authentication options

  Background:
    Given a provider "foo.3scale.localhost"
    And current domain is the admin domain of provider "foo.3scale.localhost"

  Scenario: Integration Settings options (Rolling updates Service Mesh OFF)
    Given I log in as provider "foo.3scale.localhost"
    And I have rolling updates "service_mesh_integration,apicast_oidc" disabled
    And I go to the settings page for service "API" of provider "foo.3scale.localhost"
    Then I should see within "#service_deployment_option_input" the following:
      | name                           |
      | APIcast a 3scale managed       |
      | APIcast self-managed           |

    And I should see within "#service_proxy_authentication_method_input" the following:
      | name                     |
      | API Key (user_key)       |
      | App_ID and App_Key Pair  |

  Scenario: Integration Settings options (Rolling updates ON)
    Given I log in as provider "foo.3scale.localhost"
    And I go to the settings page for service "API" of provider "foo.3scale.localhost"
    Then I should see within "#service_deployment_option_input.gateway" the following:
      | name                           |
      | APIcast a 3scale managed       |
      | APIcast self-managed           |

    And I should see within "#service_deployment_option_input.service_mesh" the following:
      | Istio                          |

    And I should see within "#service_proxy_authentication_method_input" the following:
      | name                     |
      | API Key (user_key)       |
      | App_ID and App_Key Pair  |
      | OpenID Connect           |
