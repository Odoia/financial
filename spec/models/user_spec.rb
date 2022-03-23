require 'rails_helper'

describe :User do
  let(:user) { FactoryBot.create(:user) }

  before do
     I18n.default_locale = :en
  end

  context 'When use a User model' do
    context 'When register a new user' do
      context 'When register a 2 equal user email' do
        it 'should be return a email unique message' do
          user
          expect(FactoryBot.create(:user, email: user.email)).to eq 'email in use'

        end
      end
    end
  end
end
