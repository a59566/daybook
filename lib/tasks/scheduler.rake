namespace :scheduler do
  desc 'Delete guest users and their associations'
  task :delete_guest_users_and_their_associations => :environment do
    guest_users = User.where(guest: true)
    guest_users.each(&:destroy)
  end

  desc 'Reorder tags'
  task :reorder_tags => :environment do
    ActiveRecord::Base.record_timestamps = false
    User.all.each do |user|
        Tag.transaction do
          user.tags.rank(:display_order).each_with_index do |tag, index|
            tag.update_attribute :display_order_position, index
          end
        end
    end
    ActiveRecord::Base.record_timestamps = true
  end
end
