require 'rails_helper'

RSpec.describe Tag, type: :system do

  before do
    10.times do
      FactoryBot.create(:tag)
    end
  end

  it 'should have tag_1 ~ tag_10 in tag#index' do
    visit tags_url
    10.times do |i|
        expect(page).to have_content "tag_#{i + 1}"
    end
  end
end