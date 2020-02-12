<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="f"  uri="http://java.sun.com/jsf/core"%>
<%@ taglib prefix="h"  uri="http://java.sun.com/jsf/html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript">
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
		clearBottom();
		yCreate(x_len,y_len,multipleY);
		//end//
	
}
//////////////////////////////反向自动计算//////////////////////////////////////////////

</script>
</body>
</html>