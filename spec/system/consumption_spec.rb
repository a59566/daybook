require 'rails_helper'

RSpec.describe Consumption, type: :system do
  let!(:user_a) { FactoryBot.create(:user) }
  let!(:user_b) { FactoryBot.create(:user) }

  before do
    visit new_user_session_url
    fill_in 'user_email', with: login_user.email
    fill_in 'user_password', with: login_user.password
    click_on '登入'
  end

  describe '消費一覽' do
    before do
      10.times do |n|
        tag = FactoryBot.create(:tag, user: user_a)
        FactoryBot.create(:consumption, tag: tag, user: user_a)
      end
      visit consumptions_url
    end

    context 'when login with user_a' do
      let(:login_user) { user_a }

      context '本月目前消費' do
        let(:this_month_amount) do
          Consumption.find_by_sql("
          SELECT SUM(amount)
          FROM consumptions
          WHERE date BETWEEN '#{Date.today.at_beginning_of_month}' AND '#{Date.today.at_end_of_month}'")
        end

        it 'has this month amount' do
          expect(page).to have_content this_month_amount.first.sum
        end
      end
    end

    context 'when login with user_b' do
      let(:login_user) { user_b }

      context '本月目前消費' do
        it 'this month amount equal 0' do
          expect(page).to have_content '本月目前消費: 0'
        end
      end
    end
  end

  describe '新增消費' do
    let(:login_user) { user_a }
    let!(:tag) { FactoryBot.create(:tag, user: user_a) }

    before do
      visit consumptions_url
      click_on '新增消費'
    end

    context 'fill all field' do
      it 'add consumption success' do
        fill_in '明細', with: 'test'
        fill_in '金額', with: 1000
        fill_in '日期', with: Date.today
        select tag.name, from: '標籤'
        click_on '新增消費'

        expect(page).to have_content '新增成功'
      end
    end

    context 'blank field' do
      it 'add consumption fail' do
        click_on '新增消費'

        error_message_nodes = all('.invalid-feedback')
        expect(error_message_nodes[0]).to have_content '不能為空白'
        expect(error_message_nodes[1]).to have_content '不能為空白,不是數字'
        expect(error_message_nodes[2]).to have_content '不能為空白,是無效的'
      end
    end
  end

  describe '編輯消費' do
    let(:login_user) { user_a }
    let!(:tag_1) { FactoryBot.create(:tag, user: user_a) }
    let!(:tag_2) { FactoryBot.create(:tag, user: user_a) }
    let!(:consumption) { FactoryBot.create(:consumption, tag: tag_1, user: user_a) }

    before do
      visit consumptions_url
      find(:css, 'i.far.fa-edit').click
    end

    context 'edit field with valid value' do
      it 'update success' do
        fill_in '明細', with: 'consumption'
        fill_in '金額', with: 500
        fill_in '日期', with: Date.today - 1
        select tag_2.name, from: '標籤'
        click_on '更新消費'

        expect(page).to have_content '更新成功'
        expect(page).to have_content "#{Date.today - 1}"
        expect(page).to have_content 'consumption'
        expect(page).to have_content '500'
        expect(page).to have_content tag_2.name
      end
    end

    context 'edit field with invalid value' do
      it 'update fail' do
        fill_in '明細', with: nil
        fill_in '金額', with: nil
        select '', from: '標籤'
        click_on '更新消費'

        error_message_nodes = all('.invalid-feedback')
        expect(error_message_nodes[0]).to have_content '不能為空白'
        expect(error_message_nodes[1]).to have_content '不能為空白,不是數字'
        expect(error_message_nodes[2]).to have_content '不能為空白,是無效的'
      end
    end
  end

  describe '刪除消費' do
    let(:login_user) { user_a }
    let!(:tag_1) { FactoryBot.create(:tag, user: user_a) }
    let!(:consumption) { FactoryBot.create(:consumption, tag: tag_1, user: user_a) }

    it 'consumption_1 be deleted' do
      visit consumptions_url
      find(:css, 'i.far.fa-trash-alt').click
      click_button '確認'

      expect(page).to_not have_selector '.delete'
    end
  end
end