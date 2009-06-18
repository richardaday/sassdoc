Feature: user parses sass file
  As the user
  I want to parse a Sass file
  So that I can see the documentation

  Scenario: documenting a single variable
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

  Scenario: documenting a single variable that is not at the top of the file
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

  Scenario: documenting multiple variable nodes
    Given I have a sass file containing
    """
    //**
      This is the documentation for the variable: color
    !color = red

    //**
      Background image used for overlays
    !bg_img = "my_image.jpg"
    """
    When I parse the sass file
    Then the parser should say
    """
    Variable: !color
    -----------------
    This is the documentation for the variable: color

    Variable: !bg_img
    ------------------
    Background image used for overlays

    """

  Scenario: documenting only one of many variable nodes
    Given I have a sass file containing
    """
    !color = red

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

  #Comment stuff should be moved to another file
  Scenario: documenting variable node with multiline comment
    Given I have a sass file containing
    """
    //**
      This table width is used in the main table
      located on the home page
    !table_width = red
    """
    When I parse the sass file
    Then the parser should say
    """
    Variable: !table_width
    -----------------------
    This table width is used in the main table
    located on the home page

    """

  Scenario: documenting variable node with multiline comment whose second line has whitespace in the beggining
    Given I have a sass file containing
    """
    //**
      This table width is used in the main table
        located on the home page
    !table_width = red
    """
    When I parse the sass file
    Then the parser should say
    """
    Variable: !table_width
    -----------------------
    This table width is used in the main table
      located on the home page

    """
