@allFandoms = [
                { name: 'Атлантида' }, { name: 'Шерлок' }, { name: 'Star Wars' }, { name: 'My Little Pony' },
                { name: 'Доктор Кто' }, { name: 'Ван Пис' }, { name: 'Голодные игры' }, { name: '1984' },
                { name: 'Игра Престолов' }, { name: 'Хроники Нарнии' }, { name: 'Звёздный десант' },
                { name: 'Атака Титанов' }, { name: 'DC Comics' }, { name: 'Властелин Колец' },
                { name: 'Marvel' }, { name: 'Баскетбол Куроко' }, { name: 'Мы' }, { name: 'Гарри Поттер' },
                { name: 'Наруто' }, { name: 'Сумерки' }, { name: 'Клуб романтики' }, { name: 'Космическая Одиссея' },
                { name: 'Однажды в сказке' }, { name: 'Великолепный век' }
]
            
@nicknames = [ "sashaiskatel", "igorveber", "spookypirate", "flobara", "dachanacha", "nebozhitel", "lenabistra", "pupsik"]
@cities = [ "калининград", "санкт-петербург", "владивосток", "париж", "москва", "тюмень" ]
@bios = [
          "люблю гулять и пиццу",
          "самый преданный фанат своего фандома (спорьте с воздухом, кто не согласен)",
          "продам твою душу за початок кукурузы",
          "геодезист",
          "люблю прикольные картинки и ходилки",
          "профессиональный исследователь человеческих душ"
        ]

@raw_text = "Путешествие — открытие новых горизонтов. Когда мы отправляемся в путешествие, оказываемся в незнакомой среде, где каждый день приносит новые впечатления и вызовы.
Путешествие — изучение собственных реакций. Мы сталкиваемся с новыми ситуациями и вызовами во время путешествия, это ставит нас перед необходимостью принимать решения и анализировать свои реакции. Мы учимся управлять стрессом, развивать навыки решения проблемных ситуаций и становимся более уверенными в своих собственных способностях, где бы мы не были мы можем легко решить любой вопрос, который жизнь поставит перед нами жизнь."
@words = @raw_text.downcase.gsub(/[—.—,«»:;()]/, '').gsub(/  /, ' ').split(' ')

@allFandoms.each do |fandom|
  test = Fandom.create(name: fandom[:name])
end

def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def seed
  reset_db
  create_fandom
  create_users(6)
  create_trail(2...5)
  create_comments(2..4)
end

# def upload_random_avatar
#   uploader = AvatarUploader.new(Profile.new, :avatar)
#    file = Dir.glob(File.join(Rails.root, 'public/uploads/avatars', '*')).sample
#    if file.present?
#     uploader.cache!(File.open(file))
#     uploader
#   else
#     nil
#   end
# end

def create_fandom
  @allFandoms.each do
    fandom = Fandom.create!(name: @allFandoms.sample[:name], description: "описание фандома")
    puts "Fandom with name #{fandom.name} just created"
    # create_trail(3)
  end
end

def create_users(quantity)
  i = 0

  quantity.times do
    user_data = {
      email: "user#{i}@email.com",
      password: "passpass"
    }

    if i == 0
      user_data[:admin] = true
    end

    user = User.create!(user_data)
    puts "User created with id #{user.id}"

    profile_data = {
      user_id: user.id,
      nickname: @nicknames.sample,
      bio: @bios.sample,
      city: @cities.sample,
      # avatar: upload_random_avatar,
      fandom_id: Fandom.all.sample.id
      # fandom: Fandom.create(name: @allFandoms.sample, description: "описание фандома")
    }

    puts profile_data

    Profile.create(profile_data)

    # profile_data = {
    #   nickname: @nicknames.sample,
    #   bio: @bios.sample,
    #   city: @cities.sample,
    #   # avatar: upload_random_avatar,
    #   fandom_id: Fandom.all.sample.id
    #   # fandom: Fandom.create(name: @allFandoms.sample, description: "описание фандома")
    # }

    # puts profile_data

    # user.create_profile!(profile_data)
    puts "Profile created for user with id #{user.id}: #{profile_data[:nickname]}"

    i += 1
  end
end

def get_random_bool
  [true, false].sample
end

def get_random_time
  (30...90).to_a.sample
end

def get_random_level
  (1...10).to_a.sample
end

def create_sentence
  sentence_words = []

  (10..20).to_a.sample.times do
    sentence_words << @words.sample
  end
  sentence = sentence_words.join(' ').capitalize + '.'
end

def create_trail(quantity)

  if User.count == 0
    puts "There are no users."
    return
  end
  
  Fandom.all.each do |fandom|
    rand(quantity).times do 
      if fandom.present?
        user = User.all.sample

        trail = fandom.trails.create!(
          title: "trail_name", 
          fandom: fandom, 
          user: user, 
          trail_time: get_random_time, 
          trail_level: get_random_level, 
          body: "рандомный текст", 
          public: get_random_bool
        )
          
        puts "Trail with title #{trail.title} for fandom #{trail.fandom.name} just created"
      end
    end
  end
end

def create_comments(quantity)
  Trail.all.each do |trail|
    rand(quantity).times do
      comment = Comment.create(trail_id: trail.id, body: create_sentence)
      puts "Comment with id #{comment.id} for  with id #{comment.trail.id} just created"
    end
  end
end

def create_comment_replies(quantity)
  Comment.all.each do |comment|
    rand(quantity).times do
      comment = Comment.create(trail_id: trail.id, body: create_sentence)
      puts "Comment reply with id #{comment_reply.id} for pin with id #{comment_reply.pin.id} just created"
    end
  end
end


seed