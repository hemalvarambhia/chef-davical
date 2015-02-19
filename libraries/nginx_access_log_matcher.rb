if defined?(ChefSpec)
  module ChefSpec::Matchers
    class NginxAccessLogMatcher
      def initialize(runner, path_to_error_log)
        @runner = runner
        @path_to_error_log = Regexp.escape path_to_error_log
      end

      def matches?(resource)
        @resource = resource
        @path = @resource.name

        @actual_content = ChefSpec::Renderer.new(@runner, @resource).content
        is_created? and @actual_content=~/server \{[^}]+access_log #{@path_to_error_log};/m
      end

      def failure_message
        message = %Q{expected Nginx to}
        message << " log processed requests to #{@path_to_error_log} in #{@path}\n"
        message << "Instead configuration was:\n"
        message << @actual_content

        message
      end

      private
      def is_created?
        [:create, :create_if_missing].any? { |action| @resource.performed_action?(action) }
      end
    end
  end
end

