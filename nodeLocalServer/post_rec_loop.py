import requests
import time

#url = "http://localhost:3000/sensor-data"
url = "http://mnlsvtserver.ddns.net:3000/sensor-data"
while True:
        for i in range(10):
                if (i==1 or i==3 or i==5 or i==7 or i==8 or i==10):
                        data = {"storeId" : 1,
                                "tableId" : 1,
                                "isFree" : "yes"}
                else:
                        data = {"storeId" : 1,
                                "tableId" : 1,
                                "isFree" : "no"}
                r = requests.post(url,data=data)

                if (i==1 or i==3 or i==5 or i==7 or i==8 or i==10):
                        data = {"storeId" : 2,
                                "tableId" : 1,
                                "isFree" : "yes"}
                else:
                        data = {"storeId" : 2,
                                "tableId" : 1,
                                "isFree" : "no"}
                r = requests.post(url,data=data)

                if (i==1 or i==3 or i==5 or i==7 or i==8 or i==10):
                        data = {"storeId" : 3,
                                "tableId" : 1,
                                "isFree" : "yes"}
                else:
                        data = {"storeId" : 3,
                                "tableId" : 1,
                                "isFree" : "no"}
                r = requests.post(url,data=data)


                time.sleep(5)
print(r.text)
