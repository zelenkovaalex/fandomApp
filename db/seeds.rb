def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def seed 
  reset_db
  create_users(10)
end

Fandom.create([
    { name: 'Атлантида' }, { name: 'Шерлок' }, { name: 'Star Wars' }, { name: 'My Little Pony' }, { name: 'Доктор Кто' }, 
    { name: 'Ван Пис' }, { name: 'Голодные игры' }, { name: '1984' }, { name: 'Игра Престолов' }, { name: 'Хроники Нарнии' },  
    { name: 'Звёздный десант' }, { name: 'Атака Титанов' }, { name: 'DC Comics' }, { name: 'Властелин Колец' }, { name: 'Marvel' }, 
    { name: 'Баскетол Куроко' }, { name: 'Мы' }, { name: 'Гарри Поттер' }, { name: 'Наруто' }, { name: 'Сумерки' }, 
    { name: 'Клуб романтики' }, { name: 'Космическая Одиссея' }, { name: 'Однажды в сказке' }, { name: 'Великолепный век' }
])  


# Удаляем существующие посты (если есть)
Trail.destroy_all
Comment.destroy_all

# Получаем список всех фандомов
fandoms = Fandom.all

# Создаем пользователей
users = []
5.times do |i|
  users << User.create!(
    name: "Пользователь #{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password"
  )
end

# Создаем посты
def create_trail(fandom, user)
  Trail.create!(
    title: "Пост о #{fandom.name}", # Заголовок с названием фандома
    user: user,
    fandom: fandom, # Передаем объект фандома, а не его имя
    trail_time: Time.now.strftime('%H:%M'), # Текущее время
    trail_level: rand(1..5), # Случайный уровень поста
    body: "рандомный текст"
  )
end

users = User.all

10.times do |i|
  create_trail(fandoms.sample, users.sample)
end

# Создаем комментарии к постам
def create_comment(trail)
  Comment.create!(
    trail_id: trail.id,
    body: "еще более рандомный текст"
  )
end

Trail.all.each do |trail|
  rand(1..5).times do
    create_comment(trail)
  end
end

# Выводим информацию о созданных постах
puts "Создано #{Trail.count} постов"
puts "Создано #{Comment.count} комментариев"