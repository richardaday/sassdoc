Feature: user parses sass file
  As the user
  I want to parse a Sass file
  So that I can see the documentation

  Scenario: parse sass file containing a single variable node
    Given I have a sass file containing
    """
    //**
      This is the documentation for the variable: color
    !color = red
    """
    When I parse the sass file
    Then the parser should say
    """
    Variable: !color
    -----------------
    This is the documentation for the variable: color

    """