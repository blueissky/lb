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
    <button onclick="clearPanel()" type="button" class="layui-btn">清除</button>
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
		$("#roadPanel").html('<%=request.getAttribute("roadPanel")%>');
	});
</script>
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

////////////////////////1距离,2绿波带宽,3相位差//////////////////////
function show(){
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
		createLoc(x_len,roadLen,common_cycle,r2,r3);//创建绿信
		roadName(i,roadLen/2+80);//创建道路名称
	}
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val());
	//创建反向绿波带
	createGreen_R(last2,parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),last3);	
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
		createLoc(x_len,roadLen,common_cycle,r2,r3);//创建绿信
		roadName(i,roadLen/2+80);//创建道路名称
	}
	
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val());
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
		createLoc(x_len,roadLen,common_cycle,r2,r3);//创建绿信
		roadName(i,roadLen/2+80);//创建道路名称
	}
	//反向
	createGreen_R(last2,parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),last3);
}

//////////////////////////////正向自动计算//////////////////////////////////////////////
//1距离,2绿波带宽,3相位差
function autoZ(){
	var common_speed=$("#common_speed").val();
	var common_cycle=$("#common_cycle").val();
	//路段长度
	var roadLen=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		roadLen+=parseInt(r1);
		createLoc(x_len,roadLen,common_cycle,r2,r3);//创建绿信
		roadName(i,roadLen/2+80);//创建道路名称
	}
	//上轴计算
	//y=x/speed+b
	//截距=(时间+相位差)-(距离/车速)
	var arr1=new Array();
	roadLen=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		roadLen+=parseInt(r1);
		var a1 = parseInt($("#road_"+i+"_2").val())+parseInt($("#road_"+i+"_3").val()) - parseInt(roadLen) / (parseInt(common_speed)*1000/3600);
		arr1.push(a1);
	}
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
	roadLen=0;
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			console.log("结束："+i);
			continue;
		}
		roadLen+=parseInt(r1);
		var a1 = parseInt($("#road_"+i+"_3").val()) - parseInt(roadLen) / (parseInt(common_speed)*1000/3600);
		arr2.push(a1);
	}	
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
	var allArry=new Array();//每个路口绿波点集合
	var xwcArry=new Array();//路口相位差集合，倒序
	var common_speed_r=$("#common_speed_r").val();
	var common_cycle=$("#common_cycle").val();
	/////////////////////////////////////////自动计算相位差///////////////////////////////////////////
	//路段长度
	var roadLen=0;
	for(var i=20;i>=1;i--){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			//console.log("结束："+i);
			continue;
		}
		var xwc=xwc_sl(roadLen,common_speed_r);//路口1,2
		$("#road_"+i+"_3").val(Math.round(xwc));
		roadLen+=parseInt(r1);
				
		xwc=Math.round(xwc*2);
		xwcArry.push(xwc);
	}
	
	/////////////////////////////////////////自动计算相位差///////////////////////////////////////////
	//////////////////////////创建路口////////////////////////////
	roadLen=0;	
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			//console.log("结束："+i);
			break;
		}
		roadLen+=parseInt(r1);
		createLoc(x_len,roadLen,common_cycle,r2,r3);//创建绿信
		roadName(i,roadLen/2+80);//创建道路名称
	}
	
	///////////////////////////// 所有路口点位 /////////////////////////////////////////////////////
	for(var k=1;k<=20;k++){
		var r11=parseInt($("#road_"+k+"_1").val());
		//路口1 绿波时长
		var r12=parseInt($("#road_"+k+"_2").val());
		//路口1 相位差
		var r13=parseInt($("#road_"+k+"_3").val());
		//console.log(k+"--"+r11);
		//if(r11==""||r11==null){
			//console.log("结束："+i);
		//	continue;
		//}
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
				//console.log("x_len:"+x_len +" r13："+ r13+" j:"+j +" differ："+ differ +" base："+ base+" r13:"+r13);
				if(j==r12*2){
					base=r13+j + differ + base-r13;
					//console.log(base);
				}
			}
		}
		//console.log(arry1);
		allArry.push(arry1);
	}
	//console.log(allArry);
	//////////////////////////////// 所有路口点位  //////////////////////////////////////////////////
	var arry1=allArry[0];
	var arry2=allArry[1];
	var arry3=allArry[2];
	var beginArry=new Array();
	for(var i=0;i<allArry.length;i++){//找出最后一个路口
		if(allArry[i].length>0){
			beginArry=allArry[i];
		}
	}
	//console.log(arry1);
	//console.log(arry2);
	//console.log(arry3);
	/* 
	var tempArry1=new Array();
	var tempArry2=new Array();
	var tempArry1_1=new Array();
	var tempArry2_2=new Array();
	 */
	
	var tempArry1=new Array();
	var tempArry2=new Array();
	var tempArry3=new Array();
	var tempArry3_2=new Array();
	//y=x/a+b
	//b 3的绿波点值
	
	//var temp=new Array();
	//var xwc=xwc_sl(roadLen-100,common_speed_r)*2;//路口1,2
	//var xwc1=xwc_sl(parseInt(roadLen),common_speed_r)*2;//路口2,3
	//xwc=Math.round(xwc);
	//xwc1=Math.round(xwc1);

	//console.log("arry2:"+arry2);
	//console.log("arry1:"+arry1);
	///////////////////////查找交点////////////////////////
	var jdArry=new Array();
	var jdArry_L=new Array();
	for(var i=0;i<21;i++){//构造数组
		jdArry.push(new Array());
		jdArry_L.push(new Array());
	}
	xwcArry.reverse();
	for(var i=0;i<x_len;i++){//大周期绿波
		//var y= arry3[i]-xwcArry[1]; //路口2
		//var y1= arry3[i]-xwcArry[2]; //路口3
		//temp.push(y);
		//var y=(arry3[i]) - xwc_sl(600,common_speed_r)*2;//3相交于2的 y轴坐标点
		for(var j=0;j<x_len;j++){//单条绿波
			
		 /*   if(arry2[j]==arry3[i]-xwcArry[1]){//判断路口2交点
			   tempArry2.push(arry2[j]);
			   tempArry3_2.push(arry3[i]);
			}
			
			if(arry1[j]==arry3[i]-xwcArry[2]){//arry2[j]==y&& 判断路口3交点
				tempArry1.push(arry1[j]);
				tempArry3.push(arry3[i]);
			} */
		
			for(var k=1;k<=xwcArry.length;k++){//所有路口相位差计算
				if(allArry[k-1][j]==beginArry[i]-xwcArry[k-1]){//arry2[j]==y&& 判断路口3交点
					jdArry[k].push(beginArry[i]-xwcArry[k-1]);//1,倒数第二个路口，2代数第三个路口.3..4..5..
					jdArry_L[k].push(beginArry[i]);
					//tempArry1.push(y1);
					//tempArry1_1.push(arry3[i]);
					
				}	
			}
			
		}
	}
	
	tempArry2=jdArry[2];
	tempArry3_2=jdArry_L[2];
	
	tempArry1=jdArry[1];
	tempArry3=jdArry_L[1];
	
	var tempAllF=new Array();
	var tempAll=new Array();
	/* //只保留一个
	for(var i=0;i<arry3.length;i++){
		for(var j=0;j<tempArry3.length;j++){
			if(tempArry3[i]==tempArry3_2[j]){
				tempAll.push(tempArry3[i]);
				tempAllF.push(tempArry1[i]);
			}
		}
	} */
	console.log(beginArry);
	console.log(jdArry_L);
	
	//只保留一个
	/* console.log(jdArry_L[1]);
	console.log(jdArry_L[2]); */
	//for(var i=0;i<beginArry.length;i++){//以倒序起始路口数量为依据循环查找
	for(var i=0;i<x_len;i++){//以倒序起始路口数量为依据循环查找
			//for(var j=0;j<jdArry_L[1].length;j++){
			for(var j=0;j<jdArry_L[1].length;j++){
				if(jdArry_L[1][i]==jdArry_L[2][j]){
					tempAll.push(jdArry_L[1][i]);
					tempAllF.push(jdArry[1][i]);
				}
			}
	}
	for(var n=3;n<=20;n++){
		var temp=new Array();
		var tempF=new Array();
		if(jdArry_L[n].length<=0){
			continue;			
		}
		for(var i=0;i<x_len;i++){//以倒序起始路口数量为依据循环查找
			for(var j=0;j<jdArry_L[1].length;j++){
				if(tempAll[i]==jdArry_L[n][j]){
					temp.push(tempAll[i]);
					tempF.push(tempAllF[i]);
				}
			}
		}
		tempAll=temp;
		tempAllF=tempF;
	}
	
	
/* 	var temp=new Array();
	var tempF=new Array();
	for(var i=0;i<x_len;i++){//以倒序起始路口数量为依据循环查找
		for(var j=0;j<jdArry_L[1].length;j++){
			if(tempAll[i]==jdArry_L[4][j]){
				temp.push(tempAll[i]);
				tempF.push(tempAllF[i]);
			}
		}
	}
	tempAll=temp;
	tempAllF=tempF;
 	*/
 	
	//console.log(arry3);
	//console.log(tempArry3);
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
	
	
	
}	
	
//////////////////////////////绿波轴///////////////////////////////////
</script>
</body>
</html>