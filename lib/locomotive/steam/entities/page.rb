module Locomotive
  module Steam
    module Entities
      class Page
        include Locomotive::Entity

        ## fields ##
        attributes :parent, :title, :slug, :fullpath, :redirect_url, :redirect_type,
                   :template, :handle, :listed, :searchable, :templatized, :content_type,
                   :published, :cache_strategy, :response_type, :position, :seo_title,
                   :meta_keywords, :meta_description, :editable_elements, :site,
                   :site_id, :parent_id

        ## aliases ##
        alias :listed?      :listed
        alias :published?   :published
        alias :templatized? :templatized
        alias :searchable?  :searchable

        attr_accessor :templatized_from_parent

        # Tell if the page is either the index page.
        #
        # @return [ Boolean ] True if index page.
        #
        def index?
          'index' == default_fullpath
        end

        # Tell if the page is either the index or the 404 page.
        #
        # @return [ Boolean ] True if index or 404 page.
        #
        def index_or_404?
          %w(index 404).include?(default_fullpath)
        end


        # Returns unique fullpath for depth, 404, index calculation.
        #
        # @return [String] Fullpath based on first locale found
        def default_fullpath
          fullpath.values.first
        end

        alias :index_or_not_found? :index_or_404?

        def with_cache?
          self.cache_strategy != 'none'
        end

        def default_response_type?
          self.response_type == 'text/html'
        end

        # Is it a redirect page ?
        #
        # @return [ Boolean ] True if the redirect_url property is set
        #
        def redirect?
          false
          #!self.redirect_url.blank?
        end

        # Depth of the page in the site tree.
        # Both the index and 404 pages are 0-depth.
        #
        # @return [ Integer ] The depth
        #
        def depth
          return 0 if %w(index 404).include?(default_fullpath)
          default_fullpath.split('/').size
        end

        def unpublished?
          !self.published?
        end

        # Modified setter in order to set correctly the slug
        #
        # @param [ String ] fullpath The fullpath
        #
        def fullpath_with_setting_slug=(fullpath)
          fullpath.each do |key, value|
            if value && (self.slug ||= {})[key].nil?
              self.slug[key] = File.basename(value)
            end
          end
          self.fullpath_without_setting_slug = fullpath
        end

        alias_method_chain :fullpath=, :setting_slug

        # Modified setter in order to set inheritance fields from parent
        #
        # @param [ String ] fullpath The fullpath
        #
        # def parent_with_inheritance=(parent)
        #   self.templatized_from_parent = parent.templatized?

        #   # copy properties from the parent
        #   %w(templatized content_type).each do |name|
        #     self.send(:"#{name}=", parent.send(name.to_sym))
        #   end

        #   self.parent_without_inheritance = parent
        # end
        # alias_method_chain :parent=, :inheritance

        # Set the source of the page without any pre-rendering. Used by the API reader.
        #
        # @param [ String ] content The HTML raw template
        #
        def raw_template=(content, locale)
          @source ||= {}
          @source[locale] = content
        end

        # Return the Liquid template based on the raw_template property
        # of the page. If the template is HAML or SLIM, then a pre-rendering to Liquid is done.
        #
        # @return [ String ] The liquid template or nil if not template has been provided
        #
        def source(locale)
          @source ||= self.template[locale].source
        end

        def to_liquid
          ::Locomotive::Steam::Liquid::Drops::Page.new(self)
        end

      end
    end
  end
end