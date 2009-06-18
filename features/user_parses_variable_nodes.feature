Feature: user parses variable nodes
  As the user
  I want to parse a Sass file
  So that I can see the documentation of variable nodes

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

  Scenario: documenting single line comment of a variable node
    Given I have a sass file containing
    """
    //** The background color of the page
    !page_bgcolor = #000000
    """
    When I parse the sass file
    Then the parser should say
    """
    Variable: !page_bgcolor
    ------------------------
    The background color of the page

    """

  Scenario: documenting multi line comment of a variable node
    Given I have a sass file containing
    """
    //**
      This table width is used in the main table
      located on the home page
        NOTE: It is also used in certain other pages
    !table_width  = 500px
    """
    When I parse the sass file
    Then the parser should say
    """
    Variable: !table_width
    -----------------------
    This table width is used in the main table
    located on the home page
      NOTE: It is also used in certain other pages

    """
