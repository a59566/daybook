require 'rails_helper'

RSpec.describe Tag, type: :system do
  describe '標籤一覽' do
    before do
      10.times do
        FactoryBot.create(:tag)
      end
    end

    it 'has tag_1 ~ tag_10' do
      visit tags_url
      10.times do |i|
        expect(page).to have_content "tag_#{i + 1}"
      end
    end
  end

  describe '新增標籤' do
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
        expect(page).to have_content '名稱 不能為空白'
      end
    end
  end

  describe '編輯標籤' do
    before do
      FactoryBot.create(:tag, name: 'tag_1')
    end

    it 'change tag name from tag_1 to tag' do
      visit tags_url
      click_on '編輯'
      fill_in '名稱', with: 'tag'
      click_on '更新標籤'

      expect(page).to have_selector '.alert-success', text: '[tag]標籤更新成功'
    end
  end

  describe '刪除標籤' do
    before do
      FactoryBot.create(:tag, name: 'tag_1')
    end

    it 'tag_1 be deleted' do
      visit tags_url
      click_on '刪除'
      alert = page.driver.browser.switch_to.alert
      alert.accept

      expect(page).to have_selector '.alert-success', text: '[tag_1]標籤刪除成功'
    end
  end
end