# International School TA Recruitment System

**Group 50 - EBU6304 Software Engineering**

## Overview

This is a Teaching Assistant recruitment system for BUPT International School. It streamlines the workflow for recruiting TAs for Module Organisers (MO) and other activities.

## Features Implemented

### TA Applicant Module
- **Create Applicant Profile** (TA-01): TA can create and edit their profile with personal, academic, and skills information
- **Browse Available Jobs** (TA-03): TA can view open positions with details
- **Apply for Jobs** (TA-04): TA can submit applications with reasons
- **Check Application Status** (TA-05): TA can view the status of their applications

### Module Organiser (MO) Module
- **Post New Jobs** (MO-01): MO can create job postings with module info, duties, required skills, hours, and deadlines
- **Review Applicants** (MO-02): MO can view all applications with applicant details
- **Shortlist/Reject Applicants** (MO-03): MO can change application status to Approved, Rejected, or Pending

### Admin Module
- **View Recruitment Overview** (AD-01): Admin can see job statistics and application counts
- **Check TA Workload** (AD-02): Admin can view total allocated hours per TA to ensure fair distribution

### System Requirements (SYS-01)
- All data stored in JSON text files
- No database required
- Lightweight Java Servlet/JSP web application

## Project Structure

```
International-School-Teaching-Assistant-Recruitment-System/
├── pom.xml                            # Maven configuration
├── README.md                          # This file
├── start-jetty.sh                     # Startup script
├── diagnose.sh                        # Diagnostic script
│
├── src/main/
│   ├── java/com/group50/tasystem/    # Java Servlets
│   │   ├── ProfileServlet.java
│   │   ├── JobBrowserServlet.java
│   │   ├── ApplyJobServlet.java
│   │   ├── ApplicationStatusServlet.java
│   │   ├── PostJobServlet.java
│   │   ├── ReviewApplicationServlet.java
│   │   ├── AdminServlet.java
│   │   └── CharacterEncodingFilter.java
│   │
│   ├── resources/data/                # JSON data files
│   │   ├── applicants.json
│   │   ├── jobs.json
│   │   └── applications.json
│   │
│   └── webapp/                        # Web pages
│       ├── index.jsp                  # Main entry page
│       ├── ta-applicant/              # TA module JSPs
│       ├── mo-module/                 # MO module JSPs
│       ├── application-review/        # Review module JSPs
│       ├── admin-module/              # Admin module JSPs
│       └── WEB-INF/web.xml            # Servlet mappings
│
└── target/                            # Build output (generated)
```

## Quick Start

### Prerequisites
- Java 8 or higher
- Maven 3.6+ (or use the bundled Maven)

### Start the Application

**Using bundled Maven:**
```bash
cd International-School-Teaching-Assistant-Recruitment-System
./start-jetty.sh
```

**Using system Maven:**
```bash
cd International-School-Teaching-Assistant-Recruitment-System
mvn jetty:run
```

**Access:** http://localhost:8080/

### Troubleshooting

If you encounter issues, run the diagnostic script:
```bash
./diagnose.sh
```

Common issues:
1. **Port 8080 in use**: Kill the process or change port in `pom.xml`
2. **Maven not found**: The script will auto-extract bundled Maven
3. **Compilation errors**: Run `mvn clean compile` to rebuild

## Data Files

Data is stored in `src/main/resources/data/`:

- **applicants.json**: Applicant profiles (id, name, studentId, email, programme, experience, skills)
- **jobs.json**: Job postings (id, moduleName, jobTitle, duties, requiredSkills, hours, deadline, status)
- **applications.json**: Applications (id, jobId, applicantId, name, jobTitle, reason, status, applyDate)

## User Roles

### 1. TA Applicant
- Start at: `ta-applicant/profile.jsp`
- Create/edit profile
- Browse jobs at `ta-applicant/jobs.jsp`
- Apply for positions
- Check application status at `ta-applicant/status.jsp`

### 2. Module Organiser
- Start at: `mo-module/postJob.jsp`
- Post new TA positions
- Review applications at `application-review/reviewApplications.jsp`
- Approve/Reject applications

### 3. Administrator
- Start at: `admin` (AdminServlet)
- View recruitment statistics
- Check TA workload distribution

## Intermediate Assessment Features

For the intermediate assessment (12 April 2026), the following features are implemented:

| User Story | Feature | Status |
|------------|---------|--------|
| TA-01 | Create applicant profile | Complete |
| TA-03 | Browse available jobs | Complete |
| TA-04 | Apply for a job | Complete |
| TA-05 | Check application status | Complete |
| MO-01 | Post new job | Complete |
| MO-02 | Review applicants | Complete |
| MO-03 | Shortlist/Reject applicants | Complete |
| AD-01 | View recruitment overview | Complete |
| AD-02 | Check TA workload | Complete |
| SYS-01 | Text file storage | Complete |

## Technology Stack

- **Backend**: Java Servlet API 3.1
- **Frontend**: JSP, HTML, CSS
- **Data Storage**: JSON files
- **Build Tool**: Maven
- **Server**: Jetty (embedded)

## Authors

Group 50 - EBU6304 Software Engineering
