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

    NAMES = ["liberal", "science", "general"]
    NAMES.each do |name|
      User.create!(
        name: name,
        email: "#{name}@example.com",
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


  task fake_classroom: :environment do
    Classroom.destroy_all

    CLASSROOMS = { name: ["1年一班", "2年二班", "3年三班", "4年四班", "5年五班", "6年六班", "7年特班"], grade: ["1年", "2年", "3年", "4年", "5年", "6年", "7年"], room: ["一班", "二班", "三班", "四班", "五班", "六班", "特班"]}
    for i in 0..2
      user = User.where(name: "liberal").first
      user.classrooms.create!(
        name: CLASSROOMS[:name][i],
        grade: CLASSROOMS[:grade][i],
        room: CLASSROOMS[:room][i],
        student: [*20..30].sample
      )
    end
    for i in 3..5
      user = User.where(name: "science").first
      user.classrooms.create!(
        name: CLASSROOMS[:name][i],
        grade: CLASSROOMS[:grade][i],
        room: CLASSROOMS[:room][i],
        student: [*20..30].sample
      )
    end
    user = User.where(name: "general").first
    user.classrooms.create!(
      name: CLASSROOMS[:name][6],
      grade: CLASSROOMS[:grade][6],
      room: CLASSROOMS[:room][6],
      student: [*20..30].sample
    )
    puts "created fake classrooms"
    puts "now you have #{Classroom.count} classrooms data"
  end

end
