module User::SignalUser
  extend ActiveSupport::Concern

  prepended do
    belongs_to :signal_user, dependent: :destroy, class_name: "SignalId::User", optional: true
  end

  def deactivate
    super
    SignalId::Database.on_master { signal_user&.destroy }
  end
end
