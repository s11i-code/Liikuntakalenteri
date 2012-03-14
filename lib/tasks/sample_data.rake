require 'faker'

namespace :db do
  desc "user sample data"
  task :populate => :environment do

    Rake::Task['db:reset'].invoke
    create_users
    create_events
    create_friendships

  end
end

def create_users
  @admin_user = User.create!(:email => "satu.salekari@helsinki.fi", :password =>"heihei", :password_confirmation => "heihei", :name => "Satu Eveliina")
  @admin_user.toggle!(:admin)
  @admin_user.toggle!(:approved)

  15.times do |n|
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    @user = User.new(:email => email, :name => name, :password => "password", :password_confirmation => "password")
    @user.toggle!(:approved)
    @user.save
  end

end


def create_events

  @names = %w(Zumba Bodypump Venyttely Bailatino)
  @users = User.find([1, 15, 16])
  @locations = %w(Kumpula Meilahti Viikki Keskusta)
  @users.each do|user|
    20.times do|n|
      start_time = rand(5.weeks).ago
      user.events.create!(:name =>@names[n%4], :start_at => start_time, :end_at => start_time + 1.hour,
        :yol_event_url => "https://yliopistoliikunta.helsinki.fi//yol/webauth/fi/event/viewEvent.do?reservableId=2932927", 
        :location => @locations[n%4])  
      @names.shuffle!
    end
  end
end

def create_friendships
  users = User.all
  user  = User.all.first
  recognising = users[1..8]
  recognisers = users[1..6]
  recognising.each { |recognised| user.recognise!(recognised) }
  recognisers.each { |recogniser| recogniser.recognise!(user) }

end


