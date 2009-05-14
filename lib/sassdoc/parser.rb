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

      comment_nodes = []
      variable_nodes = []
      prev_child = nil
      sass_tree.children.each do |child|
        if child.is_a?(Sass::Tree::VariableNode) && prev_child.is_a?(Sass::Tree::CommentNode)
          variable_nodes << child
          comment_nodes << prev_child
        end
        prev_child = child
      end
      
      output = ""
      variable_nodes.each_with_index { |variable_node, index|
        output += "Variable: !#{variable_node.name}\n"
        output += "#{"-" * (11 + variable_node.name.length + 1)}\n"
        output += "#{comment_nodes[index].children[0].text}\n"

        if index != (variable_nodes.length - 1)
          output += "\n"
        end
      }

      output
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
