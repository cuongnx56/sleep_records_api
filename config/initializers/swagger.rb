GrapeSwaggerRails.options.app_name      = 'Sleep App'
GrapeSwaggerRails.options.url           = '/api/v1/swagger_doc.json'
# GrapeSwaggerRails.options.api_key_name  = 'access_token'
GrapeSwaggerRails.options.doc_expansion = 'list'
# GrapeSwaggerRails.options.display_request_duration = true
# GrapeSwaggerRails.options.filter = true

GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end

# GrapeSwaggerRails.options.headers['Special-Header'] = 'Some Secret Value'
