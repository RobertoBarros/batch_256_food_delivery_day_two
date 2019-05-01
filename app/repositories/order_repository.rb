class OrderRepository
  CSV_OPTIONS = { headers: :first_row, header_converters: :symbol }

  def initialize(csv_filepath, meal_repository, employee_repository, customer_repository)
    @csv_filepath = csv_filepath
    @meal_repository = meal_repository
    @employee_repository = employee_repository
    @customer_repository = customer_repository
    @orders = []
    load
    @next_id = @orders.empty? ? 1 : @orders.last.id + 1
  end

  def add(order)
    order.id = @next_id
    @orders << order
    save
    @next_id += 1
  end

  def all
    @orders
  end

  def find(id)
    @orders.select { |order| order.id == id }.first
  end

  def undelivered_orders
    @orders.reject { |order| order.delivered? }
  end

  def load
    return unless File.exist?(@csv_filepath)

    CSV.foreach(@csv_filepath, CSV_OPTIONS) do |row|
      meal_id = row[:meal_id].to_i
      meal = @meal_repository.find(meal_id)

      customer_id = row[:customer_id].to_i
      customer = @customer_repository.find(customer_id)

      employee_id = row[:employee_id].to_i
      employee = @employee_repository.find(employee_id)

      order = Order.new(id: row[:id].to_i, delivered: row[:delivered] == 'true', meal: meal, customer: customer, employee: employee)
      @orders << order
    end
  end

  def save
    CSV.open(@csv_filepath, 'wb', CSV_OPTIONS) do |csv|
      csv << %i[id delivered meal_id customer_id employee_id]

      @orders.each do |order|
        csv << [order.id, order.delivered?, order.meal.id, order.customer.id, order.employee.id]
      end
    end
  end

end