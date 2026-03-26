<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Boolean registrationSuccess = (Boolean) session.getAttribute("registrationSuccess");

    if (username == null || !"MO".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    session.removeAttribute("registrationSuccess");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>招聘主管仪表板 — MO</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', 'Microsoft YaHei', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        /* ── Navbar ── */
        .navbar {
            background: white;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .navbar h2 { color: #333; font-size: 24px; }
        .navbar-right { display: flex; align-items: center; gap: 20px; }
        .user-info { color: #666; font-size: 14px; }
        .user-info strong { color: #333; }
        .logout-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none; padding: 10px 20px;
            border-radius: 6px; cursor: pointer; font-size: 14px;
            font-weight: 600; transition: all 0.3s ease;
        }
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        /* ── Container ── */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }

        /* ── Welcome ── */
        .welcome-section { text-align: center; margin-bottom: 30px; }
        .welcome-section h1 { color: #333; font-size: 32px; margin-bottom: 10px; }
        .welcome-section p  { color: #666; font-size: 16px; }

        .success-alert {
            background: #d4edda; color: #155724;
            border: 1px solid #c3e6cb; padding: 15px 20px;
            border-radius: 6px; margin-bottom: 20px;
            animation: slideDown 0.4s ease-out;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Info Cards ── */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px; margin-bottom: 36px;
        }
        .info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 20px; border-radius: 10px; text-align: center;
        }
        .info-card h3 { font-size: 14px; opacity: 0.8; margin-bottom: 10px; }
        .info-card p  { font-size: 24px; font-weight: 600; }

        /* ── Section Header ── */
        .section-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; padding-top: 10px;
            border-top: 1px solid #eee;
        }
        .section-title { font-size: 20px; font-weight: bold; color: #333; }
        .total-badge {
            background: rgba(102,126,234,0.1); color: #667eea;
            padding: 4px 14px; border-radius: 12px;
            font-size: 13px; font-weight: bold;
        }

        /* ── Feed ── */
        #feed { display: flex; flex-direction: column; gap: 16px; }

        .app-card {
            background: #fafafe; border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            padding: 20px 24px; border-left: 4px solid #764ba2;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .app-card:hover {
            box-shadow: 0 6px 22px rgba(118,75,162,0.18);
            transform: translateY(-2px);
        }

        /* 摘要行 */
        .card-summary {
            display: flex; justify-content: space-between; align-items: center;
            cursor: pointer; user-select: none;
        }
        .summary-left { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
        .card-applicant { font-size: 15px; font-weight: bold; color: #333; }
        .card-job { font-size: 14px; color: #666; }
        .card-date {
            background: linear-gradient(90deg, #667eea, #764ba2);
            color: #fff; font-size: 12px; font-weight: bold;
            padding: 3px 10px; border-radius: 10px; white-space: nowrap;
        }

        .status-badge {
            display: inline-block; padding: 3px 12px; border-radius: 12px;
            font-size: 12px; font-weight: bold; white-space: nowrap;
        }
        .status-PENDING  { background: #fff3cd; color: #856404; }
        .status-APPROVED { background: #d4edda; color: #155724; }
        .status-REJECTED { background: #f8d7da; color: #721c24; }

        .toggle-icon {
            font-size: 13px; color: #bbb; margin-left: 10px;
            transition: transform 0.2s; flex-shrink: 0;
        }
        .toggle-icon.open { transform: rotate(180deg); }

        /* 展开区域 */
        .card-detail {
            display: none; margin-top: 16px; padding-top: 16px;
            border-top: 1px solid #ede5f5;
        }
        .card-detail.open { display: block; }

        .detail-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 10px 20px; margin-bottom: 16px;
        }
        .detail-label { font-size: 11px; color: #aaa; margin-bottom: 3px; }
        .detail-value { font-size: 13px; color: #333; font-weight: 500; word-break: break-all; }

        .statement-block { margin-bottom: 16px; }
        .statement-label { font-size: 11px; color: #aaa; margin-bottom: 6px; }
        .statement-text {
            background: #f5f3f8; border-radius: 8px; padding: 12px 14px;
            font-size: 13px; color: #444; line-height: 1.7; white-space: pre-wrap;
        }

        .review-actions { display: flex; gap: 10px; }
        .btn-approve {
            flex: 1; padding: 9px 0; background: #28a745; color: #fff;
            border: none; border-radius: 8px; font-size: 14px;
            font-weight: bold; cursor: pointer; transition: opacity 0.2s;
        }
        .btn-approve:hover { opacity: 0.85; }
        .btn-approve:disabled { opacity: 0.4; cursor: not-allowed; }

        .btn-reject {
            flex: 1; padding: 9px 0; background: #dc3545; color: #fff;
            border: none; border-radius: 8px; font-size: 14px;
            font-weight: bold; cursor: pointer; transition: opacity 0.2s;
        }
        .btn-reject:hover { opacity: 0.85; }
        .btn-reject:disabled { opacity: 0.4; cursor: not-allowed; }

        .review-msg { font-size: 12px; margin-top: 8px; text-align: center; }
        .msg-ok  { color: #28a745; }
        .msg-err { color: #dc3545; }

        .empty-hint, .loading-hint {
            text-align: center; color: #bbb; padding: 60px 0; font-size: 15px;
        }

        /* ── 确认弹窗 ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.45); z-index: 200;
            justify-content: center; align-items: center;
        }
        .modal-overlay.open { display: flex; }

        .modal {
            background: #fff; border-radius: 14px;
            box-shadow: 0 20px 70px rgba(0,0,0,0.28);
            padding: 32px 36px; width: 100%; max-width: 380px;
            animation: modalIn 0.2s ease-out; text-align: center;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.93) translateY(14px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }

        .modal-icon  { font-size: 40px; margin-bottom: 12px; }
        .modal-title { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 8px; }
        .modal-desc  { font-size: 14px; color: #666; margin-bottom: 24px; line-height: 1.6; }

        .modal-actions { display: flex; gap: 12px; }
        .btn-modal-cancel {
            flex: 1; padding: 10px; background: #f0f0f0; color: #666;
            border: none; border-radius: 8px; font-size: 14px; cursor: pointer;
        }
        .btn-modal-cancel:hover { background: #e0e0e0; }

        .btn-modal-confirm {
            flex: 2; padding: 10px; border: none; border-radius: 8px;
            font-size: 14px; font-weight: bold; color: #fff;
            cursor: pointer; transition: opacity 0.2s;
        }
        .btn-modal-confirm:hover { opacity: 0.85; }
        .btn-modal-confirm.approve { background: #28a745; }
        .btn-modal-confirm.reject  { background: #dc3545; }

        .footer { text-align: center; color: rgba(255,255,255,0.5); padding: 20px; font-size: 12px; }
    </style>
</head>
<body>

<!-- ── Navbar ── -->
<div class="navbar">
    <h2>👔 招聘主管仪表板</h2>
    <div class="navbar-right">
        <div class="user-info">
            欢迎 <strong><%= username %></strong> | 角色: <strong>招聘主管 (MO)</strong>
        </div>
        <form action="<%= contextPath %>/logout" method="get" style="margin: 0;">
            <button type="submit" class="logout-btn">退出登录</button>
        </form>
    </div>
</div>

<!-- ── Main ── -->
<div class="container">

    <% if (registrationSuccess != null && registrationSuccess) { %>
        <div class="success-alert">✅ 恭喜！注册成功！现在您已自动登录。</div>
    <% } %>

    <div class="welcome-section">
        <h1>欢迎回来，<%= username %>！</h1>
        <p>这是您的招聘管理仪表板，管理申请和面试。</p>
    </div>

    <!-- 统计卡片 -->
    <div class="info-grid">
        <div class="info-card">
            <h3>待审核申请</h3>
            <p id="countPending">--</p>
        </div>
        <div class="info-card">
            <h3>已通过</h3>
            <p id="countApproved">0</p>
        </div>
        <div class="info-card">
            <h3>已拒绝</h3>
            <p id="countRejected">0</p>
        </div>
    </div>

    <!-- 申请列表 -->
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

    /* ─── 全局申请数据缓存 ─── */
    let allApps = [];

    /* ─── 弹窗状态 ─── */
    let pendingAppId  = null;
    let pendingStatus = null;

    /* ── 统计卡片 ── */
    function updateStats() {
        const pending  = allApps.filter(a => a.status === 'PENDING').length;
        const approved = allApps.filter(a => a.status === 'APPROVED').length;
        const rejected = allApps.filter(a => a.status === 'REJECTED').length;

        document.getElementById('countPending').textContent  = pending;
        document.getElementById('countApproved').textContent = approved;
        document.getElementById('countRejected').textContent = rejected;
    }

    /* ── 确认弹窗 ── */
    function openConfirm(appId, status, applicantId, jobId) {
        pendingAppId  = appId;
        pendingStatus = status;

        const isApprove = status === 'APPROVED';
        document.getElementById('confirmIcon').textContent  = isApprove ? '✅' : '❌';
        document.getElementById('confirmTitle').textContent = isApprove ? '确认通过申请？' : '确认拒绝申请？';
        document.getElementById('confirmDesc').textContent  = '申请人：' + applicantId + '\n职位：' + jobId;
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
            const body = new URLSearchParams({ applicationId: appId, status: status });
            const res  = await fetch(REVIEW_URL, { method: 'POST', body: body });
            const data = await res.json();

            if (data.success) {
                /* 更新缓存中的状态 */
                const cached = allApps.find(a => a.applicationId === appId);
                if (cached) cached.status = status;

                /* 更新卡片徽章 */
                const badge = document.getElementById('badge-' + appId);
                if (badge) {
                    badge.className = 'status-badge status-' + status;
                    badge.textContent = statusLabel(status);
                }

                /* 更新展开区的状态文字 */
                const detailStatus = document.getElementById('detail-status-' + appId);
                if (detailStatus) detailStatus.textContent = statusLabel(status);

                disableReviewBtns(appId);
                updateStats();

                if (msgEl) msgEl.innerHTML =
                    '<span class="msg-ok">' + (status === 'APPROVED' ? '✓ 已通过' : '✗ 已拒绝') + '</span>';
            } else {
                if (msgEl) msgEl.innerHTML =
                    '<span class="msg-err">' + (data.error || '操作失败') + '</span>';
            }
        } catch (e) {
            if (msgEl) msgEl.innerHTML = '<span class="msg-err">网络错误</span>';
        }
    }

    function disableReviewBtns(appId) {
        const approveBtn = document.getElementById('approve-' + appId);
        const rejectBtn  = document.getElementById('reject-'  + appId);
        if (approveBtn) approveBtn.disabled = true;
        if (rejectBtn)  rejectBtn.disabled  = true;
    }

    /* ── 加载 Feed ── */
    async function loadFeed() {
        const feed = document.getElementById('feed');

        try {
            const res = await fetch(REVIEW_URL);
            if (!res.ok) {
                feed.innerHTML = '<div class="empty-hint">无法加载申请记录</div>';
                document.getElementById('totalBadge').textContent = '0 条';
                return;
            }

            allApps = await res.json();
            document.getElementById('totalBadge').textContent = allApps.length + ' 条申请';
            updateStats();

            if (allApps.length === 0) {
                feed.innerHTML = '<div class="empty-hint">暂无申请记录</div>';
                return;
            }

            /* 按日期倒序 */
            allApps.sort(function(a, b) { return b.applyDate.localeCompare(a.applyDate); });

            feed.innerHTML = allApps.map(function(app) {
                var isTerminal = app.status === 'APPROVED' || app.status === 'REJECTED';
                var disabledAttr = isTerminal ? 'disabled' : '';
                var aid = esc(app.applicationId);

                return ''
                + '<div class="app-card" id="card-' + aid + '">'
                +   '<div class="card-summary" onclick="toggleDetail(\'' + aid + '\')">'
                +     '<div class="summary-left">'
                +       '<span class="card-applicant">申请人：' + esc(app.applicantId) + '</span>'
                +       '<span class="card-job">职位：' + esc(app.jobId) + '</span>'
                +       '<span class="card-date">📅 ' + esc(app.applyDate) + '</span>'
                +       '<span class="status-badge status-' + esc(app.status) + '" id="badge-' + aid + '">'
                +           statusLabel(app.status)
                +       '</span>'
                +     '</div>'
                +     '<span class="toggle-icon" id="icon-' + aid + '">▼</span>'
                +   '</div>'
                +   '<div class="card-detail" id="detail-' + aid + '">'
                +     '<div class="detail-grid">'
                +       '<div class="detail-item">'
                +         '<div class="detail-label">申请 ID</div>'
                +         '<div class="detail-value">' + aid + '</div>'
                +       '</div>'
                +       '<div class="detail-item">'
                +         '<div class="detail-label">申请人 ID</div>'
                +         '<div class="detail-value">' + esc(app.applicantId) + '</div>'
                +       '</div>'
                +       '<div class="detail-item">'
                +         '<div class="detail-label">职位 ID</div>'
                +         '<div class="detail-value">' + esc(app.jobId) + '</div>'
                +       '</div>'
                +       '<div class="detail-item">'
                +         '<div class="detail-label">当前状态</div>'
                +         '<div class="detail-value" id="detail-status-' + aid + '">' + statusLabel(app.status) + '</div>'
                +       '</div>'
                +     '</div>'
                +     '<div class="statement-block">'
                +       '<div class="statement-label">个人陈述</div>'
                +       '<div class="statement-text">' + esc(app.personalStatement) + '</div>'
                +     '</div>'
                +     '<div class="review-actions">'
                +       '<button class="btn-approve" id="approve-' + aid + '" ' + disabledAttr
                +           ' onclick="openConfirm(\'' + aid + '\',\'APPROVED\',\'' + esc(app.applicantId) + '\',\'' + esc(app.jobId) + '\')">'
                +           '✓ 通过</button>'
                +       '<button class="btn-reject" id="reject-' + aid + '" ' + disabledAttr
                +           ' onclick="openConfirm(\'' + aid + '\',\'REJECTED\',\'' + esc(app.applicantId) + '\',\'' + esc(app.jobId) + '\')">'
                +           '✗ 拒绝</button>'
                +     '</div>'
                +     '<div class="review-msg" id="msg-' + aid + '"></div>'
                +   '</div>'
                + '</div>';
            }).join('');

        } catch (e) {
            feed.innerHTML = '<div class="empty-hint">加载失败，请刷新页面重试</div>';
            document.getElementById('totalBadge').textContent = '—';
        }
    }

    function toggleDetail(id) {
        var detail = document.getElementById('detail-' + id);
        var icon   = document.getElementById('icon-'   + id);
        if (!detail) return;
        var opening = !detail.classList.contains('open');
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