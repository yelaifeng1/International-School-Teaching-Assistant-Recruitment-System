<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"TA".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String displayName = (String) session.getAttribute("displayName");
    String applicantId = (String) session.getAttribute("username");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>我的申请 — TA</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Microsoft YaHei", "Segoe UI", Tahoma, sans-serif;
            background: #f0f2f8;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── Navbar ── */
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 0 30px;
            height: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 12px rgba(102,126,234,0.4);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar-left { display: flex; align-items: center; gap: 18px; }
        .navbar-title { font-size: 18px; font-weight: bold; }
        .navbar-back {
            background: rgba(255,255,255,0.18);
            color: #fff;
            border: none;
            padding: 6px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            text-decoration: none;
        }
        .navbar-back:hover { background: rgba(255,255,255,0.3); }

        .btn-submit-top {
            background: #fff;
            color: #667eea;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transition: all 0.2s;
        }
        .btn-submit-top:hover {
            background: #f0f0ff;
            box-shadow: 0 4px 16px rgba(102,126,234,0.35);
            transform: translateY(-1px);
        }

        /* ── Main content ── */
        .main { flex: 1; max-width: 760px; margin: 32px auto; padding: 0 16px; width: 100%; }

        .section-title {
            font-size: 20px;
            font-weight: bold;
            color: #334;
            margin-bottom: 20px;
        }

        /* ── Feed cards ── */
        #feed { display: flex; flex-direction: column; gap: 14px; }

        .app-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 20px 24px;
            cursor: pointer;
            transition: box-shadow 0.2s, transform 0.2s;
            border-left: 4px solid #667eea;
        }
        .app-card:hover {
            box-shadow: 0 6px 20px rgba(102,126,234,0.2);
            transform: translateY(-2px);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-job { font-size: 16px; font-weight: bold; color: #333; }
        .card-date { font-size: 12px; color: #aaa; }

        .status-badge {
            display: inline-block;
            padding: 3px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            margin-top: 8px;
        }
        .status-PENDING  { background: #fff3cd; color: #856404; }
        .status-APPROVED { background: #d4edda; color: #155724; }
        .status-REJECTED { background: #f8d7da; color: #721c24; }

        .card-detail {
            display: none;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px solid #eee;
            font-size: 14px;
            color: #555;
            line-height: 1.7;
        }
        .card-detail.open { display: block; }

        .detail-label { color: #999; font-size: 12px; margin-top: 10px; }
        .detail-value { color: #333; font-weight: 500; }

        .empty-hint {
            text-align: center;
            color: #bbb;
            padding: 60px 0;
            font-size: 15px;
        }

        .loading-hint {
            text-align: center;
            color: #aaa;
            padding: 40px 0;
            font-size: 14px;
        }

        /* ── Modal overlay ── */
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
            border-radius: 16px;
            box-shadow: 0 24px 80px rgba(0,0,0,0.3);
            padding: 36px 40px;
            width: 100%;
            max-width: 480px;
            animation: modalIn 0.25s ease-out;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.94) translateY(16px); }
            to   { opacity: 1; transform: scale(1)    translateY(0); }
        }

        .modal-title { font-size: 20px; font-weight: bold; color: #333; margin-bottom: 24px; }

        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: 13px;
            color: #666;
            margin-bottom: 6px;
            font-weight: 500;
        }
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.2s;
            outline: none;
        }
        .form-group input:focus,
        .form-group textarea:focus { border-color: #667eea; }
        .form-group textarea { resize: vertical; min-height: 100px; }

        .form-readonly {
            background: #f8f9fa;
            color: #888;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 14px;
            border: 1.5px solid #eee;
        }

        .modal-actions { display: flex; gap: 12px; margin-top: 24px; }
        .btn-cancel {
            flex: 1;
            padding: 10px;
            background: #f0f0f0;
            color: #666;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            cursor: pointer;
        }
        .btn-cancel:hover { background: #e0e0e0; }

        .btn-confirm {
            flex: 2;
            padding: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn-confirm:hover { opacity: 0.88; }
        .btn-confirm:disabled { opacity: 0.5; cursor: not-allowed; }

        .msg-error { color: #dc3545; font-size: 13px; margin-top: 8px; text-align: center; }
        .msg-success { color: #28a745; font-size: 13px; margin-top: 8px; text-align: center; }

        .footer {
            text-align: center;
            color: #bbb;
            padding: 20px;
            font-size: 12px;
        }
    </style>
</head>
<body>

<!-- ── Navbar ── -->
<div class="navbar">
    <div class="navbar-left">
        <a href="<%= contextPath %>/applicant/dashboard.jsp" class="navbar-back">← 返回</a>
        <div class="navbar-title">我的申请</div>
    </div>
    <button class="btn-submit-top" onclick="openModal()">+ 提交新申请</button>
</div>

<!-- ── Feed ── -->
<div class="main">
    <div class="section-title">申请记录</div>
    <div id="feed">
        <div class="loading-hint" id="loading">加载中...</div>
    </div>
</div>

<div class="footer">TA Recruitment System | © 2026 Group 50</div>

<!-- ── 提交申请弹窗 ── -->
<div class="modal-overlay" id="modalOverlay" onclick="handleOverlayClick(event)">
    <div class="modal">
        <div class="modal-title">提交 TA 申请</div>

        <div class="form-group">
            <label>申请人 ID（自动填充）</label>
            <div class="form-readonly"><%= applicantId %></div>
        </div>

        <div class="form-group">
            <label>申请日期（自动填充）</label>
            <div class="form-readonly" id="displayDate"></div>
        </div>

        <div class="form-group">
            <label for="jobId">职位 ID <span style="color:#dc3545">*</span></label>
            <input type="text" id="jobId" placeholder="例如：CS101-TA" maxlength="100" />
        </div>

        <div class="form-group">
            <label for="personalStatement">个人陈述 <span style="color:#dc3545">*</span></label>
            <textarea id="personalStatement" placeholder="请简要描述你的相关经历与申请理由…"></textarea>
        </div>

        <div class="form-group">
            <label>申请状态（自动设置）</label>
            <div class="form-readonly">PENDING</div>
        </div>

        <div id="formMsg"></div>

        <div class="modal-actions">
            <button class="btn-cancel" onclick="closeModal()">取消</button>
            <button class="btn-confirm" id="submitBtn" onclick="submitApplication()">提交申请</button>
        </div>
    </div>
</div>

<script>
    const API_URL = '<%= contextPath %>/apply/applications';

    /* ── 日期工具 ── */
    function today() {
        return new Date().toISOString().slice(0, 10);
    }

    /* ── Modal 控制 ── */
    function openModal() {
        document.getElementById('displayDate').textContent = today();
        document.getElementById('jobId').value = '';
        document.getElementById('personalStatement').value = '';
        document.getElementById('formMsg').innerHTML = '';
        document.getElementById('submitBtn').disabled = false;
        document.getElementById('modalOverlay').classList.add('open');
    }

    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('open');
    }

    function handleOverlayClick(e) {
        if (e.target === document.getElementById('modalOverlay')) closeModal();
    }

    /* ── 提交申请 ── */
    async function submitApplication() {
        const jobId = document.getElementById('jobId').value.trim();
        const personalStatement = document.getElementById('personalStatement').value.trim();
        const msgEl = document.getElementById('formMsg');
        const btn = document.getElementById('submitBtn');

        if (!jobId) {
            msgEl.innerHTML = '<div class="msg-error">请填写职位 ID</div>';
            return;
        }
        if (!personalStatement) {
            msgEl.innerHTML = '<div class="msg-error">请填写个人陈述</div>';
            return;
        }

        btn.disabled = true;
        msgEl.innerHTML = '';

        try {
            const body = new URLSearchParams({ jobId, personalStatement });
            const res = await fetch(API_URL, { method: 'POST', body });
            const data = await res.json();

            if (data.success) {
                msgEl.innerHTML = '<div class="msg-success">提交成功！</div>';
                setTimeout(() => {
                    closeModal();
                    loadFeed();
                }, 800);
            } else {
                msgEl.innerHTML = '<div class="msg-error">' + (data.error || '提交失败，请重试') + '</div>';
                btn.disabled = false;
            }
        } catch (e) {
            msgEl.innerHTML = '<div class="msg-error">网络错误，请重试</div>';
            btn.disabled = false;
        }
    }

    /* ── Feed 加载 ── */
    async function loadFeed() {
        const feed = document.getElementById('feed');
        feed.innerHTML = '<div class="loading-hint">加载中...</div>';

        try {
            const res = await fetch(API_URL);
            if (!res.ok) { feed.innerHTML = '<div class="empty-hint">无法加载申请记录</div>'; return; }

            const apps = await res.json();
            if (apps.length === 0) {
                feed.innerHTML = '<div class="empty-hint">暂无申请记录，点击上方按钮提交第一份申请</div>';
                return;
            }

            /* 按提交日期倒序 */
            apps.sort((a, b) => b.applyDate.localeCompare(a.applyDate));

            feed.innerHTML = apps.map(app => `
                <div class="app-card" onclick="toggleDetail('${app.applicationId}')">
                    <div class="card-header">
                        <div class="card-job">职位：${escHtml(app.jobId)}</div>
                        <div class="card-date">${escHtml(app.applyDate)}</div>
                    </div>
                    <span class="status-badge status-${escHtml(app.status)}">${statusLabel(app.status)}</span>
                    <div class="card-detail" id="detail-${app.applicationId}">
                        <div class="detail-label">申请 ID</div>
                        <div class="detail-value">${escHtml(app.applicationId)}</div>
                        <div class="detail-label">申请人 ID</div>
                        <div class="detail-value">${escHtml(app.applicantId)}</div>
                        <div class="detail-label">个人陈述</div>
                        <div class="detail-value" style="white-space:pre-wrap;">${escHtml(app.personalStatement)}</div>
                    </div>
                </div>
            `).join('');
        } catch (e) {
            feed.innerHTML = '<div class="empty-hint">加载失败，请刷新页面重试</div>';
        }
    }

    function toggleDetail(id) {
        const el = document.getElementById('detail-' + id);
        if (el) el.classList.toggle('open');
    }

    function statusLabel(status) {
        const map = { PENDING: '审核中', APPROVED: '已通过', REJECTED: '已拒绝' };
        return map[status] || status;
    }

    function escHtml(str) {
        if (!str) return '';
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    /* 页面加载时自动拉取 */
    loadFeed();
</script>
</body>
</html>
