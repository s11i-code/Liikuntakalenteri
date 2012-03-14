# encoding: utf-8
class EventsController < ApplicationController


  before_filter :authenticate

  def index
    @page_title = "Kalenteri"

    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)
    @first_day_of_week = 1
    @event_strips = Event.event_strips_for_month(@shown_month, :conditions => "user_id = #{current_user.id}")
    render "calendar/index"

  end

  def create

    @page_title = home_page_title
    @user = current_user
    mock_event = mock_event(params[:event][:yol_event_url])
    if (mock_event.valid?)
      event_data = YolEventData.new(mock_event.yol_event_id)
      if (event_data.found?)
        current_user.events.create!(params[:event].merge({:start_at => event_data.start_time, :end_at => event_data.end_time,
                                                          :name => event_data.name, :location => event_data.location}))
        redirect_to root_path, :flash => {:success => "Luotiin tapahtuma " + event_data.name + "."}
      else
        redirect_to root_path, :flash => {:error => "Tapahtumaa ei löydy."}
      end
    else
      redirect_to root_path, :flash => {:error => "Tapahtuman osoite ei ole kunnollinen."}
    end
  end

  def destroy
    #2.0-versioon
  end

  private


  #To check the validity of the yol event url attribute
  def mock_event(yol_event_url)
    current_user.events.build(:yol_event_url => yol_event_url, :start_at => Time.zone.now, :end_at => Time.zone.now + 60.minutes, :name => "Mock name")
  end

end
