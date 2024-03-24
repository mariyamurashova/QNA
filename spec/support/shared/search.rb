shared_examples_for 'has searching content' do
  it 'populates an array of all items with given parameters' do  
    expect(assigns(:result)).to match_array(results) 
  end

  it 'it returns status 200' do 
    expect(response).to have_http_status(:ok)
  end
end

shared_examples_for 'has not searching content' do
  it 'returns empty collection' do  
    expect(assigns(:result)).to match_array([ ]) 
  end

  it 'it returns status 200' do 
    expect(response).to have_http_status(:ok)
  end
end
