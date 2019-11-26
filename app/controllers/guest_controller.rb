class GuestController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new]

  def new
    guest_user = create_guest_user

    create_template_data(guest_user)

    sign_in_and_redirect(guest_user, scope: :user)
  end

  def destroy
    guest_users = User.where(guest: true)
    guest_users.each(&:destroy)
    redirect_to(root_path)
  end

  private
    def create_guest_user
      email = Faker::Internet.email
      password = Devise.friendly_token.first(8)

      User.create!(email: email, password: password, guest: true)
    end

    def create_template_data(guest_user)
      # create tags
      template_tag_names = %w(正餐 飲料 零食 生活 其他)
      template_tags = {}

      5.times do |i|
        tag_name = template_tag_names[i]
        template_tags[tag_name] = guest_user.tags.new(name: tag_name, display_order: i)
      end

      guest_user.tags.import!(template_tags.values)

      # create consumptions
      # consumption samples
      drinks = { '烏龍綠'=> 30, '多多綠'=> 40, '珍奶'=> 65}
      snacks = { '銅鑼燒'=> 79, '蘇打餅'=> 65,  '巧克力'=> 35, '可樂果'=> 25, '卡迪那薯條'=> 68}
      lives = { '衛生紙'=> 110, '沐浴乳'=> 179, '洗髮乳'=> 135, '洗面乳'=> 99 }
      others = { '耳機'=> 3250, '遊戲'=> 1540 }

      # new consumptions by tag with probability
      15.times do |i|
        consumption_date = Date.today.prev_day(i)
        new_template_consumption(guest_user, template_tags['正餐'], nil, consumption_date, nil)
        new_template_consumption(guest_user, template_tags['飲料'], drinks, consumption_date, 60)
        new_template_consumption(guest_user, template_tags['零食'], snacks, consumption_date, 40)
        new_template_consumption(guest_user, template_tags['生活'], lives, consumption_date, 20)
        new_template_consumption(guest_user, template_tags['其他'], others, consumption_date, 5)
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
