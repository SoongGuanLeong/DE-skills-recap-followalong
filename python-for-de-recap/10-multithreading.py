import time
import random
from concurrent.futures import ThreadPoolExecutor

tables = ["orders", "products", "customers", "reviews", "cancels"]


def my_func(x):
    # wait = random.randint(1, 10)
    wait = 3
    time.sleep(wait)
    print(f"I am {x}. I took {wait} seconds.")


for i in tables:
    my_func(i)

with ThreadPoolExecutor(max_workers=len(tables)) as executor:
    futures = executor.map(my_func, tables)

with ThreadPoolExecutor(max_workers=len(tables)) as executor:
    for i in tables:
        future = executor.submit(my_func, i)
