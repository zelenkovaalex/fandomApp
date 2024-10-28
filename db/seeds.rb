def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

reset_db

Fandom.create([
    { name: 'Атлантида' }, { name: 'Шерлок' }, { name: 'Star Wars' }, { name: 'My Little Pony' }, { name: 'Доктор Кто' }, 
    { name: 'Ван Пис' }, { name: 'Голодные игры' }, { name: '1984' }, { name: 'Игра Престолов' }, { name: 'Хроники Нарнии' },  
    { name: 'Звёздный десант' }, { name: 'Атака Титанов' }, { name: 'DC Comics' }, { name: 'Властелин Колец' }, { name: 'Marvel' }, 
    { name: 'Баскетол Куроко' }, { name: 'Мы' }, { name: 'Гарри Поттер' }, { name: 'Наруто' }, { name: 'Сумерки' }, 
    { name: 'Клуб романтики' }, { name: 'Космическая Одиссея' }, { name: 'Однажды в сказке' }, { name: 'Великолепный век' }
])  

