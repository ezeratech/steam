module Locomotive::Steam

  class Snippet

    include Locomotive::Steam::Models::Entity

    def initialize(attributes = {})
      super({
        template: {}
      }.merge(attributes))
    end

  end

end
