"""
Instance Method, Class Method, Static Method
"""


class employee:
    company_name = "XYZ"  # attributes / constants

    # constructor / variables
    def __init__(self, emp_name, emp_dept):
        self.emp_name = emp_name
        self.emp_dept = emp_dept

    # works but avoid changing class attributes this way
    def changes(self, new_company):
        employee.company_name = new_company

    @classmethod
    def changesInClass(cls, new_company):
        cls.company_name = new_company

    # methods
    @property  # getter
    def info(self):
        print(
            f"Employee {self.emp_name} works for {self.emp_dept} in {self.company_name}."
        )

    @info.setter
    def info(self, new_empdetails):
        new_empname = new_empdetails[0]
        new_empdept = new_empdetails[1]
        self.emp_name = new_empname
        self.emp_dept = new_empdept

    # def changeinfo(self, new_empname, new_empdept):
    #     self.emp_name = new_empname
    #     self.emp_dept = new_empdept

    @staticmethod
    def addition(x, y):
        return x + y


emp1 = employee("Priya", "IT")
emp2 = employee("Rahul", "HR")

emp1.info()
emp2.info()

emp2.company_name = "ABC"
emp1.company_name  # changing class variable for emp2

emp2.changes("DEF")

emp1.info()

emp1.addition(1, 2)

emp1.changeinfo("Priyaa", "HR")

print(emp1.info)

emp1.info = ["Priyaa", "HR"]
