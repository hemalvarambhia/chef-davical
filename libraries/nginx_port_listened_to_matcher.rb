if defined?(ChefSpec)
  module ChefSpec::Matchers
    class NginxPortListenedToMatcher
      def initialize(runner, port)
        @runner = runner
        @port = Regexp.escape port
      end

      def matches?(resource)
        @resource = resource
        @path = @resource.name

        actual_content = ChefSpec::Renderer.new(@runner, @resource).content
        is_created? and actual_content=~/server \{[^}]+listen #{@port};/m
      end

      def failure_message
        message = %Q{expected Chef run to configure nginx to }
        message << " listen to port #{@port} in #{@path}"

        message
      end

      private
      def is_created?
        [:create, :create_if_missing].any? { |action| @resource.performed_action?(action) }
      end
    end
  end
end
