module ActionView
  module Helpers
    module AssetTagHelper
      def image_tag(source, options={})
        options = options.symbolize_keys

        src = options[:src] = path_to_image(source)

        unless src =~ /^(?:cid|data):/ || src.blank?
          options[:alt] = options.fetch(:alt){ image_alt(src) }
        end

        options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]

        # This is the line I added for SVG fallback
        options.merge! onerror: "this.onerror=null; this.src='#{path_to_image(source.gsub('.svg', '.png'))}'" if src =~ /\.svg/

        tag("img", options)
      end
    end
  end
end
