class ConsumptionsController < ApplicationController
  before_action :set_consumption, only: [:edit, :update, :destroy]

  def index
    @recent_5_days_consumptions = build_chart_data(current_user.consumptions.joins(:tag).includes(:tag)\
                                                   .where(:date => (Date.today-5)..(Date.today-1))\
                                                   .order(:date, :display_order))

    @this_month_amount = current_user.consumptions.this_month.sum(:amount)

    @amount_by_tag = current_user.consumptions.joins(:tag).this_month.group(:name, :display_order).\
                       order(display_order: :asc).pluck(:name, 'SUM(consumptions.amount)')

    @q = current_user.consumptions.ransack(params[:q])
    @consumptions = @q.result.includes(:tag).order(date: :desc, id: :desc).page(params[:page]).per(10)
  end

  def new
    @consumption = Consumption.new
    @consumption.date = Date.today
  end

  def edit

  end

  def create
    @consumption = current_user.consumptions.new(consumption_params)
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
      @consumption = current_user.consumptions.find(params[:id])
    end

    def build_chart_data(sources)
      result = []
      sources.group_by{|x| x.tag.name}.each do |tag_name, consumptions|
        result_element = {}
        result_element[:name] = tag_name

        data = []
        consumptions.each do |consumption|
          data.push([consumption.date.strftime('%m-%d'), consumption.amount])
        end
        result_element[:data] = data
        result.push result_element
      end

      result
    end
end
