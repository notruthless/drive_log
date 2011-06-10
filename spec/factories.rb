# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Ruth Helfinstein"
  user.email                 "rh55@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :log_entry do |entry|
  entry.notes "Foo bar"
  entry.association :user
end