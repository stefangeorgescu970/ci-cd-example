import os
import requests

def handler(event, context):
  url = "http://api.quotable.io/random"
  response = requests.get(url)
  response_json = response.json()
  print(response_json["content"])


if __name__ == "__main__":
  handler(None, None)
