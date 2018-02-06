---
summary: 'A webapp that gives my approximate location around the UCL main campus based on which wifi access point I am connected to.'
source: 'https://github.com/hennersz/locator'
website: 'http://wie.morti.net/'
status: 'Running but otherwise unmaintained'
---

After receiving messages daily from friends asking where I was studying I decided to automate the process of answering this question. 

I started by collecting the MAC addresses of access points and associating with the name of the room/area of UCL I was in. This was made easy by OSXs airport command line utility. Apple don't make this easy to find as the binary isn't in the default path, or anywhere obvious for that matter. You can find it at `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport`. I used this in [importXML.js](https://github.com/hennersz/locator/blob/master/importXML.js). It takes a name for the area I am in then stores that name and the MAC address of every access point in range in a mongo database.

I then made [a script](https://github.com/hennersz/locator/blob/master/client.py) which sends the MAC address of the access point my laptop is currently connected to, to a server. This is run every 15 minutes using cron. The server then maps this to a room/area using the records in the database which is then displayed on the index page.

Because one access point will generally serve many rooms this means the location reported only gives a rough idea about where I am. I could potentially improve this by also including the signal strenght data and using this to triangulate my positon. 
