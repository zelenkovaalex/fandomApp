class TrailsController < ApplicationController
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
    
    def show
        @trail = Trail.find(params[:id])

        @comment = @trail.comments.build
    end

end