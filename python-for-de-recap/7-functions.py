def my_function(x):
    if x > 10:
        print("Greater than 10")
    else:
        print("IDK")
    return x


my_function(20)
my_function(5)

y = my_function(30)
print(y)


def my_function(x, y=30):
    return x, y


my_function(20)
my_function(20, 30)


def my_function(*x):
    return x


my_function(1, 2, 3, 4, 5)


def my_function(**x):
    return x


my_function(x=20, y=60, z=70)


def add(x, y):
    return x + y


var = add(10, 20)

# lambda {parameters}: {return value}
add = lambda x, y: x + y
var = add(10, 20)

"""
map, filter, reduce
"""

my_list = [1, 2, 3, 4, 5, 6]


def square(x):
    return [i * i for i in x]


square(my_list)


def square(x):
    return x * x


# map(function, list)
result = map(square, my_list)
type(result)
result = list(result)

# filter(function, list)
result = filter(lambda x: x % 2 == 0, my_list)
result = list(result)

# reduce(function, list)
from functools import reduce


def multiply(x, y):
    return x * y


result = reduce(multiply, my_list)

"""
Exception handling
"""
try:
    x = "10"
    if x > 10:
        print("Greater than 10")
    else:
        print("IDK")
except Exception as e:
    print(f"You got this error{e}")
finally:
    print("This will always run")

print("Hello world")


def my_func(x):
    try:
        if x % 2 == 0:
            return 1
    except Exception as e:
        return e
    finally:
        print("Hello world")


my_func(4)


"""
RAISE error
"""
x = 99
if x < 100:
    raise ValueError("Value less than 100 is not allowed")

"""
enumerate
"""
my_list = ["a", "b", "c", "d", "e"]
# stores list as index and value
for i in enumerate(my_list):
    print(i)
