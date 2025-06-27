module ImmutableAttributes
  extend ActiveSupport::Concern

  included do
    validate :validate_immutable_attributes
  end

  class_methods do
    def immutable_attributes(*attrs)
      immutable_attrs.concat(attrs.map(&:to_sym)).uniq!
    end

    def immutable_attrs
      @immutable_attrs ||= []
    end
  end

  private

  def validate_immutable_attributes
    return unless persisted?

    self.class.immutable_attrs.each do |attr|
      next unless changed_attribute?(attr) && previously_set?(attr)

      errors.add(attr, "cannot be changed once set")
    end
  end

  def changed_attribute?(attr)
    respond_to?(:will_save_change_to_attribute?) ?
      public_send("will_save_change_to_#{attr}?") :
      public_send("#{attr}_changed?")
  end

  def previously_set?(attr)
    send("#{attr}_was").present?
  end
end
