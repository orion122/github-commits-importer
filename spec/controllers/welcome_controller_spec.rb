require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #welcome' do
    subject { get :welcome }
    it { is_expected.to be_successful }
    it { is_expected.to render_template(:welcome) }
  end
end