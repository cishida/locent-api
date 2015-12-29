module ActiveRecordExtension

  extend ActiveSupport::Concern

  def to_descriptor_hash
    hash = {
        id: self.id,
        class_name: self.class.name
    }
    return hash
  end

  module ClassMethods

  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)