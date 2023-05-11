import requests
import time

#url = "http://localhost:3000/sensor-data"
url = "http://mnlsvtserver.ddns.net:3000/sensor-data"
data = {"storeId" : 1,
	"tableId" : 2,
	"isFree" : "yes"}

r = requests.post(url,data=data)
print(r.text)
