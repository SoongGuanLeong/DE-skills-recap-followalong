tbl_list = ["products", "order", "customers"]

for i in tbl_list:
    if i.lower() == "order":
        print("Table Order")
    else:
        print("No Table Order")

# print("order")
# print("products")
# print("customers")

for i in tbl_list:
    print(i)
    for x in i:
        print(x)

# while
for i in tbl_list:
    if i.lower() == "order":
        continue
    print(i)

for i in tbl_list:
    if i.lower() == "order":
        break
    print(i)

x = 1
while x < 11:
    print(x)
    x += 1

x = 1
while 1 == 1:
    print("hello")
    x += 1

    if x > 10:
        break
