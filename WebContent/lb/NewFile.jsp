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
    <button onclick="autoR2()" type="button" class="layui-btn layui-btn-danger">反向绿波协调</button>
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
	  x: 40, y:x_len+20,
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
function commonCycle(){
	var v=$("#common_cycle_show").val()/4;
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
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX);//创建绿信
		roadName(i,roadLen/2+80,multipleX);//创建道路名称
	}
	var r3=$("#road_1_3").val();
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val(),r3,multipleX,multipleY);
}
//反向
function show2(){
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
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX);//创建绿信
		roadName(i,roadLen/2+80,multipleX);//创建道路名称
	}
	//创建反向绿波带
	createGreen_R(last2,parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),last3,multipleX,multipleY);	
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
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX);//创建绿信
		roadName(i,roadLen/2+80,multipleX);//创建道路名称
	}
	var r3=$("#road_1_3").val();
	//创建正向绿波带
	createGreen($("#road_1_2").val(),parseInt($("#common_up").val()),parseInt($("#common_down").val()),common_cycle,roadLen,$("#common_speed").val(),r3,multipleX,multipleY);
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
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX);//创建绿信
		roadName(i,roadLen/2+80,multipleX);//创建道路名称
	}
	//反向
	createGreen_R(last2,parseInt($("#common_up_r").val()),parseInt($("#common_down_r").val()),common_cycle,roadLen,$("#common_speed_r").val(),last3,multipleX,multipleY);
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
		createLoc(x_len,roadLen,common_cycle,r2,r3,multipleX);//创建绿信
		roadName(i,roadLen/2+80,multipleX);//创建道路名称
	}
	//上轴计算		//向下缩减
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
		//绿波时长+相位差-
		arr1.push(a1);
	}
	var tempDown=arr1[0];
	for(var i=1;i<arr1.length;i++){
		if(tempDown>arr1[i]){//取最小截距值
			tempDown=arr1[i];
		}
	}
	if(tempDown<0){
		tempDown=0;	
	}else{
		tempDown=tempDown;//																			
	}
	console.log("tempDown:"+tempDown);
	//下轴计算		//向上缩减
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
		var a1 = parseInt($("#road_"+i+"_3").val()) -  parseInt(roadLen) / (parseInt(common_speed)*1000/3600); 
				//相位差-路长/
		arr2.push(a1);
	}	
	var tempUp=arr2[0];
	for(var i=1;i<arr2.length;i++){
		if(tempUp<arr2[i]){//取最大截距值
			tempUp=arr2[i];
		}
	}
	if(tempUp<0){
		tempUp=0;	
	}else{
		tempUp=tempUp;//																				
	}
	console.log("tempUp:"+tempUp);
	
	//var r3=$("#road_1_3").val();
	//创建正向绿波带
	createGreen($("#road_1_2").val(),tempUp,parseInt($("#road_1_2").val())-tempDown,common_cycle,roadLen,common_speed,0,multipleX,multipleY);
	$("#common_up").val(tempUp);
	$("#common_down").val(parseInt($("#road_1_2").val())-tempDown);
	
	//绿波带宽计算
	var u=tempUp;
	var d=parseInt($("#road_1_2").val())-tempDown;
	var common_width=$("#common_width").val(parseInt($("#road_1_2").val())-u-d);
}

//反向绿波带计算 非自动计算相位差/////////////////////////BEGIN///////////////////////////////////
//1距离,2绿波带宽,3相位差
function autoR2(){
	var allArry=new Array();//每个路口绿波点集合
	var xwcArry=new Array();//路口相位差集合，倒序
	var common_speed_r=$("#common_speed_r").val();
	var common_cycle=$("#common_cycle").val();
	var x_len_plus=x_len;
	/////////////////////////////////////////自动计算相位差////////																			STEP1
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
		//$("#road_"+i+"_3").val(Math.round(xwc));
		roadLen+=parseInt(r1);
		xwc=Math.round(xwc*2);//相位差统计
		xwcArry.push(xwc/multipleY);													//MODIFY 4						
	}
	
	/////////////////////////////////////////自动计算相位差////////
	//////////////////////////创建路口////////////////////////////																			STEP2
	var roadLenR=0;	
	for(var i=1;i<=20;i++){
		var r1=$("#road_"+i+"_1").val();
		var r2=$("#road_"+i+"_2").val();
		var r3=$("#road_"+i+"_3").val();
		if(r1==""||r1==null){
			//console.log("结束："+i);
			break;
		}
		roadLenR+=parseInt(r1);
		createLoc(x_len_plus,roadLenR,common_cycle,r2,r3,multipleX);//创建绿信
		roadName(i,roadLenR/2+80,multipleX);//创建道路名称
	}
	
	///////////////////////////// 所有路口点位 /////////////////////																		STEP3
	for(var k=1;k<=20;k++){
		//	     路口距离
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
		var differ=parseInt(common_cycle)*2-r12*2/multipleY;		//总周期-绿波时长							//MODIFY 4	
		for(var i=0;i<x_len_plus/parseInt(common_cycle);i++){//判断几个大周期
			if(i==0){
				differ=0;
			}else{
				differ=parseInt(common_cycle)*2-r12*2/multipleY;    //总周期-绿波时长							//MODIFY 4
			}
			for(var j=1;j<=r12*2/multipleY;j++){															//MODIFY 4
				arry1.push( parseInt(x_len_plus - (r13/multipleY+j + differ + base)-r13/multipleY) );				//MODIFY 4
				//base=r13+j + i*differ + base;
				//console.log("x_len:"+x_len +" r13："+ r13+" j:"+j +" differ："+ differ +" base："+ base+" r13:"+r13);
				if(j==r12*2/multipleY){																		//MODIFY 4
					base=r13/multipleY+j + differ + base-r13/multipleY;												//MODIFY 4	
					//console.log(base);
				}
			}
		}
		//console.log(arry1);
		allArry.push(arry1);
	}
	//console.log(allArry);
	//////////////////////////////// 所有路口点位  ///////////////
	var arry1=allArry[0];
	var arry2=allArry[1];
	var arry3=allArry[2];
	var beginArry=new Array();
	for(var i=0;i<allArry.length;i++){//找出最后一个路口,反向第一个。																	STEP4
		if(allArry[i].length>0){
			beginArry=allArry[i];
		}
	}
	
	var tempArry1=new Array();
	var tempArry2=new Array();
	var tempArry3=new Array();
	var tempArry3_2=new Array();
	///////////////////////查找交点////////////////////////																		STEP5
	var jdArry=new Array();
	var jdArry_L=new Array();
	for(var i=0;i<21;i++){//构造数组
		jdArry.push(new Array());
		jdArry_L.push(new Array());
	}
	xwcArry.reverse();
	console.log("beginArry:"+beginArry);
	console.log("xwcArry:"+xwcArry);
	for(var i=0;i<x_len_plus;i++){//大周期绿波
		for(var j=0;j<x_len_plus;j++){//单条绿波
			
			for(var k=1;k<=xwcArry.length;k++){//所有路口相位差计算																	STEP6
				if( allArry[k-1][j]== parseInt(beginArry[i]-xwcArry[k-1]) ){//arry2[j]==y&& 判断路口3交点
					jdArry[k].push( parseInt(beginArry[i]-xwcArry[k-1]) );//1,倒数第二个路口，2代数第三个路口.3..4..5..
					jdArry_L[k].push( beginArry[i] );
					//tempArry1.push(y1);
					//tempArry1_1.push(arry3[i]);
					
				}	
			}
			
		}
	}
	console.log(jdArry);
	console.log(jdArry_L);
	
	var tempAllF=new Array();
	var tempAll=new Array();
	//只保留一个
	//for(var i=0;i<beginArry.length;i++){//以倒序起始路口数量为依据循环查找
	for(var i=0;i<x_len_plus;i++){//以倒序起始路口数量为依据循环查找
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
		if(jdArry_L[n].length<=0&&n<=xwcArry.length){//判断某个路口是否没有绿波相交点
			return;			
		}
		if(jdArry_L[n].length<=0){
			continue;			
		}
		var flag=0;
		for(var i=0;i<x_len_plus;i++){//以倒序起始路口数量为依据循环查找
			for(var j=0;j<jdArry_L[1].length;j++){
				if(tempAll[i]==jdArry_L[n][j]){
					temp.push(tempAll[i]);
					tempF.push(tempAllF[i]);
					flag++;//有重合
				}
			}
		}
		if(flag==0){//没有交点
			return;
		}else{
			flag=0;//重新进入下次循环计算
		}
		tempAll=temp;
		tempAllF=tempF;
	}
	
	//画图 ALL
	for(var i=0;i<tempAll.length;i++){
		$myCanvas.drawLine({
			strokeStyle:'#7CFC00',
			strokeWidth:1,
			x1:(roadLen/multipleX+160)/2,y1:tempAll[i],							//MODIFY 4  
			x2:(roadLen/multipleX+160-roadLen/multipleX)/2,y2:tempAllF[i]				//MODIFY 4
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
					$("#common_width_r").val( ((numVal+1) / 2)*multipleY );//反向绿波带宽		//MODIFY 4	
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