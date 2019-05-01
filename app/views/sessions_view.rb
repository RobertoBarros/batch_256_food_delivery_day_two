class SessionsView

  def ask_username
    puts "Enter Username:"
    gets.chomp
  end

  def ask_password
    puts "Enter Password:"
    gets.chomp
  end

  def wrong_credentials
    puts "Wrong Credentials!"
  end

  def welcome(employee)
    puts "Welcome #{employee.username}"
  end

end