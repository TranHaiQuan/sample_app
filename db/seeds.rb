User.create!(name: "Quan Tran admin", email: "quantranadmin@gmail.com",
  password: "123456", password_confirmation: "123456", admin: true, activated: true,
  activated_at: Time.zone.now)
User.create!(name: "Tran Hai Quan", email: "tranhaiquan@gmail.com",
  password: "123456", password_confirmation: "123456",  activated: true, activated_at: Time.zone.now)
50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "123456"
  password_confirmation = "123456"
  User.create!(name: name, email: email, password: password,
    password_confirmation: password_confirmation,  activated: true, activated_at: Time.zone.now)
end
