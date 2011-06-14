namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    firstuser = User.create!(:name => "Example User",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    firstuser.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    
    # make 50 log entries for the first 6 users
    r = r = Random.new(Time.now.to_i)
  
    User.all(:limit => 6).each do |user|
      50.times do |x|
         start_time = (100*x).minutes.ago
         end_time = start_time + r.rand(60...60*90)   # use random time length between a minute and 1.5 hours
         n = r.rand(1...10) # random number of night drives
         attr = {
          :notes => Faker::Lorem.sentence(5),
          :start_time => start_time,
          :end_time => end_time,
          :night => (x%n == 0)
         }
        user.log_entries.create!(attr)  
      end
    end
  end
end
