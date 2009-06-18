Feature: user parses mixin nodes
  As the user
  I want to parse a Sass file
  So that I can see the documentation of mixin nodes

  Scenario: documenting a mixin node
    Given I have a sass file containing
    """
    //**
      This mixin sets the color as blue
    =alternating-colors()
      :color blue
    """
    When I parse the sass file
    Then the parser should say
    """
    Mixin: alternating-colors()
    ----------------------------
    This mixin sets the color as blue

    """
