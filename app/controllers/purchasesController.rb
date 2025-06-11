class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def index
    purchases = current_user.purchases.includes(:trail)
    render json: purchases, include: :trail, status: :ok
  end

  def show
    @purchase = current_user.purchases.find(params[:id])
  end

  def create
    trail = Trail.find(params[:trail_id])
    purchase = current_user.purchases.build(trail: trail, price: trail.price, status: "pending")

    if purchase.save
      purchase.complete!
      render json: { message: "Trail purchased successfully", purchase: purchase }, status: :created
    else
      render json: { errors: purchase.errors.full_messages }, status: :unprocessable_entity
    end
  end

end