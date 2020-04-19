namespace :task do
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
