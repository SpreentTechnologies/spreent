# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(title:, variant: :primary, disabled: false, href: nil)
    @title = title
    @variant = variant
    @disabled = disabled
    @href = href
  end

  private

  attr_reader :title, :variant, :disabled

  def base_classes
  end

  def disabled_classes
    
  end
end
