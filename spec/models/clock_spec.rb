require 'rails_helper'

RSpec.describe Clock, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end
end
