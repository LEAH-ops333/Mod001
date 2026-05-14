<%--
  Created by IntelliJ IDEA.
  User: LEAH
  Date: 2026/5/14
  Time: 20:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String pageName = request.getParameter("page");
    if (pageName != null && !pageName.isEmpty()) {
        // 可选：增加白名单校验，防止恶意访问
        String[] allowed = {"home","A", "B", "C", "D", "E", "F"};
        boolean valid = false;
        for (String a : allowed) {
            if (a.equals(pageName)) { valid = true; break; }
        }
        if (valid) {
            request.getRequestDispatcher("/WEB-INF/views/" + pageName + ".jsp").forward(request, response);
            return;
        }
    }
    response.sendError(HttpServletResponse.SC_NOT_FOUND);
%>
