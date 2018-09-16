namespace :dev do

  # 快速一個指令重建 rails dev:rebuild
  # event_series 生成後，伴隨生成 event
  task rebuild: [
    "db:drop",
    "db:create",
    "db:migrate",
    "db:seed",
    :fake_user,
    :fake_project,
    :fake_subject
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

  task fake_project: :environment do
    Project.destroy_all

    User.all.each do |user|
      # Range
      first_semester = Time.mktime(Time.now.year,8,1)..Time.mktime(Time.now.year + 1,1,15)
      second_semester = Time.mktime(Time.now.year + 1,2,15)..Time.mktime(Time.now.year + 1,7,1)
      semesters = [first_semester, second_semester]

      semesters.each do |semester|
        
        project = user.projects.create(
          start_week: semester.first,
          end_week:semester.last
        )
      end
    end
    puts "have created fake projects"
    puts "now you have #{Project.count} projects data"
  end

  # 回呼 after_create，config/initializers/constants.rb END_TIME 設定
  task fake_subject: :environment do
    Subject.destroy_all

    User.all.each do |user|
      project = user.projects.sample
      beginning = FFaker::Time.between(1.years.ago, Date.today + 1.years)
      subject = project.subjects.create(
        name: FFaker::Book.title,
        event_type: ["lesson","exam","todo"].sample,
        grade: [*1..12].sample.to_s,
        classroom: [*1..10].sample.to_s,
        students: [*20..30].sample,
        period: ["Daily","Weekly","Monthly","Yearly"].sample,
        start_time: beginning,
        end_time: FFaker::Time.between(beginning, beginning + 1.hour),
        color: ["blue","yellow","red"].sample
      )
    end
    puts "have created fake subjects"
    puts "now you have #{Subject.count} subjects data"
  end
end
