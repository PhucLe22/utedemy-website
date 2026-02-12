<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<title>Bảng điều khiển khóa học trực tuyến</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        
        body {
            background-color: #f5f5f5;
        }
        
        .header {
            background-color: #003552;
            color: white;
            padding: 60px 200px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .instructor-info {
            display: flex;
            flex-direction: column;
        }
        
        .instructor-name {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .instructor-id {
            font-size: 14px;
            color: #cccccc;
        }
        
        .support-info {
            text-align: left;
            line-height: 1.6;
        }
        
        .support-info p {
            font-size: 14px;
        }
        
        .content {
            padding: 40px 200px;
        }
        
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .content-title {
            font-size: 24px;
            font-weight: bold;
        }
        
        body {
            background-color: #f0f2f5;
        }
        
        .header {
            background-color: #003057;
            color: white;
            padding: 20px;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: normal;
        }
        
        .header p {
            font-size: 14px;
            margin-top: 5px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .warning {
            color: #e74c3c;
            margin-bottom: 20px;
            font-size: 14px;
            margin-left: 280px;
        }
        
        .form-title {
            font-weight: bold;
            margin-bottom: 20px;
            font-size: 18px;
        }
        
        .form-group {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        
        .form-control {
            flex: 1;
            margin-right: 20px;
            margin-bottom: 15px;
            min-width: 300px;
        }
        
        .form-control:last-child {
            margin-right: 0;
        }
        
        .form-control label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-control label .required {
            color: red;
        }
        
        .form-control input[type="text"],
        .form-control input[type="tel"],
        .form-control input[type="date"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .help-text {
            font-style: italic;
            font-size: 13px;
            margin-top: 5px;
            color: #555;
        }
        
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-primary {
            background-color: #0066cc;
            color: white;
            border: none;
        }
        
        .btn-secondary {
            background-color: #e6e6e6;
            color: #333;
            border: 1px solid #ccc;
        }
        
        .upload-area {
            border: 1px dashed #ccc;
            padding: 50px 20px;
            text-align: center;
            margin-top: 5px;
            cursor: pointer;
            background-color: #f9f9f9;
        }
        
        .upload-area i {
            display: block;
            font-size: 24px;
            margin-bottom: 10px;
            color: #999;
        }
        
        .upload-text {
            font-size: 13px;
            color: #777;
        }
        
        .upload-format {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        .save-btn {
            background-color: #0066cc;
            color: white;
            border: none;
            padding: 8px 30px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            margin-left: 500px;
        }
        
        .save-btn i {
            margin-right: 5px;
        }
        
        .form-control {
	    margin-bottom: 20px;
	}
	
	.form-control label {
	    display: block;
	    margin-bottom: 8px;
	    font-weight: 500;
	    font-size: 14px;
	}
	
	.form-control .required {
	    color: #e74c3c;
	    margin-left: 2px;
	}
	
	.upload-container {
	    border: 1px solid #ddd;
	    border-radius: 6px;
	    overflow: hidden;
	    background-color: #f9f9f9;
	    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
	}
	
	.upload-preview-area {
	    padding: 10px;
	    background-color: #fff;
	    border-bottom: 1px solid #eee;
	}
	
	.image-preview {
	    position: relative;
	    width: 100%;
	    height: 200px;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    background-color: #f0f2f5;
	    border-radius: 4px;
	    overflow: hidden;
	}
	
	.image-preview img {
	    max-width: 100%;
	    max-height: 100%;
	    object-fit: contain;
	}
	
	.placeholder-text {
	    position: absolute;
	    top: 0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    color: #999;
	    background-color: #f0f2f5;
	}
	
	.upload-icon {
	    font-size: 32px;
	    margin-bottom: 10px;
	    color: #aaa;
	}
	
	.upload-controls {
	    padding: 12px;
	    display: flex;
	    justify-content: center;
	    background-color: #f9f9f9;
	}
	
	.upload-button {
	    background-color: #0066cc;
	    color: white;
	    border: none;
	    border-radius: 4px;
	    padding: 8px 16px;
	    font-size: 14px;
	    cursor: pointer;
	    display: flex;
	    align-items: center;
	    transition: background-color 0.2s;
	}
	
	.upload-button:hover {
	    background-color: #0055aa;
	}
	
	.upload-btn-icon {
	    margin-right: 6px;
	}
	.description-section {
    background-color: #f8f9fa;
    border-radius: 8px;
    padding: 15px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    border-left: 4px solid #3498db;
}
.description-label {
    font-weight: 600;
    color: #2c3e50;
    font-size: 16px;
    margin-bottom: 10px;
    display: block;
}
.description-container {
    position: relative;
    margin-bottom: 10px;
}
.enhanced-textarea {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 15px;
    transition: border 0.3s, box-shadow 0.3s;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    resize: vertical;
}
.enhanced-textarea:focus {
    border-color: #3498db;
    box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
    outline: none;
}
.enhanced-textarea::placeholder {
    color: #95a5a6;
    font-style: italic;
}
.character-counter {
    position: absolute;
    bottom: 10px;
    right: 10px;
    font-size: 12px;
    color: #7f8c8d;
    background-color: rgba(255, 255, 255, 0.8);
    padding: 2px 8px;
    border-radius: 10px;
}
.help-text-container {
    margin-top: 8px;
    padding-left: 2px;
}
.help-text {
    color: #7f8c8d;
    font-size: 13px;
    margin-bottom: 4px;
    display: flex;
    align-items: center;
}
.suggestion-text {
    color: #16a085;
    font-size: 13px;
    font-style: italic;
    margin-top: 5px;
}
.info-icon {
    margin-right: 5px;
    font-size: 14px;
}
.required {
    color: #e74c3c;
    margin-left: 2px;
}
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/Css/contract.css">

</head>
<body>
<script>window.contextPath = '${pageContext.request.contextPath}';</script>

	<%@ include file="/commons/user/header.jsp"%>
	<header class="header">
        <div class="instructor-info">
            <div class="instructor-name">Đăng ký trở thành giảng viên</div>
        </div>
    </header>
	<div class="container">
		<div class="main-content">
			<sitemesh:write property="body" />
		</div>
	</div>

</body>
</html>