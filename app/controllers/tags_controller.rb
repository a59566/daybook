class TagsController < ApplicationController
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.all.order(:display_order)
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.display_order = Tag.maximum(:display_order).to_i + 1
    if @tag.save
      redirect_to tags_url, notice: "[#{@tag.name}]標籤新增成功"
    else
      render :new
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_url, notice: "[#{@tag.name}]標籤更新成功"
    else
      render :edit
    end

  end

  def destroy
    @tag.destroy
    redirect_to tags_url, notice: "[#{@tag.name}]標籤刪除成功"
  end

  private

    def tag_params
      params.require(:tag).permit(:name)
    end

    def set_tag
      @tag = Tag.find(params[:id])
    end
end
