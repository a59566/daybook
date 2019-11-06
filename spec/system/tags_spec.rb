require 'rails_helper'

RSpec.describe Tag, type: :system do

  # before do
  #   10.times do
  #     FactoryBot.create(:tag)
  #   end
  # end


  it 'should have 10 tags in tag#index' do
    visit tags_url
    expect(page).to have_content 'tag_9'
  end
end