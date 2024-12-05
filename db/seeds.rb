@allFandoms = [
    { id: 1, name: 'Атлантида' }, { id: 2, name: 'Шерлок' }, { id: 3, name: 'Star Wars' }, { id: 4, name: 'My Little Pony' }, { id: 5, name: 'Доктор Кто' },
    { id: 6, name: 'Ван Пис' }, { id: 7, name: 'Голодные игры' }, { id: 8, name: '1984' }, { id: 9, name: 'Игра Престолов' }, { id: 10, name: 'Хроники Нарнии' },
    { id: 11, name: 'Звёздный десант' }, { id: 12, name: 'Атака Титанов' }, { id: 13, name: 'DC Comics' }, { id: 14, name: 'Властелин Колец' }, { id: 15, name: 'Marvel' },
    { id: 16, name: 'Баскетбол Куроко' }, { id: 17, name: 'Мы' }, { id: 1, name: 'Гарри Поттер' }, { id: 18, name: 'Наруто' }, { id: 19, name: 'Сумерки' },
    { id: 20, name: 'Клуб романтики' }, { id: 21, name: 'Космическая Одиссея' }, { id: 22, name: 'Однажды в сказке' }, { id: 23, name: 'Великолепный век' }
]

def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def seed
  reset_db
  create_users(6)
  create_fandom
  create_trail(2...5)
  # create_trails_and_comments
end

def create_users(quantity)
  i = 0

  quantity.times do
    user_data = {
      email: "user#{i}@email.com",
      password: "password"
    }

    if i == 0
      user_data[:admin] = true
    end

    user = User.create!(user_data)
    puts "User created with id #{user.id}"

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

def create_trail(quantity)
  
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
          public: get_random_bool)
          
        puts "Trail with title #{trail.title} for fandom #{trail.fandom.name} just created"
      end
    end
  end
end

def create_comments(quantity)
  Trail.all.esch do |trail|
    rand(quantity).times do
      comment = Comment.create(trail_id: trail.id, body: create_sentence)
      puts "Comment with id #{comment.id} for  with id #{comment.trail.id} just created"
    end
  end
end

def create_fandom
  @allFandoms.each do
    fandom = Fandom.create!(name: @allFandoms.sample[:name], description: "рандомный текст")
    puts "Fandom with name #{fandom.name} just created"
  end
end

seed