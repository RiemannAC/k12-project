namespace :dev do

  # 快速一個指令重建 rails dev:rebuild
  # event_series 生成後，伴隨生成 event
  task rebuild: [
    "db:drop",
    "db:create",
    "db:migrate",
    "db:seed",
    :fake_user
    ]

  # Test in irb > require 'ffaker'
  task fake_user: :environment do
    # 尚未建立 child records 時，關聯刪除會報錯，對應方法如下
    # user model has_many :event_series on condition 設定條件回呼或先關閉 dependent: :destroy
    User.where.not(role: "admin").destroy_all

    5.times do
      username = FFaker::Name.unique.last_name
      User.create!(
        name: username,
        email: "#{username}@example.com",
        password: "12345678",
        intro: FFaker::Lorem.paragraph.first(130),
        job_title: FFaker::Job.title,
        website: FFaker::Internet.http_url,
        share_class_count: [*5..30].sample
      )
    end
    puts "created fake users"
    puts "now you have #{User.count} users data"
  end
end
