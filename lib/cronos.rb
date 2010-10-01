class Cronos
  UNIT     = 60
  FIELDS   = [:min, :hour, :day, :month, :wday]
  UNIVERSE = { :min   => (0..59),
               :hour  => (0..23),
               :day   => (1..31),
               :month => (1..12),
               :wday  => (0..6)  }

  attr_reader :format

  def initialize(format)
    @format = format
    array = @format.split(" ")

    @definition = {}

    FIELDS.each_with_index { |field, index|
      if array[index] == "*"
        @definition[field] = UNIVERSE[field]
      else
        @definition[field] = array[index].split(",").map { |element|
          if element =~ /^\d+$/
            field == :wday ? (element.to_i % 7) : element.to_i
          elsif element =~ /^(\d+)\-(\d+)$/
            ($1.to_i..$2.to_i).to_a
          end
        }.flatten
      end
    }
  end

  def next(pointer = Time.now)
    pointer = Time.local(pointer.year, pointer.month, pointer.day, pointer.hour, pointer.min)

    loop {
      pointer += UNIT

      if FIELDS.all? { |field| @definition[field].include? pointer.send(field) }
        return pointer
      end
    }
  end
end
