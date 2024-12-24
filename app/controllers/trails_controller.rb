class TrailsController < ApplicationController
    # before_action :authenticate_user!
    load_and_authorize_resource
    before_action :set_trail, only: [ :edit, :new]
    
    load_and_authorize_resource


    def index
        if current_user && current_user.admin?
          @trails = Trail.all.order(created_at: :desc)
        elsif current_user
          @trails = current_user.trails  
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

     def update
      respond_to do |format|
        if @trail.update(trail_params)
          format.html { redirect_to trail_path(@trail), notice: "trail was successfully updated." }
          format.json { render :show, status: :ok, location: @trail }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @trail.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @trail.destroy!

      respond_to do |format|
        format.html { redirect_to admin_trails_path, status: :see_other, notice: "trail was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def set_trail
      @trail = Trail.where(params[:id])
    end

    def trail_params
      params.require(:trail).permit(:title, :description, :trail_image, :trail_time, :trail_level, :fandom_id)
    end

end