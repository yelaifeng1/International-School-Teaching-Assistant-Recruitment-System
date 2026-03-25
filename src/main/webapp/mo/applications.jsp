<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"MO".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>申请审核 — MO</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Microsoft YaHei", "Segoe UI", Tahoma, sans-serif;
            background: #f5f0fb;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── Navbar ── */
        .navbar {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: #fff;
            padding: 0 30px;
            height: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 12px rgba(240,147,251,0.4);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar-left { display: flex; align-items: center; gap: 18px; }
        .navbar-title { font-size: 18px; font-weight: bold; }
        .navbar-back {
            background: rgba(255,255,255,0.18);
            color: #fff;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
        }
        .navbar-back:hover { background: rgba(255,255,255,0.3); }
        .navbar-role {
            background: rgba(255,255,255,0.2);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
        }

        /* ── Main ── */
        .main { flex: 1; max-width: 800px; margin: 32px auto; padding: 0 16px; width: 100%; }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .section-title { font-size: 20px; font-weight: bold; color: #333; }
        .total-badge {
            background: #f093fb22;
            color: #c044c0;
            padding: 4px 14px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: bold;
        }

        /* ── Feed ── */
        #feed { display: flex; flex-direction: column; gap: 16px; }

        .app-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            padding: 20px 24px;
            border-left: 4px solid #f093fb;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .app-card:hover {
            box-shadow: 0 6px 22px rgba(240,147,251,0.22);
            transform: translateY(-2px);
        }

        /* 摘要行 */
        .card-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            user-select: none;
        }
        .summary-left { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
        .card-applicant { font-size: 15px; font-weight: bold; color: #333; }
        .card-job { font-size: 14px; color: #666; }

        /* 申请日期 — 橙黄色高亮 */
        .card-date {
            background: linear-gradient(90deg, #ff9a00, #ffcc00);
            color: #5a3a00;
            font-size: 12px;
            font-weight: bold;
            padding: 3px 10px;
            border-radius: 10px;
            white-space: nowrap;
        }

        .status-badge {
            display: inline-block;
            padding: 3px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }
        .status-PENDING  { background: #fff3cd; color: #856404; }
        .status-APPROVED { background: #d4edda; color: #155724; }
        .status-REJECTED { background: #f8d7da; color: #721c24; }

        .toggle-icon {
            font-size: 13px;
            color: #bbb;
            margin-left: 10px;
            transition: transform 0.2s;
            flex-shrink: 0;
        }
        .toggle-icon.open { transform: rotate(180deg); }

        /* 展开区域 */
        .card-detail {
            display: none;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #f0e0f8;
        }
        .card-detail.open { display: block; }

        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 20px; margin-bottom: 16px; }
        .detail-item {}
        .detail-label { font-size: 11px; color: #aaa; margin-bottom: 3px; }
        .detail-value { font-size: 13px; color: #333; font-weight: 500; word-break: break-all; }

        .statement-block { margin-bottom: 16px; }
        .statement-label { font-size: 11px; color: #aaa; margin-bottom: 6px; }
        .statement-text {
            background: #fafafa;
            border-radius: 8px;
            padding: 12px 14px;
            font-size: 13px;
            color: #444;
            line-height: 1.7;
            white-space: pre-wrap;
        }

        .review-actions { display: flex; gap: 10px; }
        .btn-approve {
            flex: 1;
            padding: 9px 0;
            background: #28a745;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-approve:hover { opacity: 0.85; }
        .btn-approve:disabled { opacity: 0.4; cursor: not-allowed; }

        .btn-reject {
            flex: 1;
            padding: 9px 0;
            background: #dc3545;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-reject:hover { opacity: 0.85; }
        .btn-reject:disabled { opacity: 0.4; cursor: not-allowed; }

        .review-msg { font-size: 12px; margin-top: 8px; text-align: center; }
        .msg-ok  { color: #28a745; }
        .msg-err { color: #dc3545; }

        /* ── Hints ── */
        .empty-hint, .loading-hint {
            text-align: center;
            color: #bbb;
            padding: 60px 0;
            font-size: 15px;
        }

        /* ── 确认弹窗 ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 200;
            justify-content: center;
            align-items: center;
        }
        .modal-overlay.open { display: flex; }

        .modal {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 20px 70px rgba(0,0,0,0.28);
            padding: 32px 36px;
            width: 100%;
            max-width: 380px;
            animation: modalIn 0.2s ease-out;
            text-align: center;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.93) translateY(14px); }
            to   { opacity: 1; transform: scale(1)    translateY(0); }
        }

        .modal-icon { font-size: 40px; margin-bottom: 12px; }
        .modal-title { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 8px; }
        .modal-desc  { font-size: 14px; color: #666; margin-bottom: 24px; line-height: 1.6; }

        .modal-actions { display: flex; gap: 12px; }
        .btn-modal-cancel {
            flex: 1; padding: 10px;
            background: #f0f0f0; color: #666;
            border: none; border-radius: 8px;
            font-size: 14px; cursor: pointer;
        }
        .btn-modal-cancel:hover { background: #e0e0e0; }

        .btn-modal-confirm {
            flex: 2; padding: 10px;
            border: none; border-radius: 8px;
            font-size: 14px; font-weight: bold;
            color: #fff; cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-modal-confirm:hover { opacity: 0.85; }
        .btn-modal-confirm.approve { background: #28a745; }
        .btn-modal-confirm.reject  { background: #dc3545; }

        .footer { text-align: center; color: #ccc; padding: 20px; font-size: 12px; }
    </style>
</head>
<body>

<!-- ── Navbar ── -->
<div class="navbar">
    <div class="navbar-left">
        <a href="<%= contextPath %>/mo/dashboard.jsp" class="navbar-back">← 返回</a>
        <div class="navbar-title">申请审核</div>
    </div>
    <div class="navbar-role">👨‍💼 MO 角色</div>
</div>

<!-- ── Feed ── -->
<div class="main">
    <div class="section-header">
        <div class="section-title">全部申请</div>
        <div class="total-badge" id="totalBadge">加载中…</div>
    </div>
    <div id="feed">
        <div class="loading-hint">加载中...</div>
    </div>
</div>

<div class="footer">TA Recruitment System | © 2026 Group 50</div>

<!-- ── 确认弹窗 ── -->
<div class="modal-overlay" id="confirmOverlay">
    <div class="modal">
        <div class="modal-icon" id="confirmIcon"></div>
        <div class="modal-title" id="confirmTitle"></div>
        <div class="modal-desc"  id="confirmDesc"></div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="closeConfirm()">取消</button>
            <button class="btn-modal-confirm" id="confirmBtn" onclick="doReview()"></button>
        </div>
    </div>
</div>

<script>
    const REVIEW_URL = '<%= contextPath %>/apply/review';

    /* 当前待确认的操作 */
    let pendingAppId  = null;
    let pendingStatus = null;

    /* ── 确认弹窗控制 ── */
    function openConfirm(appId, status, applicantId, jobId) {
        pendingAppId  = appId;
        pendingStatus = status;

        const isApprove = status === 'APPROVED';
        document.getElementById('confirmIcon').textContent  = isApprove ? '✅' : '❌';
        document.getElementById('confirmTitle').textContent = isApprove ? '确认通过申请？' : '确认拒绝申请？';
        document.getElementById('confirmDesc').textContent  =
            `申请人：${applicantId}\n职位：${jobId}`;
        document.getElementById('confirmDesc').style.whiteSpace = 'pre-line';

        const btn = document.getElementById('confirmBtn');
        btn.textContent = isApprove ? '确认通过' : '确认拒绝';
        btn.className   = 'btn-modal-confirm ' + (isApprove ? 'approve' : 'reject');

        document.getElementById('confirmOverlay').classList.add('open');
    }

    function closeConfirm() {
        document.getElementById('confirmOverlay').classList.remove('open');
        pendingAppId  = null;
        pendingStatus = null;
    }

    /* 点遮罩关闭 */
    document.getElementById('confirmOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeConfirm();
    });

    /* ── 执行审核 ── */
    async function doReview() {
        if (!pendingAppId || !pendingStatus) return;

        const appId  = pendingAppId;
        const status = pendingStatus;
        closeConfirm();

        const msgEl = document.getElementById('msg-' + appId);
        if (msgEl) msgEl.innerHTML = '<span style="color:#888">处理中…</span>';

        try {
            const body = new URLSearchParams({ applicationId: appId, status });
            const res  = await fetch(REVIEW_URL, { method: 'POST', body });
            const data = await res.json();

            if (data.success) {
                /* 更新卡片上的状态徽章，禁用按钮 */
                const badge = document.getElementById('badge-' + appId);
                if (badge) {
                    badge.className = 'status-badge status-' + status;
                    badge.textContent = statusLabel(status);
                }
                disableReviewBtns(appId, status);
                if (msgEl) msgEl.innerHTML =
                    '<span class="msg-ok">' + (status === 'APPROVED' ? '已通过' : '已拒绝') + '</span>';
            } else {
                if (msgEl) msgEl.innerHTML =
                    '<span class="msg-err">' + (data.error || '操作失败') + '</span>';
            }
        } catch (e) {
            if (msgEl) msgEl.innerHTML = '<span class="msg-err">网络错误</span>';
        }
    }

    function disableReviewBtns(appId, status) {
        const approveBtn = document.getElementById('approve-' + appId);
        const rejectBtn  = document.getElementById('reject-'  + appId);
        if (approveBtn) approveBtn.disabled = true;
        if (rejectBtn)  rejectBtn.disabled  = true;
    }

    /* ── Feed 加载 ── */
    async function loadFeed() {
        const feed = document.getElementById('feed');

        try {
            const res  = await fetch(REVIEW_URL);
            if (!res.ok) {
                feed.innerHTML = '<div class="empty-hint">无法加载申请记录</div>';
                document.getElementById('totalBadge').textContent = '0 条';
                return;
            }

            const apps = await res.json();
            document.getElementById('totalBadge').textContent = apps.length + ' 条申请';

            if (apps.length === 0) {
                feed.innerHTML = '<div class="empty-hint">暂无申请记录</div>';
                return;
            }

            /* 按日期倒序 */
            apps.sort((a, b) => b.applyDate.localeCompare(a.applyDate));

            feed.innerHTML = apps.map(app => {
                const isTerminal = app.status === 'APPROVED' || app.status === 'REJECTED';
                return `
                <div class="app-card" id="card-${esc(app.applicationId)}">
                    <div class="card-summary" onclick="toggleDetail('${esc(app.applicationId)}')">
                        <div class="summary-left">
                            <span class="card-applicant">申请人：${esc(app.applicantId)}</span>
                            <span class="card-job">职位：${esc(app.jobId)}</span>
                            <span class="card-date">📅 ${esc(app.applyDate)}</span>
                            <span class="status-badge status-${esc(app.status)}"
                                  id="badge-${esc(app.applicationId)}">${statusLabel(app.status)}</span>
                        </div>
                        <span class="toggle-icon" id="icon-${esc(app.applicationId)}">▼</span>
                    </div>

                    <div class="card-detail" id="detail-${esc(app.applicationId)}">
                        <div class="detail-grid">
                            <div class="detail-item">
                                <div class="detail-label">申请 ID</div>
                                <div class="detail-value">${esc(app.applicationId)}</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">申请人 ID</div>
                                <div class="detail-value">${esc(app.applicantId)}</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">职位 ID</div>
                                <div class="detail-value">${esc(app.jobId)}</div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">当前状态</div>
                                <div class="detail-value">${statusLabel(app.status)}</div>
                            </div>
                        </div>

                        <div class="statement-block">
                            <div class="statement-label">个人陈述</div>
                            <div class="statement-text">${esc(app.personalStatement)}</div>
                        </div>

                        <div class="review-actions">
                            <button class="btn-approve"
                                    id="approve-${esc(app.applicationId)}"
                                    ${isTerminal ? 'disabled' : ''}
                                    onclick="openConfirm('${esc(app.applicationId)}','APPROVED','${esc(app.applicantId)}','${esc(app.jobId)}')">
                                ✓ 通过
                            </button>
                            <button class="btn-reject"
                                    id="reject-${esc(app.applicationId)}"
                                    ${isTerminal ? 'disabled' : ''}
                                    onclick="openConfirm('${esc(app.applicationId)}','REJECTED','${esc(app.applicantId)}','${esc(app.jobId)}')">
                                ✗ 拒绝
                            </button>
                        </div>
                        <div class="review-msg" id="msg-${esc(app.applicationId)}"></div>
                    </div>
                </div>`;
            }).join('');

        } catch (e) {
            feed.innerHTML = '<div class="empty-hint">加载失败，请刷新页面重试</div>';
            document.getElementById('totalBadge').textContent = '—';
        }
    }

    function toggleDetail(id) {
        const detail = document.getElementById('detail-' + id);
        const icon   = document.getElementById('icon-'   + id);
        if (!detail) return;
        const opening = !detail.classList.contains('open');
        detail.classList.toggle('open');
        if (icon) icon.classList.toggle('open', opening);
    }

    function statusLabel(s) {
        return { PENDING: '审核中', APPROVED: '已通过', REJECTED: '已拒绝' }[s] || s;
    }

    function esc(str) {
        if (str == null) return '';
        return String(str)
            .replace(/&/g,  '&amp;')
            .replace(/</g,  '&lt;')
            .replace(/>/g,  '&gt;')
            .replace(/"/g,  '&quot;')
            .replace(/'/g,  '&#39;');
    }

    loadFeed();
</script>
</body>
</html>
