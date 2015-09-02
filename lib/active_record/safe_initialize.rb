require "active_record"
require "active_record/safe_initialize/version"
require 'active_support/core_ext/array/extract_options'

module ActiveRecord
  module SafeInitialize
    def safe_initialize(*attributes)
      options = attributes.extract_options!
      raise ArgumentError, "Missing initialization value" unless options[:with]

      after_initialize do
        attributes.each do |attribute|
          if has_attribute?(attribute) && read_attribute(attribute).nil?
            value = options[:with]
            value = instance_exec(&value) if value.respond_to?(:call)
            value = self.send(value) if value.is_a?(Symbol)

            self.send "#{attribute}=", value
          end
        end
      end
    end
  end
end

ActiveRecord::Base.extend ActiveRecord::SafeInitialize
