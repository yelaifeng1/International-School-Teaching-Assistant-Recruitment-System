<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
    <style>
        /* ══════════════════════════════════════
           FILTER BAR
           ══════════════════════════════════════ */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: flex-end;
            padding: 16px 20px;
            margin-bottom: 14px;
            background: #f8f9fb;
            border: 1px solid #e2e6ea;
            border-radius: 10px;
        }
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .filter-group label {
            font-size: 11px;
            font-weight: 700;
            color: #666;
            text-transform: uppercase;
            letter-spacing: .4px;
        }
        .filter-group input,
        .filter-group select {
            padding: 7px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 13px;
            background: #fff;
            min-width: 140px;
        }
        .filter-group input:focus,
        .filter-group select:focus {
            outline: none;
            border-color: #4f6ef7;
            box-shadow: 0 0 0 3px rgba(79,110,247,.15);
        }
        .filter-actions {
            display: flex;
            gap: 8px;
            align-self: flex-end;
        }
        .btn-filter {
            padding: 7px 16px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background .15s;
        }
        .btn-apply  { background: #4f6ef7; color: #fff; }
        .btn-apply:hover  { background: #3b5ae0; }
        .btn-reset  { background: #e2e6ea; color: #333; }
        .btn-reset:hover  { background: #d0d5db; }

        /* ── Inline mini-filter (for smaller panels) ── */
        .mini-filter {
            display: flex;
            gap: 8px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .mini-filter input,
        .mini-filter select {
            padding: 6px 10px;
            border: 1px solid #d0d5db;
            border-radius: 6px;
            font-size: 12px;
            background: #fff;
            min-width: 120px;
        }

        /* ══════════════════════════════════════
           SORT INDICATORS
           ══════════════════════════════════════ */
        th.sortable {
            cursor: pointer;
            user-select: none;
            position: relative;
            padding-right: 20px;
        }
        th.sortable::after {
            content: '⇅';
            position: absolute;
            right: 4px;
            opacity: .3;
            font-size: 12px;
        }
        th.sortable.asc::after  { content: '↑'; opacity: .8; }
        th.sortable.desc::after { content: '↓'; opacity: .8; }

        /* ══════════════════════════════════════
           RESULT COUNT
           ══════════════════════════════════════ */
        .filter-result-count {
            font-size: 12px;
            color: #888;
            padding: 4px 0 0;
        }

        /* ══════════════════════════════════════
           NO-MATCH ROW
           ══════════════════════════════════════ */
        .no-match-row td {
            text-align: center;
            padding: 28px 16px;
            color: #aaa;
            font-style: italic;
        }

        /* ══════════════════════════════════════
           ROLE LEGEND
           ══════════════════════════════════════ */
        .role-legend {
            display: flex;
            gap: 14px;
            margin-bottom: 10px;
            font-size: 12px;
            color: #666;
        }
        .role-legend span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .role-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
        }
        .role-dot-ta    { background: #fde68a; }
        .role-dot-mo    { background: #bbf7d0; }
        .role-dot-admin { background: #bfdbfe; }

        /* ══════════════════════════════════════
           STAT-CARD HOVER
           ══════════════════════════════════════ */
        .stat-card {
            transition: transform .15s, box-shadow .15s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0,0,0,.08);
        }
    </style>
</head>
<body>
<div class="page-shell">

    <!-- ═══════════ TOP BAR ═══════════ -->
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">AD</div>
            <div>
                <div class="brand-title">Administrator Dashboard</div>
                <div class="brand-subtitle">${currentUser.effectiveDisplayName} - ${roleLabel}</div>
            </div>
        </div>
        <div class="topbar-actions">
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <!-- ═══════════ FLASH MESSAGE ═══════════ -->
    <c:if test="${not empty flash}">
        <div class="info-banner ${flash.type}">${flash.text}</div>
    </c:if>

    <!-- ═══════════ STAT CARDS ═══════════ -->
    <div class="grid grid-4">
        <div class="stat-card">
            <div class="eyebrow">Users</div>
            <strong>${userCount}</strong>
            <p>Total accounts in the system</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Applicants</div>
            <strong>${applicantCount}</strong>
            <p>Teaching assistant applicant accounts</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Managers</div>
            <strong>${managerCount}</strong>
            <p>Module organiser accounts</p>
        </div>
        <div class="stat-card">
            <div class="eyebrow">Assignments</div>
            <strong>${assignmentCount}</strong>
            <p>Confirmed workload records</p>
        </div>
    </div>

    <!-- ═══════════════════════════════════════════════
         USER DIRECTORY  (main enhanced table)
         ═══════════════════════════════════════════════ -->
    <div class="table-panel" style="margin-top: 18px;">
        <h2>User Directory</h2>

        <!-- Role Legend -->
        <div class="role-legend">
            <span><i class="role-dot role-dot-ta"></i> TA – Teaching Assistant</span>
            <span><i class="role-dot role-dot-mo"></i> MO – Module Organiser</span>
            <span><i class="role-dot role-dot-admin"></i> ADMIN – Administrator</span>
        </div>

        <!-- Filter Bar -->
        <div class="filter-bar" id="userFilterBar">
            <div class="filter-group">
                <label>Keyword</label>
                <input type="text" id="uf_keyword" placeholder="ID, name, email…">
            </div>
            <div class="filter-group">
                <label>Role</label>
                <select id="uf_role">
                    <option value="">All Roles</option>
                    <option value="TA">TA</option>
                    <option value="MO">MO</option>
                    <option value="ADMIN">ADMIN</option>
                </select>
            </div>
            <div class="filter-group">
                <label>Created From</label>
                <input type="date" id="uf_dateFrom">
            </div>
            <div class="filter-group">
                <label>Created To</label>
                <input type="date" id="uf_dateTo">
            </div>
            <div class="filter-actions">
                <button class="btn-filter btn-apply" id="uf_apply">Apply</button>
                <button class="btn-filter btn-reset" id="uf_reset">Reset</button>
            </div>
        </div>
        <div class="filter-result-count" id="uf_count"></div>

        <!-- Table -->
        <table id="userTable">
            <thead>
            <tr>
                <th class="sortable" data-col="userId"    data-type="string">User ID</th>
                <th class="sortable" data-col="username"  data-type="string">Username</th>
                <th class="sortable" data-col="role"      data-type="string">Role</th>
                <th class="sortable" data-col="email"     data-type="string">Email</th>
                <th class="sortable" data-col="createdAt" data-type="date">Created At</th>
                <th>Workload</th>
            </tr>
            </thead>
            <tbody id="userBody">
            <c:forEach var="user" items="${users}">
                <tr data-user-id="<c:out value='${user.userId}'/>"
                    data-username="<c:out value='${user.username}'/>"
                    data-display="<c:out value='${user.effectiveDisplayName}'/>"
                    data-role="<c:out value='${user.role}'/>"
                    data-email="<c:out value='${user.email}'/>"
                    data-created="<c:out value='${user.createdAt}'/>">
                    <td><c:out value="${user.userId}"/></td>
                    <td>
                        <strong><c:out value="${user.username}"/></strong><br>
                        <span class="muted"><c:out value="${user.effectiveDisplayName}"/></span>
                    </td>
                    <td>
                        <span class="status-pill ${user.role == 'ADMIN' ? 'status-filled' : user.role == 'MO' ? 'status-open' : 'status-pending'}">
                            <c:out value="${user.role}"/>
                        </span>
                    </td>
                    <td><c:out value="${user.email}"/></td>
                    <td><c:out value="${user.createdAt}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${user.role == 'TA'}">
                                <a class="btn btn-ghost"
                                   href="${pageContext.request.contextPath}/admin/workload?taUserId=${user.userId}">View Workload</a>
                            </c:when>
                            <c:otherwise>
                                <span class="muted">-</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- ═══════════════════════════════════════════════
         BOTTOM TWO-COLUMN GRID
         ═══════════════════════════════════════════════ -->
    <div class="grid grid-2" style="margin-top: 18px;">

        <!-- ── Recent Jobs ── -->
        <div class="table-panel">
            <h2>Recent Jobs</h2>
            <c:choose>
                <c:when test="${empty jobs}">
                    <div class="empty-state">No jobs have been posted yet.</div>
                </c:when>
                <c:otherwise>
                    <!-- mini filter -->
                    <div class="mini-filter">
                        <input type="text" id="jf_keyword" placeholder="Course or lecturer…">
                        <select id="jf_status">
                            <option value="">All Status</option>
                            <option value="OPEN">OPEN</option>
                            <option value="FILLED">FILLED</option>
                            <option value="CLOSED">CLOSED</option>
                        </select>
                    </div>
                    <table id="jobTable">
                        <thead>
                        <tr>
                            <th>Course</th>
                            <th>Lecturer</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody id="jobBody">
                        <c:forEach var="job" items="${jobs}" end="4">
                            <tr data-course="<c:out value='${job.courseCode}'/> <c:out value='${job.courseName}'/>"
                                data-lecturer="<c:out value='${job.lecturerName}'/>"
                                data-status="<c:out value='${job.status}'/>">
                                <td>
                                    <strong><c:out value="${job.courseCode}"/></strong><br>
                                    <span class="muted"><c:out value="${job.courseName}"/></span>
                                </td>
                                <td><c:out value="${job.lecturerName}"/></td>
                                <td>
                                    <span class="status-pill ${job.status == 'OPEN' ? 'status-open' : job.status == 'FILLED' ? 'status-approved' : 'status-rejected'}">
                                        <c:out value="${job.status}"/>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- ── Recent Applications ── -->
        <div class="table-panel">
            <h2>Recent Applications</h2>
            <c:choose>
                <c:when test="${empty applications}">
                    <div class="empty-state">No applications have been submitted yet.</div>
                </c:when>
                <c:otherwise>
                    <!-- mini filter -->
                    <div class="mini-filter">
                        <input type="text" id="af_keyword" placeholder="Applicant or course…">
                        <select id="af_status">
                            <option value="">All Status</option>
                            <option value="PENDING">PENDING</option>
                            <option value="APPROVED">APPROVED</option>
                            <option value="REJECTED">REJECTED</option>
                        </select>
                    </div>
                    <table id="appTable">
                        <thead>
                        <tr>
                            <th>Applicant</th>
                            <th>Course</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody id="appBody">
                        <c:forEach var="application" items="${applications}" end="4">
                            <tr data-applicant="<c:out value='${application.applicantName}'/>"
                                data-course="<c:out value='${application.courseCode}'/> <c:out value='${application.courseName}'/>"
                                data-status="<c:out value='${application.status}'/>">
                                <td><c:out value="${application.applicantName}"/></td>
                                <td>
                                    <strong><c:out value="${application.courseCode}"/></strong><br>
                                    <span class="muted"><c:out value="${application.courseName}"/></span>
                                </td>
                                <td>
                                    <span class="status-pill ${application.status == 'APPROVED' ? 'status-approved' : application.status == 'REJECTED' ? 'status-rejected' : 'status-pending'}">
                                        <c:out value="${application.status}"/>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- ══════════════════════════════════════════════════════
     JAVASCRIPT – filtering + sorting
     ══════════════════════════════════════════════════════ -->
<script>
(function () {

    /* ════════════════════════════════════════
       HELPER: build a reusable table-filter
       ════════════════════════════════════════ */
    function makeFilter(cfg) {
        const tbody = document.getElementById(cfg.tbodyId);
        if (!tbody) return;
        const rows = Array.from(tbody.querySelectorAll('tr[data-' + cfg.rowKey + ']'));

        function run() {
            // remove old "no match"
            const old = tbody.querySelector('.no-match-row');
            if (old) old.remove();

            let visible = 0;
            rows.forEach(function (row) {
                let show = true;
                cfg.checks.forEach(function (chk) {
                    if (!show) return;
                    show = chk(row);
                });
                row.style.display = show ? '' : 'none';
                if (show) visible++;
            });

            if (cfg.countEl) {
                cfg.countEl.textContent = 'Showing ' + visible + ' of ' + rows.length + ' record(s)';
            }
            if (visible === 0) {
                var tr = document.createElement('tr');
                tr.className = 'no-match-row';
                tr.innerHTML = '<td colspan="' + cfg.cols + '">No records match the current filters.</td>';
                tbody.appendChild(tr);
            }
        }

        // bind events
        cfg.inputs.forEach(function (inp) {
            var el = document.getElementById(inp);
            if (!el) return;
            el.addEventListener(el.tagName === 'SELECT' ? 'change' : 'input', run);
        });

        if (cfg.applyBtn) {
            var ab = document.getElementById(cfg.applyBtn);
            if (ab) ab.addEventListener('click', run);
        }
        if (cfg.resetBtn) {
            var rb = document.getElementById(cfg.resetBtn);
            if (rb) rb.addEventListener('click', function () {
                cfg.inputs.forEach(function (inp) {
                    var el = document.getElementById(inp);
                    if (el) el.value = '';
                });
                run();
            });
        }

        run();          // initial count
        return { rows: rows, run: run };
    }

    /* ════════════════════════════════════════
       1. USER DIRECTORY – full filter
       ════════════════════════════════════════ */
    var uf_keyword  = document.getElementById('uf_keyword');
    var uf_role     = document.getElementById('uf_role');
    var uf_dateFrom = document.getElementById('uf_dateFrom');
    var uf_dateTo   = document.getElementById('uf_dateTo');

    var userFilter = makeFilter({
        tbodyId : 'userBody',
        rowKey  : 'user-id',
        cols    : 6,
        countEl : document.getElementById('uf_count'),
        inputs  : ['uf_keyword','uf_role','uf_dateFrom','uf_dateTo'],
        applyBtn: 'uf_apply',
        resetBtn: 'uf_reset',
        checks  : [
            /* keyword: matches userId, username, display name, or email */
            function (row) {
                var kw = (uf_keyword.value || '').trim().toLowerCase();
                if (!kw) return true;
                var haystack = [
                    row.dataset.userId,
                    row.dataset.username,
                    row.dataset.display,
                    row.dataset.email
                ].join(' ').toLowerCase();
                return haystack.indexOf(kw) !== -1;
            },
            /* role */
            function (row) {
                var r = uf_role.value;
                if (!r) return true;
                return row.dataset.role === r;
            },
            /* date from */
            function (row) {
                var d = uf_dateFrom.value;
                if (!d) return true;
                return (row.dataset.created || '') >= d;
            },
            /* date to */
            function (row) {
                var d = uf_dateTo.value;
                if (!d) return true;
                return (row.dataset.created || '') <= d;
            }
        ]
    });

    /* ── User Directory column sorting ── */
    (function () {
        var table = document.getElementById('userTable');
        if (!table || !userFilter) return;
        var headers = table.querySelectorAll('th.sortable');
        var current = { col: null, dir: 'asc' };

        headers.forEach(function (th) {
            th.addEventListener('click', function () {
                var col  = this.dataset.col;
                var type = this.dataset.type;

                if (current.col === col) {
                    current.dir = current.dir === 'asc' ? 'desc' : 'asc';
                } else {
                    current.col = col; current.dir = 'asc';
                }
                headers.forEach(function (h) { h.classList.remove('asc','desc'); });
                this.classList.add(current.dir);

                var attrMap = {
                    userId   : 'userId',
                    username : 'username',
                    role     : 'role',
                    email    : 'email',
                    createdAt: 'created'
                };

                userFilter.rows.sort(function (a, b) {
                    var va = (a.dataset[attrMap[col]] || '').toLowerCase();
                    var vb = (b.dataset[attrMap[col]] || '').toLowerCase();
                    var res = va < vb ? -1 : va > vb ? 1 : 0;
                    return current.dir === 'asc' ? res : -res;
                });

                var tbody = document.getElementById('userBody');
                userFilter.rows.forEach(function (r) { tbody.appendChild(r); });
            });
        });
    })();

    /* ════════════════════════════════════════
       2. RECENT JOBS – mini filter
       ════════════════════════════════════════ */
    var jf_keyword = document.getElementById('jf_keyword');
    var jf_status  = document.getElementById('jf_status');

    makeFilter({
        tbodyId : 'jobBody',
        rowKey  : 'course',
        cols    : 3,
        countEl : null,
        inputs  : ['jf_keyword','jf_status'],
        checks  : [
            function (row) {
                var kw = (jf_keyword ? jf_keyword.value : '').trim().toLowerCase();
                if (!kw) return true;
                var hay = [row.dataset.course, row.dataset.lecturer].join(' ').toLowerCase();
                return hay.indexOf(kw) !== -1;
            },
            function (row) {
                var s = jf_status ? jf_status.value : '';
                if (!s) return true;
                return row.dataset.status === s;
            }
        ]
    });

    /* ════════════════════════════════════════
       3. RECENT APPLICATIONS – mini filter
       ════════════════════════════════════════ */
    var af_keyword = document.getElementById('af_keyword');
    var af_status  = document.getElementById('af_status');

    makeFilter({
        tbodyId : 'appBody',
        rowKey  : 'applicant',
        cols    : 3,
        countEl : null,
        inputs  : ['af_keyword','af_status'],
        checks  : [
            function (row) {
                var kw = (af_keyword ? af_keyword.value : '').trim().toLowerCase();
                if (!kw) return true;
                var hay = [row.dataset.applicant, row.dataset.course].join(' ').toLowerCase();
                return hay.indexOf(kw) !== -1;
            },
            function (row) {
                var s = af_status ? af_status.value : '';
                if (!s) return true;
                return row.dataset.status === s;
            }
        ]
    });

})();
</script>
</body>
</html>