Feature: user parses comment nodes
  As the user
  I want to parse a Sass file
  So I can see the Comments relating to the nodes

  Scenario: viewing comment related to variable node
    Given I have a sass file containing
    """
    //**
      This table width is used in the main table
      located on the home page
        NOTE: It is also used in certain other pages
    !table_width = red
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
