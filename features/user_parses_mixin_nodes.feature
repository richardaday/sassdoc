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

  Scenario: documenting a mixin node with one argument
    Given I have a sass file containing
    """
    //**
      This mixin sets the color as the passing argument
    =alternating-colors(!color)
      :color !color
    """
    When I parse the sass file
    Then the parser should say
    """
    Mixin: alternating-colors(!color)
    ----------------------------
    This mixin sets the color as the passing argument

    """

