require 'rails_helper'

RSpec.describe 'Session', type: :system do
  describe 'sign in' do
    before do
      visit sign_in_url
    end

    context 'sign in success with exists user' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_on '登入'
      end

      it 'sign in success' do
        expect(page).to have_selector '.alert-success', text: '登入成功'
      end
    end

    context 'sign in fail with exists user' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: ''
        click_on '登入'
      end

      it 'password error' do
        expect(page).to have_selector '.invalid-feedback', text: '密碼錯誤'
      end
    end

    context 'sign in fail with no exists user' do
      before do
        fill_in 'user_email', with: Faker::Internet.email
        fill_in 'user_password', with: ''
        click_on '登入'
      end

      it 'no user error' do
        expect(page).to have_selector '.invalid-feedback', text: '沒有此使用者'
      end
    end
  end
end