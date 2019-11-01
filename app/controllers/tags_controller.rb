class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def create
    tag = Tag.new(tag_params)
    tag.save!
    redirect_to tags_url, notice: "\"#{tag.name}\"標籤新增成功"
  end

  def update
    tag = Tag.find(params[:id])
    tag.update!(tag_params)
    redirect_to tags_url, notice: "\"#{tag.name}\"標籤更新成功"
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    redirect_to tags_url, notice: "\"#{tag.name}\"標籤刪除成功"
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
