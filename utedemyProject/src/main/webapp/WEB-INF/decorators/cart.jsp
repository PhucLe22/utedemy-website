<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unica - Học trực tuyến</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/cartpage.css"> 
</head>
<body>
<script>window.contextPath = '${pageContext.request.contextPath}';</script>
	    <%@ include file="/commons/user/header.jsp"%>
	    <div class="main">
			<!-- Begin content -->
			<sitemesh:write property="body" />
			<!-- End content -->
		</div>
		<%@ include file="/commons/user/footer.jsp"%>
</body>
</html>