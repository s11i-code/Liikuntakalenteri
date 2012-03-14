require 'nokogiri'
require 'open-uri'

class YolEventData

  EVENTS_URL = "http://yliopistoliikunta.helsinki.fi/yol/web/fi/event/listEvents.do?shortcutSportId=825079&week="
  WEEKS_TO_CHECK_AHEAD = 3


  def initialize(yol_event_id)
    
    @attr = "'viewEvent.do?reservableId=#{yol_event_id}'"
    @link_xpath = "//a[@href="+ @attr + "]"
    @yol_event_id = yol_event_id

    current_week = Date.today.cweek
    week_range = current_week .. current_week + WEEKS_TO_CHECK_AHEAD

    begin
      @doc = Nokogiri::HTML(open(EVENTS_URL + current_week.to_s))
      current_week = current_week.next
    end while(!found? and week_range.include? current_week)
  end

  def found?
    !@doc.xpath(@link_xpath).empty?
  end

  def name
    @name ||= @doc.xpath(@link_xpath)[0].content.gsub("Â", "").gsub("®", "").gsub("Ã", "Ä")
  end

  def start_time
    generate_time(month, day, start_time_hours, start_time_minutes)
  end

  def end_time
    generate_time(month, day, end_time_hours, end_time_minutes)
  end

  def location
    @location ||= @doc.xpath(@link_xpath + "/parent::td/parent::div/child::td")[3].content.split[0]
  end

  private

  def day
    if(date =~ YolEventData.date_regex)
      $1.strip
    end
  end

  def month
    if(date =~ YolEventData.date_regex)
      $2.strip
    end
  end

  def time_interval
    @time_interval ||= @doc.xpath(@link_xpath + "/parent::td/parent::div/child::td")[0].content
  end
  
  def date
    @date ||= @doc.xpath(@link_xpath + "/ancestor::tr/preceding-sibling::tr[@class='day_row']").last.content
  end

  def start_time_hours
    if(time_interval =~ YolEventData.time_interval_regex)
      $1
    end
  end

  def start_time_minutes
    if(time_interval =~ YolEventData.time_interval_regex)
      $2
    end
  end

  def end_time_hours
    if(time_interval =~ YolEventData.time_interval_regex)
      $3
    end
  end

  def end_time_minutes
    if(time_interval =~ YolEventData.time_interval_regex)
      $4
    end
  end
  
  def generate_time(month, day, hours, minutes)
    t = Time.zone.now.change(:month => month.to_i, :day => day.to_i).midnight
    t=t.advance(:hours => hours.to_i, :minutes => minutes.to_i)
    t=t.advance(:years => 1) if(Time.zone.now.month == 12 and month.to_i == 1)
    t
  end

  #Regexes

  def self.time_interval_regex
    /(\d\d).(\d\d).*-.*(\d\d).(\d\d)/
  end

  def self.date_regex
    /(\d\d)\D*.\D*(\d\d)/
  end

  
end
 