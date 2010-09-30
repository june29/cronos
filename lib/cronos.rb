class Cronos
  UNIT            = 60

  MINUTE          = (0..59)
  HOUR            = (0..23)
  DAY             = (1..31)
  MONTH           = (1..12)
  DAY_OF_THE_WEEK = (0..6)

  attr_reader :setting

  def initialize(setting)
    @setting = setting
    array = @setting.split(" ")

    @minute          = array[0] == "*" ? MINUTE          : [array[0].to_i]
    @hour            = array[1] == "*" ? HOUR            : [array[1].to_i]
    @day             = array[2] == "*" ? DAY             : [array[2].to_i]
    @month           = array[3] == "*" ? MONTH           : [array[3].to_i]
    @day_of_the_week = array[4] == "*" ? DAY_OF_THE_WEEK : [array[4].to_i]
  end

  def next(pointer = Time.now)
    pointer = Time.local(pointer.year, pointer.month, pointer.day, pointer.hour, pointer.min)

    loop {
      pointer += UNIT

      if           @minute.include?(pointer.min)   &&
                     @hour.include?(pointer.hour)  &&
                      @day.include?(pointer.day)   &&
                    @month.include?(pointer.month) &&
          @day_of_the_week.include?(pointer.wday)

        return pointer
      end
    }
  end
end
