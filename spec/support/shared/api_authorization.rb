shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
   it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401      
    end
  end 
end

shared_examples_for 'successful response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'NOT successful response' do
  it 'returns 403 status' do
    expect(response).to_not be_successful
  end
end

shared_examples_for 'returns public fields' do
  it 'returns public fields' do
    attributes.each do |attr|
      resource.reload
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

