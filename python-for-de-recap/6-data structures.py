"""
LIST
"""

my_list = [1, 2, "Ansh", "Lamba", ["aa", "bb", "cc"]]

print(my_list[4][1])  # Accessing first element

my_list[-3:]

my_list[len(my_list) - 3 : len(my_list)]

my_list = [1, 2, "Ansh", "Lamba", 3, 4, 5, 6]

print(my_list[::2])

my_list.append("Hero")  # mutable, so we do not need to use =
print(my_list)

my_list.insert(1, "Hero")
print(my_list)

my_list.pop()  # remove last element
print(my_list)

my_list = [1, 2, 3, 4, 5, 6]

for i in reversed(my_list):
    print(i)

my_list.reverse()
print(my_list)

my_list[::-1]

# list comprehension
my_list = [1, 2, 3, 4, 5, 6]
new_list = []
for i in my_list:
    new_list.append(i * i)
print(new_list)

new_list = [i * i for i in my_list]
print(new_list)

new_list = [i * i for i in my_list if i % 2 == 0]
print(new_list)

# [{return value} for {item} in {iterable} (if {condition})+]
new_list = [i * i for i in my_list if i % 2 == 0 if i != 6]
print(new_list)

"""
DICTIONARY
"""
my_dict = {"x": 1, "y": 2, "z": 3}

my_dict["x"] = 10

my_dict.pop("z")  # mutable, so we do not need to use =

my_dict.keys()
my_dict.values()
my_dict.items()

my_dict = {"x": 1, "y": 2, "z": 3, "demo": {"a": 1, "b": 2, "c": 3}}
my_dict["demo"]
my_dict["demo"]["b"]

"""
SET
"""
a = {1, 2, 3, 4, 5, 5, 5, 5, 5, 5, 5, 6}
type(a)

b = {10, 11, 3, 2, 5}

a.union(b)
a.intersection(b)

a.remove(2)

a.add(20)

a = {}
type(a)

a = set()
type(a)

"""
TUPLE
"""
my_tup = (1, 2, 3, 4, 5, 6)

my_tuplist = list(my_tup)
my_tuplist.append(7)

my_tup = tuple(my_tuplist)
