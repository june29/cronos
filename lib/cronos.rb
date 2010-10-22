class Cronos
  UNIT     = 60
  FIELDS   = [:min, :hour, :day, :month, :wday]
  UNIVERSE = { :min   => (0..59),
               :hour  => (0..23),
               :day   => (1..31),
               :month => (1..12),
               :wday  => (0..6)  }

  def initialize(*formats)
    @specifications = formats.map { |specification|
      Specification.new(specification)
    }
  end

  def next(pointer = Time.now)
    pointer = Time.local(pointer.year, pointer.month, pointer.day, pointer.hour, pointer.min)

    begin
      pointer += UNIT
    end until @specifications.any? { |specification| specification.matches(pointer) }
    pointer
  end

  class Specification
    def initialize(line)
      @definition = {}
      array = line.split(" ")

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

    def matches(item)
      FIELDS.all? { |field| @definition[field].include? item.send(field) }
    end
  end
end
