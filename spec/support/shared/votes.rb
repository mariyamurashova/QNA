shared_examples_for 'available to vote' do
  before { login(user) }

  it "saves a new question's/answer's vote in the datebase" do 
    expect { post :vote, params: params } .to change(resource.votes, :count).by(1)
  end

  it 'returns success status' do  
    post :vote, params: params 
    expect(response).to have_http_status(:success)
  end
end

shared_examples_for 'NOT available to vote' do
  before { login(author) }

  it "doesn't save a new question's/answer's vote in the datebase" do 
    expect { post :vote, params: params }.to change(question.votes, :count).by(0)
  end

  it 'returns forbidden status' do  
    post :vote, params: params
    expect(response).to have_http_status(:forbidden)
  end
end

shared_examples_for 'can delete the vote' do
  before { login(user) }
  it "deletes the vote from question" do 
    expect { delete :destroy, params: params, format: :json }.to change(Vote, :count).by(-1)
  end

  it 'returns success status' do  
    delete :destroy, params: params, :format => :json 
    expect(response).to have_http_status(:success)
  end
end

shared_examples_for 'can not delete the vote' do
  before { login(new_user) }
  it "doesn't delete the vote from question" do 
    expect { delete :destroy, params: params, format: :json }.to change(Vote, :count).by(0)
  end

  it 'returns error status' do  
    delete :destroy, params:params, :format => :json  
    expect(response).to have_http_status(:forbidden)
  end
end

shared_examples_for 'not unique vote' do
  it 'can votes just once' do
    vote = create :vote, user: user, vottable: resource
    new_vote = build :vote, user: user, vottable: resource

    new_vote.valid?

    expect(new_vote.errors[:user]).to include "you couldn't vote twice"
  end
end

shared_examples_for 'author cannot vote' do
  let!(:user) { create :user }
  let!(:author) { create :user }
  let!(:vote) {  build :vote, user: author, vottable: resource }
  
  it "not_author" do
    vote.author_of_resource
    expect(vote.errors.full_messages).to include("User You couldn't vote for your #{resource.class.name.downcase}")
  end
end
