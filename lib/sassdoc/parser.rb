module SassDoc
  class Parser
    def initialize(file)
      @file = file
    end

    def generateTree #can be refactored into initialize
      @contents = File.open(@file) do |f|
        f.read
      end

      Sass::Engine.new(@contents).send :to_tree
    end

    def parse
      sass_tree = generateTree

      comment_nodes = []
      variable_nodes = []
      mixin_nodes = []
      prev_child = nil
      sass_tree.children.each do |child|
        if child.is_a?(Sass::Tree::VariableNode) && prev_child.is_a?(Sass::Tree::CommentNode)
          variable_nodes << child
          comment_nodes << prev_child
        elsif child.is_a?(Sass::Tree::MixinDefNode) && prev_child.is_a?(Sass::Tree::CommentNode)
          mixin_nodes << child
          comment_nodes << prev_child
        end
        prev_child = child
      end

      output = ""
      variable_nodes.each_with_index { |variable_node, index|
        output += "Variable: !#{variable_node.name}\n"
        output += "#{"-" * (11 + variable_node.name.length + 1)}\n"

        comment = comment_nodes[index].value
        output += "#{comment[3,comment.length]}\n"

        if index != (variable_nodes.length - 1)
          output += "\n"
        end
      }

      mixin_nodes.each_with_index { |mixin_node, index|
        output += "Mixin: #{mixin_node.name}()\n"
        output += "#{"-" * (9 + mixin_node.name.length + 1)}\n"

        comment = comment_nodes[index].value
        output += "#{comment[3,comment.length]}\n"

        if index != (mixin_nodes.length - 1)
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
    class MixinDefNode < Node
      attr_accessor :name
    end
  end
end
