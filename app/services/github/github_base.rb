class Github::GithubBase
  def user_auth
    # client_id valid till Jun 13 2023
    "my_client_id:#{Rails.application.credentials.github.clinet_id}"
  end

  def github_resp_body(url)
    RestClient.get(url).body
  rescue RestClient::Forbidden # => e
    raise StandardError, 'GITHUB REQUESTS LIMIT REACHED'
  end
end