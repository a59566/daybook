namespace :scheduler do
  desc 'Delete guest users and their associations'
  task :delete_guest_users_and_their_associations => :environment do
    guest_users = User.where(guest: true)
    guest_users.each(&:destroy)
  end
end
