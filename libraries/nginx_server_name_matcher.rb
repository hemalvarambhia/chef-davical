if defined?(ChefSpec)
  module ChefSpec::Matchers
    class NginxServerNameMatcher
      def initialize(runner, server_names)
        @server_names = server_names
        @runner = runner
      end

      def matches?(resource)
        @resource = resource
        @path = @resource.name

        is_created? and has_correct_server_names?
      end

      def failure_message
        message = %Q{expected Chef run to}
        message << " set server names to #{@server_names.join(", ")} in #{@path}\n"
        message << "Instead, content was\n"
        message << "#{@actual_content}"

        message
      end

      private
      def is_created?
        [:create, :create_if_missing].any?{ |action| @resource.performed_action?(action) }
      end

      def has_correct_server_names?
        escaped_server_names = @server_names.collect{|server_name| Regexp.escape server_name}
        @expected_content = /server \{[^}]+server_name #{escaped_server_names.join(" ")};/m
        @actual_content = ChefSpec::Renderer.new(@runner, @resource).content

        return false if @actual_content.nil?

        @actual_content =~ @expected_content
      end
    end
  end
end