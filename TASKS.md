# Task Management

## Breaking down task

by breaking down and analyzing user story that need to be implement

1. Landing Page (3 story point)
   1.1 Data layer (response, request, service, mapper, repository, use case)
   1.2 UI (presentation)
   1.3 Business logic and integrate UI with real data (view model)
   1.4 Tests (unit tests, UI test)
2. Detail section (2 story point)
   2.1 Data layer (response, request, service, mapper, repository, use case)
   2.2 UI (presentation)
   2.3 Business logic and integrate UI with real data (view model)
   2.4 Tests (unit tests, UI test)

## Landing Page

## Endpoint

GET https://pokeapi.co/api/v2/pokemon
Query param:

1. offset (initial as 0)
2. limit (hardcoded as 20)

### Scenario: User open the app and landed on landing page

Given the User has started the app When the user landed on landing page Then app should fetch first
pokemon list from the open API `https://pokeapi.co/api/v2/pokemon`
Then app should be in the loading state while fetching from API And app should be showing loading
indicator while in the loading state

Given landing page finish loading pokemon list from API When the app receive response from endpoint
Then the app should display the pokemon name list

Given user scrolls to the bottom of the existing list When user scroll to the bottom of the list
Then the app should fetch the next pokemon list Then appending the new list to the previous list

Given user wants to refresh the list When user scroll to the top of the screen and pull Then the app
should provide pull to refresh behavior Then should clear the cached list and call the initial
endpoint again Then user should see the refreshed name list

Given when user load pokemon list When user is in loading state and cannot call to API or API
endpoint returns error Then the app should display error dialog to show an error message

## Pokemon's Detail Section

### Endpoint

GET https://pokeapi.co/api/v2/pokemon/{id}
Path parameter:
id

### Scenario: User click on one of the list item

Given the User finished loading name list in the landing page and the list is not empty When user
click on the list item (pokemon name)
Then the app should call the API to retrieve that specific pokemon details Then the app should show
loading indicator while the API is still loading

Given user finished retrieving response from API When the detail section finished loading Then the
section should display `name`, `front image`, `back image`, `weight`, and `height` of the pokemon

Given user drag the section to the bottom of the screen When user scroll/drag the section to the
bottom of the screen Then the section should be dismiss
