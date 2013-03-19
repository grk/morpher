module Ducktrap
  class Node
    # Abstract baseclass for ducktraps to string
    class String < self

      # Ducktrap to convert fixnums to string
      class Fixnum < self
        register :string_from_fixnum
        include Singleton

        # Return inverse klass
        #
        # @return [Class:Ducktrap::Fixnum::String]
        #
        # @api private
        #
        def inverse_klass
          Node::Fixnum::String
        end

        # Return result for input
        #
        # @param [Object] input
        #
        # @return [Result]
        #
        # @api private
        #
        def run(input)
          Result::Static.new(self, input, input.to_s(10))
        end

      end

      # Abstract class to convert param hashes to string
      class ParamsHash < self
        include Singleton, AbstractType

        # Base class for params hash results that are serialized to strings
        class Result < Ducktrap::Result
        end

        # Ducktrap to convert param hashes to url encoded strings
        class URLEncoded < self

          # Return inverse class
          #
          # @return [Class:Ducktrap::ParamsHash::String::URLEncoed]
          #
          # @api private
          #
          def inverse_klass
            Ducktrap::ParamsHash::String::URLEncoded
          end

          # Resulf of url encoded string ducktrap
          class Result < ParamsHash::Result

          private

            # Return calculated result
            #
            # @return [String]
            #
            # @api private
            #
            def process
              Addressable::URI.form_encode(input)
            end

          end

        end
      end
    end
  end
end
