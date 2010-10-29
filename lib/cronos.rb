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

  def schedule(parameters)
    return schedules(parameters.merge({ :size => 1 })).first
  end

  def schedules(parameters)
    size = parameters.delete(:size) || 1
    from = parameters.delete(:from) || Time.now
    to   = parameters.delete(:to)   || from + (60 * 60 * 24)

    pointer = from

    results = []

    while results.size < size
      pointer += UNIT

      if @specifications.any? { |specification| specification.matches pointer }
        results << pointer
      end
    end

    return results.sort
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
