# Source: https://docs.emailrep.io/
class EmailRepGateway
  include Dry::Monads::Result::Mixin

  SERVICE_HTTP = {
    uri: ENV['RAILS_EMAIL_REP_URL'],
    versions: {
      v1: ''
    },
    resource_urls: {
      v1: {
        get_email_rep: ':email',
      }
    }
  }

  # Eg call: EmailRepGateway.new.get_email_rep(email: 'test@mail.com')
  def get_email_rep(version = :v1, email:)
    service_url(version, SERVICE_HTTP[:resource_urls][version.to_sym][:get_email_rep], email: email)
      .fmap(method(:get_request))
      .bind(method(:marshal_response))
  end

  ##
  # Private area
  private

  def build_resource_url(resource, **resource_params)
    dynamic_param_identifier = ':'

    resource
      .split('/')
      .map{ |param| param.start_with?(dynamic_param_identifier) ? resource_params[param.parameterize.to_sym] : param }
      .join('/')
  end

  def service_url(version, resource, **resource_params)
    resource_url = build_resource_url(resource, **resource_params)

    Success(URI.join(URI.parse(SERVICE_HTTP[:uri]),
                     SERVICE_HTTP[:versions][version.to_sym],
                     resource_url))
  end

  # When calling `get_request` in a chain like `.fmap(method(:get_request).curry...`
  # you must specify the number of arguments for `curry` because it's got an optional
  # parameter (`headers = {}`)
  # Eg:
  #  .fmap(method(:get_request).curry(2).call(form_data))
  #  .fmap(method(:get_request).curry(3).call(form_data, headers))
  def get_request(params = {}, headers = {}, request_url)
    default_headers = {
      "Content-Type" => 'application/json'
    }

    HTTParty
      .get(request_url, headers: default_headers.merge(headers), query: params)
  end

  def marshal_response(response)
    Rails.logger.debug response&.body
    Rails.logger.debug response.code

    if [200, 201, 202].include?(response.code)
      Success(response.parsed_response)
    else
      Failure(error: :bad_response, response: response.parsed_response)
    end
  end
end
