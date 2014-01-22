module Morpher
  class Evaluator
    class Transformer
      class Merge < self
        include Intransitive, Parameterized, Nullary

        register :merge

        # Call evaluator for input
        #
        # @param [Object] input
        #
        # @return [Object] output
        #
        # @api private
        #
        def call(input)
          param.merge(input)
        end

      end # Merge
    end # Transformer
  end # Evaluator
end # Morpher