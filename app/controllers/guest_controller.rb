class GuestController < ApplicationController
  skip_before_action :sign_in_required, only: [:new]

  def new
    if !current_user
      guest_user = create_guest_user
      create_template_data(guest_user)

      session[:user_id] = guest_user.id
      flash[:show_guest_notice] = true
    end

    redirect_to consumptions_url
  end

  private
    def create_guest_user
      email = Faker::Internet.email
      password = Faker::Internet.password

      User.create!(email: email, password: password, guest: true)
    end

    def create_template_data(guest_user)
      # create tags
      template_tag_names = %w(正餐 飲料 零食 生活)
      template_tags = {}

      template_tag_names.each_with_index do |tag_name, index|
        template_tags[tag_name] = guest_user.tags.new(name: tag_name, display_order: index * 1000)
      end

      guest_user.tags.import!(template_tags.values)

      # create consumptions
      # consumption samples
      drinks = { '烏龍綠'=> 30, '多多綠'=> 40, '珍奶'=> 65}
      snacks = { '銅鑼燒'=> 79, '蘇打餅'=> 65,  '巧克力'=> 35, '可樂果'=> 25, '卡迪那薯條'=> 68}
      lives = { '衛生紙'=> 110, '沐浴乳'=> 179, '洗髮乳'=> 135, '洗面乳'=> 99 }

      # new consumptions by tag with probability
      15.times do |i|
        consumption_date = Date.today.prev_day(i)
        new_template_consumption(guest_user, template_tags['正餐'], nil, consumption_date, nil)
        new_template_consumption(guest_user, template_tags['飲料'], drinks, consumption_date, 60)
        new_template_consumption(guest_user, template_tags['零食'], snacks, consumption_date, 40)
        new_template_consumption(guest_user, template_tags['生活'], lives, consumption_date, 20)
      end

      guest_user.consumptions.import!(guest_user.consumptions.to_a)
    end

    def new_template_consumption(user, tag, consumption_samples, date, probability)
      if tag.name == '正餐'
        user.consumptions.new(detail: '早餐', amount: rand(50..150), date: date, tag: tag)
        user.consumptions.new(detail: '午餐', amount: rand(50..150), date: date, tag: tag)
        user.consumptions.new(detail: '晚餐', amount: rand(50..150), date: date, tag: tag)
      else
        if rand > 1.0 - probability / 100.0
          tag_sample = consumption_samples.to_a.sample
          user.consumptions.new(detail: tag_sample[0], amount: tag_sample[1], date: date, tag: tag)
        end
      end
    end
end
