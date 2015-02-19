if defined?(ChefSpec)
  module ChefSpec::Matchers
    class NginxURIRewriteLocationMatcher
      def initialize(runner, original_uri)
        @runner = runner
        @original_uri = Regexp.escape original_uri
      end

      def matches?(resource)
        @resource = resource
        @path = @resource.name

        @actual_content = ChefSpec::Renderer.new(@runner, @resource).content

        @actual_content=~/location #{@request_uri} \{[^}]+rewrite #{@original_uri}\s+#{@new_uri} break;/m
      end

      def failure_message
        message = %Q{expected Nginx to}
        message << " redirect requests like #{@original_uri} to #{@new_uri}\n"
        message << "when the request URI matches #{@request_uri}\n"
        message << "Instead configuration was:\n"
        message << @actual_content

        message
      end

      def to(new_uri)
        @new_uri = Regexp.escape new_uri
        self
      end

      def when_request_uri_matches(request_uri)
        @request_uri = Regexp.escape request_uri
        self
      end
    end
  end
end

