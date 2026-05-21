<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Jobs</title>
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

        /* ── Status pills (chips in filter bar) ── */
        .status-chips {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }
        .status-chip {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: 2px solid transparent;
            transition: all .15s;
            user-select: none;
        }
        .status-chip[data-value="ALL"]    { background: #eef0f4; color: #444; }
        .status-chip[data-value="OPEN"]   { background: #e6f9ee; color: #1a8a4a; }
        .status-chip[data-value="CLOSED"] { background: #fde8e8; color: #b91c1c; }
        .status-chip[data-value="FILLED"] { background: #e8f0fe; color: #1d4ed8; }
        .status-chip.active {
            border-color: currentColor;
            box-shadow: 0 0 0 2px rgba(79,110,247,.2);
        }

        /* ── Result count ── */
        .filter-result-count {
            font-size: 13px;
            color: #777;
            padding: 6px 0 2px;
        }

        /* ── No-match message ── */
        .no-match-row td {
            text-align: center;
            padding: 32px 16px;
            color: #999;
            font-style: italic;
        }
    </style>
</head>
<body>
<div class="page-shell">
    <div class="topbar">
        <div class="brand">
            <div class="brand-mark">JB</div>
            <div>
                <div class="brand-title">Manage Posted Jobs</div>
                <div class="brand-subtitle">Review status and application volume</div>
            </div>
        </div>
        <div class="topbar-actions">
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/mo/jobs/new">Post New Job</a>
            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/mo/dashboard">Back to Dashboard</a>
        </div>
    </div>

    <c:if test="${not empty flash}">
        <div class="info-banner ${flash.type}">${flash.text}</div>
    </c:if>

    <div class="table-panel">
        <h2>My Jobs</h2>

        <c:if test="${not empty jobs}">
            <!-- ════════ Filter Bar ════════ -->
            <div class="filter-bar" id="filterBar">
                <div class="filter-group">
                    <label>Status</label>
                    <div class="status-chips" id="statusChips">
                        <span class="status-chip active" data-value="ALL">All</span>
                        <span class="status-chip" data-value="OPEN">Open</span>
                        <span class="status-chip" data-value="CLOSED">Closed</span>
                        <span class="status-chip" data-value="FILLED">Filled</span>
                    </div>
                </div>
                <div class="filter-group">
                    <label>Course Keyword</label>
                    <input type="text" id="filterKeyword" placeholder="e.g. CS101 or Math">
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
                <div class="empty-state">You have not posted any jobs yet.</div>
            </c:when>
            <c:otherwise>
                <table id="jobsTable">
                    <thead>
                    <tr>
                        <th>Course</th>
                        <th>Deadline</th>
                        <th>Status</th>
                        <th>Applications</th>
                        <th>Pending</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="jobsBody">
                    <c:forEach var="job" items="${jobs}">
                        <tr data-status="${job.status}"
                            data-course="${job.courseCode} ${job.courseName}"
                            data-deadline="${job.deadline}">
                            <td>
                                <strong><c:out value="${job.courseCode}"/></strong><br>
                                <span class="muted"><c:out value="${job.courseName}"/></span>
                            </td>
                            <td><c:out value="${job.deadline}"/></td>
                            <td>
                                <span class="status-pill ${job.status == 'OPEN' ? 'status-open' : job.status == 'FILLED' ? 'status-filled' : 'status-closed'}">
                                    <c:out value="${job.status}"/>
                                </span>
                            </td>
                            <td>${applicationCounts[job.jobId] != null ? applicationCounts[job.jobId] : 0}</td>
                            <td>${pendingCounts[job.jobId] != null ? pendingCounts[job.jobId] : 0}</td>
                            <td>
                                <div class="stack-inline">
                                    <a class="btn btn-ghost btn-small"
                                       href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}">Details</a>
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/mo/jobs/status">
                                        <input type="hidden" name="jobId" value="${job.jobId}">
                                        <input type="hidden" name="status"
                                               value="${job.status == 'OPEN' ? 'CLOSED' : 'OPEN'}">
                                        <button class="btn ${job.status == 'OPEN' ? 'btn-danger' : 'btn-success'} btn-small"
                                                type="submit">
                                                ${job.status == 'OPEN' ? 'Close' : 'Reopen'}
                                        </button>
                                    </form>
                                </div>
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
    const tbody        = document.getElementById('jobsBody');
    if (!tbody) return;                       // no table → nothing to filter

    const rows         = Array.from(tbody.querySelectorAll('tr[data-status]'));
    const chips        = document.querySelectorAll('#statusChips .status-chip');
    const keywordInput = document.getElementById('filterKeyword');
    const dateFrom     = document.getElementById('filterDateFrom');
    const dateTo       = document.getElementById('filterDateTo');
    const btnApply     = document.getElementById('btnApply');
    const btnReset     = document.getElementById('btnReset');
    const resultCount  = document.getElementById('resultCount');

    let activeStatus = 'ALL';

    /* ── Status chip toggle ── */
    chips.forEach(chip => {
        chip.addEventListener('click', () => {
            chips.forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            activeStatus = chip.dataset.value;
            applyFilters();
        });
    });

    /* ── Live keyword search (fires on every keystroke) ── */
    keywordInput.addEventListener('input', applyFilters);

    /* ── Date inputs trigger filter immediately ── */
    dateFrom.addEventListener('change', applyFilters);
    dateTo.addEventListener('change', applyFilters);

    /* ── Button handlers ── */
    btnApply.addEventListener('click', applyFilters);
    btnReset.addEventListener('click', () => {
        keywordInput.value = '';
        dateFrom.value     = '';
        dateTo.value       = '';
        activeStatus       = 'ALL';
        chips.forEach(c => c.classList.remove('active'));
        chips[0].classList.add('active');       // "All" chip
        applyFilters();
    });

    /* ── Core filter logic ── */
    function applyFilters() {
        const keyword = keywordInput.value.trim().toLowerCase();
        const from    = dateFrom.value;        // yyyy-mm-dd or ''
        const to      = dateTo.value;

        // Remove previous "no match" row if exists
        const prev = tbody.querySelector('.no-match-row');
        if (prev) prev.remove();

        let visible = 0;

        rows.forEach(row => {
            let show = true;

            // 1) Status filter
            if (activeStatus !== 'ALL' && row.dataset.status !== activeStatus) {
                show = false;
            }

            // 2) Keyword filter (matches courseCode or courseName)
            if (show && keyword) {
                const course = (row.dataset.course || '').toLowerCase();
                if (!course.includes(keyword)) show = false;
            }

            // 3) Date range filter
            if (show && from) {
                const dl = row.dataset.deadline || '';
                if (dl < from) show = false;
            }
            if (show && to) {
                const dl = row.dataset.deadline || '';
                if (dl > to) show = false;
            }

            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        // Update count
        resultCount.textContent = 'Showing ' + visible + ' of ' + rows.length + ' job(s)';

        // Show "no match" row when 0 results
        if (visible === 0) {
            const tr = document.createElement('tr');
            tr.className = 'no-match-row';
            tr.innerHTML = '<td colspan="6">No jobs match the current filters.</td>';
            tbody.appendChild(tr);
        }
    }

    // Initial count
    applyFilters();
})();
</script>
</body>
</html>