import requests

response = requests.get("https://jsonplaceholder.typicode.com/posts/1")

response.status_code

data = response.json()
