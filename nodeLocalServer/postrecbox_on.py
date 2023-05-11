import requests

#url = "http://localhost:3000/sensor-data"
url = "http://mnlsvtserver.ddns.net:3000/sensor-data"
data = {"storeId" : 1,
	"tableId" : 3,
	"isFree" : "no"}

r = requests.post(url,data=data)

print(r.text)
