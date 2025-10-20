# E-Commerce Storefront & Backend

Product stranica izrađena prema Figma dizajnu korištenjem Next.js, TypeScript i TailwindCSS, integrirana sa Medusa sustavom koristeći Medusa.js SDK. Repozitorij sadrži direktorije za:

- backend sustav (Medusa)
- frontend aplikaciju (Next.js)
- db folder koji sadrži lokalnu verziju korištene baze(2 pristupa)

## Značajke

- Prikaz detalja proizvoda na Product stranici
- Dodavanje izabrane varijante proizvoda u košaricu
- Prikaz broja artikala u košarici u headeru

## Korištene tehnologije

| Layer | Technology |
|-------|-------------|
| Backend | MedusaJS  |
| Frontend | Next.js (React / TypeScript) |
| Database | PostgreSQL |
| Cache | Redis |
| Package Manager | Yarn (or npm) |
| Platform | Localhost (dev) |
| Component libraries         |        DaisyUI, Shadcn         |
| State management (cart header)         |        Zustand      |

## Potrebno imati instalirano

- Node.js ≥ 18
- PostgreSQL ≥ 14
- Redis
- Git
- Yarn or npm

## Konfiguracija za lokalno pokretanje

1. Klonirati repozitorij i ući u direktorij:
```
git clone https://github.com/dgabel01/e-commerce.git
cd e-commerce
```

2. Instalirati dependencije za backend:
```
cd medusa_backend
yarn install
```

3. Instalirati dependencije za frontend:
```
cd ../next_store
yarn install
```

4. Postaviti .env file-ove:

- Za medusa_backend:
```
//dodano u .env:
MEDUSA_ADMIN_ONBOARDING_TYPE=default
STORE_CORS=http://localhost:3000,http://127.0.0.1:3000
ADMIN_CORS=http://localhost:5173,http://localhost:9000,https://docs.medusajs.com
AUTH_CORS=http://localhost:5173,http://localhost:9000,http://localhost:8000,https://docs.medusajs.com
REDIS_URL=redis://localhost:6379
JWT_SECRET=supersecret
COOKIE_SECRET=supersecret
DATABASE_URL=postgres://medusa_admin:MedusaPass123@localhost/medusa-medusa_backend
DB_NAME=medusa_db
PORT=9001
```

- Za next_store:
```
//dodano u .env.local:
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9001
NEXT_PUBLIC_MEDUSA_API_KEY=pk_cd02fba29bb2f7a2b25e3e7654609b0ae534fe11b15d74cb4cbfc216ef4f9148
```

5. Postaviti bazu podataka:

**Korak 1: Kreirati bazu i korisnika**
```bash
psql postgres
```
```sql
CREATE USER medusa_admin WITH PASSWORD 'MedusaPass123';
CREATE DATABASE "medusa-medusa_backend";
GRANT ALL PRIVILEGES ON DATABASE "medusa-medusa_backend" TO medusa_admin;
\q
```

**Korak 2: Postaviti permisije na schema**
```bash
psql -U medusa_admin -d medusa-medusa_backend
```
```sql
GRANT ALL PRIVILEGES ON SCHEMA public TO medusa_admin;
ALTER SCHEMA public OWNER TO medusa_admin;
\q
```

**Korak 3: Učitati podatke (odabrati jednu opciju)**

Opcija A - korištenje .dump datoteke:
```bash
pg_restore -U medusa_admin -d medusa-medusa_backend -v db/medusa_db.dump
```

Opcija B(testirano lokalno te radi) - korištenje .sql datoteke:
```bash
psql -U medusa_admin -d medusa-medusa_backend -f db/medusa_backup.sql
```

**Napomena**: Ako dobijete grešku "permission denied", provjerite da li je korisnik medusa_admin vlasnik schema public.Također, ovaj pristup je odabran radi lakšeg postavljanja u odnosu na npr. seed skriptu sa productsima.

**Redis Setup**:
Medusa zahtijeva Redis za caching i background poslove. Pokrenuti Redis:
```bash
docker run -d --name redis -p 6379:6379 redis
```

Ili ako je Redis već instaliran lokalno:
```bash
redis-server
```



6. Pokrenuti backend u medusa_backend direktoriju te se logirati u sucelje stvaranjem korisnika(vidljiv na http://localhost:9001/store/products):
```
npx medusa develop
```

7. Pokrenuti frontend Next aplikaciju(vidljiva na http://localhost:3000/products):
```
cd next_store
yarn dev
```

## Osvrt na zadatak

**Procijenjeno vrijeme izrade**:
Ukupno oko 7 dana rada po nekoliko sati dnevno.
Tijekom tog vremena obuhvaćeni su svi koraci — od postavljanja i konfiguracije okruženja (PostgreSQL,  Medusa backend i Next.js frontend) do testiranja prikaza i funkcionalnosti proizvoda te responzivnog dizajna.

**Najzahtjevniji dijelovi**:

Upoznavanje s MedusaJS sustavom – razumijevanje strukture podataka, odnosa između proizvoda, varijanti, opcija i cijena.

Dohvat i prikaz cijena varijanti proizvoda – integracija varijantnih cijena na frontend strani zahtijevala je detaljno razumijevanje Medusa endpointa i povezanosti entiteta, nažalost neuspješan dohvat varijanti, cijena varijanti nije uključena u JSON Paloma Haven produkta ali njene varijante imaju cijene u svom JSON-u do koje nisu uspješno dohvaćene.

Ostali dijelovi, poput osnovne konfiguracije i prikaza proizvoda, bili su manje zahtjevni, ali su zahtijevali pažnju pri povezivanju Medusa backend URL-a, API ključeva i .env varijabli u Next.js projektu.
