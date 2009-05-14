Feature: user parses sass file
  As the user
  I want to parse a Sass file
  So that I can see the documentation

  Scenario: parse sass file containing comment nodes
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

    Given I have a sass file containing
    """
    h1
      display: block;
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

    Given I have a sass file containing
    """
    //**
      Background image used for overlays
    !bg_img = "my_image.jpg"
    """
    When I parse the sass file
    Then the parser should say
    """
    Variable: !bg_img
    ------------------
    Background image used for overlays

    """
