# International School Teaching Assistant Recruitment System

A compact `Servlet + JSP + Maven + Tomcat` recruitment system for teaching assistant hiring.

## Kept Structure

- `src/main/java/com/example/tasystem/`: active application code
- `src/main/webapp/WEB-INF/views/`: active JSP views
- `src/main/webapp/assets/app.css`: shared stylesheet
- `src/main/webapp/index.jsp`: landing page
- `src/main/webapp/WEB-INF/web.xml`: web configuration
- `data/`: JSON persistence files
- `.run/`: shared IntelliJ run configurations
- `pom.xml`: Maven build and Tomcat Cargo setup

## Removed Noise

- legacy directories: `application-review/`, `com.group50/`
- build output: `target/`
- temp files: `uploads/`, `tomcat.log`, `1.txt`
- old docs: deployment, test, and checklist markdown files
- redirect-only JSP shims under the web root and `admin/`, `applicant/`, `mo/`
- empty asset subdirectories

## Stack

- Java 17
- Maven
- Servlet 4.0
- JSP + JSTL
- Gson
- Tomcat 9
- Cargo Maven Plugin

## Run

Build:

```bash
mvn clean package
```

Run locally:

```bash
mvn cargo:run
```

Start and stop in background:

```bash
mvn cargo:start
mvn cargo:stop
```

App URL:

```text
http://localhost:8080/ta-recruitment-system
```

## Demo Accounts

- TA: `ta / ta123456`
- MO: `mo / mo123456`
- Admin: `admin / admin123456`

## Main Routes

- `/`
- `/login`
- `/register`
- `/jobs`
- `/jobs/detail?id=J001`
- `/applications`
- `/applicant/dashboard`
- `/applicant/profile`
- `/applicant/applications`
- `/mo/dashboard`
- `/mo/jobs`
- `/mo/jobs/new`
- `/mo/applications`
- `/admin/dashboard`

## Data

- data is stored in the project root `data/`
- writes are persisted immediately
- override the data directory with `-Dta.data.dir=<path>`
