# Culinary Craft

Proiect de licență — aplicație pentru descoperirea și partajarea rețetelor culinare: utilizatori pot crea rețete, gestiona ingrediente, marca favorite și își pot gestiona profilul.

Pentru o **descriere amănunțită a fluxurilor și a ceea ce face aplicația** (ecrane, căutare după ingrediente, scanare foto, rețete, favorite etc.), vezi **[README_DETALIAT.md](README_DETALIAT.md)**.

## Obiectiv

O platformă care combină un **client mobil (Flutter)** cu un **API REST (Spring Boot)** și o **bază de date relațională**, pentru a susține autentificarea, conținutul (rețete, imagini) și interacțiunile de bază între utilizatori și rețete.

## Tehnologii folosite

| Strat | Tehnologii |
|--------|------------|
| **Frontend** | Flutter (Dart 3), `go_router` / rute declarative, `provider`, `http`, UI (Material, Google Fonts, animații) |
| **Autentificare (client)** | Firebase (Auth, Analytics), Google Sign-In, Facebook Login |
| **Backend** | Java 17, **Spring Boot 3.2**, Spring Data JPA, Hibernate |
| **API & docs** | REST (`/api/v1/...`), **SpringDoc OpenAPI** (Swagger UI) |
| **Bază de date** | **PostgreSQL** |
| **Altele (server)** | Thymeleaf (șabloane unde e cazul), e-mail (Jakarta Mail + șabloane), ModelMapper, Lombok |

## Arhitectură (pe scurt)

```
frontend/culinary_craft/   → aplicație Flutter
backend/culinarycraft/     → serviciu Spring Boot (port implicit 8081 în config)
```

Clientul apelează API-ul; datele persistente (utilizatori, rețete, ingrediente, imagini, relații precum favorite) sunt în PostgreSQL.

## Funcționalități principale (direcție de dezvoltare)

- Înregistrare / autentificare (inclusiv Google și Facebook pe client)
- Profil utilizator și editare profil
- Rețete: listare paginată, detalii, creare, rețetele mele, favorite
- Ingrediente (endpointuri dedicate)
- Încărcare imagini asociate conținutului
- Fluxuri auxiliare: parolă uitată / reset cu cod, schimbare parolă (conform implementării din backend)

*(Detaliile exacte ale ecranului pot evolua; sursa de adevăr pentru contractul API este codul din `controller`-e și documentația OpenAPI la pornirea serverului.)*

## Pornire rapidă (dezvoltare)

1. **PostgreSQL**: creați baza (ex. `culinary_craft_db`) și actualizați `application.yaml` cu URL, utilizator și parolă locală — fără a comite secrete în repo.
2. **Backend**: din `backend/culinarycraft/culinarycraft` — `mvn spring-boot:run` (sau rulare din IDE). API: de regulă `http://localhost:8081/api/v1/...`; Swagger UI este disponibil prin SpringDoc (calea standard `/swagger-ui.html` sau ce indică versiunea folosită).
3. **Frontend**: din `frontend/culinary_craft` — `flutter pub get`, apoi `flutter run`; configurați Firebase și URL-ul API dacă diferă de mediul local.

---

*Autor: proiect licență — document orientativ pentru îndrumare; detaliile tehnice finale se regăsesc în sursă și în documentația lucrării.*
