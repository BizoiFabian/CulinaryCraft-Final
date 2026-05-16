# Culinary Craft — descrierea aplicației

Acest document descrie **ce face concret** aplicația Culinary Craft: fluxul utilizatorului în clientul mobil, ce date gestionează și cum se leagă de server. Pentru tehnologii, structură de foldere și pornire locală, vezi `README.md`.

---

## În două propoziții

**Culinary Craft** este o aplicație mobilă prin care utilizatorii autentificați pot **alege ingrediente** (din listă sau prin **fotografie**), **căuta rețete** care conțin acele ingrediente, **publica propriile rețete** (cu text și imagine), **salva rețete la favorite** și își pot **gestiona profilul**. Serverul Spring Boot persistă utilizatori, rețete, ingrediente și imagini în PostgreSQL și oferă și funcții auxiliare: înregistrare, autentificare (inclusiv Google), recuperare parolă prin cod pe e-mail, actualizare profil și ștergere/dezactivare cont.

---

## Rolul fiecărui strat

| Strat | Rol |
|--------|-----|
| **Aplicația Flutter** | Interfață pentru onboarding, autentificare, ecran principal (ingrediente + căutare), creare rețetă, listă rețete globală / „ale mele” / favorite, profil și „Despre noi”. |
| **API REST (Spring Boot)** | Validare și persistență: utilizatori, rețete legate de utilizator și ingrediente, favorite, încărcare imagini, flux parolă uitată, recunoaștere ingredient din imagine (script Python + mapare la ingredient din baza de date). |
| **PostgreSQL** | Stocare relațională: utilizatori, rețete, ingrediente, legături many-to-many (rețetă–ingredient, utilizator–rețete favorite), imagini asociate. |

---

## Fluxul utilizatorului în aplicație

### 1. Pornire și onboarding

- Ecranul inițial (**Get Started**) prezintă aplicația și duce utilizatorul mai departe.
- **Onboarding** (slideshow) explică ideea produsului (ex.: gătit cu inspirație, descoperire de gusturi).
- Apoi utilizatorul ajunge la **autentificare**: se poate continua cu **Google** sau merge la **autentificare clasică** (e-mail/parolă).

### 2. Conturi și autentificare

- **Creare cont**: nume de utilizator, e-mail, parolă (în client parola este trimisă ca hash SHA-256 către server).
- **Autentificare cu email/parolă**: după login reușit, utilizatorul este dus la **ecranul principal (Home)**; ID-ul utilizatorului este păstrat local pentru apeluri API.
- **Google Sign-In**: după autentificare Firebase, datele relevante sunt trimise la backend (`/sign-in-with-google`) pentru a crea/încorpora utilizatorul în sistemul aplicației, apoi navigare către Home.
- **Facebook**: există endpoint dedicat pe server; în fluxul actual al clientului trebuie verificat dacă este legat complet în UI (configurația din `globals` poate fi incompletă pentru calea Facebook).
- **Deconectare**: șterge datele locale de sesiune și revine la ecranul de autentificare socială/clasică.

### 3. Parolă uitată și schimbare parolă

- **Parolă uitată**: utilizatorul introduce e-mailul; serverul generează un cod de securitate și îl trimite prin e-mail (Jakarta Mail).
- **Verificare cod**: după validare, utilizatorul poate seta o parolă nouă (fluxul din `ChangePasswordWidget` / navigare din `AuthService`).
- **Schimbare parolă** (când utilizatorul este identificat și fluxul o permite): actualizare prin API.

### 4. Ecranul principal (Home) — ingrediente și „căutare inteligentă”

Aici stă nucleul experienței:

- **Listă de ingrediente** încărcată **paginat** de la server (scroll infinit). Fiecare ingredient are nume și imagine (URL din backend).
- Utilizatorul **bifează** ingredientele pe care le are sau vrea să le folosească.
- **Scanare cu camera sau galerie**: se trimite o fotografie la endpoint-ul **`/images/food-recognition`**. Pe server, imaginea este procesată cu un **script Python**; rezultatul este mapat la un **ingredient din baza de date**. Dacă este găsit, ingredientul este adăugat la selecție (în UI apare un mesaj de confirmare).
- Un buton duce la **vizualizarea rețetelor** filtrate după ingredientele selectate (vezi secțiunea următoare).

### 5. Rețete — vizualizare, căutare, favorite

- **Toate rețetele** (feed paginat): lista publică de rețete, fiecare cu titlu, descriere, ingrediente, utilizatori care au marcat rețeta (în model ca „likes”), imagine (inclusiv date imagine în răspuns când sunt disponibile).
- **Căutare după ingrediente**: se trimite lista de ID-uri de ingrediente selectate; serverul returnează rețetele care corespund criteriului (paginat).
- **Favorite**: utilizatorul poate **adăuga** sau **elimina** o rețetă din favorite; există ecran dedicat **„Saved Recipes”** (rețete salvate).
- **Rețete proprii**: utilizatorul vede doar rețetele create de el (paginat).
- **Ștergere rețetă**: proprietarul poate șterge o rețetă proprie din API.

### 6. Crearea unei rețete

- Utilizatorul **introduce titlul și descrierea** rețetei, alege **ingredientele** (din cele deja selectate în fluxul anterior), și poate **atașa o imagine** (fotografie).
- Trimiterea se face prin **multipart/form-data** către server: nume, descriere, ingrediente (ID-uri), fișier imagine. Serverul salvează rețeta, leagă ingredientele și asociază imaginea.

### 7. Profil și „Despre noi”

- **Profil**: afișează salut cu numele de utilizator; legături către editare profil, rețetele mele, rețete salvate, pagina despre echipă, deconectare.
- **Editare profil**: în backend se actualizează în principal **numele de utilizator** (`UserUpdateDTO` conține `username`).
- **About Us**: pagină statică cu informații despre dezvoltatori și linkuri (ex. LinkedIn, e-mail).

---

## Ce date reprezintă „o rețetă” în sistem

În baza de date, o rețetă are:

- identificator, **nume**, **descriere** (text lung),
- legătură obligatorie la **utilizatorul autor**,
- **listă de ingrediente** (relație many-to-many),
- **imagine** (entitate asociată / URL),
- utilizatori care au marcat rețeta la **favorite** (relație many-to-many cu utilizatorii).

---

## Funcții server relevante (fără a lista fiecare URL)

- **Autentificare**: înregistrare, login, Google/Facebook, parolă uitată, verificare cod, schimbare parolă, dezactivare cont, ștergere cont (cu e-mailuri de notificare unde e cazul).
- **Utilizatori**: actualizare profil.
- **Rețete**: CRUD parțial (creare, listări paginate, căutare după ingrediente, favorite, ștergere pentru autor).
- **Ingrediente**: listare paginată (și variante sortate după nume).
- **Imagini**: încărcare, servire după nume, **recunoaștere aliment** din imagine (Python) și returnare ingredient potrivit.

---

## Observații practice

- **Consistența portului**: în `README.md` principal este menționat adesea portul **8081**; în `globals.dart` din client apare **8080** pentru emulator Android (`10.0.2.2`). La rulare locală, trebuie aliniat portul serverului cu URL-ul din client.
- **Recunoașterea imaginilor** necesită **Python** și scriptul din `resources/scripts/food.py` pe mașina unde rulează backend-ul, plus calea corectă pentru proces.
- Pentru „contractul” exact al API-urilor (tipuri, parametri), sursa de adevăr rămâne **controlerele Spring** și **SpringDoc OpenAPI** după pornirea serverului.

---

*Document derivat din structura codului din repository; dacă UI-ul evoluează, unele denumiri de ecran sau ordinea fluxurilor pot fi ușor diferite față de textul de mai sus.*
