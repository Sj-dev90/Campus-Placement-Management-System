import os
from dotenv import load_dotenv
from flask import Flask, jsonify, request, send_from_directory, abort
import requests

load_dotenv()

# Talks to Aura over HTTPS (port 443) using the Query API, so it works
# even on networks that block the normal Neo4j port (7687).
HOST = os.environ["NEO4J_URI"].split("://")[1].strip().rstrip("/")
DB = os.getenv("NEO4J_DATABASE") or HOST.split(".")[0]
URL = f"https://{HOST}/db/{DB}/query/v2"
AUTH = (os.environ["NEO4J_USERNAME"], os.environ["NEO4J_PASSWORD"])
STATUSES = ["Applied", "Shortlisted", "Rejected", "Selected"]

app = Flask(__name__, static_folder="static")


def run(cypher, **params):
    r = requests.post(URL, json={"statement": cypher, "parameters": params}, auth=AUTH, timeout=30)
    if not r.ok:
        print("Neo4j error:", r.status_code, r.text[:500])
        r.raise_for_status()
    d = r.json()["data"]
    return [dict(zip(d["fields"], row)) for row in d["values"]]


@app.get("/")
def index():
    return send_from_directory("static", "index.html")


@app.get("/api/summary")
def summary():
    totals = run("""
        RETURN COUNT { MATCH (:Student) } AS students,
               COUNT { MATCH (:Company) } AS companies,
               COUNT { MATCH (:Job) } AS jobs,
               COUNT { MATCH (:Application) } AS applications,
               COUNT { MATCH (:Interview) } AS interviews,
               COUNT { MATCH (o:Offer) WHERE o.status = 'Accepted' } AS accepted
    """)[0]
    placed = run("""
        MATCH (s:Student)-[:SUBMITTED]->(:Application)-[:HAS_INTERVIEW]->(:Interview)
              -[:RESULTED_IN]->(:Offer {status: 'Accepted'})
        RETURN count(DISTINCT s) AS placed
    """)[0]["placed"]
    status = run("MATCH (a:Application) RETURN a.status AS status, count(*) AS n")
    return jsonify(totals=totals, placed=placed, status=status)


@app.get("/api/departments")
def departments():
    return jsonify(run("""
        MATCH (d:Department)
        OPTIONAL MATCH (d)<-[:BELONGS_TO]-(s:Student)
        WITH d, count(s) AS students
        OPTIONAL MATCH (d)<-[:BELONGS_TO]-(:Student)-[:SUBMITTED]->(:Application)
                       -[:HAS_INTERVIEW]->(:Interview)-[:RESULTED_IN]->(o:Offer {status: 'Accepted'})
        RETURN d.name AS name, students, count(o) AS accepted
        ORDER BY accepted DESC, name
    """))


@app.get("/api/companies")
def companies():
    return jsonify(run("""
        MATCH (c:Company)
        OPTIONAL MATCH (c)-[:POSTS]->(j:Job)
        WITH c, count(j) AS jobs
        OPTIONAL MATCH (c)-[:POSTS]->(:Job)<-[:FOR]-(a:Application)
        WITH c, jobs, count(a) AS applications,
             sum(CASE WHEN a.status = 'Selected' THEN 1 ELSE 0 END) AS selected
        RETURN c.name AS name, c.industry AS industry, c.hr_name AS hr,
               jobs, applications, selected
        ORDER BY selected DESC, name
    """))


@app.get("/api/applications")
def applications():
    return jsonify(run("""
        MATCH (s:Student)-[:SUBMITTED]->(a:Application)-[:FOR]->(j:Job)<-[:POSTS]-(c:Company)
        WHERE ($status = '' OR a.status = $status)
          AND ($q = '' OR toLower(s.name) CONTAINS toLower($q)
                       OR toLower(c.name) CONTAINS toLower($q)
                       OR toLower(j.title) CONTAINS toLower($q))
        RETURN a.application_id AS id, s.name AS student, j.title AS job, c.name AS company,
               CASE WHEN j:Internship THEN 'Internship' ELSE 'Full-time' END AS type,
               a.status AS status, toString(a.application_date) AS applied
        ORDER BY a.application_id
    """, q=request.args.get("q", "").strip(), status=request.args.get("status", "")))


@app.post("/api/applications/<int:app_id>/status")
def set_status(app_id):
    status = (request.get_json(silent=True) or {}).get("status")
    if status not in STATUSES:
        abort(400)
    rows = run("MATCH (a:Application {application_id: $id}) SET a.status = $s RETURN a.status AS status",
               id=app_id, s=status)
    if not rows:
        abort(404)
    return jsonify(rows[0])


@app.get("/api/students")
def students():
    return jsonify(run("""
        MATCH (s:Student)-[:BELONGS_TO]->(d:Department)
        RETURN s.student_id AS id, s.name AS name, d.name AS department ORDER BY s.name
    """))


@app.get("/api/students/<int:sid>")
def student(sid):
    rows = run("""
        MATCH (s:Student {student_id: $id})-[:BELONGS_TO]->(d:Department)
        OPTIONAL MATCH (s)-[:SUBMITTED]->(a:Application)-[:FOR]->(j:Job)<-[:POSTS]-(c:Company)
        OPTIONAL MATCH (a)-[:HAS_INTERVIEW]->(i:Interview)
        OPTIONAL MATCH (i)-[:RESULTED_IN]->(o:Offer)
        RETURN s.name AS name, s.registration_no AS reg, s.email AS email, s.cgpa AS cgpa,
               d.name AS department, j.title AS job, c.name AS company, a.status AS status,
               toString(a.application_date) AS applied, i.round AS round,
               toString(i.interview_date) AS interview_date, i.mode AS mode, i.result AS result,
               o.status AS offer_status, o.salary_offered AS salary, toString(o.joining_date) AS joining
    """, id=sid)
    if not rows:
        abort(404)
    return jsonify(rows)


if __name__ == "__main__":
    app.run(debug=True, port=5000)
