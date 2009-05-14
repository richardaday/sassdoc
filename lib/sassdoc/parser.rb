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

      comment_node = sass_tree.children[0]
      variable_node = sass_tree.children[1]
      
      output = "Variable: !#{variable_node.name}\n"
      output += "-----------------\n"
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
