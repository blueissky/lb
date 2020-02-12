<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="<%=basePath%>js/jquery-3.4.1.min.js"></script>
<script src="<%=basePath%>js/jcanvas.js"></script>
<script src="<%=basePath%>js/base.js"></script>
<link rel="stylesheet" href="<%=basePath%>js/dist/css/layui.css">
<script src="<%=basePath%>js/dist/layui.js"></script>
<style>
body {
  text-align: center;
}

/* canvas {
  margin: auto;
  display: block;
} */
</style>

</head>
<body style="padding-left: 10px;">
<h2>绿波工具</h2>
<!--<div style="border:solid;border-color:#CCC">-->
<div>
	<canvas id="myCanvas" width="6000" height="500"></canvas>
</div>
<div style="text-align:left">    
    <label>绿波周期</label> <input onchange="commonCycle()" type="text" value="320" id="common_cycle_show">
    					  <input type="hidden" value="80" id="common_cycle">
    <br> <br>
	<label>正向:</label>
    <label>上移</label> <input type="text" value="0" id="common_up">
    <label>下移</label> <input type="text" value="0" id="common_down">
    <label>车速</label> <input type="text" value="45" id="common_speed">
    <label>绿波带宽</label> <input type="text" value="0" id="common_width">
    <br>
    <label>反向:</label>
    <label>上移</label> <input type="text" value="0" id="common_up_r">
    <label>下移</label> <input type="text" value="0" id="common_down_r">
    <label>车速</label> <input type="text" value="45" id="common_speed_r">
    <label>绿波带宽</label> <input type="text" value="0" id="common_width_r">
    <br><br>
    <button onclick="show1()" type="button" class="layui-btn">正向生成</button>
    <button onclick="show2()" type="button" class="layui-btn">反向生成</button>
    <button onclick="showZ()" type="button" class="layui-btn layui-btn-normal">正向相位差</button>
    <button onclick="showR()" type="button" class="layui-btn layui-btn-normal">反向相位差</button>
    <button onclick="autoZ()" type="button" class="layui-btn layui-btn-danger">正向绿波协调</button>
    <button onclick="autoZR()" type="button" class="layui-btn layui-btn-danger">反向绿波协调</button>
    <button onclick="autoZclear()" type="button" class="layui-btn layui-btn-warm">正向单车速计算</button>
    <button onclick="autoRclear()" type="button" class="layui-btn layui-btn-warm">反向单车速计算</button>
    <button onclick="clearPanel()" type="button" class="layui-btn layui-btn-normal">清除</button>
    <br><br>
    <div style="height: 0px;width: 100%;border: 1px;border-color: gray;border-style: solid;"></div>
    <br><br>
    
    <div id="roadPanel">
    	
	    <!-- <label>路口1</label> 
	    <label>长度</label> <input id="road_1_1" type="text" value="0">
	    <label>绿波时长</label> <input id="road_1_2" type="text" value="30">
	    <label>相位差</label> <input id="road_1_3" type="text" value="0">
	    <br><br>
	    <label>路口2</label> 
	    <label>长度</label> <input id="road_2_1" type="text" value="700">
	    <label>绿波时长</label> <input id="road_2_2" type="text" value="30">
	    <label>相位差</label> <input id="road_2_3" type="text" value="0">
	    <br><br>
	    <label>路口3</label> 
	    <label>长度</label> <input id="road_3_1" type="text" value="600">
	    <label>绿波时长</label> <input id="road_3_2" type="text" value="30">
	    <label>相位差</label> <input id="road_3_3" type="text" value="0">
	    <br><br> -->
    </div>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		//路口数
		$("#roadPanel").html('<%=request.getAttribute("roadPanel")%>');
		//总周期
		$("#common_cycle_show").val('<%=request.getAttribute("p3")%>');
		commonCycle();
	
	});
</script>
<script>
//X轴像素比例
var multipleX=<%=request.getAttribute("p1")%>;
//Y轴像素比例
var multipleY=<%=request.getAttribute("p2")%>;

var $myCanvas = $('#myCanvas');
/////////////固定不需要做改动///////////////
///////////创建X轴/////////
var x_value=220;//x轴刻度
var x_len=x_value*2;
xCreate(x_len,multipleX);
/////////创建Y轴///////////
var y_value=4400;//y轴刻度
var y_len=40+(y_value/2);
yCreate(x_len,y_len,multipleY);
/////////////固定不需要做改动///////////////


$myCanvas.drawText({
	  fillStyle: 'black',
	  //strokeStyle: 'Green',
	  //strokeWidth: 1,
	  //x: 200, y:x_len+60,
	  x: 26, y:x_len+20,
	  fontSize: 15,
	  //fontFamily: 'Verdana, sans-serif',
	  text: "s/m"
	});

////////////////////////清除画布(白色替换)//////////////////////
function clearPanel(){
	//清除路段
	var canvas = document.getElementById('myCanvas');
    if(!canvas.getContext) return;
    var ctx = canvas.getContext("2d");
    ctx.fillStyle = "rgb(255,255,255)";
    ctx.fillRect(41, -1, y_len, x_len);  
    //清除路口名称
    var ctx = canvas.getContext("2d");
    ctx.fillStyle = "rgb(255,255,255)";
    ctx.fillRect(41, 30+x_len, y_len, 40);   
}
function clearBottom(){
	//清除底部区域
	var canvas = document.getElementById('myCanvas');
    if(!canvas.getContext) return;
    var ctx = canvas.getContext("2d");
    ctx.fillStyle = "rgb(255,255,255)";
    ctx.fillRect(41,x_len, y_len, x_len);  
}
function commonCycle(){
	var v=$("#common_cycle_show").val()/multipleX;																	//MODIFY 4
		  $("#common_cycle").val(v);
}
////////////////////////1距离,2绿波带宽,3相位差//////////////////////
//正向
function show1(){
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	//反向使用
	var last2=0;
	var last3=0;
	//路段长度
	var roadLen=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			break;
		}else{
			last2=r2;
			last3=r3;
		}
		roadLen+=parseInt(r1);
		//console.log(roadLen);
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
		roadName(i,roadLen/2+80,multipleY);//创建道路名称
	}
	var r3=$("#road_1_3").val();
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val(),r3,multipleX,multipleY);
	var w=parseInt($("#road_1_2").val())-parseInt($("#common_up").val())-parseInt($("#common_down").val());
	$("#common_width").val(w);
	
	//清除，重建
	//clearBottom();
	//yCreate(x_len,y_len,multipleY);
	//创建路名
}
//反向
function show2(){
	var common_speed_r=$("#common_speed_r").val();
	var common_cycle=$("#common_cycle").val();
	//反向使用
	var last2=0;
	var last3=0;
	//路段长度
	var roadLen=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			break;
		}else{
			last2=r2;
			last3=r3;
		}
		roadLen+=parseInt(r1);
		//console.log(roadLen);
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
		roadName(i,roadLen/2+80,multipleY);//创建道路名称
	}
	//创建反向绿波带
	createGreen_R(last2,parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),last3,multipleX,multipleY);	
	
	var w=last2-parseInt($("#common_up_r").val())-parseInt($("#common_down_r").val());
	$("#common_width_r").val(w);
	
	//清除，重建 begin//
	//clearBottom();
	//yCreate(x_len,y_len,multipleY);
	//end//
}
//////////////////////正向绿波相位差//////////////////////
function showZ(){
	//$("#common_down").val();
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	
	//相位差计算
	var roadLen=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			break;
		}else{
			roadLen+=parseInt(r1);
			$("#road_"+i+"_3").val( xwc_sl(roadLen,common_speed) );
		}
		
	}
	
	//路段长度
	roadLen=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			break;
		}
		roadLen+=parseInt(r1);
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
		roadName(i,roadLen/2+80,multipleY);//创建道路名称
	}
	var r3=$("#road_1_3").val();
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val(),r3,multipleX,multipleY);
	
	//清除，重建 begin//
	//clearBottom();
	//yCreate(x_len,y_len,multipleY);
	//end//
}
////////////////////////反向绿波相位差//////////////////////
//1距离,2绿波带宽,3相位差
function showR(){
	var common_speed_r=$("#common_speed_r").val();
	var common_cycle=$("#common_cycle").val();
	
	//相位差计算
	var roadLen=0;
	for(var i=20;i>=1;i--){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}else{
			$("#road_"+i+"_3").val( xwc_sl(roadLen,common_speed_r) );
			console.log(roadLen);
			roadLen+=parseInt(r1);
		}
		
	}
	//路段长度
	roadLen=0;
	var last2=0;
	var last3=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			break;
		}else{
			last2=r2;
			last3=r3;
		}
		roadLen+=parseInt(r1);
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
		roadName(i,roadLen/2+80,multipleY);//创建道路名称
	}
	//反向
	createGreen_R(last2,parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),last3,multipleX,multipleY);
	
	//清除，重建 begin//
	//clearBottom();
	//yCreate(x_len,y_len,multipleY);
	//end//
}

//////////////////////////////正向自动计算//////////////////////////////////////////////
//1距离,2绿波带宽,3相位差
function autoZ(){
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	var arrySum=new Array();
	//路段长度
	var roadLen=0;
	var beginLen=0;
	
	var arry1=new Array();
	var arry1Add=new Array();
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		var r4=$("#road_"+i+"_4").val();//区间车速
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		roadLen+=parseInt(r1);
		arrySum=createLocAlter(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
		roadName(i,roadLen/2+80,multipleY);//创建道路名称
		//console.log(arrySum);
		//begin
		//console.log(arrySum);
		var arryFirst=new Array();
		for(var j=0;j<arrySum.length;j++){
			var sp=arrySum[j].split("*");
			var s0=parseInt(sp[0]);
			var s1=parseInt(sp[1]);
			s0=Math.round(s0);
			s1=Math.round(s1);
			while(s0<=s1){
				arryFirst.push(s0);
				s0++;
			}
		}
		arry1.push(arryFirst);//起点
		/* if(isNaN(time)){//判断是否为空
			break;	
		}
		var time2=Math.round(time);//相位差统计 */
		//console.log(time2);
		var time=xwc_sl($("#road_"+(i+1)+"_1").val(),$("#road_"+(i+1)+"_4").val());//路口1,2
		time=(time*2)/multipleX;
		time=Math.round(time);
		
		var arrySecond=new Array();
		for(var j=0;j<arrySum.length;j++){
			var sp=arrySum[j].split("*");
			var s0=parseInt(sp[0])-time;
			var s1=parseInt(sp[1])-time;
			s0=Math.round(s0);
			s1=Math.round(s1);
			while(s0<=s1){
				arrySecond.push(s0);
				s0++;
			}
		}
		arry1Add.push(arrySecond);//终点
		
	}
	console.log(arry1);
	console.log(arry1Add);
	
	var begin=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		var r4=$("#road_"+i+"_4").val();//区间车速
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}

		begin+=parseInt($("#road_"+i+"_1").val());
		var Len=parseInt($("#road_"+(i+1)+"_1").val());
		for(var n=0;n<arryFirst.length;n++){
			//判断交集
			/* console.log(arry1[i].indexOf(arry1Add[i-1][n]));  
			var flag=arry1[i].indexOf(arry1Add[i-1][n]);
			if(flag==-1){//找不到交点
				continue;
			} */
			$('canvas').drawLine({
				strokeStyle:'#7CFC00',
				strokeWidth:1,
				//x1:80,y1:x_len-(sum_c*2)-i-upAdd*2-xwc*2,
				//x2:80+(lenEnd/2),y2:x_len-(sum_c*2)-time-i-upAdd*2-xwc*2,        MODIFY   4
				x1:80+(begin/2/multipleY)			,y1:arry1[i-1][n],   //ALTER 2
										   //总长度-总周期-变量i-上偏移量-相位差
				x2:80+((begin+Len)/2/multipleY)  ,y2:arry1Add[i-1][n]    //ALTER 2
										   //总长度-总周期-车速时间-变量i-上偏移量-相位差
			});
		}
	
	}
	//清除，重建 begin//
	//clearBottom();
	//yCreate(x_len,y_len,multipleY);
	//end//
	
}
//////////////////////////////正向自动计算//////////////////////////////////////////////
//////////////////////////////反向自动计算//////////////////////////////////////////////
//1距离,2绿波带宽,3相位差
function autoZR(){
		var common_speed=$("#common_speed").val();
		var common_cycle=$("#common_cycle").val();
		var arrySum=new Array();
		//路段长度
		var roadLen=0;
		var beginLen=0;
		
		var arryAll=new Array();
		var arry1=new Array();
		var arry1Add=new Array();
		//step1.画路口
		for(var i=1;i<=20;i++){
			var r1=$("#road_"+i+"_1").val();
			var r2=$("#road_"+i+"_2").val();
			var r3=$("#road_"+i+"_3").val();
			var r4=$("#road_"+i+"_4").val();//区间车速
			if(r1==""||r1==null){
				console.log("结束："+i);
				continue;
			}
			roadLen+=parseInt(r1);
			arrySum=createLocAlter(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
			roadName(i,roadLen/2+80,multipleY);//创建道路名称
			
			arryAll.push(arrySum);
			
		}
		console.log(arryAll);
		//step2  车速
		for(var i=20;i>=1;i--){
			var r1=$("#road_"+i+"_1").val();
			var r2=$("#road_"+i+"_2").val();
			var r3=$("#road_"+i+"_3").val();
			var r5=$("#road_"+i+"_5").val();//区间车速
			if(r1==""||r1==null){
				console.log("结束："+i);
				continue;
			}
			
			var arryFirst=new Array();//起点
			for(var j=0;j<arryAll[i-1].length;j++){
				var sp=arryAll[i-1][j].split("*");
				var s0=parseInt(sp[0]);
				var s1=parseInt(sp[1]);
				s0=Math.round(s0);
				s1=Math.round(s1);
				while(s0<=s1){
					arryFirst.push(s0);
					s0++;
				}
			}
			arry1.push(arryFirst);//反过来装
			
			var time=xwc_sl($("#road_"+(i)+"_1").val(),$("#road_"+(i-1)+"_5").val());//路口1,2
			time=(time*2)/multipleX;
			time=Math.round(time);
			
			var arrySecond=new Array();
			for(var j=0;j<arryAll[i-1].length;j++){
				var sp=arryAll[i-1][j].split("*");
				var s0=parseInt(sp[0])-time;
				var s1=parseInt(sp[1])-time;
				s0=Math.round(s0);
				s1=Math.round(s1);
				while(s0<=s1){
					arrySecond.push(s0);
					s0++;
				}
			}		
			arry1Add.push(arrySecond);//反过来装
			
		}
		//反转
		arry1.reverse();
		arry1Add.reverse();
		
		console.log(arry1);
		console.log(arry1Add);//终点
		
		var begin=roadLen;
		for(var i=20;i>=1;i--){
			var r1=$("#road_"+i+"_1").val();
			var r2=$("#road_"+i+"_2").val();
			var r3=$("#road_"+i+"_3").val();
			var r5=$("#road_"+i+"_5").val();//区间车速
			if(r1==""||r1==null){
				console.log("结束："+i);
				continue;
			}
			
			var Len=parseInt($("#road_"+i+"_1").val());
			for(var n=0;n<arry1[i-1].length;n++){
				$('canvas').drawLine({
					strokeStyle:'#7CFC00',
					strokeWidth:1,
					//x1:80,y1:x_len-(sum_c*2)-i-upAdd*2-xwc*2,
					//x2:80+(lenEnd/2),y2:x_len-(sum_c*2)-time-i-upAdd*2-xwc*2,        MODIFY   4
					x1:80+(begin/2/multipleY)			,y1:arry1[i-1][n],   //ALTER 2
											   //总长度-总周期-变量i-上偏移量-相位差
					x2:80+((begin-Len)/2/multipleY)  ,y2:arry1Add[i-1][n]    //ALTER 2
											   //总长度-总周期-车速时间-变量i-上偏移量-相位差
				});
			}
			begin-=parseInt($("#road_"+i+"_1").val());
		}
		//清除，重建 begin//
		//clearBottom();
		//yCreate(x_len,y_len,multipleY);
		//end//
	
}
//////////////////////////////反向自动计算//////////////////////////////////////////////

//////////////////////////////正向自动计算-区间//////////////////////////////////////////////
//1距离,2绿波带宽,3相位差
function autoZclear(){

	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	var arrySum=new Array();
	//路段长度
	var roadLen=0;
	var beginLen=0;
	
	var arry1=new Array();
	var arry1Add=new Array();
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		var r4=$("#road_"+i+"_4").val();//区间车速
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		roadLen+=parseInt(r1);
		arrySum=createLocAlter(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
		roadName(i,roadLen/2+80,multipleY);//创建道路名称
		//console.log(arrySum);
		//begin
		console.log(arrySum);
		var arryFirst=new Array();
		for(var j=0;j<arrySum.length;j++){
			var sp=arrySum[j].split("*");
			var s0=parseInt(sp[0]);
			var s1=parseInt(sp[1]);
			s0=Math.round(s0);
			s1=Math.round(s1);
			while(s0<=s1){
				arryFirst.push(s0);
				s0++;
			}
		}
		console.log(arryFirst);//起点
		arry1.push(arryFirst);
		var time=xwc_sl($("#road_"+(i+1)+"_1").val(),$("#road_"+(i+1)+"_4").val());//路口1,2
		/* if(isNaN(time)){//判断是否为空
			break;	
		}
		var time2=Math.round(time);//相位差统计 */
		time=(time*2)/multipleX;
		time=Math.round(time);
		//console.log(time2);
		var arrySecond=new Array();
		for(var j=0;j<arrySum.length;j++){
			var sp=arrySum[j].split("*");
			var s0=parseInt(sp[0])-time;
			var s1=parseInt(sp[1])-time;
			s0=Math.round(s0);
			s1=Math.round(s1);
			while(s0<=s1){
				arrySecond.push(s0);
				s0++;
			}
		}
		console.log(arrySecond);//终点
		arry1Add.push(arrySecond);
		
	}
	console.log(arry1);
	console.log(arry1Add);
	
	var begin=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		var r4=$("#road_"+i+"_4").val();//区间车速
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}

		begin+=parseInt($("#road_"+i+"_1").val());
		var Len=parseInt($("#road_"+(i+1)+"_1").val());
		for(var n=0;n<arryFirst.length;n++){
			
			//判断交集
			console.log(arry1[i].indexOf(arry1Add[i-1][n]));  
			var flag=arry1[i].indexOf(arry1Add[i-1][n]);
			if(flag==-1){//找不到交点
				continue;
			}
			$('canvas').drawLine({
				strokeStyle:'#7CFC00',
				strokeWidth:1,
				//x1:80,y1:x_len-(sum_c*2)-i-upAdd*2-xwc*2,
				//x2:80+(lenEnd/2),y2:x_len-(sum_c*2)-time-i-upAdd*2-xwc*2,        MODIFY   4
				x1:80+(begin/2/multipleY)			,y1:arry1[i-1][n],   //ALTER 2
										   //总长度-总周期-变量i-上偏移量-相位差
				x2:80+((begin+Len)/2/multipleY)  ,y2:arry1Add[i-1][n]    //ALTER 2
										   //总长度-总周期-车速时间-变量i-上偏移量-相位差
			});
		}
	
	}
	//清除，重建 begin//
	//clearBottom();
	//yCreate(x_len,y_len,multipleY);
	//end//
}
//////////////////////////////正向自动计算-区间//////////////////////////////////////////////

//////////////////////////////反向自动计算-区间//////////////////////////////////////////////
function autoRclear(){
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	var arrySum=new Array();
	//路段长度
	var roadLen=0;
	var beginLen=0;
	
	var arryAll=new Array();
	var arry1=new Array();
	var arry1Add=new Array();
	//step1.画路口
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		var r4=$("#road_"+i+"_4").val();//区间车速
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		roadLen+=parseInt(r1);
		arrySum=createLocAlter(x_len,roadLen,common_cycle,r2,r3,multipleX,multipleY);//创建绿信
		roadName(i,roadLen/2+80,multipleY);//创建道路名称
		
		arryAll.push(arrySum);
		
		
	}
	console.log(arryAll);
	//step2  车速
	for(var i=20;i>=1;i--){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		var r5=$("#road_"+i+"_5").val();//区间车速
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		
		var arryFirst=new Array();//起点
		for(var j=0;j<arryAll[i-1].length;j++){
			var sp=arryAll[i-1][j].split("*");
			var s0=parseInt(sp[0]);
			var s1=parseInt(sp[1]);
			s0=Math.round(s0);
			s1=Math.round(s1);
			while(s0<=s1){
				arryFirst.push(s0);
				s0++;
			}
		}
		arry1.push(arryFirst);//反过来装
		
		var time=xwc_sl($("#road_"+(i)+"_1").val(),$("#road_"+(i-1)+"_5").val());//路口1,2
		time=(time*2)/multipleX;
		time=Math.round(time);
		
		var arrySecond=new Array();
		for(var j=0;j<arryAll[i-1].length;j++){
			var sp=arryAll[i-1][j].split("*");
			var s0=parseInt(sp[0])-time;
			var s1=parseInt(sp[1])-time;
			s0=Math.round(s0);
			s1=Math.round(s1);
			while(s0<=s1){
				arrySecond.push(s0);
				s0++;
			}
		}		
		arry1Add.push(arrySecond);//反过来装
		
	}
	//console.log(arry1);
	//console.log(arry1Add);//终点
	
	arry1.reverse();
	arry1Add.reverse();
	
	console.log(arry1);
	console.log(arry1Add);//终点
	
	var begin=roadLen;
	for(var i=20;i>=1;i--){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		var r5=$("#road_"+i+"_5").val();//区间车速
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		
		var Len=parseInt($("#road_"+i+"_1").val());
		console.log(begin);
		console.log(begin-Len);
		for(var n=0;n<arry1[i-1].length;n++){
			//判断交集
			//console.log(arry1[i].indexOf(arry1Add[i-1][n]));  
			var flag=arry1[i-2].indexOf(arry1Add[i-1][n]);
			if(flag==-1){//找不到交点
				continue;
			}
			$('canvas').drawLine({
				strokeStyle:'#7CFC00',
				strokeWidth:1,
				//x1:80,y1:x_len-(sum_c*2)-i-upAdd*2-xwc*2,
				//x2:80+(lenEnd/2),y2:x_len-(sum_c*2)-time-i-upAdd*2-xwc*2,        MODIFY   4
				x1:80+(begin/2/multipleY)			,y1:arry1[i-1][n],   //ALTER 2
										   //总长度-总周期-变量i-上偏移量-相位差
				x2:80+((begin-Len)/2/multipleY)  ,y2:arry1Add[i-1][n]    //ALTER 2
										   //总长度-总周期-车速时间-变量i-上偏移量-相位差
			});
		}
		begin-=parseInt($("#road_"+i+"_1").val());
	}
	//清除，重建 begin//
	//clearBottom();
	//yCreate(x_len,y_len,multipleY);
	//end//
}
//////////////////////////////反向自动计算-区间//////////////////////////////////////////////



</script>
</body>
</html>