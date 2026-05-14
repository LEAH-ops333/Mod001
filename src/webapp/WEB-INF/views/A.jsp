<%--
  Created by IntelliJ IDEA.
  User: LEAH
  Date: 2026/5/14
  Time: 19:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的介绍</title>
    <style>
        body {
            background-image: url("${pageContext.request.contextPath}/IMAGES/1.jpg");
            background-position: center;
            background-size: cover;
            background-attachment: fixed;
            background-repeat: no-repeat;
            margin: 0;
            height: 100vh;
            font-family: Arial, sans-serif;
            color: #333;
        }
        /* 返回按钮样式 */
        .back-button {
            position: fixed;        /* 固定定位，滚动时也可见 */
            top: 20px;
            left: 20px;
            background: rgba(255, 255, 255, 0.5);  /* 白色半透明 */
            backdrop-filter: blur(4px);            /* 可选：背景模糊效果 */
            padding: 10px 18px;
            border-radius: 30px;    /* 圆角方框 */
            text-decoration: none;
            font-family: Arial, sans-serif;
            font-size: 18px;
            font-weight: bold;
            color: #333;
            border: 1px solid rgba(255,255,255,0.3);
            transition: all 0.3s ease;
            z-index: 1000;
        }
        .back-button:hover {
            background: rgba(255, 255, 255, 0.8);
            color: #000;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<a href="${pageContext.request.contextPath}/redirect.jsp?page=home" class="back-button">← 返回</a>
</body>
</html>
