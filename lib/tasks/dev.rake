namespace :dev do

  # 快速一個指令重建 rails dev:rebuild
  # event_series 生成後，伴隨生成 event
  task rebuild: [
    "db:drop",
    "db:create",
    "db:migrate",
    "db:seed",
    :fake_user,
    :fake_event_series
    ]

  # Test in irb > require 'ffaker'
  task fake_user: :environment do
    # 尚未建立 child records 時，關聯刪除會報錯，對應方法如下
    # user model has_many :event_series on condition 設定條件回呼或先關閉 dependent: :destroy
    User.where.not(role: "admin").destroy_all

    20.times do
      username = FFaker::Name.unique.last_name
      User.create!(
        name: username,
        email: "#{username}@example.com",
        password: "12345678",
        intro: FFaker::Lorem.paragraph.first(130),
        title: FFaker::Job.title,
        website: FFaker::Internet.http_url,
        share_class_count: [*5..30].sample
      )
    end
    puts "created fake users"
    puts "now you have #{User.count} users data"
  end

  # 回呼 after_create，config/initializers/constants.rb END_TIME 設定
  task fake_event_series: :environment do
    EventSeries.destroy_all

    5.times do
      user = User.all.sample
      beginning = FFaker::Time.between(1.years.ago, Date.today + 1.years)
      event_series = user.event_series.create(
        title: FFaker::Book.title,
        event_type: ["subject","exam","todo"].sample,
        grade: [*1..12].sample.to_s,
        class_name: [*1..10].sample.to_s,
        students: [*20..30].sample,
        period: ["Daily","Weekly","Monthly","Yearly"].sample,
        starttime: beginning,
        endtime: FFaker::Time.between(beginning, beginning + 1.hour),
        color: ["blue","yellow","red"].sample
      )
    end
    puts "have created fake event_series"
    puts "now you have #{EventSeries.count} event_series data"
  end
end