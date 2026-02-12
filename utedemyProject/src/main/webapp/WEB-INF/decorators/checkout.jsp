<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unica - Thanh Toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/checkout.css">
    <style>
        /* Thêm CSS cho hiển thị loại giảm giá */
        .discount-type {
            font-size: 0.9em;
            font-style: italic;
            color: #f26522;
        }
         /* Thêm CSS cho nút hủy đơn hàng */
        .btn-cancel-order {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 15px;
            width: 100%;
            transition: background-color 0.3s;
        }
        
        .btn-cancel-order:hover {
            background-color: #c82333;
        }
        
        .confirm-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border-radius: 5px;
            width: 400px;
            text-align: center;
        }
        
        .modal-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        
        .modal-buttons button {
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .btn-confirm {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-cancel {
            background-color: #6c757d;
            color: white;
        }
    </style>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/homepage.css">
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