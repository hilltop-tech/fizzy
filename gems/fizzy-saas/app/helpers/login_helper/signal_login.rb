module LoginHelper
  module SignalLogin
    def login_url
      if ApplicationRecord.current_tenant
        Launchpad.login_url(product: true, account: Account.sole)
      else
        Launchpad.login_url(product: true)
      end
    end

    def logout_url
      Launchpad.logout_url
    end
  end
end
