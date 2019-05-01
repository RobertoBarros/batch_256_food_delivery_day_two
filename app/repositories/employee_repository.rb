class EmployeeRepository
  CSV_OPTIONS = { headers: :first_row, header_converters: :symbol }

  def initialize(csv_filepath)
    @csv_filepath = csv_filepath
    @employees = []
    load
  end

  def all
    @employees
  end

  def find(id)
    @employees.select { |employee| employee.id == id }.first
  end

  def all_delivery_guys
    @employees.select { |employee| employee.delivery_guy? }
  end

  def find_by_username(username)
    @employees.select { |employee| employee.username == username }.first
  end

  def load
    return unless File.exist?(@csv_filepath)

    CSV.foreach(@csv_filepath, CSV_OPTIONS) do |row|
      employee = Employee.new(id: row[:id].to_i, username: row[:username], password: row[:password], role: row[:role])
      @employees << employee
    end
  end


end