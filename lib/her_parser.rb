require "her_parser/version"

module HerParser
  
  class Response < Faraday::Response::Middleware

    def on_complete(env)
      json = MultiJson.load(env[:body]) rescue {}

      if env.status >= 200 && env.status < 300
        if json['collection']
          env[:body] = {
            data: json['collection'],
            errors: json['errors'],
            metadata: json['metadata']
          }
        else
          env[:body] = {
            data: json,
            errors: [],
            metadata: {},
          }
        end
      elsif env.status == 422
        env[:body] = {
            data: {},
            errors: json,
            metadata: {},
          }
      end
    end

  end

end
