# Campus Placement Management System

A campus recruitment database modelled as a **graph in Neo4j**, with a small Flask web dashboard on top of it. It tracks students, departments, companies, job postings, applications, interviews and offers.

The same data model can be built relationally (normalised to BCNF) or as a graph; this project takes the graph approach and shows how the placement process maps onto it.

---

## Why a graph database?

Campus recruitment is a chain of relationships: a student submits an application for a job posted by a company, the application leads to interviews, and an interview may lead to an offer. In SQL, questions that follow this chain need several JOINs across tables. In Neo4j the relationships are stored directly, so the same question is a single path pattern.

| | Relational (SQL) | Graph (Neo4j) |
|---|---|---|
| Student → job → company | 3 JOINs | one `MATCH` pattern |
| Student → offer (full journey) | 5 JOINs | one path, variable length |
| Adding a new relationship type | schema change | add a new relationship |
| Strict tabular reports, heavy transactions | strong | weaker |

SQL is still the better fit for fixed tabular reporting and strict transactional rules. The graph model is the better fit for exploring connections.

---

## Graph model

**Nodes:** `Department`, `Student`, `Company`, `Job`, `Application`, `Interview`, `Offer`

**Relationships**

```
(Student)-[:BELONGS_TO]->(Department)
(Company)-[:POSTS]->(Job)
(Student)-[:SUBMITTED]->(Application)-[:FOR]->(Job)
(Application)-[:HAS_INTERVIEW]->(Interview)-[:RESULTED_IN]->(Offer)
```

**EER specialisation:** the `Job` superclass has a disjoint, total specialisation into internships and full-time jobs. In the graph this becomes an extra label on the same node: a job is either `:Job:Internship` (with duration, stipend, work mode, start date) or `:Job:FullTime` (with CTC, bond period, joining date, openings).

**Sample data:** 20 departments, 20 students, 20 companies, 40 jobs (20 internships and 20 full-time), 20 applications, 20 interviews, 20 offers.

---

## Project structure

```
.
├── app.py                  # Flask backend: runs Cypher queries, serves the API
├── static/
│   └── index.html          # Frontend dashboard (HTML, CSS, JavaScript)
├── load_data.cypher        # Creates constraints and loads all sample data
├── requirements.txt        # Python dependencies
├── .env.example            # Template for database credentials
└── README.md
```

**Architecture:**

```
Browser (index.html)  →  Flask (app.py)  →  Neo4j Aura (Query API over HTTPS)
```

The browser never talks to the database directly. The Flask server holds the credentials and runs the queries.

---

## Setup

### 1. Create the database

1. Create a free instance at [console.neo4j.io](https://console.neo4j.io) (AuraDB Free) and save the credentials file it gives you.
2. Open the **Query** tool for the instance.
3. Paste the contents of `load_data.cypher` and run it. If the editor runs one statement at a time, run each section in order.
4. The last statement counts the nodes. You should see Student 20, Department 20, Company 20, Job 40, Application 20, Interview 20, Offer 20.

### 2. Run the dashboard

```bash
pip install -r requirements.txt
```

Copy `.env.example` to `.env` and fill in your Aura details:

```
NEO4J_URI=neo4j+s://xxxxxxxx.databases.neo4j.io
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=your-password
NEO4J_DATABASE=
```

Leave `NEO4J_DATABASE` blank unless your Aura console shows a different database name. Then start the server:

```bash
python app.py
```

Open <http://localhost:5000>.

> Never commit your `.env` file. It is listed in `.gitignore`.

---

## Dashboard features

- **Overview:** totals, placement rate, application status split, accepted offers by department, top companies.
- **Applications:** search by student, company or role, filter by status, and update an application's status (saved to the graph).
- **Companies:** roles posted, applications received and selections for each company.
- **Student journey:** follow one student from application to interview to offer.

---

## Example Cypher queries

**Students with their company and job**

```cypher
MATCH (s:Student)-[:SUBMITTED]->(a:Application)-[:FOR]->(j:Job)<-[:POSTS]-(c:Company)
RETURN s.name AS student, j.title AS job, c.name AS company, a.status AS status
```

**Full placement journey (graph view)**

```cypher
MATCH (s:Student)-[:SUBMITTED]->(a:Application)-[:FOR]->(j:Job)<-[:POSTS]-(c:Company),
      (a)-[:HAS_INTERVIEW]->(i:Interview)-[:RESULTED_IN]->(o:Offer {status: 'Accepted'})
RETURN s, a, j, c, i, o
```

**Accepted offers per department**

```cypher
MATCH (d:Department)<-[:BELONGS_TO]-(:Student)-[:SUBMITTED]->(:Application)
      -[:HAS_INTERVIEW]->(:Interview)-[:RESULTED_IN]->(o:Offer {status: 'Accepted'})
RETURN d.name AS department, count(o) AS accepted_offers
ORDER BY accepted_offers DESC
```

**Internship summary using the specialisation label**

```cypher
MATCH (j:Internship)
RETURN j.work_mode AS mode, count(*) AS internships, round(avg(j.stipend)) AS avg_stipend
```

**Full-time jobs paying above the average CTC**

```cypher
MATCH (j:FullTime) WITH avg(j.ctc) AS avgCtc
MATCH (c:Company)-[:POSTS]->(j:FullTime) WHERE j.ctc > avgCtc
RETURN j.title AS job, c.name AS company, j.ctc AS ctc ORDER BY ctc DESC
```

---

## Technology

- **Database:** Neo4j (graph), hosted on AuraDB Free, queried with Cypher
- **Backend:** Python, Flask, Neo4j Query API (HTTPS)
- **Frontend:** HTML, CSS and JavaScript (no framework)
