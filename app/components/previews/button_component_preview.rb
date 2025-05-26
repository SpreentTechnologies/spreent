class ButtonComponentPreview < ViewComponent::Preview
  # @param label [String] The text to display on the button
  # @param variant [String] The variant of the button (e.g., "primary", "secondary")
  def default(label: "Click Me", variant: "primary")
    render(ButtonComponent.new(label: label, variant: variant))
  end

  # @param disabled [Boolean] Whether the button should be disabled
  def disabled(disabled: true)
    render(ButtonComponent.new(label: "Disabled Button", variant: "primary", disabled: disabled))
  end
end