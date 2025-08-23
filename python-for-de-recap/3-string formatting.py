x = "Ansh Lamba Love"

print(x.upper())
print(x.lower())

print(x.replace("sh", "z"))

mylist = x.split(" ")
print(mylist)

file = "raw_data.orc"

if file.endswith(".csv"):
    print("CSV file")
if file.startswith("raw"):
    print("RAW file")

statement = "Hello Ansh. What are you doing? Hey Ansh I am talking to you."
print(statement.count("Ansh"))

demo_str = "Hello"
demo_var = 10
print(demo_str.isnumeric())
print(demo_var.isnumeric())

demo_var = "10"
print(demo_var.isnumeric())

demo_var = "10abc"
print(demo_var.isalnum())
