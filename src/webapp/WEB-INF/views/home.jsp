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

        /* 饼图容器：左对齐，无背景 */
        .pie-container {
            margin-left: 5%;
            margin-top: 40px;
        }

        canvas {
            display: block;
            cursor: pointer;
            filter: drop-shadow(0 4px 12px rgba(0,0,0,0.3));
            transition: filter 0.2s;
            border-radius: 50%;
        }

        canvas:hover {
            filter: drop-shadow(0 8px 20px rgba(0,0,0,0.4));
        }

        .welcome-title {
            text-align: center;
            margin-top: 20px;
            color: white;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">我的主页</a>
    </div>
</nav>

<div class="welcome-title">
    <h1>欢迎来到我的个人主页</h1>
</div>

<div class="pie-container">
    <canvas id="pieCanvas"></canvas>
</div>

<script>
    (function() {
        const canvas = document.getElementById('pieCanvas');
        let ctx = canvas.getContext('2d');

        let categories = 7;
        let radius = 0;
        let centerX = 0, centerY = 0;
        let sectors = [];
        let hoverIndex = -1;
        let offsetDistance = 20;

        const imageBase = "${pageContext.request.contextPath}/IMAGES/";
        let images = [];
        let imagesLoaded = 0;

        function loadImages(callback) {
            for (let i = 1; i <= categories; i++) {
                let img = new Image();
                img.src = imageBase + i + ".jpg";
                img.onload = () => {
                    imagesLoaded++;
                    if (imagesLoaded === categories) callback();
                };
                img.onerror = () => {
                    console.warn("图片加载失败: " + (imageBase + i + ".jpg"));
                    imagesLoaded++;
                    if (imagesLoaded === categories) callback();
                };
                images.push(img);
            }
        }

        function calcSectors() {
            const angleStep = (Math.PI * 2) / categories;
            sectors = [];
            for (let i = 0; i < categories; i++) {
                sectors.push({
                    start: i * angleStep,
                    end: (i + 1) * angleStep
                });
            }
        }

        // 绘制扇形（图片覆盖整个圆，通过裁剪实现扇形区域填充）
        function drawSectorWithImage(img, cx, cy, radius, startAngle, endAngle, isOffset, offsetDist) {
            ctx.save();
            if (isOffset && offsetDist > 0) {
                const mid = (startAngle + endAngle) / 2;
                const dx = Math.cos(mid) * offsetDist;
                const dy = Math.sin(mid) * offsetDist;
                ctx.translate(dx, dy);
            }
            // 裁剪为扇形区域
            ctx.beginPath();
            ctx.moveTo(cx, cy);
            ctx.arc(cx, cy, radius, startAngle, endAngle);
            ctx.closePath();
            ctx.clip();

            // 图片覆盖整个圆（cover 效果，图片可能被裁剪但填满扇形）
            ctx.drawImage(img, cx - radius, cy - radius, radius * 2, radius * 2);

            ctx.restore();

            // 绘制扇形边框（增强边界）
            ctx.save();
            if (isOffset && offsetDist > 0) {
                const mid = (startAngle + endAngle) / 2;
                const dx = Math.cos(mid) * offsetDist;
                const dy = Math.sin(mid) * offsetDist;
                ctx.translate(dx, dy);
            }
            ctx.beginPath();
            ctx.moveTo(cx, cy);
            ctx.arc(cx, cy, radius, startAngle, endAngle);
            ctx.closePath();
            ctx.strokeStyle = "rgba(255,255,255,0.8)";
            ctx.lineWidth = 2;
            ctx.stroke();
            ctx.restore();
        }

        function drawPie() {
            if (imagesLoaded < categories) return;
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            // 先绘制非高亮扇区
            for (let i = 0; i < categories; i++) {
                if (i === hoverIndex) continue;
                const s = sectors[i];
                drawSectorWithImage(images[i], centerX, centerY, radius, s.start, s.end, false, 0);
            }
            // 最后绘制高亮扇区（使其在上层，带偏移）
            if (hoverIndex !== -1) {
                const s = sectors[hoverIndex];
                drawSectorWithImage(images[hoverIndex], centerX, centerY, radius, s.start, s.end, true, offsetDistance);
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

        function resizeCanvas() {
            const viewportWidth = window.innerWidth;
            const diameter = viewportWidth * 0.38;
            canvas.width = diameter;
            canvas.height = diameter;
            canvas.style.width = diameter + 'px';
            canvas.style.height = diameter + 'px';
            centerX = diameter / 2;
            centerY = diameter / 2;
            radius = diameter / 2 - 5;
            calcSectors();
            drawPie();
        }

        function onMouseMove(e) {
            const newIndex = getHoverIndex(e.clientX, e.clientY);
            if (newIndex !== hoverIndex) {
                hoverIndex = newIndex;
                drawPie();
            }
        }

        function onMouseLeave() {
            if (hoverIndex !== -1) {
                hoverIndex = -1;
                drawPie();
            }
        }

        function init() {
            calcSectors();
            loadImages(() => {
                resizeCanvas();
                window.addEventListener('resize', () => {
                    resizeCanvas();
                });
                canvas.addEventListener('mousemove', onMouseMove);
                canvas.addEventListener('mouseleave', onMouseLeave);
            });
        }

        init();
    })();
</script>
</body>
</html>