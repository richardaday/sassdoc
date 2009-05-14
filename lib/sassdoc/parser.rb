module SassDoc
  class Parser
    def initialize(file)
      @file = file
    end

    def generateTree #can be refactored into initialize
      @contents = File.open(@file) do |f|
        f.read
      end

      Sass::Engine.new(@contents).send :render_to_tree
    end

    def parse
      sass_tree = generateTree

      comment_node = nil
      variable_node = nil
      sass_tree.children.each do |child|
        if child.is_a? Sass::Tree::CommentNode
          comment_node = child
        elsif child.is_a? Sass::Tree::VariableNode
          variable_node = child
        end
      end
      
      output = "Variable: !#{variable_node.name}\n"
      output += "#{"-" * (output.length)}\n"
      output += "#{comment_node.children[0].text}\n"
    end
  end
end

module Sass
  module Tree
    class VariableNode < Node
      attr_accessor :name
    end
  end
end
