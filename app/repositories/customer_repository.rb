class CustomerRepository
  CSV_OPTIONS = { headers: :first_row, header_converters: :symbol }

  def initialize(csv_filepath)
    @csv_filepath = csv_filepath
    @customers = []
    load
    @next_id = @customers.empty? ? 1 : @customers.last.id + 1
  end

  def add(customer)
    customer.id = @next_id
    @customers << customer
    save
    @next_id += 1
  end

  def all
    @customers
  end

  def find(id)
    @customers.select { |customer| customer.id == id }.first
  end

  def load
    return unless File.exist?(@csv_filepath)

    CSV.foreach(@csv_filepath, CSV_OPTIONS) do |row|
      customer = Customer.new(id: row[:id].to_i, name: row[:name], address: row[:address])
      @customers << customer
    end
  end

  def save
    CSV.open(@csv_filepath, 'wb', CSV_OPTIONS) do |csv|
      csv << %i[id name address]

      @customers.each do |customer|
        csv << [customer.id, customer.name, customer.address]
      end
    end
  end

end