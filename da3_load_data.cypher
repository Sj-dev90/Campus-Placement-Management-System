// ---------- 1. CONSTRAINTS ----------
CREATE CONSTRAINT dept_id IF NOT EXISTS FOR (n:Department) REQUIRE n.department_id IS UNIQUE;
CREATE CONSTRAINT student_id IF NOT EXISTS FOR (n:Student) REQUIRE n.student_id IS UNIQUE;
CREATE CONSTRAINT company_id IF NOT EXISTS FOR (n:Company) REQUIRE n.company_id IS UNIQUE;
CREATE CONSTRAINT job_id IF NOT EXISTS FOR (n:Job) REQUIRE n.job_id IS UNIQUE;
CREATE CONSTRAINT application_id IF NOT EXISTS FOR (n:Application) REQUIRE n.application_id IS UNIQUE;
CREATE CONSTRAINT interview_id IF NOT EXISTS FOR (n:Interview) REQUIRE n.interview_id IS UNIQUE;
CREATE CONSTRAINT offer_id IF NOT EXISTS FOR (n:Offer) REQUIRE n.offer_id IS UNIQUE;

// ---------- 2. DEPARTMENTS ----------
UNWIND [
  [1, 'Computer Science and Engineering', 'Dr. Rajesh Kumar', 'cse@college.edu', '9000000001'],
  [2, 'Information Technology', 'Dr. Priya Sharma', 'it@college.edu', '9000000002'],
  [3, 'Electronics and Communication Engineering', 'Dr. Arun Mehta', 'ece@college.edu', '9000000003'],
  [4, 'Electrical and Electronics Engineering', 'Dr. Neha Singh', 'eee@college.edu', '9000000004'],
  [5, 'Mechanical Engineering', 'Dr. Vikram Rao', 'mech@college.edu', '9000000005'],
  [6, 'Civil Engineering', 'Dr. Anil Verma', 'civil@college.edu', '9000000006'],
  [7, 'Artificial Intelligence and Data Science', 'Dr. Sneha Iyer', 'aids@college.edu', '9000000007'],
  [8, 'Cyber Security', 'Dr. Karan Malhotra', 'cyber@college.edu', '9000000008'],
  [9, 'Biotechnology', 'Dr. Meera Nair', 'biotech@college.edu', '9000000009'],
  [10, 'Chemical Engineering', 'Dr. Rohan Gupta', 'chem@college.edu', '9000000010'],
  [11, 'Aerospace Engineering', 'Dr. Amit Kapoor', 'aero@college.edu', '9000000011'],
  [12, 'Automobile Engineering', 'Dr. Pooja Joshi', 'auto@college.edu', '9000000012'],
  [13, 'Biomedical Engineering', 'Dr. Nitin Shah', 'biomed@college.edu', '9000000013'],
  [14, 'Robotics and Automation', 'Dr. Kavita Menon', 'robotics@college.edu', '9000000014'],
  [15, 'Data Science', 'Dr. Suresh Bhat', 'ds@college.edu', '9000000015'],
  [16, 'Artificial Intelligence', 'Dr. Divya Patel', 'ai@college.edu', '9000000016'],
  [17, 'Mathematics', 'Dr. Sanjay Rao', 'math@college.edu', '9000000017'],
  [18, 'Physics', 'Dr. Lakshmi Iyer', 'physics@college.edu', '9000000018'],
  [19, 'Management Studies', 'Dr. Vivek Nair', 'mba@college.edu', '9000000019'],
  [20, 'Computer Applications', 'Dr. Ananya Das', 'mca@college.edu', '9000000020']
] AS r
CREATE (:Department {department_id: r[0], name: r[1], hod_name: r[2], office_email: r[3], office_phone: r[4]});

// ---------- 3. STUDENTS (+ BELONGS_TO department) ----------
UNWIND [
  [101, 'REG001', 'Aarav Sharma', 'Male', 'aarav@college.edu', 8.70, 1],
  [102, 'REG002', 'Ananya Iyer', 'Female', 'ananya@college.edu', 9.10, 2],
  [103, 'REG003', 'Rohan Gupta', 'Male', 'rohan@college.edu', 8.40, 3],
  [104, 'REG004', 'Priya Nair', 'Female', 'priya@college.edu', 9.20, 4],
  [105, 'REG005', 'Vikram Singh', 'Male', 'vikram@college.edu', 7.90, 5],
  [106, 'REG006', 'Sneha Patel', 'Female', 'sneha@college.edu', 8.80, 6],
  [107, 'REG007', 'Karan Mehta', 'Male', 'karan@college.edu', 8.60, 7],
  [108, 'REG008', 'Meera Joshi', 'Female', 'meera@college.edu', 9.00, 8],
  [109, 'REG009', 'Aditya Rao', 'Male', 'aditya@college.edu', 8.10, 9],
  [110, 'REG010', 'Kavya Menon', 'Female', 'kavya@college.edu', 9.30, 10],
  [111, 'REG011', 'Arjun Shah', 'Male', 'arjun@college.edu', 8.50, 11],
  [112, 'REG012', 'Ishita Verma', 'Female', 'ishita@college.edu', 9.40, 12],
  [113, 'REG013', 'Rahul Kapoor', 'Male', 'rahul@college.edu', 7.80, 13],
  [114, 'REG014', 'Diya Malhotra', 'Female', 'diya@college.edu', 8.90, 14],
  [115, 'REG015', 'Nikhil Bhat', 'Male', 'nikhil@college.edu', 8.30, 15],
  [116, 'REG016', 'Riya Das', 'Female', 'riya@college.edu', 9.10, 16],
  [117, 'REG017', 'Siddharth Rao', 'Male', 'siddharth@college.edu', 8.20, 17],
  [118, 'REG018', 'Tanvi Iyer', 'Female', 'tanvi@college.edu', 8.70, 18],
  [119, 'REG019', 'Yash Jain', 'Male', 'yash@college.edu', 8.00, 19],
  [120, 'REG020', 'Nandini Shah', 'Female', 'nandini@college.edu', 9.00, 20]
] AS r
MATCH (d:Department {department_id: r[6]})
CREATE (s:Student {student_id: r[0], registration_no: r[1], name: r[2], gender: r[3], email: r[4], cgpa: r[5]})
CREATE (s)-[:BELONGS_TO]->(d);

// ---------- 4. COMPANIES ----------
UNWIND [
  [201, 'TechNova Solutions', 'IT Services', 'www.technova.com', 'Rahul Verma', 'rahul.verma@technova.com'],
  [202, 'CloudMatrix', 'Cloud Computing', 'www.cloudmatrix.com', 'Sneha Rao', 'sneha.rao@cloudmatrix.com'],
  [203, 'DataSphere Analytics', 'Data Analytics', 'www.datasphere.com', 'Amit Shah', 'amit.shah@datasphere.com'],
  [204, 'FinEdge Technologies', 'FinTech', 'www.finedge.com', 'Priya Kapoor', 'priya.kapoor@finedge.com'],
  [205, 'AutoCore Motors', 'Automobile', 'www.autocore.com', 'Vikram Joshi', 'vikram.joshi@autocore.com'],
  [206, 'CyberShield Labs', 'Cyber Security', 'www.cybershield.com', 'Karan Mehta', 'karan.mehta@cybershield.com'],
  [207, 'HealthGen Biotech', 'Biotechnology', 'www.healthgen.com', 'Meera Nair', 'meera.nair@healthgen.com'],
  [208, 'BuildRight Infra', 'Construction', 'www.buildright.com', 'Anil Rao', 'anil.rao@buildright.com'],
  [209, 'RoboWorks', 'Robotics', 'www.roboworks.com', 'Kavita Singh', 'kavita.singh@roboworks.com'],
  [210, 'AeroSpace Dynamics', 'Aerospace', 'www.aerodynamics.com', 'Arjun Gupta', 'arjun.gupta@aerodynamics.com'],
  [211, 'InnoSoft Systems', 'Software', 'www.innosoft.com', 'Riya Shah', 'riya.shah@innosoft.com'],
  [212, 'QuantumEdge', 'Artificial Intelligence', 'www.quantumedge.com', 'Nitin Rao', 'nitin.rao@quantumedge.com'],
  [213, 'GreenGrid Energy', 'Energy', 'www.greengrid.com', 'Divya Menon', 'divya.menon@greengrid.com'],
  [214, 'MediCore', 'Healthcare', 'www.medicore.com', 'Suresh Iyer', 'suresh.iyer@medicore.com'],
  [215, 'NextGen Automations', 'Automation', 'www.nextgenauto.com', 'Pooja Das', 'pooja.das@nextgenauto.com'],
  [216, 'Insight Data Labs', 'Data Science', 'www.insightdata.com', 'Sanjay Patel', 'sanjay.patel@insightdata.com'],
  [217, 'SecureNet Technologies', 'Network Security', 'www.securenet.com', 'Ananya Gupta', 'ananya.gupta@securenet.com'],
  [218, 'UrbanAxis', 'Civil Engineering', 'www.urbanaxis.com', 'Vivek Shah', 'vivek.shah@urbanaxis.com'],
  [219, 'AppVerse', 'Mobile Development', 'www.appverse.com', 'Neha Kapoor', 'neha.kapoor@appverse.com'],
  [220, 'WebCore Technologies', 'Web Development', 'www.webcore.com', 'Rohan Mehta', 'rohan.mehta@webcore.com']
] AS r
CREATE (:Company {company_id: r[0], name: r[1], industry: r[2], website: r[3], hr_name: r[4], hr_email: r[5]});

// ---------- 5. JOBS (+ POSTS from company) ----------
UNWIND [
  ['J001', 201, 'Software Development Intern', 'Develop and test software applications.', 'Bangalore', '2026-09-20'],
  ['J002', 202, 'Cloud Engineering Intern', 'Assist with cloud infrastructure and deployment.', 'Hyderabad', '2026-09-21'],
  ['J003', 203, 'Data Analyst Intern', 'Analyze datasets and prepare reports.', 'Bangalore', '2026-09-22'],
  ['J004', 204, 'FinTech Intern', 'Support financial technology projects.', 'Mumbai', '2026-09-23'],
  ['J005', 205, 'Automotive Engineering Intern', 'Assist automotive design and testing.', 'Chennai', '2026-09-24'],
  ['J006', 206, 'Cyber Security Intern', 'Assist in security monitoring and analysis.', 'Pune', '2026-09-25'],
  ['J007', 207, 'Biotech Research Intern', 'Support laboratory research activities.', 'Bangalore', '2026-09-26'],
  ['J008', 208, 'Civil Engineering Intern', 'Assist in infrastructure projects.', 'Delhi', '2026-09-27'],
  ['J009', 209, 'Robotics Intern', 'Develop and test robotic systems.', 'Chennai', '2026-09-28'],
  ['J010', 210, 'Aerospace Intern', 'Support aerospace engineering projects.', 'Bangalore', '2026-09-29'],
  ['J011', 211, 'Software Testing Intern', 'Perform software testing and debugging.', 'Hyderabad', '2026-09-30'],
  ['J012', 212, 'AI Research Intern', 'Assist in machine learning research.', 'Bangalore', '2026-10-01'],
  ['J013', 213, 'Energy Systems Intern', 'Analyze renewable energy systems.', 'Mumbai', '2026-10-02'],
  ['J014', 214, 'Healthcare Technology Intern', 'Support healthcare technology solutions.', 'Pune', '2026-10-03'],
  ['J015', 215, 'Automation Intern', 'Assist in industrial automation projects.', 'Chennai', '2026-10-04'],
  ['J016', 216, 'Data Science Intern', 'Build analytical models and dashboards.', 'Bangalore', '2026-10-05'],
  ['J017', 217, 'Network Security Intern', 'Assist with network security operations.', 'Hyderabad', '2026-10-06'],
  ['J018', 218, 'Urban Planning Intern', 'Assist with urban infrastructure planning.', 'Delhi', '2026-10-07'],
  ['J019', 219, 'Mobile App Intern', 'Develop and test mobile applications.', 'Bangalore', '2026-10-08'],
  ['J020', 220, 'Web Development Intern', 'Develop responsive web applications.', 'Chennai', '2026-10-09'],
  ['J021', 201, 'Software Engineer', 'Develop scalable software applications.', 'Bangalore', '2026-09-20'],
  ['J022', 202, 'Cloud Engineer', 'Manage cloud infrastructure and services.', 'Hyderabad', '2026-09-21'],
  ['J023', 203, 'Data Analyst', 'Analyze business data and generate insights.', 'Bangalore', '2026-09-22'],
  ['J024', 204, 'FinTech Developer', 'Develop financial technology applications.', 'Mumbai', '2026-09-23'],
  ['J025', 205, 'Automotive Engineer', 'Design and test automotive systems.', 'Chennai', '2026-09-24'],
  ['J026', 206, 'Cyber Security Analyst', 'Monitor and secure enterprise systems.', 'Pune', '2026-09-25'],
  ['J027', 207, 'Biotech Engineer', 'Work on biotechnology research projects.', 'Bangalore', '2026-09-26'],
  ['J028', 208, 'Civil Engineer', 'Manage infrastructure engineering projects.', 'Delhi', '2026-09-27'],
  ['J029', 209, 'Robotics Engineer', 'Design and develop robotic systems.', 'Chennai', '2026-09-28'],
  ['J030', 210, 'Aerospace Engineer', 'Work on aerospace engineering systems.', 'Bangalore', '2026-09-29'],
  ['J031', 211, 'Software Developer', 'Develop enterprise software solutions.', 'Hyderabad', '2026-09-30'],
  ['J032', 212, 'Machine Learning Engineer', 'Build and deploy machine learning models.', 'Bangalore', '2026-10-01'],
  ['J033', 213, 'Energy Engineer', 'Design and optimize energy systems.', 'Mumbai', '2026-10-02'],
  ['J034', 214, 'Healthcare Software Engineer', 'Develop healthcare software systems.', 'Pune', '2026-10-03'],
  ['J035', 215, 'Automation Engineer', 'Develop industrial automation solutions.', 'Chennai', '2026-10-04'],
  ['J036', 216, 'Data Scientist', 'Develop predictive and analytical models.', 'Bangalore', '2026-10-05'],
  ['J037', 217, 'Security Engineer', 'Design and maintain secure networks.', 'Hyderabad', '2026-10-06'],
  ['J038', 218, 'Infrastructure Engineer', 'Plan and manage infrastructure systems.', 'Delhi', '2026-10-07'],
  ['J039', 219, 'Mobile Application Developer', 'Develop mobile application products.', 'Bangalore', '2026-10-08'],
  ['J040', 220, 'Web Developer', 'Develop and maintain web platforms.', 'Chennai', '2026-10-09']
] AS r
MATCH (c:Company {company_id: r[1]})
CREATE (j:Job {job_id: r[0], title: r[2], description: r[3], location: r[4], last_date_to_apply: date(r[5])})
CREATE (c)-[:POSTS]->(j);

// ---------- 6. INTERNSHIP specialisation (extra label on Job) ----------
UNWIND [
  ['J001', 'I001', '3 Months', 20000, 'Hybrid', '2026-10-01'],
  ['J002', 'I002', '6 Months', 25000, 'Remote', '2026-10-05'],
  ['J003', 'I003', '3 Months', 18000, 'Onsite', '2026-10-10'],
  ['J004', 'I004', '6 Months', 22000, 'Hybrid', '2026-10-15'],
  ['J005', 'I005', '4 Months', 20000, 'Onsite', '2026-10-20'],
  ['J006', 'I006', '3 Months', 24000, 'Remote', '2026-10-25'],
  ['J007', 'I007', '6 Months', 21000, 'Onsite', '2026-11-01'],
  ['J008', 'I008', '3 Months', 19000, 'Hybrid', '2026-11-05'],
  ['J009', 'I009', '6 Months', 26000, 'Onsite', '2026-11-10'],
  ['J010', 'I010', '4 Months', 23000, 'Remote', '2026-11-15'],
  ['J011', 'I011', '3 Months', 20000, 'Hybrid', '2026-11-20'],
  ['J012', 'I012', '6 Months', 28000, 'Remote', '2026-11-25'],
  ['J013', 'I013', '3 Months', 21000, 'Onsite', '2026-12-01'],
  ['J014', 'I014', '4 Months', 22000, 'Hybrid', '2026-12-05'],
  ['J015', 'I015', '6 Months', 25000, 'Onsite', '2026-12-10'],
  ['J016', 'I016', '3 Months', 27000, 'Remote', '2026-12-15'],
  ['J017', 'I017', '4 Months', 24000, 'Hybrid', '2026-12-20'],
  ['J018', 'I018', '3 Months', 19000, 'Onsite', '2027-01-05'],
  ['J019', 'I019', '6 Months', 23000, 'Remote', '2027-01-10'],
  ['J020', 'I020', '3 Months', 20000, 'Hybrid', '2027-01-15']
] AS r
MATCH (j:Job {job_id: r[0]})
SET j:Internship, j.internship_id = r[1], j.duration = r[2], j.stipend = r[3], j.work_mode = r[4], j.start_date = date(r[5]);

// ---------- 7. FULL-TIME specialisation (extra label on Job) ----------
UNWIND [
  ['J021', 'F001', 650000, '1 Year', '2027-07-01', 5],
  ['J022', 'F002', 750000, '2 Years', '2027-07-01', 4],
  ['J023', 'F003', 600000, '1 Year', '2027-07-05', 6],
  ['J024', 'F004', 700000, '1 Year', '2027-07-10', 5],
  ['J025', 'F005', 550000, '2 Years', '2027-07-15', 4],
  ['J026', 'F006', 800000, '1 Year', '2027-07-20', 3],
  ['J027', 'F007', 500000, '1 Year', '2027-07-25', 5],
  ['J028', 'F008', 580000, '2 Years', '2027-08-01', 4],
  ['J029', 'F009', 850000, '1 Year', '2027-08-05', 3],
  ['J030', 'F010', 900000, '2 Years', '2027-08-10', 2],
  ['J031', 'F011', 680000, '1 Year', '2027-08-15', 6],
  ['J032', 'F012', 950000, '1 Year', '2027-08-20', 4],
  ['J033', 'F013', 620000, '2 Years', '2027-08-25', 5],
  ['J034', 'F014', 720000, '1 Year', '2027-09-01', 4],
  ['J035', 'F015', 780000, '2 Years', '2027-09-05', 3],
  ['J036', 'F016', 1000000, '1 Year', '2027-09-10', 2],
  ['J037', 'F017', 820000, '1 Year', '2027-09-15', 4],
  ['J038', 'F018', 590000, '2 Years', '2027-09-20', 5],
  ['J039', 'F019', 700000, '1 Year', '2027-09-25', 4],
  ['J040', 'F020', 660000, '1 Year', '2027-10-01', 5]
] AS r
MATCH (j:Job {job_id: r[0]})
SET j:FullTime, j.fulltime_job_id = r[1], j.ctc = r[2], j.bond_period = r[3], j.joining_date = date(r[4]), j.openings = r[5];

// ---------- 8. APPLICATIONS (Student -SUBMITTED-> Application -FOR-> Job) ----------
UNWIND [
  [1001, 101, 'J001', '2026-09-10', 'Selected', 'resume101.pdf'],
  [1002, 102, 'J002', '2026-09-11', 'Selected', 'resume102.pdf'],
  [1003, 103, 'J003', '2026-09-12', 'Shortlisted', 'resume103.pdf'],
  [1004, 104, 'J004', '2026-09-13', 'Selected', 'resume104.pdf'],
  [1005, 105, 'J005', '2026-09-14', 'Rejected', 'resume105.pdf'],
  [1006, 106, 'J006', '2026-09-15', 'Shortlisted', 'resume106.pdf'],
  [1007, 107, 'J007', '2026-09-16', 'Applied', 'resume107.pdf'],
  [1008, 108, 'J008', '2026-09-17', 'Selected', 'resume108.pdf'],
  [1009, 109, 'J009', '2026-09-18', 'Rejected', 'resume109.pdf'],
  [1010, 110, 'J010', '2026-09-19', 'Selected', 'resume110.pdf'],
  [1011, 111, 'J021', '2026-09-20', 'Selected', 'resume111.pdf'],
  [1012, 112, 'J022', '2026-09-21', 'Selected', 'resume112.pdf'],
  [1013, 113, 'J023', '2026-09-22', 'Rejected', 'resume113.pdf'],
  [1014, 114, 'J024', '2026-09-23', 'Selected', 'resume114.pdf'],
  [1015, 115, 'J025', '2026-09-24', 'Shortlisted', 'resume115.pdf'],
  [1016, 116, 'J026', '2026-09-25', 'Selected', 'resume116.pdf'],
  [1017, 117, 'J027', '2026-09-26', 'Applied', 'resume117.pdf'],
  [1018, 118, 'J028', '2026-09-27', 'Selected', 'resume118.pdf'],
  [1019, 119, 'J029', '2026-09-28', 'Rejected', 'resume119.pdf'],
  [1020, 120, 'J030', '2026-09-29', 'Selected', 'resume120.pdf']
] AS r
MATCH (s:Student {student_id: r[1]}), (j:Job {job_id: r[2]})
CREATE (a:Application {application_id: r[0], application_date: date(r[3]), status: r[4], resume_link: r[5]})
CREATE (s)-[:SUBMITTED]->(a)
CREATE (a)-[:FOR]->(j);

// ---------- 9. INTERVIEWS (Application -HAS_INTERVIEW-> Interview) ----------
UNWIND [
  [3001, 1001, 'Technical', '2026-09-25', 'Online', 'Selected'],
  [3002, 1002, 'Technical', '2026-09-26', 'Online', 'Selected'],
  [3003, 1003, 'Aptitude', '2026-09-27', 'Offline', 'Pass'],
  [3004, 1004, 'HR', '2026-09-28', 'Online', 'Selected'],
  [3005, 1005, 'Technical', '2026-09-29', 'Offline', 'Fail'],
  [3006, 1006, 'Technical', '2026-09-30', 'Online', 'Pass'],
  [3007, 1007, 'Aptitude', '2026-10-01', 'Online', 'Pending'],
  [3008, 1008, 'HR', '2026-10-02', 'Offline', 'Selected'],
  [3009, 1009, 'Technical', '2026-10-03', 'Online', 'Fail'],
  [3010, 1010, 'HR', '2026-10-04', 'Online', 'Selected'],
  [3011, 1011, 'Technical', '2026-10-05', 'Offline', 'Selected'],
  [3012, 1012, 'Technical', '2026-10-06', 'Online', 'Selected'],
  [3013, 1013, 'Aptitude', '2026-10-07', 'Offline', 'Fail'],
  [3014, 1014, 'HR', '2026-10-08', 'Online', 'Selected'],
  [3015, 1015, 'Technical', '2026-10-09', 'Online', 'Pass'],
  [3016, 1016, 'Technical', '2026-10-10', 'Offline', 'Selected'],
  [3017, 1017, 'Aptitude', '2026-10-11', 'Online', 'Pending'],
  [3018, 1018, 'HR', '2026-10-12', 'Offline', 'Selected'],
  [3019, 1019, 'Technical', '2026-10-13', 'Online', 'Fail'],
  [3020, 1020, 'HR', '2026-10-14', 'Online', 'Selected']
] AS r
MATCH (a:Application {application_id: r[1]})
CREATE (i:Interview {interview_id: r[0], round: r[2], interview_date: date(r[3]), mode: r[4], result: r[5]})
CREATE (a)-[:HAS_INTERVIEW]->(i);

// ---------- 10. OFFERS (Interview -RESULTED_IN-> Offer) ----------
UNWIND [
  [4001, 3001, '2026-10-01', '2026-10-05', 'Accepted', 20000],
  [4002, 3002, '2026-10-02', '2026-10-06', 'Accepted', 25000],
  [4003, 3003, '2026-10-03', '2026-10-07', 'Offered', 18000],
  [4004, 3004, '2026-10-04', '2026-10-08', 'Accepted', 22000],
  [4005, 3005, '2026-10-05', '2026-10-09', 'Rejected', 20000],
  [4006, 3006, '2026-10-06', '2026-10-10', 'Offered', 24000],
  [4007, 3007, '2026-10-07', '2026-10-11', 'Offered', 21000],
  [4008, 3008, '2026-10-08', '2026-10-12', 'Accepted', 19000],
  [4009, 3009, '2026-10-09', '2026-10-13', 'Rejected', 26000],
  [4010, 3010, '2026-10-10', '2026-10-14', 'Accepted', 23000],
  [4011, 3011, '2026-10-15', '2027-07-01', 'Accepted', 650000],
  [4012, 3012, '2026-10-16', '2027-07-01', 'Accepted', 750000],
  [4013, 3013, '2026-10-17', '2027-07-05', 'Rejected', 600000],
  [4014, 3014, '2026-10-18', '2027-07-10', 'Accepted', 700000],
  [4015, 3015, '2026-10-19', '2027-07-15', 'Offered', 550000],
  [4016, 3016, '2026-10-20', '2027-07-20', 'Accepted', 800000],
  [4017, 3017, '2026-10-21', '2027-07-25', 'Offered', 500000],
  [4018, 3018, '2026-10-22', '2027-08-01', 'Accepted', 580000],
  [4019, 3019, '2026-10-23', '2027-08-05', 'Rejected', 850000],
  [4020, 3020, '2026-10-24', '2027-08-10', 'Accepted', 900000]
] AS r
MATCH (i:Interview {interview_id: r[1]})
CREATE (o:Offer {offer_id: r[0], offer_date: date(r[2]), joining_date: date(r[3]), status: r[4], salary_offered: r[5]})
CREATE (i)-[:RESULTED_IN]->(o);

// ---------- 11. VERIFY (should show 20/20/20/40/20/20/20) ----------
MATCH (n) RETURN labels(n) AS label, count(*) AS total ORDER BY total DESC;
