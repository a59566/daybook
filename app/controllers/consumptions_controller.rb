class ConsumptionsController < ApplicationController
  def index
    @consumptions = Consumption.all
    @tags = Tag.all
  end

  def new
    @consumption = Consumption.new
  end

  def edit
    @consumption = Consumption.find(params[:id])
  end

  def create
    consumption = Consumption.new(consumption_params)
    consumption.save!
    redirect_to consumptions_url, notice: '新增成功'
  end

  def update
    consumption = Consumption.find(params[:id])
    consumption.update!(consumption_params)
    redirect_to consumptions_url, notice: '更新成功'
  end

  def destroy
    consumption = Consumption.find(params[:id])
    consumption.destroy
    redirect_to consumptions_url, notice: '刪除成功'
  end

  private

  def consumption_params
    params.require(:consumption).permit(:detail, :amount, :date, :tag_id)
  end
end
