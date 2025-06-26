class BasePagesController < ApplicationController
  def index
    # @fandoms = Fandom.all
    # @allFandoms = [
    #     'Атлантида' , 'Шерлок' , 'Star Wars' , 'My Little Pony' ,
    #     'Доктор Кто' , 'Ван Пис' , 'Голодные игры' , '1984' ,
    #     'Игра Престолов' , 'Хроники Нарнии' , 'Звёздный десант' ,
    #     'Атака Титанов' , 'DC Comics' , 'Властелин Колец' ,
    #     'Marvel' , 'Баскетбол Куроко' , 'Мы' , 'Гарри Поттер' ,
    #     'Наруто' , 'Сумерки' , 'Клуб романтики' , 'Космическая Одиссея' ,
    #     'Однажды в сказке' , 'Великолепный век' 
    #     ]
    @random_trails = Trail.order("RANDOM()").limit(6)
    @top_trails = Trail.includes(:user).order(likes_count: :desc).limit(5)
    @marvel = Fandom.find_by(name: "Marvel")
    @marvel_trails = Trail.where(fandom_id: @marvel.id).limit(4) if @marvel

    @categories = Fandom.distinct.pluck(:category)
    @selected_category = params[:category] || @categories.first
    @fandoms = Fandom.where(category: @selected_category)
  end
    

  def about
  end
end