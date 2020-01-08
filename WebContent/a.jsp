<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="<%=basePath%>js/jquery-3.4.1.min.js"></script>
<script src="<%=basePath%>js/jcanvas.js"></script>
<script src="<%=basePath%>js/base.js"></script>
<%--<link rel="stylesheet" href="<%=basePath%>js/dist/css/layui.css">--%>
 <script src="<%=basePath%>js/dist/layui.js"></script> 
</head>
<body>
<!--<div style="border:solid;border-color:#CCC">-->
<div>
	<canvas id="myCanvas" width="6000" height="500"></canvas>
</div>
<script type="text/javascript">
var array=new Array();
var a1=new Array();
a1.push(1);a1.push(2);
var a2=new Array();
a2.push(13);a2.push(24);
array.push(a1);
array.push(a2);
console.log(array);
</script>
</body>
</html>