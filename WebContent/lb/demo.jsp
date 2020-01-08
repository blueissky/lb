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

canvas {
  margin: auto;
  display: block;
}
</style>
</head>
<body style="padding-left: 10px;">
<h2>绿波工具</h2>
<!--<div style="border:solid;border-color:#CCC">-->
<div>
	<canvas id="myCanvas" width="6000" height="500"></canvas>
</div>
<div style="text-align:left">    
    <label>绿波周期</label> <input type="text" value="80" id="common_cycle">
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
    <button onclick="show()" type="button" class="layui-btn">生成</button>
    <button onclick="showZ()" type="button" class="layui-btn">正向相位差</button>
    <button onclick="showR()" type="button" class="layui-btn">反向相位差</button>
    <button onclick="autoZ()" type="button" class="layui-btn">正向绿波协调</button>
    <button onclick="autoR()" type="button" class="layui-btn">反向绿波协调</button>
    <br><br>
    <div style="height: 0px;width: 100%;border: 1px;border-color: gray;border-style: solid;"></div>
    <br><br>
    <div>
	    <label>路口1</label> 
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
	    <br><br>
    </div>
</div>

<script>
var $myCanvas = $('#myCanvas');

/////////////固定不需要做改动///////////////
///////////创建X轴/////////
var x_value=220;//x轴刻度
var x_len=x_value*2;
xCreate(x_len);
/////////创建Y轴///////////
var y_value=4400;//y轴刻度
var y_len=40+(y_value/2);
yCreate(x_len,y_len);
/////////////固定不需要做改动///////////////

//1距离,2绿波带宽,3相位差
function show(){
	$('#myCanvas').clearCanvas();
	/////////创建XY轴刷新///////////
	xCreate(x_len);
	yCreate(x_len,y_len);
	/////////创建XY轴刷新///////////	
	$("#common_up").val();
	$("#common_down").val();
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	///////////清零////////////////
	/* 
	$("#road_1_3").val(0);
	$("#road_2_3").val(0);
	$("#road_3_3").val(0); 
	*/
	///////////清零////////////////
	//路段长度
	var roadLen=0;	
	/* $("#road_1_1").val();
	$("#road_1_2").val();
	$("#road_1_3").val(); */
	
	//创建路口1
	createLoc(x_len,$("#road_1_1").val(),common_cycle,$("#road_1_2").val(),$("#road_1_3").val());
	//创建路口2
	createLoc(x_len,$("#road_2_1").val(),common_cycle,$("#road_2_2").val(),$("#road_2_3").val());
	//创建路口3
	createLoc(x_len,parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val()),common_cycle,$("#road_3_2").val(),$("#road_3_3").val());
	
	//创建路口名称
	roadName("路口1",parseInt($("#road_1_1").val())+80);
	roadName("路口2",parseInt($("#road_2_1").val())/2 + 80);
	roadName("路口3",(parseInt($("#road_2_1").val())/2 + parseInt($("#road_3_1").val())/2) +80);
	//创建路口名称
	
	//总长度	
	roadLen=parseInt($("#road_1_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val());
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val());
	//反向绿波带
	createGreen_R($("#road_3_2").val(),parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),$("#road_3_3").val());
}
//正向绿波相位差
function showZ(){
	$('#myCanvas').clearCanvas();
	/////////创建XY轴刷新///////////
	xCreate(x_len);
	yCreate(x_len,y_len);
	/////////创建XY轴刷新///////////	
	$("#common_up").val();
	$("#common_down").val();
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	///////////清零////////////////
	$("#road_1_3").val(0);
	$("#road_2_3").val(0);
	$("#road_3_3").val(0);
	///////////清零////////////////
	//路段长度
	var roadLen=0;	
	/* $("#road_1_1").val();
	$("#road_1_2").val();
	$("#road_1_3").val(); */
	if(true){
		var r2 = xwc_sl($("#road_2_1").val(),common_speed);
		var r3 = xwc_sl(parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val()),common_speed);
		$("#road_2_3").val(r2);
		$("#road_3_3").val(r3);
	}
	
	//创建路口1
	createLoc(x_len,$("#road_1_1").val(),common_cycle,$("#road_1_2").val(),$("#road_1_3").val());
	//创建路口2
	createLoc(x_len,$("#road_2_1").val(),common_cycle,$("#road_2_2").val(),$("#road_2_3").val());
	//创建路口3
	createLoc(x_len,parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val()),common_cycle,$("#road_3_2").val(),$("#road_3_3").val());
	
	
	//总长度	
	roadLen=parseInt($("#road_1_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val());
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val());
	//反向
	//createGreen_R($("#road_3_2").val(),parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),$("#road_3_3").val());
}
//反向绿波相位差
//1距离,2绿波带宽,3相位差
function showR(){
	$('#myCanvas').clearCanvas();
	/////////创建XY轴刷新///////////
	xCreate(x_len);
	yCreate(x_len,y_len);
	/////////创建XY轴刷新///////////	
	$("#common_up").val();
	$("#common_down").val();
	var common_speed_r=$("#common_speed_r").val();
	var common_cycle=$("#common_cycle").val();
	///////////清零////////////////
	$("#road_1_3").val(0);
	$("#road_2_3").val(0);
	$("#road_3_3").val(0);
	///////////清零////////////////
	//路段长度
	var roadLen=0;	
	/* $("#road_1_1").val();
	$("#road_1_2").val();
	$("#road_1_3").val(); */
	if(true){
		var r2 = xwc_sl($("#road_3_1").val(),common_speed_r);
		var r1 = xwc_sl(parseInt($("#road_3_1").val())+parseInt($("#road_2_1").val()),common_speed_r);
		$("#road_2_3").val(r2);
		$("#road_1_3").val(r1);
	}
	
	//创建路口1
	createLoc(x_len,$("#road_1_1").val(),common_cycle,$("#road_1_2").val(),$("#road_1_3").val());
	//创建路口2
	createLoc(x_len,$("#road_2_1").val(),common_cycle,$("#road_2_2").val(),$("#road_2_3").val());
	//创建路口3
	createLoc(x_len,parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val()),common_cycle,$("#road_3_2").val(),$("#road_3_3").val());
	
	//总长度	
	roadLen=parseInt($("#road_1_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val());
	//创建正向绿波带
	//createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val());
	//反向
	createGreen_R($("#road_3_2").val(),parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),$("#road_3_3").val());
}

//正向自动计算
//1距离,2绿波带宽,3相位差
function autoZ(){
	$('#myCanvas').clearCanvas();
	/////////创建XY轴刷新///////////
	xCreate(x_len);
	yCreate(x_len,y_len);
	/////////创建XY轴刷新///////////	
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	//总长度	
	var roadLen=parseInt($("#road_1_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val());
	
	//创建路口1
	createLoc(x_len,$("#road_1_1").val(),common_cycle,$("#road_1_2").val(),$("#road_1_3").val());
	//创建路口2
	createLoc(x_len,$("#road_2_1").val(),common_cycle,$("#road_2_2").val(),$("#road_2_3").val());
	//创建路口3
	createLoc(x_len,parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val()),common_cycle,$("#road_3_2").val(),$("#road_3_3").val());
	
	
	//上轴计算
	//y=x/speed+b
	//截距=(时间+相位差)-(距离/车速)
	var arr1=new Array();
	var a1 = parseInt($("#road_1_2").val())+parseInt($("#road_1_3").val()) - parseInt($("#road_1_1").val()) / (parseInt(common_speed)*1000/3600);
	var a2 = parseInt($("#road_2_2").val())+parseInt($("#road_2_3").val()) - ( parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed)*1000/3600);
	var a3 = parseInt($("#road_3_2").val())+parseInt($("#road_3_3").val()) - ( parseInt($("#road_3_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed)*1000/3600);
	arr1.push(a1);arr1.push(a2);arr1.push(a3);
	console.log(a1+","+a2+","+a3);
	var tempDown=arr1[0];
	for(var i=1;i<arr1.length;i++){
		if(tempDown>arr1[i]){//取最小截距值
			tempDown=arr1[i];
		}
	}
	if(tempDown<0)tempDown=0;
	console.log("temp:"+tempDown);
	//下轴计算
	//y=x/speed+b
	//截距=(相位差)-(距离/车速)
	var arr2=new Array();
	var a1 = parseInt($("#road_1_3").val()) - parseInt($("#road_1_1").val()) / (parseInt(common_speed)*1000/3600);
	var a2 = parseInt($("#road_2_3").val()) - ( parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed)*1000/3600);
	var a3 = parseInt($("#road_3_3").val()) - ( parseInt($("#road_3_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed)*1000/3600);
	arr2.push(a1);arr2.push(a2);arr2.push(a3);
	console.log(a1+","+a2+","+a3);
	var tempUp=arr2[0];
	for(var i=1;i<arr2.length;i++){
		if(tempUp<arr2[i]){//取最大截距值
			tempUp=arr2[i];
		}
	}
	if(tempUp<0)tempUp=0;
	console.log("temp:"+tempUp);
	
	//创建正向绿波带
	createGreen($("#road_1_2").val(),tempUp,parseInt($("#road_1_2").val())-tempDown,common_cycle,roadLen,common_speed);
	$("#common_up").val(tempUp);
	$("#common_down").val(parseInt($("#road_1_2").val())-tempDown);
	
	//绿波带宽计算
	var u=tempUp;
	var d=parseInt($("#road_1_2").val())-tempDown;
	var common_width=$("#common_width").val(parseInt($("#road_1_2").val())-u-d);
}

//反向自动计算
//1距离,2绿波带宽,3相位差
function autoR(){
	$('#myCanvas').clearCanvas();
	//console.log("clear!");
	/////////创建XY轴刷新///////////
	xCreate(x_len);
	yCreate(x_len,y_len);
	/////////创建XY轴刷新///////////	
	var common_speed_r=$("#common_speed_r").val();
	var common_cycle=$("#common_cycle").val();
	//总长度	
	var roadLen=parseInt($("#road_1_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val());
	
	//创建路口1
	createLoc(x_len,$("#road_1_1").val(),common_cycle,$("#road_1_2").val(),$("#road_1_3").val());
	//创建路口2
	createLoc(x_len,$("#road_2_1").val(),common_cycle,$("#road_2_2").val(),$("#road_2_3").val());
	//创建路口3
	createLoc(x_len,parseInt($("#road_2_1").val())+parseInt($("#road_3_1").val()),common_cycle,$("#road_3_2").val(),$("#road_3_3").val());
	//////////////////////////Begin////////////////////////////
	//周期
	/////////////////////////////SAVE 路口 1/////////////////////////////////////////////////////
	//路口1 路长
	var r11=parseInt($("#road_1_1").val());
	//路口1 绿波时长
	var r12=parseInt($("#road_1_2").val());
	//路口1 相位差
	var r13=parseInt($("#road_1_3").val());

	var arry1=new Array();
	var base=0;
	var differ=parseInt(common_cycle)*2-r12*2;
	for(var i=0;i<x_len/parseInt(common_cycle);i++){
		if(i==0){
			differ=0;
		}else{
			differ=parseInt(common_cycle)*2-r12*2;
		}
		for(var j=1;j<=r12*2;j++){
			arry1.push(x_len - (r13+j + differ + base)-r13);
			//base=r13+j + i*differ + base;
			if(j==r12*2){
				base=r13+j + differ + base-r13;
				//console.log(base);
			}
		}
	}
	////////////////////////////////SAVE 路口 2//////////////////////////////////////////////////
	//路口1 路长
	var r21=parseInt($("#road_2_1").val());
	//路口1 绿波时长
	var r22=parseInt($("#road_2_2").val());
	//路口1 相位差
	var r23=parseInt($("#road_2_3").val());

	var arry2=new Array();
	var base=0;
	var differ=parseInt(common_cycle)*2-r22*2;
	for(var i=0;i<x_len/parseInt(common_cycle);i++){
		if(i==0){
			differ=0;
		}else{
			differ=parseInt(common_cycle)*2-r22*2;
		}
		for(var j=1;j<=r22*2;j++){
			arry2.push(x_len - (r23+j + differ + base)-r23);
			//base=r13+j + i*differ + base;
			if(j==r22*2){
				base=r23+j + differ + base-r23;
				//console.log(base);
			}
		}
	}
	////////////////////////////////SAVE 路口 3//////////////////////////////////////////////////
	//路口1 路长
	var r31=parseInt($("#road_3_1").val());
	//路口1 绿波时长
	var r32=parseInt($("#road_3_2").val());
	//路口1 相位差
	var r33=parseInt($("#road_3_3").val());

	var arry3=new Array();
	var base=0;
	var differ=parseInt(common_cycle)*2-r32*2;//固定值
	for(var i=0;i<x_len/parseInt(common_cycle);i++){
		if(i==0){
			differ=0;
		}else{
			differ=parseInt(common_cycle)*2-r32*2;
		}
		for(var j=1;j<=r32*2;j++){
			arry3.push(x_len - (r33+j + differ + base)-r33);
			//base=r13+j + i*differ + base;
			if(j==r32*2){
				base=r33+j + differ + base-r33;
				//console.log(base);
			}
		}
	}
	
	console.log(arry1);
	console.log(arry2);
	console.log(arry3);
	
	//直线方程 x=ay+b y=x/a+b 
	//画图
	/* for(var i=0;i<arry1.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:r11+40*2,y1:arry1[i]+60,//x1固定,y1变化
			x2:(roadLen+160)/2,y2:(arry1[i]+60) - xwc_sl(roadLen,common_speed_r)*2
		});//x2固定,y2变化
	} */
	
	
	/* for(var i=0;i<arry3.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160)/2,y1:arry3[i]+60,//x1固定,y1变化  
			x2:(roadLen+160-roadLen)/2,y2:(arry3[i]+60) - xwc_sl(roadLen,common_speed_r)*2
		});//x2固定,y2变化
	} */
	///////////////////////////////////////
	var tempArry1=new Array();
	var tempArry2=new Array();
	var tempArry3=new Array();
	var tempArry3_2=new Array();
	//y=x/a+b
	//b 3的绿波点值
	
	//var temp=new Array();
	var xwc=xwc_sl(parseInt(r31),common_speed_r)*2;
	var xwc1=xwc_sl(parseInt(roadLen),common_speed_r)*2;
	xwc=Math.round(xwc);
	xwc1=Math.round(xwc1);
	//console.log("arry2:"+arry2);
	//console.log("arry1:"+arry1);
	//查找交点
	for(var i=0;i<arry3.length;i++){
		var y= arry3[i]-xwc;
		var y1= arry3[i]-xwc1;
		//temp.push(y);
		//var y=(arry3[i]) - xwc_sl(600,common_speed_r)*2;//3相交于2的 y轴坐标点
		for(var j=0;j<arry3.length;j++){
			
			if(arry2[j]==y){
				tempArry2.push(y);
				tempArry3_2.push(arry3[i]);
			}
			
			if(arry1[j]==y1){//arry2[j]==y&&
				tempArry1.push(y1);
				tempArry3.push(arry3[i]);
			}
		}
	}
	
	console.log("*****");
	console.log(xwc);
	console.log(xwc1);
	console.log(tempArry2);
	console.log(tempArry3_2);
	console.log(tempArry1);
	console.log(tempArry3);
	console.log("*****");
	
	var tempAllF=new Array();
	var tempAll=new Array();
	//只保留一个
	for(var i=0;i<arry3.length;i++){
		for(var j=0;j<tempArry3.length;j++){
			if(tempArry3[i]==tempArry3_2[j]){
				tempAll.push(tempArry3[i]);
				tempAllF.push(tempArry1[i]);
			}
		}
	}
	console.log(arry3);
	console.log(tempArry3);
	//画图 ALL
	for(var i=0;i<tempAll.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160)/2,y1:tempAll[i],  
			x2:(roadLen+160-roadLen)/2,y2:tempAllF[i]
		});//x2固定,y2变化
	}
	//console.log(tempAll);
	
	//反向绿波带宽计算
	var num=0;
	var numVal=0;
	for(var i=0;i<9999;i++){
		if(tempAll[i]-1==tempAll[i+1]){
			num++;
		}else{
			if(num!=0){
				if(num>numVal){
					numVal=num;	
					$("#common_width_r").val((numVal+1) / 2);//反向绿波带宽
				}
			}
			num=0;
		}
	}
	
	
	
	
	/* var ts=x_len/(parseInt(common_cycle)*2);
	var len=tempAll.length;
	var lvR_len=(len/Math.round(ts)) / (2*2);
	console.log("ts:"+ts);
	console.log("len:"+len);
	console.log("lvR_len:"+lvR_len); */
	/* 
	//画图
	for(var i=0;i<tempArry3.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160)/2,y1:tempArry3[i],  
			x2:(roadLen+160-roadLen)/2,y2:tempArry1[i]
		});//x2固定,y2变化
	}
	
	//画图
	for(var i=0;i<tempArry3_2.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160)/2,y1:tempArry3_2[i],  
			x2:(roadLen+160-600)/2,y2:tempArry2[i]
		});//x2固定,y2变化
	}
	 */
	
	
	
	/* var xwc=xwc_sl(parseInt(r31),common_speed_r)*2;
	//查找交点
	for(var i=0;i<arry3.length;i++){
		var y= arry3[i]-xwc;
		//temp.push(y);
		//var y=(arry3[i]) - xwc_sl(600,common_speed_r)*2;//3相交于2的 y轴坐标点
		for(var j=0;j<arry3.length;j++){
			if(arry2[j]==y){
				tempArry2.push(y);
				tempArry3.push(arry3[i]);
			}
		}
	}
	//画图
	for(var i=0;i<tempArry3.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160)/2,y1:tempArry3[i],  
			x2:(roadLen+160-600)/2,y2:tempArry2[i]
		});//x2固定,y2变化
	}
	
	var xwc1=xwc_sl(parseInt(r21),common_speed_r)*2;
	tempArry2=new Array();
	//查找交点
	for(var i=0;i<arry2.length;i++){
		var y= arry2[i]-xwc1;
		//temp.push(y);
		//var y=(arry3[i]) - xwc_sl(600,common_speed_r)*2;//3相交于2的 y轴坐标点
		for(var j=0;j<arry2.length;j++){
			if(arry1[j]==y){
				tempArry1.push(y);
				tempArry2.push(arry2[i]);
			}
		}
	}
	//画图
	for(var i=0;i<tempArry2.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160-600)/2,y1:tempArry2[i],  
			x2:(roadLen+160-roadLen)/2,y2:tempArry1[i]
		});//x2固定,y2变化
	} */
	
	//画图
	/* for(var i=0;i<tempArry1.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160)/2,y1:tempArry3[i],  
			x2:160/2,y2:tempArry1[i]
		});//x2固定,y2变化
	} */
	//for(var i=0;i<tempArry2.length;i++){
	//	$myCanvas.drawLine({
	//		strokeStyle:'RED',
	//		strokeWidth:1,
	//		x1:(roadLen+160)/2,y1:tempArry3[i],  
	//		x2:(roadLen+160-600)/2,y2:tempArry2[i]
			/* x1:(roadLen+160)/2,y1:tempArry[i]+60,//x1固定,y1变化  
			x2:(roadLen+160-600)/2,y2:(tempArry[i]+60) - xwc_sl(roadLen-600,common_speed_r)*2 */
	//	});//x2固定,y2变化
	//}
	
/* 	$myCanvas.drawLine({
		strokeStyle:'RED',
		strokeWidth:1,
		x1:(roadLen+160)/2,y1:arry3[i]+60,//x1固定,y1变化  
		x2:r21*2+40*2,y2:y
	});//x2固定,y2变化
	break;
 */
 	/* 
	for(var i=0;i<arry2.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'RED',
			strokeWidth:1,
			x1:(roadLen+160-600)/2,y1:arry2[i]+60,//x1固定,y1变化  
			x2:r11+40*2,y2:(arry2[i]+60) - xwc_sl(roadLen-600,common_speed_r)*2
		});//x2固定,y2变化
	} */
	
	
	
	//////////////////////////End////////////////////////////
	
	//上轴计算
	//y=x/speed+b
	//截距=(时间+相位差)-(距离/车速)
	/* var arr1=new Array();
	var a1 = parseInt($("#road_1_2").val())+parseInt($("#road_1_3").val()) - parseInt($("#road_1_1").val()) / (parseInt(common_speed_r)*1000/3600);
	var a2 = parseInt($("#road_2_2").val())+parseInt($("#road_2_3").val()) - ( parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed)*1000/3600);
	var a3 = parseInt($("#road_3_2").val())+parseInt($("#road_3_3").val()) - ( parseInt($("#road_3_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed)*1000/3600);
	arr1.push(a1);arr1.push(a2);arr1.push(a3);
	console.log(a1+","+a2+","+a3);
	var tempDown=arr1[0];
	for(var i=1;i<arr1.length;i++){
		if(tempDown>arr1[i]){//取最小截距值
			tempDown=arr1[i];
		}
	}
	if(tempDown<0)tempDown=0;
	console.log("temp:"+tempDown); */
	//下轴计算
	//y=x/speed+b
	//截距=(相位差)-(距离/车速)
	/* var arr2=new Array();
	var a1 = parseInt($("#road_1_3").val()) - parseInt($("#road_1_1").val()) / (parseInt(common_speed)*1000/3600);
	var a2 = parseInt($("#road_2_3").val()) - ( parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed_r)*1000/3600);
	var a3 = parseInt($("#road_3_3").val()) - ( parseInt($("#road_3_1").val())+parseInt($("#road_2_1").val())+parseInt($("#road_1_1").val()) ) / (parseInt(common_speed)*1000/3600);
	arr2.push(a1);arr2.push(a2);arr2.push(a3);
	console.log(a1+","+a2+","+a3);
	var tempUp=arr2[0];
	for(var i=1;i<arr2.length;i++){
		if(tempUp<arr2[i]){//取最大截距值
			tempUp=arr2[i];
		}
	}
	if(tempUp<0)tempUp=0;
	console.log("temp:"+tempUp); */
	
	//创建正向绿波带
	/* createLv_R($("#road_1_2").val(),tempUp,parseInt($("#road_1_2").val())-tempDown,common_cycle,roadLen,common_speed);
	$("#common_up").val(tempUp);
	$("#common_down").val(parseInt($("#road_1_2").val())-tempDown); */
}


// 创建反向绿波带
// lv_cycle3最后一个路口绿波宽度,cycle总周期,xwc最后一个路口
//createGreen_R(lv_cycle3,0,0,cycle,roadLen,speed,xwc);

 
 
 
//for(var i=0;i<lv_cycle*2;i++){
//	$('canvas').drawLine({
//		strokeStyle:'GREEN',
//		strokeWidth:1,
//		x1:80,y1:x_len-i,
//		x2:road_loc1,y2:x_len-time1-i
//	});
//}


/*$('canvas').drawText({
	  //fillStyle: 'gray',
	  strokeStyle: 'gray',
	  strokeWidth: 1,
	  x: 300, y: 200,
	  fontSize: 12,
	  //fontFamily: 'Verdana, sans-serif',
	  //两个像素为1秒
	  text: time1
	});*/
	


/*$('canvas').drawVector({
  strokeStyle: '#000',
  strokeWidth: 4,
  x: 40, y: 400,
  a1: 0, l1: 200
});*/
//////////////////////////////绿波轴///////////////////////////////////
/*STEP 3 变量*/
//路口A位置 80 为0起始
//var road_len=0;
//var road_loc=80+(road_len/2);
///*STEP 3 变量*/
//
//$myCanvas.drawLine({
//	strokeStyle:'RED',
//	strokeWidth:1,
//	x1:road_loc,y1:0,
//	x2:road_loc,y2:x_len
//});
//
///*STEP 4 变量*/
////周期(秒)
//var sum_c=40;
////绿波时长(秒)
//var green_len=20;
////相位差
//var xwc=0;
///*STEP 4 变量*/
//
//var cycle=x_len/(sum_c*2);
////var region=(50*2)-40;//非绿波时间
//var r_y1=x_len-(green_len*2);//2为固定值
//var r_y2=x_len;
//for(var i=0;i<cycle;i++){
//	$myCanvas.drawLine({
//		strokeStyle:'GREEN',
//		strokeWidth:10,
//		x1:road_loc,y1:r_y1-(sum_c*2)*i-xwc,
//		x2:road_loc,y2:r_y2-(sum_c*2)*i-xwc
//	});
//}
//////////////////////////////绿波轴///////////////////////////////////


//////////////////////////////绿波轴///////////////////////////////////
/*STEP 3 变量*/
//路口A位置 80 为0起始
//var road_len=800;
//var road_loc=80+(road_len/2);
///*STEP 3 变量*/
//
//$myCanvas.drawLine({
//	strokeStyle:'RED',
//	strokeWidth:1,
//	x1:road_loc,y1:0,
//	x2:road_loc,y2:x_len
//});
//
///*STEP 4 变量*/
////周期(秒)
//var sum_c=40;
////绿波时长(秒)
//var green_len=30;
////相位差
//var xwc=40;
///*STEP 4 变量*/
//
//var cycle=x_len/(sum_c*2);
////var region=(50*2)-40;//非绿波时间
//var r_y1=x_len-(green_len*2);//2为固定值
//var r_y2=x_len;
//for(var i=0;i<cycle;i++){
//	$myCanvas.drawLine({
//		strokeStyle:'GREEN',
//		strokeWidth:10,
//		x1:road_loc,y1:r_y1-(sum_c*2)*i-xwc,
//		x2:road_loc,y2:r_y2-(sum_c*2)*i-xwc
//	});
//}
//////////////////////////////绿波轴///////////////////////////////////
</script>
</body>
</html>