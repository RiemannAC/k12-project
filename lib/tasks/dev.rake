namespace :dev do

  # 快速一個指令重建 rails dev:rebuild
  # event_series 生成後，伴隨生成 event
  task rebuild: [
    "db:drop",
    "db:create",
    "db:migrate",
    "db:seed",
    :fake_user,
    :fake_classroom,
    :fake_subject,
    :fake_lesson_00,
    :fake_lesson_01,
    :fake_lesson_02,
    :fake_lesson_10,
    :fake_lesson_11,
    :fake_lesson_12,
    :fake_lesson_20,
    :fake_lesson_21,
    :fake_lesson_22,
    :fake_lesson_23,
    :fake_lesson_24,
    :fake_lesson_25,
    :fake_topic,
    :fake_plan,
    :fake_material,
    :fake_teachingfile,
    :fake_aim,
    :fake_addfile
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

  task fake_subject: :environment do
    Subject.destroy_all

    SUBJECTS = ["國文", "英文", "社會", "數學", "自然", "生活科技"]
    for i in 0..2
      user = User.where(name: "liberal").first
      classroom = user.classrooms[i]
      subject = user.subjects.find_or_create_by( name: SUBJECTS[i] )
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end
    for i in 3..5
      user = User.where(name: "science").first
      # 理科教師只有教三班，index 要平移
      classroom = user.classrooms[i - 3]

      subject = user.subjects.find_or_create_by( name: SUBJECTS[i] )
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    user = User.where(name: "general").first
    classroom = user.classrooms[0]
    for i in 0..5
      subject = user.subjects.find_or_create_by( name: SUBJECTS[i] )
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake subjects"
    puts "now you have #{Subject.count} subjects data"
  end

  task fake_lesson_00: :environment do
    # Lesson.destroy_all

    user = User.where(name: "liberal").first
    SUBJECTS00 = ["國文", "英文", "社會"]
    classrooms = [ user.classrooms[0], user.classrooms[1], user.classrooms[2] ]
    # 參數
    subject_name = SUBJECTS00[0]
    # 時間不重疊
    start_time = Time.new(Time.now.year, 7, 2, 8)
    # 參數
    classroom = classrooms[0]
    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_01: :environment do
    # Lesson.destroy_all

    user = User.where(name: "liberal").first
    SUBJECTS01 = ["國文", "英文", "社會"]
    classrooms = [ user.classrooms[0], user.classrooms[1], user.classrooms[2] ]
    subject_name = SUBJECTS01[1]
    start_time = Time.new(Time.now.year, 7, 3, 8)

    classroom = classrooms[1]
    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_02: :environment do

    user = User.where(name: "liberal").first
    SUBJECTS02 = ["國文", "英文", "社會"]
    classrooms = [ user.classrooms[0], user.classrooms[1], user.classrooms[2] ]
    subject_name = SUBJECTS02[2]
    start_time = Time.new(Time.now.year, 7, 4, 8)

    classroom = classrooms[2]
    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_10: :environment do

    user = User.where(name: "science").first
    SUBJECTS10 = ["數學", "自然", "生活科技"]
    classrooms = [ user.classrooms[0], user.classrooms[1], user.classrooms[2] ]
    # 最後一位參數設定
    subject_name = SUBJECTS10[0]
    start_time = Time.new(Time.now.year, 7, 2 + 0, 8)
    classroom = classrooms[0]

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_11: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "science").first
    SUBJECTS11 = ["數學", "自然", "生活科技"]
    classrooms = [ user.classrooms[0], user.classrooms[1], user.classrooms[2] ]

    # 最後一位參數設定
    subject_name = SUBJECTS11[1]
    classroom = classrooms[1]
    start_time = Time.new(Time.now.year, 7, 2 + 1, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_12: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "science").first
    SUBJECTS12 = ["數學", "自然", "生活科技"]
    classrooms = [ user.classrooms[0], user.classrooms[1], user.classrooms[2] ]

    # 最後一位參數設定
    subject_name = SUBJECTS12[2]
    classroom = classrooms[2]
    start_time = Time.new(Time.now.year, 7, 2 + 2, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_20: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "general").first
    SUBJECTS20 = ["國文", "英文", "社會", "數學", "自然", "生活科技"]
    classroom = user.classrooms[0]

    # 最後一位參數設定：0..5
    subject_name = SUBJECTS20[0]
    start_time = Time.new(Time.now.year, 7, 2 + 0, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_21: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "general").first
    SUBJECTS21 = ["國文", "英文", "社會", "數學", "自然", "生活科技"]
    classroom = user.classrooms[0]

    # 最後一位參數設定：0..5
    subject_name = SUBJECTS21[1]
    start_time = Time.new(Time.now.year, 7, 2 + 1, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_22: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "general").first
    SUBJECTS22 = ["國文", "英文", "社會", "數學", "自然", "生活科技"]
    classroom = user.classrooms[0]

    # 最後一位參數設定：0..5
    subject_name = SUBJECTS22[2]
    start_time = Time.new(Time.now.year, 7, 2 + 2, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_23: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "general").first
    SUBJECTS23 = ["國文", "英文", "社會", "數學", "自然", "生活科技"]
    classroom = user.classrooms[0]

    # 最後一位參數設定：0..5
    subject_name = SUBJECTS23[3]
    start_time = Time.new(Time.now.year, 7, 2 + 3, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_24: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "general").first
    SUBJECTS24 = ["國文", "英文", "社會", "數學", "自然", "生活科技"]
    classroom = user.classrooms[0]

    # 最後一位參數設定：0..5
    subject_name = SUBJECTS24[4]
    start_time = Time.new(Time.now.year, 7, 2 + 4, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_lesson_25: :environment do

    # 第一位參數，使用者編號
    user = User.where(name: "general").first
    SUBJECTS25 = ["國文", "英文", "社會", "數學", "自然", "生活科技"]
    classroom = user.classrooms[0]

    # 最後一位參數設定：0..5
    subject_name = SUBJECTS25[5]
    start_time = Time.new(Time.now.year, 7, 2 + 5, 8)

    # 判斷 break point
    if Time.now.month.between?(7,12)
      semester = Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31).end_of_day
    elsif  Time.now.month.between?(1,1)
      semester = Time.new(Time.now.year - 1,7,1)..Time.new(Time.now.year,1,31).end_of_day
    else
      semester = Time.new(Time.now.year,2,1)..Time.new(Time.now.year,6,30).end_of_day
    end

     i = 0
    loop do
      @lesson = classroom.lessons.new(name: subject_name, grade: classroom.grade, room: classroom.room)
      @lesson.start_time = start_time
      @lesson.end_time = start_time + 1.hour
      @lesson.save
      start_time += 1.week
      i += 1
      break if start_time > semester.end
    end
    if @lesson.save

      # Subject name 需保持唯一性，lesson name 編輯時需同步更換同名的 subject
      subject = user.subjects.find_or_create_by(name: subject_name)
      subject.classrooms << classroom unless subject.classrooms.exists?(classroom.id)
    end

    puts "created fake lessons"
    puts "now you have #{Lesson.count} lessons data"
  end

  task fake_topic: :environment do
    # 每個 user 的每個 classroom 生成 topics
    User.all.each do |user|
      user.classrooms.all.each do |classroom|
        4.times do |i|
          start_point = Time.new(2018, 07, 01) + i.week
          classroom.topics.create(
            name: FFaker::Book::genre,
            start_time: start_point,
            # 注意是加六天，加一週會和下一週重疊
            end_time: start_point + 6.day
          )
          i += 1
        end
      end
    end
    puts "created fake topics"
    puts "now you have #{Topic.count} topics data"
  end

  task fake_plan: :environment do
    User.all.each do |user|
      15.times do
        user.plans.create(
          plan_folder_name: FFaker::Book::genre,
          # 全科隨機，有可是舊教案但本學年沒開課
          subject_tag_id: rand(1..13)
        )
      end
    end
    puts "created fake plans"
    puts "now you have #{Plan.count} plans data"
  end

  task fake_material: :environment do
    User.all.each do |user|
      15.times do
        user.materials.create(
          mtrial_folder_name: FFaker::Book::genre,
          # 全科隨機，有可是舊教案但本學年沒開課
          subject_tag_id: rand(1..13)
        )
      end
    end
    puts "created fake materials"
    puts "now you have #{Material.count} materials data"
  end

  task fake_teachingfile: :environment do
    Teachingfile.destroy_all

    User.all.each do |user|
      materials = user.materials
      content_1 = Pathname.new("/Users/riemann/k12-project/public/materials/material.pdf").open
      materials.all.each do |material|
        teachingfile = material.teachingfiles.new(name: "教材範例")
        teachingfile.attachments = [content_1]
        teachingfile.save
      end
      plans = user.plans
      content_2 = File.open("#{Rails.root}/public/plans/plan.pdf")
      plans.all.each do |plan|
        teachingfile_p = plan.teachingfiles.new(name: "教案範例")
        teachingfile_p.attachments = [content_2]
        teachingfile_p.save
      end
    end
    puts "created fake teachingfiles"
    puts "now you have #{Teachingfile.count} teachingfiles data"
  end

  task fake_aim: :environment do
    Topic.all.each do |topic|
      3.times do
        topic.aims.create(name: FFaker::Book::genre)
      end
    end
    puts "created fake aims"
    puts "now you have #{Aim.count} aims data"
  end

  task fake_addfile: :environment do
    User.all.each do |user|
      plan_ids = user.plans.pluck(:id)
      material_ids = user.materials.pluck(:id)
      t_plans = Teachingfile.where(plan_id: plan_ids)
      t_materials = Teachingfile.where(material_id: material_ids)
      classroom_ids = user.classrooms.pluck(:id)
      topics = Topic.where(classroom_id: classroom_ids)
      topics.each do |topic|
        topic.addfiles.create(teachingfile: t_plans.sample)
        topic.addfiles.create(teachingfile: t_materials.sample)
      end
    end
    puts "created fake addfiles"
    puts "now you have #{Addfile.count} addfiles data"
  end

  task fake_feedback: :environment do
    Topic.all.each do |topic|
      topic.feedback = FFaker::Lorem::paragraph
      topic.save
    end
    puts "created fake feedbacks"
    puts "now you have #{Topic.count} feedbacks data"
  end

end
