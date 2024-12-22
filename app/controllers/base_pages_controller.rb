class BasePagesController < ApplicationController
  def index
    @fandoms = Fandom.all
    @allFandoms = [
        'Атлантида' , 'Шерлок' , 'Star Wars' , 'My Little Pony' ,
        'Доктор Кто' , 'Ван Пис' , 'Голодные игры' , '1984' ,
        'Игра Престолов' , 'Хроники Нарнии' , 'Звёздный десант' ,
        'Атака Титанов' , 'DC Comics' , 'Властелин Колец' ,
        'Marvel' , 'Баскетбол Куроко' , 'Мы' , 'Гарри Поттер' ,
        'Наруто' , 'Сумерки' , 'Клуб романтики' , 'Космическая Одиссея' ,
        'Однажды в сказке' , 'Великолепный век' 
        ]
  end

  def about
  end
end