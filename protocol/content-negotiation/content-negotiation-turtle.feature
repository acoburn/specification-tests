Feature: Requests support content negotiation for Turtle resource

  Background: Create a Turtle resource
    * def testContainer = rootTestContainer.reserveContainer()
    * def exampleTurtle = karate.readAsString('../fixtures/example.ttl')
    * def resource = testContainer.createResource('.ttl', exampleTurtle, 'text/turtle');
    * def expected = RDFUtils.turtleToTripleArray(exampleTurtle, resource.url)
    * configure headers = clients.alice.getAuthHeaders('GET', resource.url)
    * url resource.url

  Scenario: Alice can read the Turtle example as JSON-LD
    Given header Accept = 'application/ld+json'
    When method GET
    Then status 200
    And match header Content-Type contains 'application/ld+json'
    And match RDFUtils.jsonLdToTripleArray(JSON.stringify(response), resource.url) contains expected

  Scenario: Alice can read the Turtle example as Turtle
    Given header Accept = 'text/turtle'
    When method GET
    Then status 200
    And match header Content-Type contains 'text/turtle'
    And match RDFUtils.turtleToTripleArray(response, resource.url) contains expected
