require File.join(File.dirname(__FILE__), "/../spec_helper")

module SassDoc
  describe Parser do
    def generate_sass_file(contents)
      sass_file = Tempfile.new('sass_file')
      sass_file.puts(contents)
      sass_file.flush
    end

    context "in order to parse a sass file" do
      it "should be able to represent the file as a SassTree" do
        sass_file = generate_sass_file( <<-eos
//**
  This is the documentation for the variable: color
!color = red
          eos
        )

        parser = SassDoc::Parser.new(sass_file.path)
        sass_tree = parser.generateTree

        sass_tree.is_a?(Sass::Tree::Node).should == true
        sass_tree.children[0].is_a?(Sass::Tree::CommentNode).should == true
      end
    end

    context "parsing a sassdoc file" do
      it "should output the documentation related to CommentNodes" do
        sass_file = generate_sass_file( <<-eos
//**
  This is the documentation for the variable: color
!color = red
          eos
        )

        parser = SassDoc::Parser.new(sass_file.path)
        messenger = parser.parse

        messenger.should == <<-eos
Variable: !color
-----------------
This is the documentation for the variable: color
          eos
      end

      it "should not care if there are extra Sass Nodes in the sass file" do
        sass_file = generate_sass_file( <<-eos
h1
  display:block;
//**
  This is the documentation for the variable: color
!color = red
          eos
        )

        parser = SassDoc::Parser.new(sass_file.path)
        messenger = parser.parse

        messenger.should == <<-eos
Variable: !color
-----------------
This is the documentation for the variable: color
          eos

      end

      it "should be able to handle multiple variable nodes" do
        sass_file = generate_sass_file( <<-eos
//**
  This is the documentation for the variable: color
!color = red

//**
  Background image used for overlays
!bg_img = "my_image.jpg"
          eos
        )

        parser = SassDoc::Parser.new(sass_file.path)
        messenger = parser.parse

        messenger.should == <<-eos
Variable: !color
-----------------
This is the documentation for the variable: color

Variable: !bg_img
------------------
Background image used for overlays
          eos
      end

      it "should ignore variable nodes that do not have a comment" do
        sass_file = generate_sass_file( <<-eos
!color = red

//**
  Background image used for overlays
!bg_img = "my_image.jpg"
          eos
        )

        parser = SassDoc::Parser.new(sass_file.path)
        messenger = parser.parse

        messenger.should == <<-eos
Variable: !bg_img
------------------
Background image used for overlays
          eos
      end

    end

  end
end
