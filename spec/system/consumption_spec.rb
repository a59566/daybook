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

      context '近五日消費' do
        let(:recent_5_days_consumptions) {Consumption.find_by_sql("
          SELECT date, SUM(amount)
          FROM consumptions
          WHERE date BETWEEN '#{Date.today - 5}' AND '#{Date.today - 1}'
          GROUP BY date
          ORDER BY date DESC")}
        let(:table_row) { all('#recent_5_days_consumptions tbody tr') }

        it 'have recent 5 days consumptions' do
          recent_5_days_consumptions.each_with_index  do |recent_consumption, i|
            expect(table_row[i]).to have_content "#{recent_consumption.date}"
            expect(table_row[i]).to have_content "#{recent_consumption.sum}"
          end
        end
      end

      context '本月目前消費' do
        let(:this_month_amount) { Consumption.find_by_sql("
          SELECT SUM(amount)
          FROM consumptions
          WHERE date BETWEEN '#{Date.today.at_beginning_of_month}' AND '#{Date.today.at_end_of_month}'") }

        it 'has this month amount' do
          expect(page).to have_content this_month_amount.first.sum
        end
      end

      context '最新五筆消費' do
        let(:recent_5_consumptions) {Consumption.includes(:tag).find_by_sql("
          SELECT *
          FROM consumptions
          ORDER BY consumptions.date
          DESC LIMIT 5 OFFSET 0")}
        let(:table_row) { all('#recent_5_consumptions tbody tr') }

        it 'has recent 5 consumptions' do
          recent_5_consumptions.each_with_index do |recent_consumption, i|
            expect(table_row[i]).to have_content "#{recent_consumption.date}"
            expect(table_row[i]).to have_content "#{recent_consumption.detail}"
            expect(table_row[i]).to have_content "#{recent_consumption.amount}"
            expect(table_row[i]).to have_content "#{recent_consumption.tag.name}"
            expect(table_row[i]).to have_link '編輯', href: edit_consumption_path(recent_consumption)
            expect(page).to have_selector "a[data-method=delete][href='#{consumption_path(recent_consumption)}']", text: '刪除'
          end
        end
      end
    end

    context 'when login with user_b' do
      let(:login_user) { user_b }

      context '近五日消費' do
        let(:table_row) { all('#recent_5_days_consumptions tbody tr') }

        it 'has no recent 5 days consumptions' do
          expect(table_row.count).to equal 0
        end
      end

      context '本月目前消費' do
        it 'this month amount equal 0' do
          expect(page).to have_content '本月目前消費: 0'
        end
      end

      context '最新五筆消費' do
        let(:table_row) { all('#recent_5_consumptions tbody tr') }

        it 'has no recent 5 consumptions' do
          expect(table_row.count).to equal 0
        end
      end
    end
  end

  describe '新增消費'  do
    let(:login_user) { user_a }
    let!(:tag) {FactoryBot.create(:tag, user: user_a)}

    before do
      visit consumptions_url
      click_on '新增消費'
      fill_in '明細', with: detail
      fill_in '金額', with: amount
      fill_in '日期', with: date
      select tag.name, from: '標籤'
      click_on '新增消費'
    end

    context 'fill all field' do
      let(:detail) { 'test' }
      let(:amount) { 1000 }
      let(:date) { Date.today }

      it 'add consumption success' do
        expect(page).to have_content '新增成功'
      end
    end

    context 'blank field' do
      let(:detail) {  }
      let(:amount) { }
      let(:date) { }

      it 'add consumption fail' do
        expect(page).to have_selector '.alert-danger', text: '明細 不能為空白'
        expect(page).to have_selector '.alert-danger', text: '金額 不能為空白'
        expect(page).to have_selector '.alert-danger', text: '金額 不是數字'
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
      click_on '編輯'
      fill_in '明細', with: detail
      fill_in '金額', with: amount
      fill_in '日期', with: date
      select tag.name, from: '標籤'
      click_on '更新消費'
    end

    context 'edit field with valid value' do
      let(:detail) { 'consumption' }
      let(:amount) { 500 }
      let(:date) { Date.today - 1 }
      let(:tag) { tag_2 }

      it 'update success' do
        expect(page).to have_content '更新成功'
        expect(page).to have_content "#{Date.today - 1}"
        expect(page).to have_content 'consumption'
        expect(page).to have_content '500'
        expect(page).to have_content tag_2.name
      end
    end

    context 'edit field with invalid value' do
      let(:detail) {  }
      let(:amount) { }
      let(:date) { }
      let(:tag) { tag_2 }

      it 'update fail' do
        expect(page).to have_selector '.alert-danger', text: '明細 不能為空白'
        expect(page).to have_selector '.alert-danger', text: '金額 不能為空白'
        expect(page).to have_selector '.alert-danger', text: '金額 不是數字'
      end
    end
  end

  describe '刪除消費' do
    let(:login_user) { user_a }
    let!(:tag_1) { FactoryBot.create(:tag, user: user_a) }
    let!(:consumption) { FactoryBot.create(:consumption, tag: tag_1, user: user_a) }

    it 'consumption_1 be deleted' do
      visit consumptions_url
      click_on '刪除'
      alert = page.driver.browser.switch_to.alert
      alert.accept
      expect(page).to have_content '刪除成功'
    end
  end
end