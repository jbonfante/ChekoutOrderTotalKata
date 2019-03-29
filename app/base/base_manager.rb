class BaseManager
  attr_accessor :list, :logger, :id_counter, :managed_klass

  def initialize
    @id_counter  = 0
    @list        = []
    @logger      = Logger.new(STDOUT)
    @managed_klass = nil
    logger.level = Logger::INFO
  end

  def add(options={ update: false})
    begin
      existing = find_by_name(options[:name])
      if existing.nil?
        item = managed_klass.new(options.merge({id: id_counter}))
        list.push(item)
        logger.info(item)
        self.id_counter += 1
      elsif options[:update].present?
        update(existing.id, options)
      else
        logger.error("#{options[:name]} has already been added.")
        logger.info("If you want to update instead, pass `update: true` in options parameters.")
      end


    rescue ArgumentError => msg
      logger.error("#{self.class} - Add: ") { "#{msg}" }
    end
  end

  def update(id, options)
    find_by_id(id).update(options)
  end

  def find(options={ id: nil , name: nil})
    if options[:id]
      return find_by_id(options[:id])
    end
    if options[:name]
      return find_by_name(options[:name])
    end
    nil
  end

  def find_by_id(id)
    raise ArgumentError.new('ID must be a valid integer') unless id.is_a?(Integer)
    list.filter { |item| item.id == id }.first || nil
  end

  def find_by_name(name)
    raise ArgumentError.new('Name is blank') unless name.present?
    list.filter { |item| item.name.downcase == name.downcase }.first || nil
  end
end
