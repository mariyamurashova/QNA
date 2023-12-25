require 'rails_helper'

shared_examples_for "vottable" do
  
  it { should have_many(:votes).dependent(:delete_all) }
end

