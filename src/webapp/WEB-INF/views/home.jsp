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
            display: flex;
            align-items: center;
            gap: 300px;
            margin-left: 5%;
            margin-top: 10px;
        }
        .selfie {
            width: 450px;
            height: auto;
            border-radius: 20px;
        }

        canvas {
            display: block;
            cursor: pointer;
            border-radius: 50%;
            box-shadow: none;
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
        }
    </style>
</head>
<body>

<div class="welcome-title">
    <h1>Welcome to my page</h1>
</div>
<div class="sub-title">
    <h1>Know about me ^0^</h1>
</div>
<div class="pie-container">
    <canvas id="pieCanvas" style="width:550px; height:550px;"></canvas>
    <img src="${pageContext.request.contextPath}/IMAGES/AA.png" class="selfie">
</div>

<script>
    (function() {
        // 等待 DOM 完全加载后再执行绘制，避免 canvas 未就绪
        window.addEventListener('DOMContentLoaded', function() {
            initPie();
        });

        function initPie() {
            var canvas = document.getElementById('pieCanvas');
            if (!canvas) {
                console.error("canvas 元素不存在");
                return;
            }
            var ctx = canvas.getContext('2d');
            canvas.width = 650;
            canvas.height = 650;

            // 饼图数据
            var labels = ["我的介绍", "兴趣", "优势", "陈述", "xxx", "xxxxx"];
            var colors = [
                'rgba(173, 216, 245, 0.85)', 'rgba(118, 184, 225, 0.85)',
                'rgba(74, 151, 210, 0.85)', 'rgba(44, 123, 185, 0.85)',
                'rgba(30, 100, 165, 0.85)', "rgba(15, 89, 145, 0.85)"
            ];
            var categories = labels.length;
            var centerX = 325, centerY = 325;
            var radius = 305;
            var offsetDistance = 20;
            var hoverIndex = -1;

            // 可调节字号系数（建议 0.5 ~ 0.8）
            var FONT_SCALE = 0.15;

            // 生成扇形数据
            var sectors = [];
            var angleStep = (Math.PI * 2) / categories;
            for (var i = 0; i < categories; i++) {
                sectors.push({
                    start: i * angleStep,
                    end: (i + 1) * angleStep,
                    midAngle: i * angleStep + angleStep / 2,
                    color: colors[i % colors.length],
                    label: labels[i]
                });
            }

            // 绘制单个扇形
            function drawSector(sector, cx, cy, radius, isOffset, offsetDist) {
                ctx.save();
                if (isOffset && offsetDist > 0) {
                    var dx = Math.cos(sector.midAngle) * offsetDist;
                    var dy = Math.sin(sector.midAngle) * offsetDist;
                    ctx.translate(dx, dy);
                }
                ctx.beginPath();
                ctx.moveTo(cx, cy);
                ctx.arc(cx, cy, radius, sector.start, sector.end);
                ctx.closePath();
                ctx.fillStyle = sector.color;
                ctx.fill();
                ctx.strokeStyle = "rgba(255, 255, 255, 0.8)";
                ctx.lineWidth = isOffset ? 8 : 10;
                ctx.stroke();

                var textRadius = radius * 0.70;
                var x = cx + Math.cos(sector.midAngle) * textRadius;
                var y = cy + Math.sin(sector.midAngle) * textRadius;
                var fontSize = radius * FONT_SCALE;
                fontSize = Math.max(20, fontSize);
                ctx.font = "bold " + fontSize + 'px "Segoe UI", Arial, sans-serif';
                ctx.fillStyle = "#FFFFFF";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillText(sector.label, x, y);
                ctx.restore();
            }

            // 绘制全部
            function drawPie() {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                for (var i = 0; i < categories; i++) {
                    if (i === hoverIndex) continue;
                    drawSector(sectors[i], centerX, centerY, radius, false, 0);
                }
                if (hoverIndex !== -1) {
                    drawSector(sectors[hoverIndex], centerX, centerY, radius, true, offsetDistance);
                }
            }

            // 获取悬停扇形索引
            function getHoverIndex(mouseX, mouseY) {
                var rect = canvas.getBoundingClientRect();
                var scaleX = canvas.width / rect.width;
                var scaleY = canvas.height / rect.height;
                var canvasX = (mouseX - rect.left) * scaleX;
                var canvasY = (mouseY - rect.top) * scaleY;
                var dx = canvasX - centerX, dy = canvasY - centerY;
                if (Math.hypot(dx, dy) > radius + 20) return -1;
                var angle = Math.atan2(dy, dx);
                if (angle < 0) angle += 2 * Math.PI;
                for (var i = 0; i < sectors.length; i++) {
                    if (angle >= sectors[i].start && angle < sectors[i].end) return i;
                }
                return -1;
            }

            // 绑定鼠标事件
            canvas.addEventListener('mousemove', function(e) {
                var idx = getHoverIndex(e.clientX, e.clientY);
                if (idx !== hoverIndex) {
                    hoverIndex = idx;
                    drawPie();
                }
            });
            canvas.addEventListener('mouseleave', function() {
                hoverIndex = -1;
                drawPie();
            });

            drawPie();
            var pageUrls = [
                "${pageContext.request.contextPath}/redirect.jsp?page=A",
                "${pageContext.request.contextPath}/redirect.jsp?page=B",
                "${pageContext.request.contextPath}/redirect.jsp?page=C",
                "${pageContext.request.contextPath}/redirect.jsp?page=D",
                "${pageContext.request.contextPath}/redirect.jsp?page=E",
                "${pageContext.request.contextPath}/redirect.jsp?page=F"
            ];

// 添加点击事件
            canvas.addEventListener('click', function(e) {
                var idx = getHoverIndex(e.clientX, e.clientY);
                if (idx !== -1 && pageUrls[idx]) {
                    window.location.href = pageUrls[idx];
                }
            });
        }
    })();

</script>
</body>
</html>