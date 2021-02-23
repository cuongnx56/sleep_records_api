require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:clocks) }
    it { should have_many(:followers).through(:reverse_relationships) }
    it { should have_many(:followed_users).through(:relationships) }
    it { should have_many(:relationships) }
    it { should have_many(:reverse_relationships) }
  end
end
