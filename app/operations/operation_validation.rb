# frozen_string_literal: true

module OperationValidation
  def self.included(base)
    base.include ActiveModel::Validations
    base.include InstanceMethods
  end

  module InstanceMethods
    def read_attribute_for_validation(attribute)
      params[attribute]
    end
  end
end
