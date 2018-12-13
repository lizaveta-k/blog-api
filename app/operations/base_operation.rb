# frozen_string_literal: true

class BaseOperation
  include OperationValidation

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def self.run(params)
    operation = new(params)

    return { error: operation.errors.to_h } unless operation.valid?

    { success: operation.run }
  end
end
