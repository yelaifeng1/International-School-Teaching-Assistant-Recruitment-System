<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教学助手招聘系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Microsoft YaHei', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
            color: white;
        }

        /* 网格纹理背景 */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                linear-gradient(rgba(255, 255, 255, 0.05) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 255, 255, 0.05) 1px, transparent 1px);
            background-size: 50px 50px;
            pointer-events: none;
            z-index: 0;
        }

        /* 轻微的渐变叠加 */
        body::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(ellipse at 30% 30%, rgba(255, 255, 255, 0.08) 0%, transparent 50%),
                        radial-gradient(ellipse at 70% 70%, rgba(255, 255, 255, 0.06) 0%, transparent 50%);
            pointer-events: none;
            z-index: 0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }

        /* 导航栏 */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            animation: slideDown 0.8s ease-out;
            position: relative;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 26px;
            font-weight: 700;
            color: white;
            cursor: pointer;
            transition: all 0.3s;
        }

        .logo:hover {
            transform: translateY(-3px);
            filter: drop-shadow(0 6px 12px rgba(0, 0, 0, 0.3));
        }

        .logo-icon {
            font-size: 32px;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .nav-links {
            display: flex;
            gap: 50px;
            align-items: center;
        }

        .nav-links a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s;
            position: relative;
            padding: 8px 0;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: white;
            transition: width 0.3s ease;
        }

        .nav-links a:hover {
            color: white;
        }

        .nav-links a:hover::after {
            width: 100%;
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

        /* 英雄区域 */
        .hero {
            min-height: 600px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            animation: slideUp 1s ease-out;
            position: relative;
            padding: 60px 0;
        }

        .hero-content {
            max-width: 700px;
            position: relative;
            z-index: 1;
        }

        .hero h1 {
            font-size: 62px;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 20px;
            animation: fadeInUp 0.8s ease-out 0.2s backwards;
            letter-spacing: -1px;
        }

        .hero p {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 50px;
            line-height: 1.8;
            animation: fadeInUp 0.8s ease-out 0.4s backwards;
            letter-spacing: 0.3px;
        }

        .cta-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeInUp 0.8s ease-out 0.6s backwards;
        }

        .cta-btn {
            padding: 16px 40px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            font-size: 15px;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }

        .cta-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.2);
            transition: left 0.3s ease;
            z-index: -1;
        }

        .cta-btn:hover::before {
            left: 100%;
        }

        .cta-btn-primary {
            background: white;
            color: #667eea;
        }

        .cta-btn-primary:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.3);
        }

        .cta-btn-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
        }

        .cta-btn-secondary:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-4px);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 统计数据 */
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin: 80px 0;
            padding: 60px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            animation: slideUp 0.8s ease-out 0.3s backwards;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 48px;
            font-weight: 800;
            margin-bottom: 12px;
            font-variant-numeric: tabular-nums;
        }

        .stat-label {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.8);
            font-weight: 600;
        }

        /* 功能卡片 */
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 28px;
            margin: 80px 0;
            padding: 80px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.08);
            padding: 48px 40px;
            border-radius: 16px;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            animation: slideUp 0.8s ease-out backwards;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            backdrop-filter: blur(10px);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, transparent 100%);
            opacity: 0;
            transition: opacity 0.4s ease;
            pointer-events: none;
        }

        .feature-card:nth-child(1) {
            animation-delay: 0.1s;
        }

        .feature-card:nth-child(2) {
            animation-delay: 0.25s;
        }

        .feature-card:nth-child(3) {
            animation-delay: 0.4s;
        }

        .feature-card:hover {
            transform: translateY(-12px) scale(1.02);
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            background: rgba(255, 255, 255, 0.15);
        }

        .feature-card:hover::before {
            opacity: 1;
        }

        .feature-icon {
            font-size: 56px;
            margin-bottom: 24px;
            display: inline-block;
            animation: iconBounce 2s ease-in-out infinite;
            transition: transform 0.3s ease;
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.2) rotate(10deg);
            animation: none;
        }

        @keyframes iconBounce {
            0%, 100% { transform: translateY(0) rotateZ(0deg); }
            25% { transform: translateY(-8px) rotateZ(-5deg); }
            75% { transform: translateY(8px) rotateZ(5deg); }
        }

        .feature-card h3 {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 12px;
            transition: color 0.3s ease;
            position: relative;
        }

        .feature-card p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 15px;
            line-height: 1.8;
            transition: color 0.3s ease;
            position: relative;
        }

        /* 工作流程 */
        .workflow {
            margin: 80px 0;
            padding: 80px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .section-title {
            text-align: center;
            font-size: 36px;
            font-weight: 800;
            margin-bottom: 60px;
            animation: slideUp 0.8s ease-out;
        }

        .workflow-steps {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            position: relative;
        }

        .step-item {
            background: rgba(255, 255, 255, 0.08);
            padding: 40px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            animation: slideUp 0.8s ease-out backwards;
            backdrop-filter: blur(10px);
        }

        .step-item:nth-child(1) {
            animation-delay: 0.1s;
        }

        .step-item:nth-child(2) {
            animation-delay: 0.2s;
        }

        .step-item:nth-child(3) {
            animation-delay: 0.3s;
        }

        .step-item:nth-child(4) {
            animation-delay: 0.4s;
        }

        .step-item:hover {
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
            background: rgba(255, 255, 255, 0.12);
        }

        .step-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-radius: 50%;
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .step-item h4 {
            font-size: 18px;
            color: white;
            margin-bottom: 12px;
        }

        .step-item p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
            line-height: 1.6;
        }

        /* 用户评价 */
        .testimonials {
            margin: 80px 0;
            padding: 80px 0;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 28px;
        }

        .testimonial-card {
            background: rgba(255, 255, 255, 0.08);
            padding: 40px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            animation: slideUp 0.8s ease-out backwards;
            backdrop-filter: blur(10px);
        }

        .testimonial-card:nth-child(1) {
            animation-delay: 0.1s;
        }

        .testimonial-card:nth-child(2) {
            animation-delay: 0.2s;
        }

        .testimonial-card:nth-child(3) {
            animation-delay: 0.3s;
        }

        .testimonial-card:hover {
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
            transform: translateY(-4px);
            background: rgba(255, 255, 255, 0.12);
        }

        .stars {
            color: #fbbf24;
            font-size: 16px;
            margin-bottom: 12px;
        }

        .testimonial-text {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
            line-height: 1.8;
            margin-bottom: 20px;
            font-style: italic;
        }

        .testimonial-author {
            font-weight: 700;
            color: white;
            font-size: 14px;
        }

        .testimonial-role {
            color: rgba(255, 255, 255, 0.6);
            font-size: 13px;
        }

        /* CTA区域 */
        .cta-section {
            margin: 80px 0;
            padding: 60px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideUp 0.8s ease-out;
            backdrop-filter: blur(10px);
        }

        .cta-section h2 {
            font-size: 36px;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .cta-section p {
            font-size: 16px;
            margin-bottom: 30px;
            opacity: 0.9;
        }

        /* 页脚 */
        .footer {
            margin-top: 60px;
            padding: 40px 0 20px;
            text-align: center;
            color: rgba(255, 255, 255, 0.6);
            font-size: 14px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            animation: fadeInUp 0.8s ease-out;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 20px;
            }

            .nav-links {
                gap: 30px;
                flex-direction: column;
            }

            .hero {
                min-height: 400px;
                padding: 40px 0;
            }

            .hero h1 {
                font-size: 40px;
            }

            .hero p {
                font-size: 16px;
            }

            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .cta-btn {
                width: 100%;
                max-width: 280px;
            }

            .stats {
                grid-template-columns: 1fr;
            }

            .features {
                grid-template-columns: 1fr;
            }

            .section-title {
                font-size: 28px;
            }

            .cta-section {
                padding: 40px;
            }

            .cta-section h2 {
                font-size: 28px;
            }
        }

        @media (max-width: 480px) {
            .logo {
                font-size: 20px;
            }

            .hero h1 {
                font-size: 32px;
            }

            .stat-number {
                font-size: 36px;
            }

            .section-title {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 导航栏 -->
    <div class="navbar">
        <div class="logo">
            <span class="logo-icon">🎓</span>
            <span>TA招聘系统</span>
        </div>
        <div class="nav-links">
            <a href="#stats">关于</a>
            <a href="#features">功能</a>
            <a href="#testimonials">用户反馈</a>
        </div>
    </div>

    <!-- 英雄区域 -->
    <div class="hero">
        <div class="hero-content">
            <h1>教学助手招聘系统</h1>
            <p>高效管理教学助手招聘全流程，为学校和申请者搭建最好的沟通桥梁</p>
            
            <div class="cta-buttons">
                <a href="login.jsp" class="cta-btn cta-btn-primary">立即登录</a>
                <a href="register.jsp" class="cta-btn cta-btn-secondary">创建账户</a>
            </div>
        </div>
    </div>

    <!-- 统计数据 -->
    <div class="stats" id="stats">
        <div class="stat-item">
            <div class="stat-number">500+</div>
            <div class="stat-label">学校用户</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">5000+</div>
            <div class="stat-label">成功招聘</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">98%</div>
            <div class="stat-label">满意度</div>
        </div>
    </div>

    <!-- 功能介绍 -->
    <div class="features" id="features">
        <div class="feature-card">
            <div class="feature-icon">📝</div>
            <h3>快速申请</h3>
            <p>简洁高效的申请流程，一键提交您的申请，让您的才能充分展现</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🤖</div>
            <h3>智能管理</h3>
            <p>强大的管理后台，帮助招聘团队高效处理来自全国的申请信息</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📊</div>
            <h3>数据分析</h3>
            <p>完整的数据统计与可视化分析，为招聘决策提供强有力的数据支持</p>
        </div>
    </div>

    <!-- 工作流程 -->
    <div class="workflow">
        <h2 class="section-title">How It Works - 工作流程</h2>
        <div class="workflow-steps">
            <div class="step-item">
                <div class="step-number">1</div>
                <h4>创建账户</h4>
                <p>填写基本信息快速注册，选择您的角色身份</p>
            </div>
            <div class="step-item">
                <div class="step-number">2</div>
                <h4>发布职位</h4>
                <p>管理员发布招聘职位，设置要求和福利待遇</p>
            </div>
            <div class="step-item">
                <div class="step-number">3</div>
                <h4>申请投递</h4>
                <p>申请者浏览职位，提交申请和个人资料</p>
            </div>
            <div class="step-item">
                <div class="step-number">4</div>
                <h4>招聘完成</h4>
                <p>通过系统沟通面试，最终确定录用人选</p>
            </div>
        </div>
    </div>

    <!-- 用户评价 -->
    <div class="testimonials" id="testimonials">
        <h2 class="section-title">用户评价</h2>
        <div class="testimonial-grid">
            <div class="testimonial-card">
                <div class="stars">★★★★★</div>
                <p class="testimonial-text">"这个系统真的太好用了，让我们的招聘效率提升了300%。强烈推荐给其他学校！"</p>
                <div class="testimonial-author">李校长</div>
                <div class="testimonial-role">某国际学校 校长</div>
            </div>
            <div class="testimonial-card">
                <div class="stars">★★★★★</div>
                <p class="testimonial-text">"申请流程简单明了，没有繁琐的步骤。成功拿到offer，非常满意！"</p>
                <div class="testimonial-author">王同学</div>
                <div class="testimonial-role">教学助手 应聘者</div>
            </div>
            <div class="testimonial-card">
                <div class="stars">★★★★★</div>
                <p class="testimonial-text">"数据分析功能特别实用，帮我们找到了最合适的候选人。系统持续更新，服务很贴心。"</p>
                <div class="testimonial-author">张经理</div>
                <div class="testimonial-role">人力资源 负责人</div>
            </div>
        </div>
    </div>

    <!-- CTA区域 -->
    <div class="cta-section">
        <h2>准备好开始了吗？</h2>
        <p>加入数千个已经使用本系统的学校和申请者</p>
        <a href="register.jsp" class="cta-btn cta-btn-primary">立即注册</a>
    </div>

    <!-- 页脚 -->
    <div class="footer">
        <p>&copy; 2026 教学助手招聘系统 | 保留所有权利</p>
    </div>
</div>

<script>
    // 平滑滚动
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
</script>
</body>
</html>
