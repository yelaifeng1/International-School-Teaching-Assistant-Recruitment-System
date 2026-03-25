<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
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
    <title>系统管理 — Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Microsoft YaHei", "Segoe UI", Tahoma, sans-serif;
            background: #fdf6f0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── Navbar ── */
        .navbar {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: #333;
            padding: 0 30px;
            height: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 12px rgba(250,112,154,0.35);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar-left { display: flex; align-items: center; gap: 18px; }
        .navbar-title { font-size: 18px; font-weight: bold; }
        .navbar-back {
            background: rgba(0,0,0,0.1);
            color: #333;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
        }
        .navbar-back:hover { background: rgba(0,0,0,0.18); }
        .navbar-role {
            background: rgba(0,0,0,0.1);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        /* ── Tab Bar ── */
        .tab-bar {
            display: flex;
            background: #fff;
            border-bottom: 2px solid #f0e0e8;
            padding: 0 30px;
        }
        .tab-btn {
            padding: 14px 28px;
            font-size: 15px;
            font-weight: bold;
            color: #aaa;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            cursor: pointer;
            transition: color 0.2s, border-color 0.2s;
        }
        .tab-btn:hover { color: #fa709a; }
        .tab-btn.active { color: #fa709a; border-bottom-color: #fa709a; }

        /* ── Tab panels ── */
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* ── Main content area ── */
        .main { flex: 1; max-width: 860px; margin: 28px auto; padding: 0 16px; width: 100%; }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .section-title { font-size: 20px; font-weight: bold; color: #333; }
        .total-badge {
            background: #fa709a22;
            color: #c0306a;
            padding: 4px 14px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: bold;
        }

        /* ── Feed cards ── */
        #feed { display: flex; flex-direction: column; gap: 16px; }

        .app-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            padding: 20px 24px;
            border-left: 4px solid #fa709a;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .app-card:hover {
            box-shadow: 0 6px 22px rgba(250,112,154,0.2);
            transform: translateY(-2px);
        }

        .card-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            user-select: none;
        }
        .summary-left { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .card-applicant { font-size: 15px; font-weight: bold; color: #333; }
        .card-job { font-size: 14px; color: #666; }

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
            font-size: 13px; color: #bbb; margin-left: 10px;
            transition: transform 0.2s; flex-shrink: 0;
        }
        .toggle-icon.open { transform: rotate(180deg); }

        /* ── Expanded edit panel ── */
        .card-detail {
            display: none;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #fde8f0;
        }
        .card-detail.open { display: block; }

        .edit-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px 20px;
            margin-bottom: 14px;
        }
        .edit-item { display: flex; flex-direction: column; gap: 5px; }
        .edit-label { font-size: 11px; color: #aaa; font-weight: 500; }
        .edit-input {
            padding: 8px 12px;
            border: 1.5px solid #ddd;
            border-radius: 8px;
            font-size: 13px;
            font-family: inherit;
            outline: none;
            transition: border-color 0.2s;
        }
        .edit-input:focus { border-color: #fa709a; }
        select.edit-input { cursor: pointer; background: #fff; }

        .edit-item-full { margin-bottom: 14px; display: flex; flex-direction: column; gap: 5px; }
        .edit-textarea {
            padding: 10px 12px;
            border: 1.5px solid #ddd;
            border-radius: 8px;
            font-size: 13px;
            font-family: inherit;
            outline: none;
            resize: vertical;
            min-height: 90px;
            transition: border-color 0.2s;
            width: 100%;
        }
        .edit-textarea:focus { border-color: #fa709a; }

        .card-actions { display: flex; gap: 10px; margin-top: 6px; }
        .btn-save {
            flex: 2; padding: 9px 0;
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: #333; border: none; border-radius: 8px;
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
            margin: 60px auto;
            max-width: 400px;
            text-align: center;
            color: #ccc;
            font-size: 15px;
        }
        .placeholder-panel .icon { font-size: 52px; margin-bottom: 16px; }

        /* ── 确认弹窗 ── */
        .modal-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 200;
            justify-content: center; align-items: center;
        }
        .modal-overlay.open { display: flex; }

        .modal {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 20px 70px rgba(0,0,0,0.28);
            padding: 32px 36px;
            width: 100%; max-width: 400px;
            animation: modalIn 0.2s ease-out;
            text-align: center;
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
            flex:1; padding:10px;
            background:#f0f0f0; color:#666;
            border:none; border-radius:8px; font-size:14px; cursor:pointer;
        }
        .btn-modal-cancel:hover { background:#e0e0e0; }
        .btn-modal-confirm {
            flex:2; padding:10px;
            border:none; border-radius:8px;
            font-size:14px; font-weight:bold; color:#fff; cursor:pointer;
            transition: opacity 0.2s;
        }
        .btn-modal-confirm:hover { opacity:0.85; }
        .btn-modal-confirm.save   { background: linear-gradient(135deg,#fa709a,#fee140); color:#333; }
        .btn-modal-confirm.delete { background: #dc3545; }

        .footer { text-align:center; color:#ccc; padding:20px; font-size:12px; }
    </style>
</head>
<body>

<!-- ── Navbar ── -->
<div class="navbar">
    <div class="navbar-left">
        <a href="<%= contextPath %>/admin/dashboard.jsp" class="navbar-back">← 返回</a>
        <div class="navbar-title">系统管理</div>
    </div>
    <div class="navbar-role">🔑 Admin</div>
</div>

<!-- ── Tab Bar ── -->
<div class="tab-bar">
    <button class="tab-btn active" onclick="switchTab('applications', this)">📋 申请管理</button>
    <button class="tab-btn"        onclick="switchTab('users',        this)">👥 人员管理</button>
</div>

<!-- ── 申请管理 Tab ── -->
<div id="tab-applications" class="tab-panel active">
    <div class="main">
        <div class="section-header">
            <div class="section-title">全部申请</div>
            <div class="total-badge" id="totalBadge">加载中…</div>
        </div>
        <div id="feed">
            <div class="loading-hint">加载中...</div>
        </div>
    </div>
</div>

<!-- ── 人员管理 Tab ── -->
<div id="tab-users" class="tab-panel">
    <div class="main">
        <div class="placeholder-panel">
            <div class="icon">👥</div>
            <div>人员管理功能尚未实现，敬请期待。</div>
        </div>
    </div>
</div>

<div class="footer">TA Recruitment System | © 2026 Group 50</div>

<!-- ── 确认弹窗 ── -->
<div class="modal-overlay" id="confirmOverlay">
    <div class="modal">
        <div class="modal-icon"  id="confirmIcon"></div>
        <div class="modal-title" id="confirmTitle"></div>
        <div class="modal-desc"  id="confirmDesc"></div>
        <div class="modal-actions">
            <button class="btn-modal-cancel"  onclick="closeConfirm()">取消</button>
            <button class="btn-modal-confirm" id="confirmBtn" onclick="doConfirm()"></button>
        </div>
    </div>
</div>

<script>
    const ADMIN_URL = '<%= contextPath %>/apply/admin';

    /* ── Tab 切换 ── */
    function switchTab(name, el) {
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + name).classList.add('active');
        el.classList.add('active');
    }

    /* ── 确认弹窗 ── */
    let pendingAction = null;   // { type: 'save'|'delete', appId, payload }

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
                    /* 移除卡片 */
                    const card = document.getElementById('card-' + action.appId);
                    if (card) card.remove();
                    updateTotal(-1);
                } else {
                    /* 刷新摘要行 */
                    if (msgEl) msgEl.innerHTML = '<span class="msg-ok">保存成功</span>';
                    refreshCardSummary(action.appId, action.payload);
                }
            } else {
                if (msgEl) msgEl.innerHTML = '<span class="msg-err">' + (data.error || '操作失败') + '</span>';
            }
        } catch (e) {
            if (msgEl) msgEl.innerHTML = '<span class="msg-err">网络错误</span>';
        }
    }

    /* ── Feed ── */
    async function loadFeed() {
        const feed = document.getElementById('feed');
        try {
            const res  = await fetch(ADMIN_URL);
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

            apps.sort((a, b) => b.applyDate.localeCompare(a.applyDate));
            feed.innerHTML = apps.map(renderCard).join('');
        } catch (e) {
            feed.innerHTML = '<div class="empty-hint">加载失败，请刷新页面重试</div>';
        }
    }

    function renderCard(app) {
        const id = esc(app.applicationId);
        return `
        <div class="app-card" id="card-${id}">
            <div class="card-summary" onclick="toggleDetail('${id}')">
                <div class="summary-left">
                    <span class="card-applicant">申请人：${esc(app.applicantId)}</span>
                    <span class="card-job">职位：${esc(app.jobId)}</span>
                    <span class="card-date">📅 ${esc(app.applyDate)}</span>
                    <span class="status-badge status-${esc(app.status)}"
                          id="badge-${id}">${statusLabel(app.status)}</span>
                </div>
                <span class="toggle-icon" id="icon-${id}">▼</span>
            </div>

            <div class="card-detail" id="detail-${id}">
                <div class="edit-grid">
                    <div class="edit-item">
                        <span class="edit-label">申请人 ID</span>
                        <input class="edit-input" id="f-applicantId-${id}"
                               value="${esc(app.applicantId)}" />
                    </div>
                    <div class="edit-item">
                        <span class="edit-label">职位 ID</span>
                        <input class="edit-input" id="f-jobId-${id}"
                               value="${esc(app.jobId)}" />
                    </div>
                    <div class="edit-item">
                        <span class="edit-label">申请日期</span>
                        <input class="edit-input" id="f-applyDate-${id}"
                               value="${esc(app.applyDate)}" placeholder="YYYY-MM-DD" />
                    </div>
                    <div class="edit-item">
                        <span class="edit-label">审核状态</span>
                        <select class="edit-input" id="f-status-${id}">
                            <option value="PENDING"  ${app.status==='PENDING'  ?'selected':''}>审核中 (PENDING)</option>
                            <option value="APPROVED" ${app.status==='APPROVED' ?'selected':''}>已通过 (APPROVED)</option>
                            <option value="REJECTED" ${app.status==='REJECTED' ?'selected':''}>已拒绝 (REJECTED)</option>
                        </select>
                    </div>
                </div>
                <div class="edit-item-full">
                    <span class="edit-label">个人陈述</span>
                    <textarea class="edit-textarea" id="f-ps-${id}">${esc(app.personalStatement)}</textarea>
                </div>
                <div class="card-actions">
                    <button class="btn-save"   id="save-${id}"
                            onclick="askSave('${id}','${esc(app.applicantId)}')">💾 保存修改</button>
                    <button class="btn-delete" id="del-${id}"
                            onclick="askDelete('${id}','${esc(app.applicantId)}','${esc(app.jobId)}')">🗑️ 删除</button>
                </div>
                <div class="card-msg" id="msg-${id}"></div>
            </div>
        </div>`;
    }

    /* 保存确认 */
    function askSave(id, applicantId) {
        const payload = {
            action: 'update',
            applicationId:    id,
            applicantId:      document.getElementById('f-applicantId-' + id).value,
            jobId:            document.getElementById('f-jobId-'       + id).value,
            applyDate:        document.getElementById('f-applyDate-'   + id).value,
            status:           document.getElementById('f-status-'      + id).value,
            personalStatement: document.getElementById('f-ps-'         + id).value
        };
        openConfirm({
            type: 'save', appId: id, payload,
            desc: `申请人：${applicantId}\n新状态：${statusLabel(payload.status)}`
        });
    }

    /* 删除确认 */
    function askDelete(id, applicantId, jobId) {
        openConfirm({
            type: 'delete',
            appId: id,
            payload: { action: 'delete', applicationId: id },
            desc: `申请人：${applicantId}\n职位：${jobId}\n\n此操作不可撤销！`
        });
    }

    /* 保存成功后刷新摘要行徽章 */
    function refreshCardSummary(id, payload) {
        const badge = document.getElementById('badge-' + id);
        if (badge) {
            badge.className   = 'status-badge status-' + payload.status;
            badge.textContent = statusLabel(payload.status);
        }
    }

    /* 删除后更新总数 */
    let currentTotal = 0;
    function updateTotal(delta) {
        currentTotal += delta;
        document.getElementById('totalBadge').textContent = currentTotal + ' 条申请';
    }

    /* ── 展开/收起 ── */
    function toggleDetail(id) {
        const detail = document.getElementById('detail-' + id);
        const icon   = document.getElementById('icon-'   + id);
        if (!detail) return;
        const opening = !detail.classList.contains('open');
        detail.classList.toggle('open');
        if (icon) icon.classList.toggle('open', opening);
    }

    /* ── 工具 ── */
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

    /* 页面初始化 */
    loadFeed().then(() => {
        /* 记录初始总数，供 updateTotal 使用 */
        const badge = document.getElementById('totalBadge');
        const m = badge && badge.textContent.match(/\d+/);
        currentTotal = m ? parseInt(m[0]) : 0;
    });
</script>
</body>
</html>
