class ConsumptionsController < ApplicationController
  before_action :set_consumption, only: [:edit, :update, :destroy]

  def index
    recent_days = 5
    @recent_amount_by_tag = build_recent_amount_by_tag(
      current_user.tags.joins(:consumptions).includes(:consumptions)\
                  .merge(Consumption.recent(recent_days)).order(:display_order, :date)\
                  .select(:name, :date, :amount),
      recent_days
    )

    @this_month_amount_by_tag = current_user.tags.joins(:consumptions).merge(Consumption.this_month)\
                                            .group(:name, :display_order).order(display_order: :asc)\
                                            .pluck(:name, 'SUM(consumptions.amount) AS amount_sum')

    @this_month_amount = @this_month_amount_by_tag.inject(0) { |sum, tag_and_amount| sum + tag_and_amount[1] }

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
      respond_to do |format|
        format.html { render :new }
        format.js { render json: get_formatted_error_message(@consumption), status: :unprocessable_entity }
      end
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
    head :no_content
  end

  private

    def consumption_params
      params.require(:consumption).permit(:detail, :amount, :date, :tag_id)
    end

    def set_consumption
      @consumption = current_user.consumptions.find(params[:id])
    end

    def build_recent_amount_by_tag(tags, recent_days)
      result = []
      tags.each_with_index do |tag, index|
        result_element = {}
        result_element[:name] = tag.name

        data = []

        # add empty date amount in first tag to keep date order in chart
        if index == 0
          recent_range = Date.today - recent_days .. Date.today - 1
          recent_range.each do |date|
            consumptions = tag.consumptions.select{ |consumption| consumption.date == date }
            if consumptions.count != 0
              amount = consumptions.inject(0) { |sum, consumption| sum + consumption.amount }
              data.push([date.strftime('%m-%d'), amount ])
            else
              data.push([date.strftime('%m-%d'), 0 ])
            end
          end
        else
          tag.consumptions.group_by(&:date).each do |date, consumptions|
            amount = consumptions.inject(0) { |sum, consumption| sum + consumption.amount }
            data.push([date.strftime('%m-%d'), amount ])
          end
        end

        result_element[:data] = data
        result.push result_element
      end

      result
    end
end
