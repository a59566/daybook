require 'rails_helper'

RSpec.describe User, type: :system do
  describe 'sign up' do
    before do
      visit users_sign_up_url
    end

    context 'sign up with valid email and password' do
      before do
        fill_in 'user_email', with: Faker::Internet.email
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_on '註冊'
      end

      it 'sign up success' do
        expect(page).to have_selector '.alert_success', text: '註冊成功, 歡迎使用本網站'
      end
    end
  end
end