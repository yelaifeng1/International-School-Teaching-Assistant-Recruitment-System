<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Open Jobs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
    <style>
        /* ── Filter Bar ── */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: flex-end;
            padding: 16px 20px;
            margin-bottom: 16px;
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
            font-size: 12px;
            font-weight: 600;
            color: #555;
            text-transform: uppercase;
            letter-spacing: .4px;
        }
        .filter-group input,
        .filter-group select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
            min-width: 160px;
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
            padding: 8px 18px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background .15s;
        }
        .btn-apply {
            background: #4f6ef7;
            color: #fff;
        }
        .btn-apply:hover { background: #3b5ae0; }
        .btn-reset {
            background: #e2e6ea;
            color: #333;
        }
        .btn-reset:hover { background: #d0d5db; }

        /* ── Sort indicator ── */
        th.sortable {
            cursor: pointer;
            user-select: none;
            position: relative;
            padding-right: 22px;
        }
        th.sortable::after {
            content: '⇅';
            position: absolute;
            right: 6px;
            opacity: .35;
            font-size: 13px;
        }
        th.sortable.asc::after  { content: '↑'; opacity: .8; }
        th.sortable.desc::after { content: '↓'; opacity: .8; }

        /* ── Result count ── */
        .filter-result-count {
            font-size: 13px;
            color: #777;
            padding: 6px 0 2px;
        }

        /* ── No-match row ── */
        .no-match-row td {
            text-align: center;
            padding: 32px 16px;
            color: #999;
            font-style: italic;
        }

        /* ── Deadline proximity badges ── */
        .deadline-badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: 10px;
            margin-left: 6px;
            vertical-align: middle;
        }
        .deadline-urgent  { background: #fee2e2; color: #b91c1c; }
        .deadline-soon    { background: #fef3c7; color: #92400e; }
        .deadline-relaxed { background: #d1fae5; color: #065f46; }
    </style>
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">TA</div>
            <div>
                <div class="brand-title">Open Teaching Assistant Jobs</div>
                <div class="brand-subtitle">Browse currently available positions</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-ghost"
               href="${pageContext.request.contextPath}${currentUser.role == 'TA' ? '/applicant/dashboard' : currentUser.role == 'MO' ? '/mo/dashboard' : '/admin/dashboard'}">
                Back to Dashboard
            </a>
            <form method="post" action="${pageContext.request.contextPath}/logout">
                <button class="btn btn-primary" type="submit">Log Out</button>
            </form>
        </div>
    </div>

    <div class="table-panel">
        <h2>Available Roles</h2>
        <p class="muted">Open a job to view the description, deadline, and application form.</p>

        <c:if test="${not empty jobs}">
            <!-- ════════ Filter Bar ════════ -->
            <div class="filter-bar" id="filterBar">
                <div class="filter-group">
                    <label>Course Keyword</label>
                    <input type="text" id="filterCourse" placeholder="e.g. CS101 or Math">
                </div>
                <div class="filter-group">
                    <label>Lecturer</label>
                    <input type="text" id="filterLecturer" placeholder="e.g. Smith">
                </div>
                <div class="filter-group">
                    <label>Deadline From</label>
                    <input type="date" id="filterDateFrom">
                </div>
                <div class="filter-group">
                    <label>Deadline To</label>
                    <input type="date" id="filterDateTo">
                </div>
                <div class="filter-actions">
                    <button class="btn-filter btn-apply" id="btnApply">Apply</button>
                    <button class="btn-filter btn-reset" id="btnReset">Reset</button>
                </div>
            </div>
            <div class="filter-result-count" id="resultCount"></div>
            <!-- ════════ End Filter Bar ════════ -->
        </c:if>

        <c:choose>
            <c:when test="${empty jobs}">
                <div class="empty-state">There are no open jobs at the moment.</div>
            </c:when>
            <c:otherwise>
                <table id="jobsTable">
                    <thead>
                    <tr>
                        <th class="sortable" data-col="jobId"    data-type="number">Job ID</th>
                        <th class="sortable" data-col="course"   data-type="string">Course</th>
                        <th class="sortable" data-col="lecturer" data-type="string">Lecturer</th>
                        <th class="sortable" data-col="deadline" data-type="date">Deadline</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id="jobsBody">
                    <c:forEach var="job" items="${jobs}">
                        <tr data-job-id="${job.jobId}"
                            data-course="${job.courseCode} ${job.courseName}"
                            data-lecturer="${job.lecturerName}"
                            data-deadline="${job.deadline}">
                            <td><c:out value="${job.jobId}"/></td>
                            <td>
                                <strong><c:out value="${job.courseCode}"/></strong><br>
                                <span class="muted"><c:out value="${job.courseName}"/></span>
                            </td>
                            <td><c:out value="${job.lecturerName}"/></td>
                            <td class="deadline-cell"><c:out value="${job.deadline}"/></td>
                            <td><span class="status-pill status-open">OPEN</span></td>
                            <td>
                                <a class="btn btn-secondary btn-small"
                                   href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}">View Details</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
(function () {
    /* ── DOM refs ── */
    const tbody          = document.getElementById('jobsBody');
    if (!tbody) return;

    const rows           = Array.from(tbody.querySelectorAll('tr[data-job-id]'));
    const courseInput     = document.getElementById('filterCourse');
    const lecturerInput  = document.getElementById('filterLecturer');
    const dateFrom       = document.getElementById('filterDateFrom');
    const dateTo         = document.getElementById('filterDateTo');
    const btnApply       = document.getElementById('btnApply');
    const btnReset       = document.getElementById('btnReset');
    const resultCount    = document.getElementById('resultCount');

    /* ═══════════════════════════════════════
       1.  DEADLINE PROXIMITY BADGES
       ═══════════════════════════════════════ */
    (function addDeadlineBadges() {
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        rows.forEach(row => {
            const dl = row.dataset.deadline;           // yyyy-MM-dd expected
            if (!dl) return;
            const deadlineDate = new Date(dl + 'T00:00:00');
            const diffDays = Math.ceil((deadlineDate - today) / 86400000);
            const cell = row.querySelector('.deadline-cell');
            if (!cell) return;

            let badge = '';
            if (diffDays < 0) {
                badge = '<span class="deadline-badge deadline-urgent">Expired</span>';
            } else if (diffDays <= 3) {
                badge = '<span class="deadline-badge deadline-urgent">' + diffDays + 'd left</span>';
            } else if (diffDays <= 7) {
                badge = '<span class="deadline-badge deadline-soon">' + diffDays + 'd left</span>';
            } else {
                badge = '<span class="deadline-badge deadline-relaxed">' + diffDays + 'd left</span>';
            }
            cell.insertAdjacentHTML('beforeend', ' ' + badge);
        });
    })();

    /* ═══════════════════════════════════════
       2.  FILTER LOGIC
       ═══════════════════════════════════════ */
    function applyFilters() {
        const course   = courseInput.value.trim().toLowerCase();
        const lecturer = lecturerInput.value.trim().toLowerCase();
        const from     = dateFrom.value;
        const to       = dateTo.value;

        // Remove previous "no match" row
        const prev = tbody.querySelector('.no-match-row');
        if (prev) prev.remove();

        let visible = 0;

        rows.forEach(row => {
            let show = true;

            // Course keyword
            if (course) {
                const c = (row.dataset.course || '').toLowerCase();
                if (!c.includes(course)) show = false;
            }

            // Lecturer keyword
            if (show && lecturer) {
                const l = (row.dataset.lecturer || '').toLowerCase();
                if (!l.includes(lecturer)) show = false;
            }

            // Deadline from
            if (show && from) {
                if ((row.dataset.deadline || '') < from) show = false;
            }

            // Deadline to
            if (show && to) {
                if ((row.dataset.deadline || '') > to) show = false;
            }

            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        resultCount.textContent = 'Showing ' + visible + ' of ' + rows.length + ' position(s)';

        if (visible === 0) {
            const tr = document.createElement('tr');
            tr.className = 'no-match-row';
            tr.innerHTML = '<td colspan="6">No positions match the current filters.</td>';
            tbody.appendChild(tr);
        }
    }

    // Live input listeners
    courseInput.addEventListener('input', applyFilters);
    lecturerInput.addEventListener('input', applyFilters);
    dateFrom.addEventListener('change', applyFilters);
    dateTo.addEventListener('change', applyFilters);
    btnApply.addEventListener('click', applyFilters);

    btnReset.addEventListener('click', function () {
        courseInput.value    = '';
        lecturerInput.value = '';
        dateFrom.value      = '';
        dateTo.value        = '';
        applyFilters();
    });

    /* ═══════════════════════════════════════
       3.  COLUMN SORTING
       ═══════════════════════════════════════ */
    const sortHeaders = document.querySelectorAll('th.sortable');
    let currentSort   = { col: null, dir: 'asc' };

    sortHeaders.forEach(th => {
        th.addEventListener('click', function () {
            const col  = this.dataset.col;
            const type = this.dataset.type;

            // Toggle direction
            if (currentSort.col === col) {
                currentSort.dir = currentSort.dir === 'asc' ? 'desc' : 'asc';
            } else {
                currentSort.col = col;
                currentSort.dir = 'asc';
            }

            // Update header classes
            sortHeaders.forEach(h => h.classList.remove('asc', 'desc'));
            this.classList.add(currentSort.dir);

            // Sort the rows array
            rows.sort(function (a, b) {
                let va, vb;
                if (col === 'jobId') {
                    va = a.dataset.jobId || '';
                    vb = b.dataset.jobId || '';
                } else if (col === 'course') {
                    va = (a.dataset.course || '').toLowerCase();
                    vb = (b.dataset.course || '').toLowerCase();
                } else if (col === 'lecturer') {
                    va = (a.dataset.lecturer || '').toLowerCase();
                    vb = (b.dataset.lecturer || '').toLowerCase();
                } else if (col === 'deadline') {
                    va = a.dataset.deadline || '';
                    vb = b.dataset.deadline || '';
                }

                let result;
                if (type === 'number') {
                    result = (parseInt(va, 10) || 0) - (parseInt(vb, 10) || 0);
                } else {
                    result = va < vb ? -1 : va > vb ? 1 : 0;
                }

                return currentSort.dir === 'asc' ? result : -result;
            });

            // Re-append sorted rows to DOM
            rows.forEach(r => tbody.appendChild(r));
        });
    });

    // Initial run
    applyFilters();
})();
</script>
</body>
</html>