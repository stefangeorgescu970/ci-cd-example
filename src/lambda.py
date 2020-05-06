import os
import requests

def handler(event, context):
  url = "http://api.quotable.io/random"
  response = requests.get(url)
  data = response.json()
  print(data["content"])


if __name__ == "__main__":
  handler(None, None)
