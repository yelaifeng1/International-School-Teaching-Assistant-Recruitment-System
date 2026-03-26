<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Boolean registrationSuccess = (Boolean) session.getAttribute("registrationSuccess");

    if (username == null || !"ADMIN".equalsIgnoreCase(role)) {
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
    <title>教学助手招聘系统 — 管理员仪表板</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Microsoft YaHei", "Segoe UI", Tahoma, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── Navbar ── */
        .navbar {
            background: white;
            padding: 0 30px;
            height: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar h2 { color: #333; font-size: 20px; }
        .navbar-right { display: flex; align-items: center; gap: 20px; }
        .user-info { color: #666; font-size: 14px; }
        .user-info strong { color: #333; }
        .logout-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border: none;
            padding: 8px 20px; border-radius: 6px;
            cursor: pointer; font-size: 13px; font-weight: 600;
            transition: all 0.3s ease;
        }
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102,126,234,0.4);
        }

        /* ── Success alert ── */
        .success-alert {
            background: #d4edda; color: #155724;
            border: 1px solid #c3e6cb;
            padding: 14px 30px; text-align: center;
            animation: slideDown 0.4s ease-out;
        }
        @keyframes slideDown {
            from { opacity:0; transform:translateY(-20px); }
            to   { opacity:1; transform:translateY(0); }
        }

        /* ── Info Cards ── */
        .info-strip {
            display: flex; gap: 16px;
            max-width: 900px; width: 100%;
            margin: 24px auto 0; padding: 0 16px;
        }
        .info-card {
            flex: 1;
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(6px);
            color: white;
            padding: 18px 20px;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
        }
        .info-card h3 { font-size: 12px; opacity: 0.8; margin-bottom: 8px; text-transform: uppercase; }
        .info-card p  { font-size: 22px; font-weight: 700; }

        /* ── Tab Bar ── */
        .tab-bar-wrapper {
            max-width: 900px; width: 100%;
            margin: 20px auto 0; padding: 0 16px;
        }
        .tab-bar {
            display: flex;
            background: white;
            border-radius: 12px 12px 0 0;
            overflow: hidden;
        }
        .tab-btn {
            padding: 14px 28px;
            font-size: 15px; font-weight: bold;
            color: #aaa; background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            transition: color 0.2s, border-color 0.2s;
        }
        .tab-btn:hover { color: #667eea; }
        .tab-btn.active { color: #667eea; border-bottom-color: #667eea; }

        /* ── Tab panels ── */
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* ── Main content area ── */
        .content-wrapper {
            max-width: 900px; width: 100%;
            margin: 0 auto; padding: 0 16px;
        }
        .content-body {
            background: white;
            border-radius: 0 0 12px 12px;
            padding: 28px 30px 20px;
            min-height: 400px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            margin-bottom: 20px;
        }

        .section-header {
            display: flex; justify-content: space-between;
            align-items: center; margin-bottom: 20px;
        }
        .section-title { font-size: 20px; font-weight: bold; color: #333; }
        .total-badge {
            background: #667eea22; color: #4a5acb;
            padding: 4px 14px; border-radius: 12px;
            font-size: 13px; font-weight: bold;
        }

        /* ── Feed cards ── */
        #feed { display: flex; flex-direction: column; gap: 14px; }

        .app-card {
            background: #fafafe;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            padding: 18px 22px;
            border-left: 4px solid #667eea;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .app-card:hover {
            box-shadow: 0 6px 22px rgba(102,126,234,0.18);
            transform: translateY(-2px);
        }

        .card-summary {
            display: flex; justify-content: space-between;
            align-items: center; cursor: pointer; user-select: none;
        }
        .summary-left { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .card-applicant { font-size: 15px; font-weight: bold; color: #333; }
        .card-job { font-size: 14px; color: #666; }
        .card-date {
            background: linear-gradient(90deg, #667eea, #764ba2);
            color: #fff; font-size: 12px; font-weight: bold;
            padding: 3px 10px; border-radius: 10px; white-space: nowrap;
        }

        .status-badge {
            display: inline-block; padding: 3px 12px;
            border-radius: 12px; font-size: 12px;
            font-weight: bold; white-space: nowrap;
        }
        .status-PENDING  { background: #fff3cd; color: #856404; }
        .status-APPROVED { background: #d4edda; color: #155724; }
        .status-REJECTED { background: #f8d7da; color: #721c24; }

        .toggle-icon {
            font-size: 13px; color: #bbb; margin-left: 10px;
            transition: transform 0.2s; flex-shrink: 0;
        }
        .toggle-icon.open { transform: rotate(180deg); }

        /* ── Expanded edit panel ── */
        .card-detail {
            display: none; margin-top: 14px;
            padding-top: 14px; border-top: 1px solid #e8e8f0;
        }
        .card-detail.open { display: block; }

        .edit-grid {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 12px 20px; margin-bottom: 14px;
        }
        .edit-item { display: flex; flex-direction: column; gap: 5px; }
        .edit-label { font-size: 11px; color: #aaa; font-weight: 500; }
        .edit-input {
            padding: 8px 12px; border: 1.5px solid #ddd;
            border-radius: 8px; font-size: 13px;
            font-family: inherit; outline: none;
            transition: border-color 0.2s;
        }
        .edit-input:focus { border-color: #667eea; }
        select.edit-input { cursor: pointer; background: #fff; }

        .edit-item-full { margin-bottom: 14px; display: flex; flex-direction: column; gap: 5px; }
        .edit-textarea {
            padding: 10px 12px; border: 1.5px solid #ddd;
            border-radius: 8px; font-size: 13px;
            font-family: inherit; outline: none;
            resize: vertical; min-height: 90px;
            transition: border-color 0.2s; width: 100%;
        }
        .edit-textarea:focus { border-color: #667eea; }

        .card-actions { display: flex; gap: 10px; margin-top: 6px; }
        .btn-save {
            flex: 2; padding: 9px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff; border: none; border-radius: 8px;
            font-size: 14px; font-weight: bold; cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-save:hover { opacity: 0.85; }
        .btn-save:disabled { opacity: 0.4; cursor: not-allowed; }

        .btn-delete {
            flex: 1; padding: 9px 0;
            background: #fff; color: #dc3545;
            border: 2px solid #dc3545; border-radius: 8px;
            font-size: 14px; font-weight: bold; cursor: pointer;
            transition: background 0.2s;
        }
        .btn-delete:hover { background: #fff0f0; }
        .btn-delete:disabled { opacity: 0.4; cursor: not-allowed; }

        .card-msg { font-size: 12px; margin-top: 8px; text-align: center; }
        .msg-ok  { color: #28a745; }
        .msg-err { color: #dc3545; }

        /* ── Hints ── */
        .empty-hint, .loading-hint {
            text-align: center; color: #bbb;
            padding: 60px 0; font-size: 15px;
        }

        /* ── 人员管理占位 ── */
        .placeholder-panel {
            margin: 60px auto; max-width: 400px;
            text-align: center; color: #ccc; font-size: 15px;
        }
        .placeholder-panel .icon { font-size: 52px; margin-bottom: 16px; }

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
            padding: 32px 36px; width: 100%; max-width: 400px;
            animation: modalIn 0.2s ease-out; text-align: center;
        }
        @keyframes modalIn {
            from { opacity:0; transform: scale(0.93) translateY(14px); }
            to   { opacity:1; transform: scale(1)    translateY(0); }
        }
        .modal-icon  { font-size: 40px; margin-bottom: 12px; }
        .modal-title { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 8px; }
        .modal-desc  { font-size: 14px; color: #666; margin-bottom: 24px; line-height: 1.6; white-space: pre-line; }
        .modal-actions { display: flex; gap: 12px; }
        .btn-modal-cancel {
            flex:1; padding:10px; background:#f0f0f0; color:#666;
            border:none; border-radius:8px; font-size:14px; cursor:pointer;
        }
        .btn-modal-cancel:hover { background:#e0e0e0; }
        .btn-modal-confirm {
            flex:2; padding:10px; border:none; border-radius:8px;
            font-size:14px; font-weight:bold; color:#fff; cursor:pointer;
            transition: opacity 0.2s;
        }
        .btn-modal-confirm:hover { opacity:0.85; }
        .btn-modal-confirm.save   { background: linear-gradient(135deg,#667eea,#764ba2); color:#fff; }
        .btn-modal-confirm.delete { background: #dc3545; }

        .footer { text-align:center; color:rgba(255,255,255,0.5); padding:20px; font-size:12px; }

        /* ── Responsive ── */
        @media (max-width: 600px) {
            .info-strip { flex-direction: column; }
            .edit-grid  { grid-template-columns: 1fr; }
            .navbar { padding: 0 16px; }
            .navbar h2 { font-size: 16px; }
            .tab-btn { padding: 12px 16px; font-size: 14px; }
        }
    </style>
</head>
<body>

<!-- ── Navbar ── -->
<div class="navbar">
    <h2>👨‍💼 系统管理员仪表板</h2>
    <div class="navbar-right">
        <div class="user-info">
            欢迎 <strong><%= username %></strong> | 角色: <strong>系统管理员</strong>
        </div>
        <form action="<%= contextPath %>/logout" method="get" style="margin:0;">
            <button type="submit" class="logout-btn">退出登录</button>
        </form>
    </div>
</div>

<!-- ── 注册成功提示 ── -->
<% if (registrationSuccess != null && registrationSuccess) { %>
    <div class="success-alert">✅ 恭喜！注册成功！现在您已自动登录。</div>
<% } %>

<!-- ── Info Cards ── -->
<div class="info-strip">
    <div class="info-card">
        <h3>申请总数</h3>
        <p id="stat-total">--</p>
    </div>
    <div class="info-card">
        <h3>待审核</h3>
        <p id="stat-pending">--</p>
    </div>
    <div class="info-card">
        <h3>已通过</h3>
        <p id="stat-approved">--</p>
    </div>
    <div class="info-card">
        <h3>已拒绝</h3>
        <p id="stat-rejected">--</p>
    </div>
</div>

<!-- ── Tab Bar ── -->
<div class="tab-bar-wrapper">
    <div class="tab-bar">
        <button class="tab-btn active" onclick="switchTab('applications', this)">📋 申请管理</button>
        <button class="tab-btn"        onclick="switchTab('users', this)">👥 人员管理</button>
    </div>
</div>

<!-- ── Content Body ── -->
<div class="content-wrapper">
    <div class="content-body">

        <!-- 申请管理 Tab -->
        <div id="tab-applications" class="tab-panel active">
            <div class="section-header">
                <div class="section-title">全部申请</div>
                <div class="total-badge" id="totalBadge">加载中…</div>
            </div>
            <div id="feed">
                <div class="loading-hint">加载中...</div>
            </div>
        </div>

        <!-- 人员管理 Tab -->
        <div id="tab-users" class="tab-panel">
            <div class="placeholder-panel">
                <div class="icon">👥</div>
                <div>人员管理功能尚未实现，敬请期待。</div>
            </div>
        </div>

    </div>
</div>

<div class="footer">TA Recruitment System | &copy; 2026 Group 50</div>

<!-- ── 确认弹窗 ── -->
<div class="modal-overlay" id="confirmOverlay">
    <div class="modal">
        <div class="modal-icon"  id="confirmIcon"></div>
        <div class="modal-title" id="confirmTitle"></div>
        <div class="modal-desc"  id="confirmDesc"></div>
        <div class="modal-actions">
            <button class="btn-modal-cancel" onclick="closeConfirm()">取消</button>
            <button class="btn-modal-confirm" id="confirmBtn" onclick="doConfirm()"></button>
        </div>
    </div>
</div>

<script>
    const ADMIN_URL = '<%= contextPath %>/apply/admin';

    /* ══════════ Tab 切换 ══════════ */
    function switchTab(name, el) {
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + name).classList.add('active');
        el.classList.add('active');
    }

    /* ══════════ 确认弹窗 ══════════ */
    let pendingAction = null;

    function openConfirm(action) {
        pendingAction = action;
        const isDel = action.type === 'delete';
        document.getElementById('confirmIcon').textContent  = isDel ? '🗑️' : '💾';
        document.getElementById('confirmTitle').textContent = isDel ? '确认删除申请？' : '确认保存修改？';
        document.getElementById('confirmDesc').textContent  = action.desc || '';
        const btn = document.getElementById('confirmBtn');
        btn.textContent = isDel ? '确认删除' : '确认保存';
        btn.className   = 'btn-modal-confirm ' + (isDel ? 'delete' : 'save');
        document.getElementById('confirmOverlay').classList.add('open');
    }

    function closeConfirm() {
        document.getElementById('confirmOverlay').classList.remove('open');
        pendingAction = null;
    }

    document.getElementById('confirmOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeConfirm();
    });

    async function doConfirm() {
        if (!pendingAction) return;
        const action = pendingAction;
        closeConfirm();

        const msgEl = document.getElementById('msg-' + action.appId);
        if (msgEl) msgEl.innerHTML = '<span style="color:#888">处理中…</span>';

        try {
            const res  = await fetch(ADMIN_URL, { method: 'POST', body: new URLSearchParams(action.payload) });
            const data = await res.json();

            if (data.success) {
                if (action.type === 'delete') {
                    const card = document.getElementById('card-' + action.appId);
                    if (card) card.remove();
                    updateTotal(-1);
                    refreshStats();
                } else {
                    if (msgEl) msgEl.innerHTML = '<span class="msg-ok">保存成功 ✓</span>';
                    refreshCardSummary(action.appId, action.payload);
                    refreshStats();
                }
            } else {
                if (msgEl) msgEl.innerHTML = '<span class="msg-err">' + (data.error || '操作失败') + '</span>';
            }
        } catch (e) {
            if (msgEl) msgEl.innerHTML = '<span class="msg-err">网络错误</span>';
        }
    }

    /* ══════════ Feed 加载 ══════════ */
    let allApps = [];

    async function loadFeed() {
        const feed = document.getElementById('feed');
        try {
            const res = await fetch(ADMIN_URL);
            if (!res.ok) {
                feed.innerHTML = '<div class="empty-hint">无法加载申请记录</div>';
                document.getElementById('totalBadge').textContent = '0 条';
                return;
            }
            allApps = await res.json();
            document.getElementById('totalBadge').textContent = allApps.length + ' 条申请';

            if (allApps.length === 0) {
                feed.innerHTML = '<div class="empty-hint">暂无申请记录</div>';
                updateStats(allApps);
                return;
            }

            allApps.sort((a, b) => (b.applyDate || '').localeCompare(a.applyDate || ''));
            feed.innerHTML = allApps.map(renderCard).join('');
            updateStats(allApps);
        } catch (e) {
            feed.innerHTML = '<div class="empty-hint">加载失败，请刷新页面重试</div>';
        }
    }

    /* ══════════ 统计卡片 ══════════ */
    function updateStats(apps) {
        const total    = apps.length;
        const pending  = apps.filter(a => a.status === 'PENDING').length;
        const approved = apps.filter(a => a.status === 'APPROVED').length;
        const rejected = apps.filter(a => a.status === 'REJECTED').length;
        document.getElementById('stat-total').textContent    = total;
        document.getElementById('stat-pending').textContent  = pending;
        document.getElementById('stat-approved').textContent = approved;
        document.getElementById('stat-rejected').textContent = rejected;
    }

    function refreshStats() {
        /* 从当前 DOM 里重新统计 */
        const badges = document.querySelectorAll('[id^="badge-"]');
        let pending = 0, approved = 0, rejected = 0;
        badges.forEach(b => {
            if (b.classList.contains('status-PENDING'))  pending++;
            if (b.classList.contains('status-APPROVED')) approved++;
            if (b.classList.contains('status-REJECTED')) rejected++;
        });
        const total = badges.length;
        document.getElementById('stat-total').textContent    = total;
        document.getElementById('stat-pending').textContent  = pending;
        document.getElementById('stat-approved').textContent = approved;
        document.getElementById('stat-rejected').textContent = rejected;
    }

    /* ══════════ 卡片渲染 ══════════ */
    function renderCard(app) {
        const id = esc(app.applicationId);
        return '\
        <div class="app-card" id="card-' + id + '">\
            <div class="card-summary" onclick="toggleDetail(\'' + id + '\')">\
                <div class="summary-left">\
                    <span class="card-applicant">申请人：' + esc(app.applicantId) + '</span>\
                    <span class="card-job">职位：' + esc(app.jobId) + '</span>\
                    <span class="card-date">📅 ' + esc(app.applyDate) + '</span>\
                    <span class="status-badge status-' + esc(app.status) + '"\
                          id="badge-' + id + '">' + statusLabel(app.status) + '</span>\
                </div>\
                <span class="toggle-icon" id="icon-' + id + '">▼</span>\
            </div>\
            <div class="card-detail" id="detail-' + id + '">\
                <div class="edit-grid">\
                    <div class="edit-item">\
                        <span class="edit-label">申请人 ID</span>\
                        <input class="edit-input" id="f-applicantId-' + id + '"\
                               value="' + esc(app.applicantId) + '" />\
                    </div>\
                    <div class="edit-item">\
                        <span class="edit-label">职位 ID</span>\
                        <input class="edit-input" id="f-jobId-' + id + '"\
                               value="' + esc(app.jobId) + '" />\
                    </div>\
                    <div class="edit-item">\
                        <span class="edit-label">申请日期</span>\
                        <input class="edit-input" id="f-applyDate-' + id + '"\
                               value="' + esc(app.applyDate) + '" placeholder="YYYY-MM-DD" />\
                    </div>\
                    <div class="edit-item">\
                        <span class="edit-label">审核状态</span>\
                        <select class="edit-input" id="f-status-' + id + '">\
                            <option value="PENDING"  ' + (app.status==='PENDING'  ? 'selected' : '') + '>审核中 (PENDING)</option>\
                            <option value="APPROVED" ' + (app.status==='APPROVED' ? 'selected' : '') + '>已通过 (APPROVED)</option>\
                            <option value="REJECTED" ' + (app.status==='REJECTED' ? 'selected' : '') + '>已拒绝 (REJECTED)</option>\
                        </select>\
                    </div>\
                </div>\
                <div class="edit-item-full">\
                    <span class="edit-label">个人陈述</span>\
                    <textarea class="edit-textarea" id="f-ps-' + id + '">' + esc(app.personalStatement) + '</textarea>\
                </div>\
                <div class="card-actions">\
                    <button class="btn-save" id="save-' + id + '"\
                            onclick="askSave(\'' + id + '\',\'' + esc(app.applicantId) + '\')">💾 保存修改</button>\
                    <button class="btn-delete" id="del-' + id + '"\
                            onclick="askDelete(\'' + id + '\',\'' + esc(app.applicantId) + '\',\'' + esc(app.jobId) + '\')">🗑️ 删除</button>\
                </div>\
                <div class="card-msg" id="msg-' + id + '"></div>\
            </div>\
        </div>';
    }

    /* ══════════ 保存 / 删除 ══════════ */
    function askSave(id, applicantId) {
        const payload = {
            action:           'update',
            applicationId:     id,
            applicantId:       document.getElementById('f-applicantId-' + id).value,
            jobId:             document.getElementById('f-jobId-'       + id).value,
            applyDate:         document.getElementById('f-applyDate-'   + id).value,
            status:            document.getElementById('f-status-'      + id).value,
            personalStatement: document.getElementById('f-ps-'          + id).value
        };
        openConfirm({
            type: 'save', appId: id, payload: payload,
            desc: '申请人：' + applicantId + '\n新状态：' + statusLabel(payload.status)
        });
    }

    function askDelete(id, applicantId, jobId) {
        openConfirm({
            type: 'delete', appId: id,
            payload: { action: 'delete', applicationId: id },
            desc: '申请人：' + applicantId + '\n职位：' + jobId + '\n\n此操作不可撤销！'
        });
    }

    function refreshCardSummary(id, payload) {
        const badge = document.getElementById('badge-' + id);
        if (badge) {
            badge.className   = 'status-badge status-' + payload.status;
            badge.textContent = statusLabel(payload.status);
        }
    }

    let currentTotal = 0;
    function updateTotal(delta) {
        currentTotal += delta;
        document.getElementById('totalBadge').textContent = currentTotal + ' 条申请';
    }

    /* ══════════ 展开 / 收起 ══════════ */
    function toggleDetail(id) {
        const detail = document.getElementById('detail-' + id);
        const icon   = document.getElementById('icon-'   + id);
        if (!detail) return;
        const opening = !detail.classList.contains('open');
        detail.classList.toggle('open');
        if (icon) icon.classList.toggle('open', opening);
    }

    /* ══════════ 工具函数 ══════════ */
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

    /* ══════════ 页面初始化 ══════════ */
    loadFeed().then(function() {
        var badge = document.getElementById('totalBadge');
        var m = badge && badge.textContent.match(/\d+/);
        currentTotal = m ? parseInt(m[0]) : 0;
    });
</script>
</body>
</html>