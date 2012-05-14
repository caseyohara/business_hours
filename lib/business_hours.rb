require 'time'

class BusinessHours

  def initialize(opens, closes)
    @defaults = { :opens => opens, :closes => closes, :closed => false }
    @days = {}
  end

  def update(day, opens, closes)
    key = convert_to_key(day)
    @days[key] = { :opens => opens, :closes => closes }
  end

  def [](day)
    key = convert_to_key(day)
    @days[key] || default(key)
  end

  def closed(*days)
    days.each do |day|
      key = convert_to_key(day)
      @days[key] = { :closed => true }
    end
  end


  def calculate_deadline(seconds, drop_off)
    drop_off_time       = Time.parse(drop_off)
    drop_off_day        = Time.parse(drop_off_time.strftime("%b %-d, %Y"))
    drop_off_day_opens  = add_time_to_day(drop_off_day, :opens)
    drop_off_day_closes = add_time_to_day(drop_off_day, :closes)


    if (drop_off_time + seconds) < drop_off_day_closes
      drop_off_time + seconds
    else
      seconds_to_close = (drop_off_day_closes - drop_off_time).to_i
      seconds_remaining = seconds - seconds_to_close

      if drop_off_time < drop_off_day_opens
        seconds_remaining += (drop_off_day_opens - drop_off_time).to_i
      end

      next_day = next_open_day(drop_off_day)
      add_time_to_day(next_day, :opens) + seconds_remaining
    end
  end



  def next_open_day(current_day)
    next_day = current_day + 86400
    next_day += 86400 while self[next_day][:closed]
    return next_day
  end


  def add_time_to_day(day, time)
    Time.parse("#{day.strftime("%b %-d, %Y")} #{self[day][time]}")
  end


  def default(key)
    if key.class == Time
      day_of_week = key.strftime("%a").downcase.to_sym
      self[day_of_week]
    else
      @defaults
    end
  end


  def convert_to_key(day)
    if day.class == String
      day = Time.parse(day)
    end
    return day
  end
end
