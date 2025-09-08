if defined?(Searchkick)
  begin
    if ENV["ELASTICSEARCH_URL"].present?
      Searchkick.client = Elasticsearch::Client.new(
        url: ENV["ELASTICSEARCH_URL"],
        transport_options: { request: { timeout: 250 } }
      )
      Searchkick.client.ping
      Rails.configuration.x.elasticsearch_available = true
    else
      Rails.configuration.x.elasticsearch_available = false
    end
  rescue => e
    Rails.logger.warn "Elasticsearch unavailable: #{e.message}"
    Rails.configuration.x.elasticsearch_available = false
  end
end
