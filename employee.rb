class Employee
  attr_reader :name, :title, :salary, :boss
  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    unless @boss.nil?
      @boss.add_employee(self)
    end

  end

  def bonus(multiplier)
    @salary * multiplier
  end

  def inspect
    @name
  end




end


class Manager < Employee
  attr_reader :employees
  def initialize(name, title, salary, boss)
    super
    @employees = []
  end

  def bonus(multiplier)
    self.sub_employees.reduce(0) { |acc, employee| acc + employee.salary } * multiplier
  end

  def sub_employees
    sub_array = []
    self.employees.each do |employee|
      if employee.class == Manager
        sub_array << employee.sub_employees
      end
      sub_array << employee

      end
    sub_array.flatten
  end

  def add_employee(employee)
    @employees << employee
  end

  def inspect
    @name
  end

end

ned = Manager.new("Ned", "Founder", 1_000_000, nil)
bob = Manager.new("Bob", "Middle Management", 80_000, ned)
darren = Manager.new("Darren", "TA Manager", 78_000, bob)
shawna = Employee.new("Shawna", "TA", 12_000, darren)
david = Employee.new("David", "TA", 10_000, darren)

p ned.sub_employees
p bob.sub_employees
p ned.bonus(5) # => 500_000
p bob.bonus(4)
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000
