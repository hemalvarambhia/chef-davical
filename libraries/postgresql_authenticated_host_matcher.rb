if defined?(ChefSpec)
  module ChefSpec::Matchers
    class PostgresqlAuthenticatedHostMatcher
      def initialize(runner, username, policy = "trust")
        @runner = runner
        @username = username
        @policy = policy
      end

      def matches?(resource)
        @resource = resource
        @path = @resource.name

        @actual_content = ChefSpec::Renderer.new(@runner, @resource).content

        @actual_content=~/local   #{@database}    #{@username}   #{@policy}/
      end

      def failure_message
        failure_message = "Expected postgresql to #{@policy} #{@username} with database #{@database}\n"
        failure_message << "Instead, got:\n"
        failure_message << @actual_content

        failure_message
      end

      def with_database(database)
        @database = database

        self
      end

    end
  end
end
