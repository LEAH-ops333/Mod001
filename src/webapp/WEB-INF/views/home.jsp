<%--
  Created by IntelliJ IDEA.
  User: LEAH
  Date: 2026/5/13
  Time: 13:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>My Page</title>
    <style>
        body {
            background-image: url("${pageContext.request.contextPath}/IMAGES/背景.jpg");
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            background-repeat: no-repeat;
            margin: 0;
            height: 100vh;
            font-family: Arial, sans-serif;
            color: #333;
        }

        .pie-container {
            margin-left: 5%;
            margin-top: 1%;
        }

        canvas {
            display: block;
            cursor: pointer;
            border-radius: 50%;
            box-shadow: none;
            filter: none;
        }

        .welcome-title {
            text-align: center;
            margin-top: 20px;
            color: rgba(20, 62, 120, 0.85);
            font-weight: bold;
        }

        .welcome-title h1 {
            font-size: 5rem;
            -webkit-text-stroke: 1.2px rgba(255, 255, 255, 0.65);
            text-stroke: 1.2px rgba(255, 255, 255, 0.65);
            letter-spacing: 1px;
        }

        .sub-title {
            text-align: right;
            margin-top: 45px;
            margin-right: 30px;
            color: rgba(80, 60, 180, 0.85);
            font-weight: bold;
        }

        .sub-title h1 {
            -webkit-text-stroke: 3px rgba(255, 255, 255, 0.7);
            text-stroke: 1.2px rgba(255, 255, 255, 0.7);
            text-shadow: 0 0 1px rgba(255, 255, 255, 0.3);
            letter-spacing: 1px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/home"></a>
</nav>

<div class="welcome-title">
    <h1>Welcome to my page</h1>
</div>

<div class="sub-title">
    <h1>Know about me ^0^</h1>
</div>

<div class="pie-container">
    <canvas id="pieCanvas"></canvas>
</div>

<script>
    (function() {
        const canvas = document.getElementById('pieCanvas');

        const dpr = window.devicePixelRatio || 1;
        let ctx = canvas.getContext('2d');

        // ========== 在这里自定义你的7个分类文字 ==========
        const labels = [
            "我的介绍",      // 第1个扇形
            "兴趣",      // 第2个扇形
            "优势",      // 第3个扇形
            "xxx",      // 第4个扇形
            "xxx"
        ];
        // 如果你需要修改为其他文字，直接修改上面数组即可。
        // 注意：文字长度建议不超过4个中文字，否则可能超出扇形区域。

        const categories = labels.length;
        let radius = 0;
        let centerX = 0, centerY = 0;
        let sectors = [];
        let hoverIndex = -1;
        const offsetDistance = 20;

        // 扇形颜色
        const colors = [
            'rgba(173, 216, 245, 0.85)',  // 淡天蓝 (亮)
            'rgba(118, 184, 225, 0.85)',  // 柔蔚蓝
            'rgba(74, 151, 210, 0.85)',   // 中蓝
            'rgba(44, 123, 185, 0.85)',   // 海蓝
            'rgba(30, 100, 165, 0.85)',   // 深蓝
            'rgba(22, 80, 145, 0.85)',    // 暗蓝
            'rgba(20, 62, 120, 0.85)'     // 暮蓝 (最深)
        ];

        function calcSectors() {
            const angleStep = (Math.PI * 2) / categories;
            sectors = [];
            for (let i = 0; i < categories; i++) {
                sectors.push({
                    start: i * angleStep,
                    end: (i + 1) * angleStep,
                    midAngle: i * angleStep + angleStep / 2,
                    color: colors[i % colors.length],
                    label: labels[i]
                });
            }
        }

        function drawSector(sector, cx, cy, radius, isOffset, offsetDist) {
            ctx.save();
            if (isOffset && offsetDist > 0) {
                const dx = Math.cos(sector.midAngle) * offsetDist;
                const dy = Math.sin(sector.midAngle) * offsetDist;
                ctx.translate(dx, dy);
            }

            // 绘制扇形区域
            ctx.beginPath();
            ctx.moveTo(cx, cy);
            ctx.arc(cx, cy, radius, sector.start, sector.end);
            ctx.closePath();
            ctx.fillStyle = sector.color;
            ctx.fill();
            // 边框统一用半透明白色
            ctx.strokeStyle = "rgba(255, 255, 255, 0.8)";
            ctx.lineWidth = isOffset ? 8 : 10;
            ctx.stroke();

            // 绘制自定义文字
            const textRadius = radius * 0.78;  // 往里收一点，避免字跑出扇形
            const x = cx + Math.cos(sector.midAngle) * textRadius;
            const y = cy + Math.sin(sector.midAngle) * textRadius;

            let fontSize = 40;
            if (sector.label.length > 4) fontSize = 32;

            ctx.font = `bold ${fontSize}px "Segoe UI", Arial`;
            ctx.fillStyle = "#FFFFFF";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(sector.label, x, y);

            ctx.restore();
        }

        function drawPie() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < categories; i++) {
                if (i === hoverIndex) continue;
                drawSector(sectors[i], centerX, centerY, radius, false, 0);
            }
            if (hoverIndex !== -1) {
                drawSector(sectors[hoverIndex], centerX, centerY, radius, true, offsetDistance);
            }
        }

        function getHoverIndex(mouseX, mouseY) {
            const rect = canvas.getBoundingClientRect();
            const scaleX = canvas.width / rect.width;
            const scaleY = canvas.height / rect.height;
            let canvasX = (mouseX - rect.left) * scaleX;
            let canvasY = (mouseY - rect.top) * scaleY;
            const dx = canvasX - centerX;
            const dy = canvasY - centerY;
            const distance = Math.hypot(dx, dy);
            if (distance > radius + 20) return -1;
            let angle = Math.atan2(dy, dx);
            if (angle < 0) angle += 2 * Math.PI;
            for (let i = 0; i < sectors.length; i++) {
                const s = sectors[i];
                if (angle >= s.start && angle < s.end) return i;
            }
            return -1;
        }

        // 关键优化：canvas 实际像素 = CSS 像素（1:1），无 dpr 缩放，性能最大
        function resizeCanvas() {
            const viewportWidth = window.innerWidth;
            const cssDiameter = viewportWidth * 0.38;
            canvas.style.width = cssDiameter + 'px';
            canvas.style.height = cssDiameter + 'px';
            canvas.width = cssDiameter;      // 直接设置成 CSS 像素大小
            canvas.height = cssDiameter;
            // 不需要任何缩放变换
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            centerX = cssDiameter / 2;
            centerY = cssDiameter / 2;
            radius = cssDiameter / 2 - 5;
            calcSectors();
            drawPie();
        }

        // 节流 + 异步重绘
        let pendingRedraw = false;
        let lastMoveTime = 0;
        const THROTTLE_MS = 16; // 约 60fps

        function onMouseMove(e) {
            const now = Date.now();
            if (now - lastMoveTime < THROTTLE_MS) return;
            lastMoveTime = now;

            const newIndex = getHoverIndex(e.clientX, e.clientY);
            if (newIndex !== hoverIndex) {
                hoverIndex = newIndex;
                if (!pendingRedraw) {
                    pendingRedraw = true;
                    requestAnimationFrame(() => {
                        drawPie();
                        pendingRedraw = false;
                    });
                }
            }
        }

        function onMouseLeave() {
            if (hoverIndex !== -1) {
                hoverIndex = -1;
                if (!pendingRedraw) {
                    pendingRedraw = true;
                    requestAnimationFrame(() => {
                        drawPie();
                        pendingRedraw = false;
                    });
                }
            }
        }

        function init() {
            resizeCanvas();
            window.addEventListener('resize', () => resizeCanvas());
            canvas.addEventListener('mousemove', onMouseMove);
            canvas.addEventListener('mouseleave', onMouseLeave);
        }

        init();
    })();
</script>
</body>
</html>