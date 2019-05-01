class Router

  def initialize(orders_controller, meals_controller, customers_controller, sessions_controller)
    @orders_controller = orders_controller
    @meals_controller = meals_controller
    @customers_controller = customers_controller
    @sessions_controller = sessions_controller
  end

  def run

    @employee = @sessions_controller.sign_in

    loop do
      if @employee.manager?
        print_manager_actions
        puts "Enter your option:"
        index = gets.chomp.to_i
        dispatch_manager(index)
      else
        print_delivery_guy_actions
        puts "Enter your option:"
        index = gets.chomp.to_i
        dispatch_delivery_guy(index)
      end
    end
  end

  def print_manager_actions
    puts "1. Add a meal"
    puts "2. List all meals"
    puts "-" * 30
    puts "3. Add customer"
    puts "4. List all customers"
    puts "-" * 30
    puts "5. List all undelivered orders"
    puts "6. Add new order"
  end

  def print_delivery_guy_actions
    puts "1. List all undelivered orders"
    puts "2. Mark order as delivered"
  end

  def dispatch_manager(index)
    case index
    when 1 then @meals_controller.add
    when 2 then @meals_controller.list
    when 3 then @customers_controller.add
    when 4 then @customers_controller.list
    when 5 then @orders_controller.list_undelivered_orders
    when 6 then @orders_controller.add
    end
  end

  def dispatch_delivery_guy(index)
    case index
    when 1 then @orders_controller.list_my_undelivered_orders(@employee)
    when 2 then @orders_controller.mark_as_delivered(@employee)
    end
  end
end