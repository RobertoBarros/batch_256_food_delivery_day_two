class MealRepository
  CSV_OPTIONS = { headers: :first_row, header_converters: :symbol }

  def initialize(csv_filepath)
    @csv_filepath = csv_filepath
    @meals = []
    load
    @next_id = @meals.empty? ? 1 : @meals.last.id + 1
  end

  def add(meal)
    meal.id = @next_id
    @meals << meal
    save
    @next_id += 1
  end

  def all
    @meals
  end

  def find(id)
    @meals.select { |meal| meal.id == id }.first
  end

  def load
    return unless File.exist?(@csv_filepath)

    CSV.foreach(@csv_filepath, CSV_OPTIONS) do |row|
      meal = Meal.new(id: row[:id].to_i, name: row[:name], price: row[:price].to_i)
      @meals << meal
    end
  end

  def save
    CSV.open(@csv_filepath, 'wb', CSV_OPTIONS) do |csv|
      csv << %i[id name price]

      @meals.each do |meal|
        csv << [meal.id, meal.name, meal.price]
      end
    end
  end

end