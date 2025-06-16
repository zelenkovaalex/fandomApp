require 'yaml'

@nicknames = ["sazelmist", "frostpeak", "novaflare", 
              "sashaiskatel", "opalflare", "sparklush", 
              "steelstrike", "honeyglow", "crystalflame", 
              "sylvanmuse", "stormborn", "vanilladream", 
              "blazepath", "orbitcrash", "torqueaxe", 
              "electriclily", "cherryspark", 
              "owloffurtune", "worldoftanks", 
              "bearforce", "jamhaze", "chocobliss",
              "cobrascale", "starfury", "noirbelle",
              "ironclaw", "velvetlynx", "trailblaze",
              "vortexdrive", "wildstride"]

@names = [ "юля", "альфред", "игорь", 
                "олеся", "петя", "алина", 
                "софа", "кирилл", "полина", 
                "ярослав", "максим", "таня", 
                "вероника", "даня", "кира", 
                "маргарита", "олег", 
                "анастасия", "костя", "ира" ]


@bios = YAML.load_file(Rails.root.join('db', 'seeds', 'bios.yml'))
@cities = YAML.load_file(Rails.root.join('db', 'seeds', 'cities.yml'))
@fandoms_data = YAML.load_file(Rails.root.join('db', 'seeds', 'fandoms.yml'))
@trail_info = YAML.load_file(Rails.root.join('db', 'seeds', 'trails.yml'))

@comments = [
  "Отличный маршрут! Особенно понравился вид на закат.",
  "Места просто потрясающие, чувствуется душа природы.",
  "Сложный маршрут, но оно того стоит. Виды незабываемые!",
  "Рекомендую взять с собой теплую одежду, в горах прохладно.",
  "Очень интересная история этого места. Спасибо за экскурсию!",
  "Путешествие было захватывающим, особенно водопады.",
  "Не забудьте фотоаппарат — здесь есть что снять!",
  "Маршрут подходит для новичков, все четко организовано.",
  "Лучше взять с собой карту, GPS иногда теряет сигнал.",
  "Красота неописуемая, обязательно вернусь сюда снова!"
]

@replies = [
  "Согласен, это место действительно волшебное!",
  "Спасибо за отзыв, рады, что вам понравилось!",
  "Обязательно учтем ваш совет, спасибо!",
  "Да, маршрут требует подготовки, но оно того стоит.",
  "Спасибо за подробный отзыв, он очень полезен!"
]

def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

def seed
  reset_db
  create_fandoms
  create_users(30)
  create_trails
  create_comments(2..4)
  create_comment_replies(1..3)
end

def create_fandoms
  @fandoms_data.map do |fandom_data|
    puts fandom_data["name"]
    if fandom_data["name"] != nil
      Fandom.create!(name: fandom_data["name"], category: fandom_data["category"])
      puts "Fandom with name #{fandom_data["name"]} created"
    end
  end
  puts "Total fandoms created: #{Fandom.count}"
end

def upload_random_avatar(profile)
  avatar_directory = Rails.root.join('public', 'uploads', 'avatars')
  avatar_paths = Dir.glob("#{avatar_directory}/*.{jpg,jpeg,png,gif}")

  if avatar_paths.empty?
    puts "No avatars found in directory: #{avatar_directory}"
    return
  end

  random_avatar = avatar_paths.sample
  puts "Selected avatar: #{random_avatar}"

  profile.avatar = File.open(random_avatar)
  if profile.save!
    puts "Avatar saved to: #{profile.avatar.url}"
  else
    puts "Error: #{profile.errors.full_messages}"
  end
end

def upload_random_trail_image(model, attribute = :image)
  image_directory = Rails.root.join('public', 'uploads', 'trail')
  image_paths = Dir.glob("#{image_directory}/*.{jpg,jpeg,png,gif}")
                   .select { |file| File.file?(file) }

  if image_paths.empty?
    puts "No images found in directory: #{image_directory}"
    return
  end

  random_image = image_paths.sample
  puts "Selected image: #{random_image}"

  unless File.exist?(random_image)
    puts "File does not exist: #{random_image}"
    return
  end

  File.open(random_image) do |file|
    model.send("#{attribute}=", file)

    if model.save
      uploaded_image = model.send(attribute)
      if uploaded_image.present?
        puts "Image saved to: #{uploaded_image.url}"
      else
        puts "Error: Image was not assigned to the model."
      end
    else
      puts "Error saving model: #{model.errors.full_messages.join(', ')}"
    end
  end
end

def create_users(quantity)
  raise "Nicknames array is empty!" if @nicknames.empty?
  raise "Bios array is empty!" if @bios.empty?
  raise "Cities array is empty!" if @cities.empty?

  if Fandom.count.zero?
    raise "No fandoms in the database! Please seed fandoms first."
  end

  created_emails = []
  created_nicknames = []

  quantity.times do |i|
    # Генерация уникального email
    email = "user#{i}@email.com"
    while created_emails.include?(email)
      email = "user#{rand(1000)}@email.com"
    end

    # Генерация уникального nickname
    nickname = @nicknames.sample
    while created_nicknames.include?(nickname)
      nickname = @nicknames.sample
      if @nicknames.all? { |n| created_nicknames.include?(n) }
        raise "All nicknames are already used!"
      end
    end

    # Создание пользователя
    user_data = {
      email: email,
      password: "passpass"
    }
    user_data[:admin] = true if i == 0

    user = User.create!(user_data)
    created_emails << email
    puts "User created with id #{user.id}"

    # Создание профиля
    profile_data = {
      user_id: user.id,
      nickname: nickname,
      name: @names.sample,
      bio: @bios.sample,
      city: @cities.sample
    }
    profile = Profile.new(profile_data)
    upload_random_avatar(profile)
    profile.save!

    puts "Profile created for user with id #{user.id}: #{profile.nickname}"

    # Присоединение фандомов (1-2 для каждого профиля)
    random_fandoms = Fandom.all.sample(rand(1..2))
    profile.update!(fandom_names: random_fandoms.map(&:name))

    created_nicknames << nickname
  end
end

def create_trails
  if User.count == 0
    puts "There are no users."
    return
  end

  @trail_info.each do |trail_data|
    fandom = Fandom.find_by(name: trail_data['fandom'])
    next unless fandom

    user = User.all.sample
    profile = user.profile
    next unless profile

    trail = Trail.new(
      title: trail_data["title"],
      body: trail_data["body"],
      fandom: fandom,
      city: @cities.sample,
      user: user,
      profile: profile,
      trail_time: rand(30..90),
      trail_level: rand(1..10),
      public: [true, false].sample,
      duration: rand(30..300),
      distance: rand(1..10),
      price: 150,
      difficulty: ["легкий", "средний", "сложный"].sample
    )

    if trail.save
      puts "Trail with title #{trail.title} just created"

      if trail_data["points"].present?
        trail_data["points"].each do |point_data|
          point = trail.trail_points.build(
            name: point_data["name"],
            description: point_data["description"],
            map_link: point_data["map_link"]
          )
          upload_random_trail_image(point, :image)
          point.save!
        end
        puts "Added points to trail #{trail.title}"
      else
        puts "No points data found for trail #{trail.title}"
      end
    else
      puts "Error creating trail: #{trail.errors.full_messages.join(', ')}"
    end
  end
  puts "Total trails created: #{Trail.count}"
end

def create_comments(quantity)
  Trail.all.each do |trail|
    rand(quantity).times do
      user = User.all.sample
      comment = Comment.create(
        trail_id: trail.id,
        user_id: user.id,
        body: @comments.sample,
        rating_value: rand(1..5)
      )
      # puts "Comment with id #{comment.id} for trail with id #{comment.trail.id} created by user #{user.email}"
    end
  end
end

def create_comment_replies(quantity)
  Comment.all.each do |comment|
    if rand(1..3) == 1
      reply_body = @replies.sample
      comment_reply = comment.replies.create(comment_id: comment.id, body: reply_body)
      # puts "Comment reply with id #{comment_reply.id} for trail with id #{comment.trail.id} just created"
    end
  end
end

seed