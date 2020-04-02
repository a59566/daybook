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
        expect(page).to have_selector '.alert-success', text: '註冊成功, 歡迎使用本網站'
      end
    end

    context 'sign up with invalid email field' do
      before do
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
      end

      context 'with exists email' do
        let!(:user) { FactoryBot.create(:user) }

        before do
          fill_in 'user_email', with: user.email
          click_on '註冊'
        end

        it 'sign up fail ' do
          expect(page).to have_selector '.invalid-feedback', text: '已經被使用'
        end
      end

      context 'with invalid email' do
        before do
          fill_in 'user_email', with: 'email'
          click_on '註冊'
        end

        it 'sign up fail' do
          expect(page).to have_selector '.invalid-feedback', text: '是無效的'
        end
      end

      context 'with blank email' do
        before do
          fill_in 'user_email', with: ''
          click_on '註冊'
        end

        it 'sign up fail' do
          expect(page).to have_selector '.invalid-feedback', text: '不能為空白'
        end
      end
    end

    context 'sign up with fatal password confirmation' do
      before do
        fill_in 'user_email', with: Faker::Internet.email
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password123'
        click_on '註冊'
      end

      it 'sign up with confirmation fail' do
        expect(page).to have_selector '.invalid-feedback', text: '與 密碼 須一致'
      end
    end
  end
end