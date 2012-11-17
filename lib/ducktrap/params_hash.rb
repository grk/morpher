class Ducktrap
  # Abstract base class for ducktraps that result in params hash
  class ParamsHash < self

    # Attribute hash extraction
    class AttributesHashExtraction < self
      include Nary

      register :params_hash_from_attributes_hash_extraction

      # Retuirn inverse
      #
      # @return [Ducktrap] 
      #
      # @api private
      #
      def inverse
        Ducktrap::AttributesHash::ParamsHashExtraction.new(inverse_body)
      end

      # Result of attribute hash extraction
      class Result < Nary::Result

      private

        # Calcluate result
        #
        # @return [Object]
        #
        # @api private
        #
        def process
          body.each_with_object({}) do |controller, hash|
            name = controller.name
            value = NamedValue.new(name, input.fetch(name))
            result = controller.run(value)

            unless result.successful?
              return Nary::MemberError.new(context, input, result)
            end

            hash.merge!(result.output)
          end
        end
      end
    end

    class Attribute < self
      include Unary
      include Equalizer.new(:name, :postprocessor)

      register :params_hash_from_attribute

      attr_reader :name
      attr_reader :postprocessor

      def initialize(name, postprocessor = Noop.instance)
        @name, @postprocessor = name, postprocessor
      end

      def inverse
        Ducktrap::Attribute::ParamsHash.new(name, postprocessor.inverse)
      end

      # Perform pretty dump
      #
      # @return [self]
      #
      # @api private
      #
      def pretty_dump(output=Formatter.new)
        output.name(self)
        output = output.indent
        output.puts("name: #{name.inspect}")
        output.nest('postprocessor:', postprocessor)
        self
      end

      # build attribute hash extraction
      #
      # @param [Symbol] name
      #
      # @return [Ducktrap]
      #
      # @api private
      #
      def self.build(name, &block)
        postprocessor = Noop.instance

        if block
          postprocessor = Ducktrap::Block.build(&block)
        end

        new(name, postprocessor)
      end

      # Result of attribute
      class Result < Ducktrap::Unary::Result

      private

        # Return key
        #
        # @return [String]
        #
        # @api private
        #
        def key
          context.name.to_s
        end

        # Return postprocessor
        #
        # @return  [Ducktrap]
        #
        # @api private
        #
        def postprocessor
          context.postprocessor
        end

        # Return result
        #
        # @return [Object]
        #
        # @api private
        #
        def process
          value = input.value
          result = postprocessor.run(value)

          unless result.successful?
            return Nary::MemberError.new(context, input, result)
          end

          { key => result.output }
        end
      end
    end
  end
end
