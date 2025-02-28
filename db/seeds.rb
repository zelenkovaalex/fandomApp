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
@titles = [
          "Путешествие в Атлантиду",
          "Загадки Шерлока",
          "Звездные войны: путь джедая",
          "Дорога в страну пони",
          "Временные парадоксы Доктора",
          "Открытия на грани Ван Писа",
          "Арена Голодных игр",
          "Восхождение на Железный трон",
          "Путешествие по Хроникам Нарнии",
          "Звёздный десант: миссия на Марс",
          "Битва с Титанами",
          "Город супергероев DC",
          "По следам кольца",
          "Вселенная Marvel: эпопея героев",
          "Баскетбольные высоты Куроко",
          "Уроки магии в Хогвартсе",
          "Путь ниндзя Наруто",
          "Романтические приключения в Форксе",
          "Сказочные тропы Клуба романтики",
          "Сказки из «Однажды в сказке»",
          "Величие Великолепного века",
          "Тайны подводного мира Атлантиды",
          "Шерлок и дело о пропавшем артефакте",
          "Звёздные приключения: путь к свету",
          "Пони на границе реальности",
          "Время и пространство с Доктором",
          "Приключения на море с Ван Писом",
          "Путешествие по Нарнии: за пределами шкафчика",
          "Звёздный десант: битва за Землю"
        ]

@raw_text = "Путешествие — открытие новых горизонтов. Когда мы отправляемся в путешествие, оказываемся в незнакомой среде, где каждый день приносит новые впечатления и вызовы.
Путешествие — изучение собственных реакций. Мы сталкиваемся с новыми ситуациями и вызовами во время путешествия, это ставит нас перед необходимостью принимать решения и анализировать свои реакции. Мы учимся управлять стрессом, развивать навыки решения проблемных ситуаций и становимся более уверенными в своих собственных способностях, где бы мы не были мы можем легко решить любой вопрос, который жизнь поставит перед нами жизнь."
@words = @raw_text.downcase.gsub(/[—.—,«»:;()]/, '').gsub(/  /, ' ').split(' ')

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

def create_fandom
  @allFandoms.each do |fandom|
    Fandom.create!(name: fandom[:name], description: "описание фандома")
    puts "Fandom with name #{fandom[:name]} just created"
    # create_trail(3)
  end
end

# def upload_random_avatar
#   uploader = AvatarUploader.new(Profile.new, :avatar) # Используем загрузчик для аватаров
#   uploader.cache!(File.open(Dir.glob(File.join(Rails.root, 'public/uploads/avatars', '*')).sample))
#   uploader
# end

def create_users(quantity)
  i = 0
  created_emails = []
  created_nicknames = []

  quantity.times do
    email = "user#{i}@email.com"

    # Check for duplicate email
    while created_emails.include?(email)
      i += 1
      email = "user#{i}@email.com"
    end

    nickname = @nicknames.sample
    while created_nicknames.include?(nickname)
      nickname = @nicknames.sample
    end

    user_data = {
      email: email,
      password: "passpass"
    }

    if i == 0
      user_data[:admin] = true
    end

    user = User.create!(user_data)
    created_emails << email
    puts "User created with id #{user.id}"
    puts "User created with JTI #{user.jti}"

    profile_data = {
      user_id: user.id,
      nickname: nickname,
      bio: @bios.sample,
      city: @cities.sample,
      # avatar: upload_random_avatar,
      fandom_id: Fandom.all.sample.id
    }

    created_nicknames << nickname

    puts profile_data

    Profile.create(profile_data)
    puts "Profile created for user with id #{user.id}: #{profile_data[:nickname]}"

    random_fandoms = Fandom.all.sample(rand(2..5)) # Assign 2 to 5 random fandoms
    random_fandoms.each do |fandom|
      # user.fandoms << fandom # Assuming you have a has_and_belongs_to_many relationship between user and fandom
      puts "Fandom #{fandom.name} assigned to user #{user.id}"
    end

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
          title: @titles.sample, 
          fandom: fandom, 
          city: @cities.sample,
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

  puts Trail.count  
end

def create_comments(quantity)
  Trail.all.each do |trail|
    quantity.to_a.sample.times do
      user = User.all.sample
      comment = Comment.create(
        trail_id: trail.id,
        user_id: user.id,
        body: create_sentence
      )
      puts "Comment with id #{comment.id} for trail with id #{comment.trail.id} created by user #{user.email}"
    end
  end
end

def create_comment_replies(quantity)
  Comment.all.each do |comment|
    if rand(1..3) == 1
      comment_reply = comment.replies.create(trail_id: comment.trail_id, body: create_sentence)
      puts "Comment reply with id #{comment_reply.id} for pin with id #{comment_reply.trail.id} just created"
    end
  end
end


seed