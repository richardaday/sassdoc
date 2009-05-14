require File.join(File.dirname(__FILE__), "/../spec_helper")

module SassDoc
  describe Parser do
    context "parsing a sassdoc file" do
    
      it "should convert the file into a SassTree" do
        sass_file = Tempfile.new('sass_file')
        sass_file.puts( <<-eos
//**
  This is the documentation for the variable: color
!color = red
          eos
        )
        sass_file.flush
        parser = SassDoc::Parser.new(sass_file.path)
        sass_tree = parser.generateTree

        sass_tree.is_a?(Sass::Tree::Node).should == true
        sass_tree.children[0].is_a?(Sass::Tree::CommentNode).should == true
      end

      it "should output the documentation related to CommentNodes" do
        sass_file = Tempfile.new('sass_file')
        sass_file.puts( <<-eos
//**
  This is the documentation for the variable: color
!color = red
          eos
        )
        sass_file.flush

        parser = SassDoc::Parser.new(sass_file.path)
        messenger = parser.parse

        messenger.should == <<-eos
Variable: !color
-----------------
This is the documentation for the variable: color
          eos
      end
    end
  end
end
