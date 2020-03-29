class TagsController < ApplicationController
  before_action :set_tag, only: [:sort, :edit, :update, :destroy]

  def index
    @tags = current_user.tags.rank(:display_order)
  end

  def sort
    @tag.update(tag_params.permit(:display_order_position))
    head :no_content
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = current_user.tags.new(tag_params)
    @tag.display_order_position = :last
    if @tag.save
      redirect_to tags_url, notice: t('.success_message', name: @tag.name)
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: get_formatted_error_message(@tag), status: :unprocessable_entity }
      end
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_url, notice: t('.success_message', name: @tag.name)
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render json: get_formatted_error_message(@tag), status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @tag.destroy
      head :no_content
    else
      respond_to do |format|
        format.js { render plain: @tag.errors.messages[:base][0], status: :method_not_allowed }
      end
    end
  end

  private

    def tag_params
      params.require(:tag).permit(:name, :display_order_position)
    end

    def set_tag
      @tag = current_user.tags.find(params[:id])
    end
end
