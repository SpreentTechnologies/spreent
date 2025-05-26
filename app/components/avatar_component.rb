# frozen_string_literal: true

class AvatarComponent < ViewComponent::Base
    SIZES = {
        small: {
            container: "w-8 h-8",
        }
    }
    def initialize(
        src: nil,
        alt: nil,
        name: nil,
        size: :medium,
    )
        @src = src
        @alt = alt || name || "Avatar"
        @name = name
        @size = size.to_sym
    end
end