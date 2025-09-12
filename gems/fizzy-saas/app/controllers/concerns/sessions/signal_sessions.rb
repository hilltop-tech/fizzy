module Sessions
  module SignalSessions
    extend ActiveSupport::Concern

    included do
      before_action :require_local_auth, only: %i[ new create ]
    end

    private
      def require_local_auth
        head :forbidden
      end
  end
end
