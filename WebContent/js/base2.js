/////////////创建文本///////////////
function roadName(name,locX){
	$myCanvas.drawText({
	  fillStyle: 'black',
	  strokeStyle: '#CD950C',
	  //strokeWidth: 1,
	  //x: 200, y:x_len+60,
	  x: locX, y:x_len+40,
	  fontSize: 15,
	  //fontFamily: 'Georgia, serif',
	  text: "路口"+name
	});
}
/////////////创建文本///////////////
/**创建X轴**/
function xCreate(x_len){
	/*STEP 1 变量*/
	//X轴长度  200为变量值
	/*STEP 1 变量*/
	$myCanvas.drawLine({
		strokeStyle:'#000',
		strokeWidth:1,
		x1:40,y1:0,
		x2:40,y2:x_len
	});
	//X轴刻度距离
	var x_area=20;
	var forTimes=x_len;
	for(var i=1;i<=x_len/x_area;i++){
		forTimes=x_len-(i*x_area);
		$myCanvas.drawLine({
			strokeStyle:'#000',
			strokeWidth:1,
			x1:30,y1:i*x_area,
			x2:40-1,y2:i*x_area
		});
		
		$('canvas').drawText({
		  //fillStyle: 'gray',
		  strokeStyle: 'gray',
		  strokeWidth: 1,
		  x: 20, y: i*x_area,
		  fontSize: 12,
		  //fontFamily: 'Verdana, sans-serif',
		  //两个像素为1秒
		  text: forTimes/2
		});
	}
}
/**创建Y轴**/
function yCreate(x_len,y_len){
	//Y轴 //40为偏移量 880 为变量值
	
	/*STEP 2 变量*/
	$myCanvas.drawLine({
		strokeStyle:'#000',
		strokeWidth:1,
		x1:40,y1:x_len,
		x2:y_len,y2:x_len
	});
	//Y轴刻度距离
	var y_area=40;
	var forTimes=y_len;
	for(var i=1;i<y_len/y_area;i++){
		forTimes=y_len-(i*y_area);
		$myCanvas.drawLine({
			strokeStyle:'#000',
			strokeWidth:1,
			x1:i*y_area+40,y1:x_len,
			x2:i*y_area+40,y2:x_len+10
		});
		
		$('canvas').drawText({
		  //fillStyle: 'gray',
		  strokeStyle: 'gray',
		  strokeWidth: 1,
		  x: i*y_area+40, y: x_len+20,
		  fontSize: 12,
		  //fontFamily: 'Verdana, sans-serif',
		  //两个像素为1秒
		  text: (i-1)*y_area*2								
		});
	}
}

				 //X轴长度,路口位置,  总周期,绿波时长,   相位差
function createLoc(x_len,road_len,sum_c,green_len,xwc){
	//////////////////////////////绿波轴///////////////////////////////////
	/*STEP 3 变量*/
	//路口A位置 80 为0起始
	//var road_len=800;
	var road_loc=80+(road_len/2);						
	/*STEP 3 变量*/
	
	$myCanvas.drawLine({
		strokeStyle:'RED',
		strokeWidth:1,
		x1:road_loc,y1:0,
		x2:road_loc,y2:x_len
	});
	
	/*STEP 4 变量*/
	//周期(秒)
	//var sum_c=40;
	//绿波时长(秒)
	//var green_len=30;
	//相位差
	//var xwc=40;
	/*STEP 4 变量*/
	
	var cycle=x_len/(sum_c*2);
	//var region=(50*2)-40;//非绿波时间
	var r_y1=x_len-(green_len*2);//2为固定值
	var r_y2=x_len;
	for(var i=0;i<cycle;i++){
		$myCanvas.drawLine({
			strokeStyle:'#228B22',
			strokeWidth:10,
			x1:road_loc,y1:r_y1-(sum_c*2)*i-(xwc*2),
			x2:road_loc,y2:r_y2-(sum_c*2)*i-(xwc*2)
		});
	}
	//////////////////////////////绿波轴///////////////////////////////////
}
//根据路程,车速计算相位差
function xwc_sl(lenEnd,speed){
	var time_xwc=lenEnd/(speed*1000/3600);
	return time_xwc;
}

////////////////////////创建正向绿波带////////////////////////
//绿波带宽度（小）		  绿波时长,   上偏移量,绿波周期,路口距离，绿波周期
function createLv(lv_cycle,upAdd,downSub,sum_c,lenEnd,speed,xwc){
	var time=(lenEnd*2)/(speed*1000/3600);								 //  MODIFY	 4
	//time=time*2;//X轴偏移量修正，20像素 实际 40像素
	for(var i=0;i<(lv_cycle-downSub-upAdd)*2;i++){
		$('canvas').drawLine({
			strokeStyle:'#7CFC00',
			strokeWidth:1,
			x1:80,y1:x_len-(sum_c*2)-i-upAdd*2-xwc*2,
			x2:80+(lenEnd/2),y2:x_len-(sum_c*2)-time-i-upAdd*2-xwc*2,    //    MODIFY   4
		});
	}
}
//绿波带条数(大)			  绿波周期,向上偏移量,向下偏移量,总周期,总路程,  车速
function createGreen(lv_cycle,upAdd,downSub,sum_c,lenEnd,speed,xwc){	
	for(var i=0;i<y_len/sum_c;i++){
	//	createLv(lv_cycle1,road_loc1,sum_c2*i);	
		createLv(lv_cycle,upAdd,downSub,sum_c*i,lenEnd,speed,xwc);	
	
	}
}
////////////////////////创建正向绿波带////////////////////////

//创建反向绿波带
//绿波时长，路口距离，绿波周期
function createLv_R(lv_cycle,upAdd,downSub,sum_c,lenEnd,speed,xwc){
	var time=(lenEnd*2)/(speed*1000/3600);
	//time=time*2;//X轴偏移量修正，20像素 实际 40像素
	for(var i=0;i<(lv_cycle-upAdd-downSub)*2;i++){
		$('canvas').drawLine({
			strokeStyle:'#7CFC00',
			strokeWidth:1,
			x1:(lenEnd/2)+80,y1:x_len-(sum_c*2)-i-upAdd*2-xwc*2,
			x2:(lenEnd/2)+(lenEnd/2)-lenEnd+80,y2:x_len-(sum_c*2)-time-i-upAdd*2-xwc*2
		});
	}
}
//绿波周期，向上偏移量，向下偏移量，周期，总路程，车速
function createGreen_R(lv_cycle,upAdd,downSub,sum_c,lenEnd,speed,xwc){	
	for(var i=0;i<y_len/sum_c;i++){
	//	createLv(lv_cycle1,road_loc1,sum_c2*i);	
		createLv_R(lv_cycle,upAdd,downSub,sum_c*i,lenEnd,speed,xwc);	
	
	}
}
//创建反向绿波带