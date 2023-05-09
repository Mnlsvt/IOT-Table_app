import requests

#url = "http://localhost:3000/sensor-data"
url = "http://mnlsvtserver.ddns.net:3000/sensor-data"
data = {"temperature": 25,"humidity": 60,"pressure": 1013}

r = requests.post(url,data=data)
print(data)
print(r.text)
