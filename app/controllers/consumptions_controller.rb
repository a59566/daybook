class ConsumptionsController < ApplicationController
  before_action :set_consumption, only: [:edit, :update, :destroy]

  def index
    @consumptions = Consumption.includes(:tag).order(date: :desc).page(params[:page]).per(5)
  end

  def new
    @consumption = Consumption.new
    @consumption.date = Date.today
  end

  def edit

  end

  def create
    @consumption = Consumption.new(consumption_params)
    if @consumption.save
      redirect_to consumptions_url, notice: '新增成功'
    else
      render :new
    end
  end

  def update
    if @consumption.update(consumption_params)
      redirect_to consumptions_url, notice: '更新成功'
    else
      render :edit
    end
  end

  def destroy
    @consumption.destroy
    redirect_to consumptions_url, notice: '刪除成功'
  end

  private

    def consumption_params
      params.require(:consumption).permit(:detail, :amount, :date, :tag_id)
    end

    def set_consumption
      @consumption = Consumption.find(params[:id])
    end
end
