<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="<%=basePath%>js/jquery-3.4.1.min.js"></script>
<link rel="stylesheet" href="<%=basePath%>js/dist/css/layui.css">
<script src="<%=basePath%>js/dist/layui.js"></script>
</head>
<body>
<br><br>

<div class="layui-container">  
  <div class="layui-row">
    <div class="layui-col-md2">&nbsp;
    </div>
    <div class="layui-col-md6">

		<form class="layui-form" method="post" action="<%=basePath%>BeginAction">
		  <div class="layui-form-item">
		    <label class="layui-form-label">X轴(米/像素)</label>
		    <div class="layui-input-block">
		      <input type="text" name="p1" required value="1" lay-verify="required" autocomplete="off" class="layui-input" id="xv">
		      <div id="slideX"></div>
		    </div>
		  </div>
	      
		  <div class="layui-form-item">
		    <label class="layui-form-label">Y轴(秒/像素)</label>
		    <div class="layui-input-block">
		      <input type="text" name="p2" required value="1" lay-verify="required" autocomplete="off" class="layui-input" id="yv">
		      <div id="slideY"></div>
		    </div>
		  </div>

		   <div class="layui-form-item">
		    <label class="layui-form-label">总周期</label>
		    <div class="layui-input-block">
		      <input type="text" name="p3" required  lay-verify="required" autocomplete="off" class="layui-input">
		    </div>
		  </div>
		  <div class="layui-form-item">
		    <label class="layui-form-label">路口数</label>
		    <div class="layui-input-block">
		      <select name="p4" lay-verify="required" >
		        <option value="1">1</option>
		        <option value="2">2</option>
		        <option value="3">3</option>
		        <option value="4">4</option>
		        <option value="5">5</option>
		        <option value="6">6</option>
		        <option value="7">7</option>
		        <option value="8">8</option>
		        <option value="9">9</option>
		        <option value="10">10</option>
		        <option value="11">11</option>
		        <option value="12">12</option>
		        <option value="13">13</option>
		        <option value="14">14</option>
		        <option value="15">15</option>
		        <option value="16">16</option>
		        <option value="17">17</option>
		        <option value="18">18</option>
		        <option value="19">19</option>
		        <option value="20">20</option>
		      </select>
		    </div>
		  </div>
		  <div class="layui-form-item">
		    <div class="layui-input-block">
		      <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
		      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
		    </div>
		  </div>
		</form>
    
    </div>
    <div class="layui-col-md2">
    </div>
  </div>
<script>

layui.use('slider', function(){
	  var slider = layui.slider;
	  //渲染
	  slider.render({
		    elem: '#slideX',  //绑定元素
		    min:1,
		    max:100,
		    change: function(value){
		        console.log(value) //动态获取滑块数值
		        //do something
		        $("#xv").val(value/10);
		    }
	  });
	  slider.render({
		    elem: '#slideY',  //绑定元素
		    min:1,
		    max:50,
		    change: function(value){
		        console.log(value) //动态获取滑块数值
		        //do something
		        $("#yv").val(value/10);
		    }
	  });
});

//Demo
layui.use('form', function(){
  var form = layui.form;
  //监听提交
  /* form.on('submit(formDemo)', function(data){
    layer.msg(JSON.stringify(data.field));
    return false;
  }); */
});
</script>
</body>
</html>