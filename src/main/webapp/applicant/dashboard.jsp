<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // 检查用户是否已登录
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Boolean registrationSuccess = (Boolean) session.getAttribute("registrationSuccess");

    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String applicantId = username; // 用 username 作为申请人 ID

    // 清除注册成功标记（只显示一次）
    session.removeAttribute("registrationSuccess");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教学助手招聘系统 - 仪表板</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Microsoft YaHei", 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

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

        .navbar h2 {
            color: #333;
            font-size: 24px;
            margin: 0;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            color: #666;
            font-size: 14px;
        }

        .user-info strong {
            color: #333;
        }

        .logout-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        }

        .welcome-section {
            text-align: center;
            margin-bottom: 40px;
        }

        .welcome-section h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .welcome-section p {
            color: #666;
            font-size: 16px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }

        .info-card h3 {
            font-size: 14px;
            opacity: 0.8;
            margin-bottom: 10px;
        }

        .info-card p {
            font-size: 18px;
            font-weight: 600;
        }

        .success-alert {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            animation: slideDown 0.4s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ══════════════════════════════════════════
           申请记录区域 — 从 my-applications 迁移过来
           ══════════════════════════════════════════ */
        .applications-section {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 20px;
            font-weight: bold;
            color: #334;
        }

        .btn-submit-top {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            padding: 10px 24px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transition: all 0.2s;
        }
        .btn-submit-top:hover {
            opacity: 0.88;
            box-shadow: 0 4px 16px rgba(102,126,234,0.35);
            transform: translateY(-1px);
        }

        /* ── Feed cards ── */
        #feed {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .app-card {
            background: #fafbff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            padding: 20px 24px;
            cursor: pointer;
            transition: box-shadow 0.2s, transform 0.2s;
            border-left: 4px solid #667eea;
        }
        .app-card:hover {
            box-shadow: 0 6px 20px rgba(102,126,234,0.18);
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

        .msg-error   { color: #dc3545; font-size: 13px; margin-top: 8px; text-align: center; }
        .msg-success { color: #28a745; font-size: 13px; margin-top: 8px; text-align: center; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>😊 教学助手仪表板</h2>
        <div class="navbar-right">
            <div class="user-info">
                欢迎 <strong><%= username %></strong> | 角色: <strong>教学助手</strong>
            </div>
            <form action="<%= contextPath %>/logout" method="get" style="margin: 0;">
                <button type="submit" class="logout-btn">退出登录</button>
            </form>
        </div>
    </div>

    <div class="container">
        <% if (registrationSuccess != null && registrationSuccess) { %>
            <div class="success-alert">
                ✅ 恭喜！注册成功！现在您已自动登录。
            </div>
        <% } %>

        <div class="welcome-section">
            <h1>欢迎回来，<%= username %>！</h1>
            <p>这是您的个人仪表板，管理您的申请和档案。</p>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h3>我的申请</h3>
                <p id="statCount">--</p>
            </div>
            <div class="info-card">
                <h3>申请状态</h3>
                <p id="statStatus">待审核</p>
            </div>
            <div class="info-card">
                <h3>消息通知</h3>
                <p>0</p>
            </div>
        </div>

        <!-- ══════════════════════════════════════
             申请记录区域（从 my-applications 迁移）
             ══════════════════════════════════════ -->
        <div class="applications-section">
            <div class="section-header">
                <div class="section-title">📋 申请记录</div>
                <button class="btn-submit-top" onclick="openModal()">+ 提交新申请</button>
            </div>
            <div id="feed">
                <div class="loading-hint" id="loading">加载中...</div>
            </div>
        </div>
    </div>

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
                if (!res.ok) {
                    feed.innerHTML = '<div class="empty-hint">无法加载申请记录</div>';
                    return;
                }

                const apps = await res.json();

                /* 更新顶部统计卡片 */
                document.getElementById('statCount').textContent = apps.length;
                if (apps.length > 0) {
                    const pending  = apps.filter(a => a.status === 'PENDING').length;
                    const approved = apps.filter(a => a.status === 'APPROVED').length;
                    const rejected = apps.filter(a => a.status === 'REJECTED').length;
                    const parts = [];
                    if (pending)  parts.push('审核中 ' + pending);
                    if (approved) parts.push('已通过 ' + approved);
                    if (rejected) parts.push('已拒绝 ' + rejected);
                    document.getElementById('statStatus').textContent = parts.join(' / ') || '无';
                } else {
                    document.getElementById('statStatus').textContent = '暂无申请';
                }

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