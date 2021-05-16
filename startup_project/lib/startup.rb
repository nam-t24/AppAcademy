require "employee"

class Startup

    def initialize(name, funding, salaries)
        @name=name
        @funding=funding
        @salaries=salaries
        @employees=[]
    end
    def name
        @name
    end
    def funding
        @funding
    end
    def salaries
        @salaries
    end
    def employees
        @employees
    end
    def valid_title?(title)
        @salaries.has_key?(title)
    end
    def >(startup)
        self.funding>startup.funding
    end
    def hire(employee_name, title)
        if valid_title?(title)
            @employees<<Employee.new(employee_name, title)
            return true
        end
        raise "error"
    end
    def size
        @employees.length
    end
    def pay_employee(employee)
        # debugger
        if @funding>=@salaries[employee.title]
            employee.pay(@salaries[employee.title])
            @funding-=@salaries[employee.title]
        else
            raise "error"
        end
    end
    def payday
        @employees.each {|employee| pay_employee(employee)}
    end

    def average_salary
        sum = @employees.inject(0) {|salary_sum, employee| salary_sum+@salaries[employee.title]}
        sum/(@employees.length*1.0)
    end
    def close
        @employees=[]
        @funding=0
    end
    def acquire(startup)
        
        @funding+=startup.funding
        @salaries={**startup.salaries,**@salaries}
        @employees=[*employees, *startup.employees]
        startup.close
    end

end
