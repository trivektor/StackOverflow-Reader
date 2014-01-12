module AFNetworkingClient
  
  def initAFNetworkingClient
    AFMotion::Client.build_shared(STACK_EXCHANGE_API_HOST) do
      header 'Accept', 'application/json'
      response_serializer :json
    end
  end
  
end