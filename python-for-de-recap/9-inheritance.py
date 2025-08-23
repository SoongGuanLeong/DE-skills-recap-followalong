class company:
    def __init__(self, com_name):
        self.com_name = com_name

    def company_info(self):
        print(f"Company name is {self.com_name}.")


class country:
    def __init__(self, country_name):
        self.country_name = country_name

    def country_info(self):
        print(f"Country name is {self.country_name}.")


class department(company):
    def __init__(self, dept_name, com_name):
        self.dept_name = dept_name
        company.__init__(self, com_name)

    def department_info(self):
        print(f"The department info is {self.dept_name} of {self.com_name}")


class employee(department, country):
    def __init__(self, emp_name, dept_name, com_name, country_name):
        self.emp_name = emp_name
        country.__init__(self, country_name)
        department.__init__(self, dept_name, com_name)
        # self.com_name = com_name

    def full_info(self):
        print(
            f"Employee {self.emp_name} lives in {self.country_name} and works for {self.com_name} in {self.dept_name}"
        )

    def all_info_child(self):
        print("This is running from employee")
        company.company_info(self)
        department.department_info(self)


emp1 = employee("Rahul", "HR", "XYZ", "US")

emp1.full_info()

emp1.all_info_child()

emp1.department_info()

emp1.country_info()

emp1.company_info()
