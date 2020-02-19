class TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = current_user.tags.order(:display_order)
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
    @tag.display_order = current_user.tags.maximum(:display_order).to_i + 1
    if @tag.save
      redirect_to tags_url, notice: "[#{@tag.name}]標籤新增成功"
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: get_formatted_error_message(@tag), status: :unprocessable_entity }
      end
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_url, notice: "[#{@tag.name}]標籤更新成功"
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render json: get_formatted_error_message(@tag), status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  private

    def tag_params
      params.require(:tag).permit(:name)
    end

    def set_tag
      @tag = current_user.tags.find(params[:id])
    end
end
