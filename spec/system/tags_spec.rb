require 'rails_helper'

RSpec.describe Tag, type: :system do
  let!(:user_a) { FactoryBot.create(:user) }
  let!(:user_b) { FactoryBot.create(:user) }

  before do
    visit new_user_session_url
    fill_in 'user_email', with: login_user.email
    fill_in 'user_password', with: login_user.password
    click_on '登入'
  end

  describe '標籤一覽' do
    let!(:user_a_tag) { FactoryBot.create(:tag, user: user_a) }

    context 'when login with user_a' do
      let(:login_user) { user_a }

      it 'has user_a_tag' do
        visit tags_url

        expect(page).to have_content "#{user_a_tag.name}"
      end
    end

    context 'when login with user_b' do
      let(:login_user) { user_b }

      it 'has no user_a_tag' do
        visit tags_url

        expect(page).to have_no_content "#{user_a_tag.name}"
      end
    end
  end

  describe '新增標籤' do
    let(:login_user) { user_a }

    before do
      visit tags_url
      click_on '新增標籤'
      fill_in '名稱', with: tag_name
      click_on '新增標籤'
    end

    context 'has tag name' do
      let(:tag_name) { 'tag' }

      it 'add tag success' do
        expect(page).to have_selector '.alert-success', text: '[tag]標籤新增成功'
      end
    end

    context 'without tag name' do
      let(:tag_name) { '' }

      it 'add tag failed' do
        expect(page).to have_selector '.invalid-feedback', text: '不能為空白'
      end
    end
  end

  describe '編輯標籤' do
    let(:login_user) { user_a }
    let!(:user_a_tag) { FactoryBot.create(:tag, user: user_a) }

    it 'change user_a_tag name to "tag"' do
      visit tags_url
      find(:css, 'i.far.fa-edit').click
      fill_in '名稱', with: 'tag'
      click_on '更新標籤'

      expect(page).to have_selector '.alert-success', text: '[tag]標籤更新成功'
    end
  end

  describe '刪除標籤' do
    let(:login_user) { user_a }
    let!(:user_a_tag) { FactoryBot.create(:tag, user: user_a) }

    it 'user_a_tag be deleted' do
      visit tags_url
      click_link class: 'delete'
      click_button '確認'

      expect(page).to_not have_selector '.delete', text: user_a_tag.name
    end
  end
end