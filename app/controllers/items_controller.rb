class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /items
  def index
    @items = Item.all
    @items.each.with_index do |item, index|
      @items[index].encrypt_password = params[:encrypt_password]
    end
  end

  # GET /items/1
  def show
  end

  # POST /items
  def create
    if check_for_same_password
      @item = Item.new(item_params)
      @item.encrypt_password = params[:encrypt_password]

      if @item.save
        render :show, status: :created
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Authentication Error: Password Failure" }, status: :unauthorized
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy

    @items = Item.all
    @items.each.with_index do |item, index|
      @items[index].encrypt_password = params[:encrypt_password]
    end

    render :index
  end

  private

  def set_item
    @item = Item.find(params[:id])
    @item.encrypt_password = params[:encrypt_password]
  end

  def item_params
    params.require(:item).permit(:name,
                                 :price_cents,
                                 :description)
  end

  def check_for_same_password
    if @current_user && @current_user.authenticate(params[:encrypt_password])
      true
    else
      false
    end
  end
end
