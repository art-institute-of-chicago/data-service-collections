# Make errors display nicely
module ErrorFormatter
  def self.call(message, backtrace, options, env)
    {
      # TODO: At some point we can add an :id representing the unique instance of an error
      # and a :code represneting our own convention of identifying errors
      status: env[Grape::Env::API_ENDPOINT].status,
      error: (message.is_a? String) ? message : message[:error],
      detail: (message.is_a? String) ? nil : message[:detail]
    }.to_json
  end
end
