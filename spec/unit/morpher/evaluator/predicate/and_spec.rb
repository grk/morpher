# encoding: UTF-8

require 'spec_helper'

describe Morpher::Evaluator::Predicate::And do
  let(:object) { described_class.new([body_a, body_b]) }

  let(:body_a) { Morpher.evaluator(s(:primitive, String))                          }
  let(:body_b) { Morpher.evaluator(s(:eql, s(:attribute, :length), s(:static, 1))) }

  let(:negative_input) { ''  }
  let(:positive_input) { 'a' }

  include_examples 'predicate evaluator'
end
