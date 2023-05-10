import requests

#url = "http://localhost:3000/sensor-data"
url = "http://mnlsvtserver.ddns.net:3000/sensor-data"
data = {"table_value":"off"}

r = requests.post(url,data=data)
print(data)
print(r.text)
