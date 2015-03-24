module Locomotive::Steam

  class Page

    include Locomotive::Steam::Models::Entity

    attr_accessor :depth, :_fullpath, :content_entry

    def initialize(attributes)
      super({
        handle:             nil,
        listed:             false,
        published:          true,
        templatized:        false,
        fullpath:           {},
        content_type:       nil,
        target_klass_name:  nil,
        position:           99,
        raw_template:       nil,
        source:             nil,
        editable_elements:  {},
        redirect_url:       {},
        redirect_type:      nil,
        parent_id:          nil,
        parent_ids:         nil
      }.merge(attributes))
    end

    def listed?; !!listed; end
    def published?; !!published; end
    def templatized?; !!templatized; end

    def content_type_id
      # TODO
    end

    def index?
      attributes[:fullpath].values.first == 'index'
    end

    def not_found?
      attributes[:fullpath].values.first == '404'
    end

    def source
      self[:raw_template]
    end

    def to_liquid
      Locomotive::Steam::Liquid::Drops::Page.new(self)
    end

  end

end
