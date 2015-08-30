require "active_record/safe_initialize/version"

module ActiveRecord
  module SafeInitialize
    def safe_initialize(attribute, options = {})
      raise ArgumentError, "Missing initialization value" unless options[:with]

      after_initialize do
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

ActiveRecord::Base.extend ActiveRecord::SafeInitialize
