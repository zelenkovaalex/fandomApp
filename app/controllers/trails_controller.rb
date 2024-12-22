class TrailsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_trail, only: [ :edit, :new]
    
    load_and_authorize_resource


    def index
        if current_user
            @trails = current_user.trails  
        elsif current_user && current_user.admin?
            @trails = Trail.all.order(created_at: :desc)
        else
            @trail = Trail.where(public: true)  
        end
    end

    def by_tag
      @trails = Trail.tagged_with(params[:tag])

      render :index
    end
    
    def show
    end

    def new
        @trail = Trail.new
    end

    def edit
    end   

    def create
      @trail = current_user.trails.new(trail_params)

      respond_to do |format|
        if @trail.save
          format.html { redirect_to @trail, notice: "Trail was successfully created." }
          format.json { render :show, status: :created, location: @trail }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @trail.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_trail
      @trail = Trail.find(params[:id])
    end

    def trail_params
      params.require(:trail).permit(:title, :description, :trail_image, :trail_time, :trail_level, :fandom_id)
    end

end