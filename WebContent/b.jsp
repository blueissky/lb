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
<script type="text/javascript">
	var arry1=new Array();
	var arry2=new Array();
	
	for(var i=0;i<10;i++){
		arry1.push(i);
	}
	for(var i=7;i<10;i++){
		arry2.push(i);
	}
	
	function compareArray(arry1,arry2){
		//对比判断交集	
		for(var j=0;j<arry1.length;j++){
			for(var k=0;k<arry2.length;k++){
				if(arry1[j]==arry2[k]){
					console.log(arry1[j]);
					return true;
				}			
			}
		}
		return false;
	}
	
	console.log(compareArray(arry1,arry2));
</script>
</body>
</html>