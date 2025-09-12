module Bootstrap
  def self.local_authentication?
    ENV.fetch("LOCAL_AUTHENTICATION", "") != "" || !File.directory?(File.expand_path("../gems/fizzy-saas", __dir__))
  end
end
