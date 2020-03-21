<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common.jsp" %>

<script src = "https:www.google.com/jsapi"></script>
<script type="text/javascript" src="https:www.gstatic.com/charts/loader.js"></script>
    
<!DOCTYPE html>
<html lang="ko">

<head>
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:100,200,300,350,400,500,600,700,800,900&display=swap" rel="stylesheet">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="">
  <meta name="author" content="Dashboard">
  <meta name="keyword" content="Dashboard, Bootstrap, Admin, Template, Theme, Responsive, Fluid, Retina">
  <title>mainPage-bookstreet</title>

   <!-- Favicons -->
  <link href="${ctRootImg}/favicon.png" rel="icon">
  <link href="${ctRootImg}/apple-touch-icon.png" rel="apple-touch-icon">
  <!-- Bootstrap core CSS -->
  <link href="${ctRootlib}/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!--external css-->
  <link href="${ctRootlib}/font-awesome/css/font-awesome.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="${ctRootcss}/zabuto_calendar.css">
  <!-- Custom styles for this template -->
  <link href="${ctRootcss}/style.css" rel="stylesheet">
  <link href="${ctRootcss}/style-responsive.css" rel="stylesheet">
  <script src="${ctRootlib}/chart-master/Chart.js"></script>
  <script src = "https://www.google.com/jsapi"></script>
  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <!-- js placed at the end of the document so the pages load faster -->
  <script src="${ctRootlib}/jquery/jquery.min.js"></script>
  <script src="${ctRootlib}/bootstrap/js/bootstrap.min.js"></script>
  <script class="include" type="text/javascript" src="${ctRootlib}/jquery.dcjqaccordion.2.7.js"></script>
  <script src="${ctRootlib}/jquery.scrollTo.min.js"></script>
  <script src="${ctRootlib}/jquery.nicescroll.js" type="text/javascript"></script>
  
  <script type="text/javascript">
	   //차트 버전을 최신으로 불러옴
	   google.charts.load('current', {'packages' : ['corechart'] } );
	   //차트를 로드
	   google.charts.setOnLoadCallback(drawChartSellingStat);
	
	   // 월별 판매 부수 Selling statistics (데이터 setting, 옵션 setting, 차트 그리는 역할)
	   function drawChartSellingStat(){
		   
		   // 데이터 setting
		   var sellingStat_data = google.visualization.arrayToDataTable([
					['Month', '판매부수']
			  	  	,["${mainChartsDTO.sellingStat[0].title}", (${mainChartsDTO.sellingStat[0].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[1].title}", (${mainChartsDTO.sellingStat[1].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[2].title}", (${mainChartsDTO.sellingStat[2].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[3].title}", (${mainChartsDTO.sellingStat[3].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[4].title}", (${mainChartsDTO.sellingStat[4].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[5].title}", (${mainChartsDTO.sellingStat[5].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[6].title}", (${mainChartsDTO.sellingStat[6].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[7].title}", (${mainChartsDTO.sellingStat[7].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[8].title}", (${mainChartsDTO.sellingStat[8].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[9].title}", (${mainChartsDTO.sellingStat[9].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[10].title}", (${mainChartsDTO.sellingStat[10].cnt})]
			  	  	,["${mainChartsDTO.sellingStat[11].title}", (${mainChartsDTO.sellingStat[11].cnt})]
			]);
		
		   	// 옵션 setting
			var sellingStat_option = {
		         height: 400
		         ,colors:['#fba14c','#fba14c', 'opacity: 0.2']
		         ,animation:{
		              startup: true,
		              duration: 1000,
		              easing: 'out',
		         }
		         ,backgroundColor: {
		             fill: '#eaeaea',
		             fillOpacity: 0
		         }
				 ,chartArea: {'width': '80%', 'height': '80%'}
	             ,legend: {'position': 'right', textStyle: {fontSize:13, color: '#797979', fontName:'Noto Sans KR'}}
		         ,hAxis: { textStyle:{color: '#797979'}, gridlines: {color: "white"}, baselineColor: 'white'} 
	             ,vAxis: { textStyle:{color: '#797979'}, baselineColor: 'lightgray', titleTextStyle: {color: '#797979'} }
			};//----sellingStat_option end
			
			// 차트 그리기
			var sellingStat_chart = new google.visualization.ColumnChart(document.getElementById('sellingStat'));
	 		sellingStat_chart.draw(sellingStat_data, sellingStat_option);
	  			
		}//----function drawChartSellingStat end
		
		
		
		
		  // 부트스트랩 템플릿 내의 캘린더 출력 / 상단바 시계 및 페이지 재로드
		  $(document).ready(function() {
			  
			  startTime(); 	//1초마다 시계 역할하는 함수 호출
			  pageReload(); //차트 데이터를 위해 10분마다 페이지 재로드
			  
		      $("#date-popover").popover({
		        html: true,
		        trigger: "manual"
		      });
		      
		      $("#date-popover").hide();
		      $("#date-popover").click(function(e) {
		        $(this).hide();
		      });
	
		      $("#my-calendar").zabuto_calendar({
		        action: function() {
		          return myDateFunction(this.id, false);
		        },
		        action_nav: function() {
		          return myNavFunction(this.id);
		        },
		        legend: [{
		            type: "text",
		            label: "Special event",
		            badge: "00"
		          },
		          {
		            type: "block",
		            label: "Regular event",
		          }
		        ]
		      });
		    }); //--------------document ready 끝
	
		    function myNavFunction(id) {
		      $("#date-popover").hide();
		      var nav = $("#" + id).data("navigation");
		      var to = $("#" + id).data("to");
		      console.log('nav ' + nav + ' to: ' + to.month + '/' + to.year);
		    }
		    
			function showTime() {
			    //현재 날짜를 관리하는 Date 객체 생성
			    var today = new Date();
			    //----------------------------------------
			    //Date 객체에서 날짜 관련 각 데이터를 꺼내어 저장하는 변수 선언
			    var amPm = "오후";
			    var year = today.getFullYear();
			    var month = today.getMonth()+1;
			    var week = today.getDay();
			    var date = today.getDate();
			    var hour = today.getHours();
			    var minute = today.getMinutes();
			    var second = today.getSeconds();
			
			    var week = ["일", "월", "화", "수", "목", "금", "토"][week];
			    //날짜 관련 각 데이터가 10 미만이면 앞에 0 붙이기
			    //오전, 오후 여부 판단해서 저장하기
			    if(month<10) {
			       month = "0"+month;
			    }
			
			    if(date<10) {
			       date = "0"+date;
			    }
			
			    if(hour<12) {
			       amPm = "오전";
			    }
			
			    if(hour>12) {
			       hour=hour-12;
			    }
			
			    if(hour<10) {
			       hour="0"+hour;
			    }
			
			    if(minute<10) {
			       minute = "0"+minute;
			    }
			
			    if(second<10) {
			       second = "0" + second;
			    }
			    //id="nowTime"가 있는 태그영역 내부에 시간 문자열 삽입
			    document.getElementById("nowTime").innerHTML = year+"년 "+month+"월 "+date+"일("+week+") "+amPm+" "+hour+"시 "+minute+"분 "+second+"초 ";
			    
			 }
			
			 function startTime() {
				showTime();//1초 딜레이 되어 시간이 표시되는 현상을 제거하기 위해 showTime() 함수를 한 번 호출한다.
				//-----------------------------------
				//1초마다 showTime() 함수를 호출하기
				//-----------------------------------
				window.setInterval("showTime()", 1000);//window.setInterval(function() { showTime(); }, 1000);
			 }
			 
			 // 10분마다 페이지를 reload하여 차트 데이터 업데이트 하기
			 function pageReload(){  
			      setTimeout('location.reload()',600000); 
			}
	</script>
	<style>
		:root {
		  --blue : #1B9DD9;
		  --grey : #F5F6FA;
		  --light-grey : #707070;
		  --dark-grey : #5F5F5F;
		  --border-radius : 20px;
		  --green : #BCCF11;
		  --red : #E20D18;
		  --yellow : #eab71b;
		  --silver : #C1C1C1;
		  --bronze : #AC7D18;
		}
		html, body {
		  margin: 0;
		  font-family: 'Montserrat', sans-serif;
		  /* background-color : var(--grey); */
		}
		#app {
		  height : 80em;
		  width : 10vw;
		  /* margin-top : 1em; */
		  display : grid;
		}
		.slider-container {
		  border-radius : 10px;
		  display : flex;
		  width : 15em;
		  margin-left: auto;
		  margin-right: auto;
		  background-color : white;
		  color : var(--dark-grey);
		}
		.slider-container .option {
		  border-radius : 10px;
		  width : 5em;
		  margin : 0em;
		  padding : 1em;
		  text-align : center;
		}
		.slider-container .option.highlighted {
		  background-color : var(--red);
		  color : white;
		}
		.podium-places-container {
		  display: flex;
		  width : 50%;
		  margin-left: auto;
		  margin-right : auto;
		  justify-content : center;
		}
		.podium {
		  display : grid;
		  grid-template-columns: 1fr 3fr;
		  width : 15em;
		  background-color : white;
		  margin : 2.5em;
		  border-radius : 20px;
		  color : white;
		}
		.podium .position {
		  border-right-style: solid;
		  border-color: var(--grey);
		  border-width : .4em;
		
		}
		.podium .position {
		  width : 3em;
		  position : relative;
		}
		.podium.gold .position {
		  width : 5em;
		}
		.podium .class-information {
		 padding : .5em;
		}
		.podium.bronze, .podium.silver {
		  width : 13.5em;
		  height : 7em;
		  margin-top : 5em;
		}
		.podium.silver .position div,
		.podium.bronze .position div {
		  position : absolute;
		  top : .2em;
		  left : .1em;
		  font-size : 4em;
		}
		.podium.gold .position div {
		  position : absolute;
		  top : .1em;
		  left : .1em;
		  font-size : 6em;
		}
		.podium.bronze .class-information .title, .podium.silver .class-information .title {
		  margin-top : .1em;
		  font-size : 1.1em;
		}
		.podium.bronze .class-information .steps, .podium.silver .class-information .steps {
		  margin-top : .1em;
		  font-size : 1.1em;
		}
		.podium.gold .class-information .title {
		  margin-top : .1em;
		  font-size : 1.4em;
		}
		.podium.gold .class-information .steps {
		  margin-top : .1em;
		  font-size : 1.4em;
		}
		.podium.bronze {
		  background-color : var(--bronze);
		}
		.podium.silver {
		  background-color : var(--silver);
		}
		.podium.gold {
		  background-color : var(--yellow);
		  height : 9em;
		  width : 20em;
		}
		.leaderboards-container{
			height:30%
		}
		.nullDiv{
			margin-top:0;
			margin-bottom:0;
			padding-top:0;
			padding-bottom:0;
		}
		.cat-name{
			color : black;
		}
		.title{
			font-weight:bold;
		}
		.steps{
			text-align:right;
		}
	</style>
</head>


<body>
  <section id="container">
     <!-- **********************************************************************************************************************************************************
        TOP BAR CONTENT & NOTIFICATIONS
        *********************************************************************************************************************************************************** -->
    <!--header start-->
    <header class="header black-bg">
      <div class="sidebar-toggle-box">
        <div class="fa fa-bars tooltips" data-placement="right" data-original-title="Toggle Navigation"></div>
      </div>
      <!--logo start-->
      <a href="/group4erp/goMain.do" class="logo"><b>BOOK<span>STREET</span></b></a>
      <!--logo end-->
      <div class="nav notify-row" id="top_menu">
        <!--  notification start -->
        <ul class="nav top-menu">
          <!-- settings start -->
          <!-- notification dropdown end -->
          <li>
          </li>
        </ul>
        <!--  notification end -->
      </div>
      <div class="top-menu">
        <ul class="nav pull-right top-menu">
          <li>
             <a class="logout" href="/group4erp/logout.do">Logout</a>
          </li>
        </ul>
      </div>
      <div class="top-menu">
        <ul class="nav pull-right top-menu">
          <li style="margin-top: 10px; margin-right: 20px;">
             <font style="color:#D8E8E4;"><h4><span id="nowTime" align="right"></span> </h4></font>
          </li>
        </ul>
      </div>
    </header>
    <!--header end-->
    <!-- **********************************************************************************************************************************************************
        MAIN SIDEBAR MENU
        *********************************************************************************************************************************************************** -->
    <!--sidebar start-->
    <aside>
      <div id="sidebar" class="nav-collapse ">
        <!-- sidebar menu start-->
        <ul class="sidebar-menu" id="nav-accordion">
          <p class="centered">
            <a href="/group4erp/goMain.do"><img src="/group4erp/resources/image/logo_sidebar.png"  width="80"></a>
          </p>
          <h4 class="centered"><b><font style="color:lightgray">${emp_name} ${jikup}님</font></b></h4>
          <li class="mt">
            <a class="active" href="/group4erp/goMain.do">
              <i class="fa fa-dashboard"></i>
              <span>메인페이지</span>
              </a>
          </li>
          <li class="sub-menu">
            <a href="javascript:;">
              <i class="fa fa-desktop"></i>
              <span>업무 관리</span>
              </a>
            <ul class="sub">
              <li>
                <a href="/group4erp/goMyCareBookList.do"><i class="fa fa-book"></i>담당 도서 조회</a>
              </li>
              <li>
                <a href="/group4erp/businessTripList.do"><i class="fa fa-briefcase"></i>출장 신청</a>
              </li>
              <li>
                <a href="/group4erp/viewApprovalList.do"><i class="fa fa-pencil"></i>문서 결재</a>
              </li>
              <li>
                <a href="/group4erp/goEmpDayOffjoin.do"><i class="fa fa-edit"></i>휴가 신청</a>
              </li>
            </ul>
          </li>
          <li class="sub-menu">
            <a href="javascript:;">
              <i class="fa fa-shopping-cart"></i>
              <span>재고 관리</span>
              </a>
            <ul class="sub">
              <li>
                <a href="/group4erp/goBookList.do"><i class="fa fa-info-circle"></i>도서정보조회</a>
              </li>
              <li>
                <a href="/group4erp/goReleaseList.do"><i class="fa fa-list"></i>출고현황조회</a>
              </li>
              <li>
                <a href="/group4erp/goWarehousingList.do"><i class="fa fa-list"></i>입고현황조회</a>
              </li>
              <li>
                <a href="/group4erp/goReturnOrderList.do"><i class="fa fa-list"></i>반품현황조회</a>
              </li>
            </ul>
          </li>
          <li class="sub-menu">
            <a href="javascript:;">
              <i class="fa fa-calendar"></i>
              <span>마케팅 관리</span>
              </a>
            <ul class="sub">
              <li>
                <a href="/group4erp/viewSalesInfoList.do"><i class="fa fa-money"></i>판매현황</a>
              </li>
              <li>
                <a href="/group4erp/viewEventList.do"><i class="fa fa-gift"></i>이벤트행사 현황</a>
              </li>
            </ul>
          </li>
          <li class="sub-menu">
            <a href="javascript:;">
              <i class="fa fa-users"></i>
              <span>인사 관리</span>
              </a>
            <ul class="sub">
              <li>
                <a href="/group4erp/viewEmpList.do"><i class="fa fa-info-circle"></i>직원정보</a>
              </li>
              <c:if test="${emp_id eq '600001'}">
                   		<li>
              				<a href="/group4erp/viewSalList.do"><i class="fa fa-file"></i>급여지급대장 조회</a>
              			</li>	
              			<li>
              				<a href="/group4erp/viewEmpSalInfo.do"><i class="fa fa-file"></i>급여명세서 조회</a>
              			</li>	
                   </c:if>
                   
                   <c:if test="${emp_id != '600001'}">
                   		<li>
              				<a href="/group4erp/viewEmpSalInfo.do"><i class="fa fa-file"></i>급여명세서 조회</a>
              			</li>	
                   </c:if>
              <li>
                <a href="/group4erp/viewEmpDayOffList.do"><i class="fa fa-list"></i>직원별 휴가 현황</a>
              </li>
            </ul>
          </li>
          <li class="sub-menu">
            <a href="javascript:;">
              <i class="fa fa-krw"></i>
              <span>회계 관리</span>
              </a>
            <ul class="sub">
              <li>
                <a href="/group4erp/viewTranSpecIssueList.do"><i class="fa fa-list"></i>거래명세서 조회</a>
              </li>
              <li>
                <a href="/group4erp/viewTranSpecList.do"><i class="fa fa-file-text"></i>사업자 거래내역 조회</a>
              </li>
              <li>
                <a href="/group4erp/viewCorpList.do"><i class="fa fa-link"></i>거래처 현황 조회</a>
              </li>
            </ul>
          </li>
          <li class="sub-menu">
            <a href="javascript:;">
              <i class=" fa fa-bar-chart-o"></i>
              <span>전략 분석</span>
              </a>
            <ul class="sub">
              <li>
                <a href="/group4erp/viewBestKeywdAnalysis.do"><i class="fa fa-search"></i>키워드 검색 자료 조회</a>
              </li>
              <li>
                <a href="/group4erp/viewOurCompanyReport.do"><i class="fa fa-building-o"></i>회사현황</a>
              </li>
              <li>
                <a href="/group4erp/goMyChart.do"><i class="fa fa-bar-chart-o"></i>시장 분석 자료</a>
              </li>
            </ul>
          </li>
        </ul>
        <!-- sidebar menu end-->
      </div>
    </aside>
    <!--sidebar end-->
    <!-- **********************************************************************************************************************************************************
        MAIN CONTENT
        *********************************************************************************************************************************************************** -->
    <!--main content start-->
    <section id="main-content">
      <section class="wrapper">
        <div class="row">
          <div class="col-lg-9 main-chart">
            <!--CUSTOM CHART START -->
            <div class="border-head">
              <h3>월별 판매 부수(온/오프라인 합산)</h3>
            </div>
            <div id="sellingStat" style="background-color:#eaeaea">
            	<!-- 구글 차트 내용입니다. -->
            </div>
            
            <div class="row mt">
              <!-- 베스트샐러 판넬 -->
               <div class="col-md-8 mb">
                <div class="message-p pn">
                  <div class="message-header" style="margin-bottom:0px; background-color:#444c57">
                    <h4><font style="color:white;">Bestsellers</font></h4>
                  </div>
                  <div class="row">
                    <div class="col-md-12">
						<div id="app" style='height:20%; padding-top:0; margin-top:0;'></div>
						<script src='https://cdnjs.cloudflare.com/ajax/libs/react/0.13.0/react.min.js'></script>
						<script id="rendered-js">
							let title = '';
							let catName = '';
							let steps = '';
							let app =
							React.createElement("div", { className: "leaderboards-container" }
							,React.createElement("div", { className: "podium-places-container" }
							,React.createElement("div", null
							,React.createElement("div", { className: "podium silver" }
							,React.createElement("div", { className: "position" }
							,React.createElement("div", null, "2"))
							,React.createElement("div", { className: "class-information" }
							,React.createElement("div", { className: "title" },'${bestSellers[1].book_name}')
							,React.createElement("div", { className: "cat-name" }, '${bestSellers[1].cat_name}')
							,React.createElement("div", { className: "steps" }, '${bestSellers[1].soldcnt}'+'권'))))
							
							,React.createElement("div", null
							,React.createElement("div", { className: "podium gold" }
							,React.createElement("div", { className: "position" }
							,React.createElement("div", null, "1"))
							,React.createElement("div", { className: "class-information" }
							,React.createElement("div", { className: "title" }, '${bestSellers[0].book_name}')
							,React.createElement("div", { className: "cat-name" }, '${bestSellers[0].cat_name}')
							,React.createElement("div", { className: "steps" }, '${bestSellers[0].soldcnt}'+'권'))))
							
							,React.createElement("div", null
							,React.createElement("div", { className: "podium bronze" }
							,React.createElement("div", { className: "position" }
							,React.createElement("div", null, "3"))
							,React.createElement("div", { className: "class-information" }
							,React.createElement("div", { className: "title" }, '${bestSellers[2].book_name}')
							,React.createElement("div", { className: "cat-name" }, '${bestSellers[2].cat_name}')
							,React.createElement("div", { className: "steps" }, '${bestSellers[2].soldcnt}'+'권'))))));
							
							React.render(app, document.getElementById('app'));
						</script>
                    </div>
                  </div> 
                  <!-- class="row" -->
                </div>
                <!-- /Message Panel-->
              </div>
              <!-- /col-md-8 (베스트샐러 판넬)  -->
              
              
              
              
              <!-- 계획 대비 실적 현황 PANELS -->
              <div class="col-md-4 col-sm-4 mb">
                <div class="grey-panel pn donut-chart" style="color:#fff;">
                  <div class="grey-header">
                    <h5><b>${orderStat.title} 계획대비 실적 현황</b></h5>
                  </div>
                  <table width="95%">
                  	<tr><td>&nbsp;</td></tr>
                  	<tr>
                  		<td width="10%"></td>
                  		<td>
                  		  <!-- 판매된 도서가 없을 때 -->
		                  <c:if test="${empty orderStat}">
		                  	판매율
		                  	<table>
		                  		<tr>
		                  			<td width="100%">
		                  				<div class="progress progress-striped">
				                  			<font style="font-size:8pt; color:#ef6242;">&nbsp;※판매 건수가 없습니다.</font>
				                   				<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%">
				                     				<span class="sr-only">0%</span>
				                    			</div>
				                  		</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td width="20%"><div class="percent">0%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if> 
		                  <!-- 판매율이 50 이하일 때 (빨간 프로그래스 바 )-->
		                  <c:if test="${!empty orderStat and orderStat.cnt<=50}">
		                   	판매율 
		                   	<table>
		                  		<tr>
		                  			<td width="100%">
		                  				<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="${orderStat.cnt}" aria-valuemin="0" aria-valuemax="100" style="width:${orderStat.cnt}%">
					                      		<span class="sr-only">${orderStat.cnt}</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${orderStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
		                  <!-- 판매율이 50초과, 70 이하 일 때 (노란 프로그래스 바 )-->
		                  <c:if test="${!empty orderStat and orderStat.cnt>50 and orderStat.cnt<=70}">
		                  	판매율
		                   	<table>
		                  		<tr>
		                  			<td width="100%">
		                  				<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="${orderStat.cnt}" aria-valuemin="0" aria-valuemax="100" style="width:${orderStat.cnt}%">
					                      		<span class="sr-only">${orderStat.cnt}</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${orderStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
		                  <!-- 판매율이 70초과, 100이하 일 때 (초록 프로그래스 바 )-->
		                  <c:if test="${!empty orderStat and orderStat.cnt>70 and orderStat.cnt<=100}">
		                   	판매율
		                  	<table>
		                  		<tr>
		                  			<td width="100%">
					                  	<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="${orderStat.cnt}" aria-valuemin="0" aria-valuemax="100" style="width:${orderStat.cnt}%">
					                      		<span class="sr-only">${orderStat.cnt}</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${orderStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
		                  <!-- 판매율이 100초과 일 때 (초록 프로그래스 바 / 텍스트는 100초과로 나타냄 )-->
		                  <c:if test="${!empty orderStat and orderStat.cnt>=100}">
		                   	판매율
		                  	<table>
		                  		<tr>
		                  			<td width="100%">
					                  	<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%">
					                      		<span class="sr-only">100</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${orderStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
                  		</td>
                  	</tr>

                  	<tr height="50%"><td>&nbsp;</td></tr>
                  	<tr>
                  		<td width="10%"></td>
                  		<td>
                  		  <!-- 반품된 도서가 없을 때 -->
		                  <c:if test="${empty returnStat}">
		                  	반품율
		                  	<table>
		                  		<tr>
		                  			<td width="100%">
		                  				<div class="progress progress-striped">
				                  		<font style="font-size:8pt; color:#ef6242;">&nbsp;※반품 건수가 없습니다.</font>
				                   			<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%">
				                     			<span class="sr-only">0%</span>
				                    		</div>
				                  		</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">0%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if> 
		                  
		                  <!-- 판매율이 30이하 일 때 (초록 프로그래스 바 )-->
		                  <c:if test="${!empty returnStat and returnStat.cnt<=30}">
		                   	반품율
		                   	<table>
		                  		<tr>
		                  			<td width="100%">
		                  				<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="${returnStat.cnt}" aria-valuemin="0" aria-valuemax="100" style="width:${returnStat.cnt}%">
					                      		<span class="sr-only">${returnStat.cnt}</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${returnStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
		                  
		                  <!-- 판매율이 30초과, 60 이하 일 때 (노란 프로그래스 바 )-->
		                  <c:if test="${!empty returnStat and returnStat.cnt>30 and returnStat.cnt<=60}">
		                  	반품율
		                   	<table>
		                  		<tr>
		                  			<td width="100%">
		                  				<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="${returnStat.cnt}" aria-valuemin="0" aria-valuemax="100" style="width:${returnStat.cnt}%">
					                      		<span class="sr-only">${returnStat.cnt}</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${returnStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
		                  
		                  <!-- 판매율이 60초과, 100 이하 일 때 (빨간 프로그래스 바 )-->
		                  <c:if test="${!empty returnStat and returnStat.cnt>60 and returnStat.cnt<=100}">
		                   	반품율
		                  	<table>
		                  		<tr>
		                  			<td width="100%">
					                  	<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="${returnStat.cnt}" aria-valuemin="0" aria-valuemax="100" style="width:${returnStat.cnt}%">
					                      		<span class="sr-only">${returnStat.cnt}</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${returnStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
		                  <!-- 판매율이 100초과 일 때 (빨간 프로그래스 바 / 텍스트는 100초과의 수를 나타냄)-->
		                  <c:if test="${!empty returnStat and returnStat.cnt>100}">
		                   	반품율
		                  	<table>
		                  		<tr>
		                  			<td width="100%">
					                  	<div class="progress progress-striped">
					                    	<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%">
					                      		<span class="sr-only">100</span>
					                    	</div>
					                  	</div>
		                  			</td>
		                  			<td width="10%"></td>
		                  			<td valign="top" width="20%"><div class="percent">${returnStat.cnt}%</div></td>
		                  		</tr>
		                  	</table>
		                  </c:if>
                  		</td>
                  	</tr>
                  </table>

                  <div id="event_text" align="left" style="padding-left:20; padding-top:10;">
                  </div>
                </div>
                <!-- /grey-panel -->
              </div>
            </div>
            <!-- /row -->
            
            
            
            
            <div class="row">
              <!-- SERVER STATUS PANELS -->
              <div class="col-md-4 col-sm-4 mb">
                <div class="grey-panel pn donut-chart" style="color:#fff;">
                  <div class="grey-header">
                    <h5><b>Yesterday summary</b></h5>
                  </div>
                  <table id="yesterdaySum">
              		<tr>
              			<td rowspan="4" width="30%"></td>
              			<td>
              				<h4><i class="fa fa-pencil-square"></i>&nbsp;</h4> 
              			</td>
              			<td>
              				어제 도서계약 건수 :&nbsp;<font style='font-weight:bold; font-size:15pt;color:#424141;'>${mainChartsDTO.reg_cnt}</font>건
              			</td>
              		</tr>
               		<tr>
               			<td>
               				<h4><i class="fa fa-shopping-cart"></i>&nbsp;</h4> 
               			</td>
               			<td>
               				어제 주문 건수 :&nbsp;<font style='font-weight:bold; font-size:15pt;color:#424141;'>${mainChartsDTO.order_cnt}</font>건
               			</td>
               		</tr>
               		<tr>
               			<td>
               				<h4><i class="fa fa-building-o"></i>&nbsp;</h4> 
               			</td>
               			<td>
               				어제 기업 주문 건수 :&nbsp;<font style='font-weight:bold; font-size:15pt;color:#424141;'>${mainChartsDTO.corp_order_cnt}</font>건
               			</td>
               		</tr>
               		<tr>
               			<td>
               				<h4><i class="fa fa-reply"></i>&nbsp;</h4> 
               			</td>
               			<td>
               				어제 반품 건수 :&nbsp;<font style='font-weight:bold; font-size:15pt;color:#424141;'>${mainChartsDTO.return_cnt}</font>건
               			</td>
               		</tr>
	              </table>
                </div>
                <!-- /grey-panel -->
              </div>
              <!-- /col-md-4-->
              
              
              
              
              <!-- /col-md-4-->
              <div class="col-md-4 col-sm-4 mb">
                <div class="darkblue-panel pn donut-chart">
                  <div class="darkblue-header">
                    <h5><b>회원  성비</b></h5>
                  </div>
                  <canvas id="genderStatCanvas" height="120" width="120"></canvas>
                  <div class="row">
                    <div class="col-sm-6 col-xs-6 goleft">
                    	<br>
                      	<p><font style="color:white;">여자 / 남자 :</font></p>
                    </div>
                    <div class="col-sm-6 col-xs-6" id="genderText">
                    	<script>
	                    	var genderData 
	                    		= [
	                    			{value: ${mainChartsDTO.genderStat[0].cnt}, color: "#FF6B6B"}
	                  		    	,{value: ${mainChartsDTO.genderStat[1].cnt}, color: "#1c9ca7"}
	                  			  ];
	
	                  		var genderText = "<h2><font style='font-size:20pt'>"+${mainChartsDTO.genderStat[0].cnt}+"%</font>";
	                  		genderText += "<font style='font-size:20pt; color:darkgray;'>/</font>";
	                  		genderText += "<font style='font-size:20pt; color:#1c9ca7;'>"+${mainChartsDTO.genderStat[1].cnt}+"%</font></h2>"; 
	                  		
	                  		$("#genderText").append(genderText);
	                  		
	                  		var myDoughnut = new Chart(document.getElementById("genderStatCanvas").getContext("2d")).Doughnut(genderData);
                    	</script>
                    </div>
                  </div>
                </div>
              </div>
              
              
              
              
              <!-- /col-md-4 -->
              <div class="col-md-4 col-sm-4 mb">
                <!-- REVENUE PANEL -->
                <div class="green-panel pn" style="background-color:#4a493f;">
                  <div class="green-header" style="background-color:#675b5e;">
                    <h5><b>2019 이벤트 분포 현황</b></h5>
                  </div>
                  <canvas id="ageStatCanvas" height="120" width="120"></canvas>
                  <div class="row">
                    <!-- <div class="col-sm-6 col-xs-6 goleft" id="text1"> -->
                    <div class="col-sm-12 col-xs-12 goleft" id="text1">
                    </div>
                    <div class="col-sm-12 col-xs-12" id="text">
                    	<br>
                    	<script>
	                  		var evntData = [
	                  			{value: ${mainChartsDTO.eventStat[0].cnt}, color: '#b97df0'}
		                  		,{value: ${mainChartsDTO.eventStat[1].cnt}, color: '#5cb0fa'}
		                  		,{value: ${mainChartsDTO.eventStat[2].cnt}, color: '#fdfdfd'}
		                  		,{value: ${mainChartsDTO.eventStat[3].cnt}, color: '#baf07d'}
		                  		,{value: ${mainChartsDTO.eventStat[4].cnt}, color: '#f07d7d'}
	                  		 ];
	
	                  		var lastyearEvnt = "<font style='color:#d0c2c2;'>${mainChartsDTO.eventStat[0].title}</font>"+"&nbsp;:&nbsp;";
	                  		lastyearEvnt += "<font style='color:#d2bff5;font-weight:bold;font-size:14pt'>"+${mainChartsDTO.eventStat[0].cnt}+"%</font>&nbsp;&nbsp;&nbsp;&nbsp;" 
	                  		lastyearEvnt +=  "<font style='color:#d0c2c2;'>${mainChartsDTO.eventStat[1].title}</font>"+"&nbsp;:&nbsp;"
	                  		lastyearEvnt += "<font style='color:#bfdcf5;font-weight:bold;font-size:14pt'>"+${mainChartsDTO.eventStat[1].cnt}+"%</font>&nbsp;&nbsp;&nbsp;&nbsp;"
	                  		lastyearEvnt +=  "<font style='color:#d0c2c2;'>${mainChartsDTO.eventStat[2].title}</font>"+"&nbsp;:&nbsp;"
	                  		lastyearEvnt += "<font style='color:#fdfdfd;font-weight:bold;font-size:14pt'>"+${mainChartsDTO.eventStat[2].cnt}+"%</font><br>"
	                  		lastyearEvnt +=  "<font style='color:#d0c2c2;'>${mainChartsDTO.eventStat[3].title}</font>"+"&nbsp;:&nbsp;"
	                  		lastyearEvnt += "<font style='color:#baf07d;font-weight:bold;font-size:14pt'>"+${mainChartsDTO.eventStat[3].cnt}+"%</font>&nbsp;&nbsp;&nbsp;&nbsp;"
	                  		lastyearEvnt += "<font style='color:#d0c2c2;'>${mainChartsDTO.eventStat[4].title}</font>"+"&nbsp;:&nbsp;"
	                  		lastyearEvnt += "<font style='color:#f07d7d;font-weight:bold;font-size:14pt'>"+${mainChartsDTO.eventStat[4].cnt}+"%</font>&nbsp;&nbsp;&nbsp;&nbsp;"
	                  		
	                  		$("#text").append(lastyearEvnt);
	                          	  
	                  		var myDoughnut = new Chart(document.getElementById("ageStatCanvas").getContext("2d")).Doughnut(evntData);
                    	</script>
                    </div>
                  </div>
                  
                </div>
              </div>
              <!-- /col-md-4 -->
              
            </div>
            <!-- /row -->
            
          </div>
          <!-- /col-lg-9 END SECTION MIDDLE -->
          
          
          <!-- **********************************************************************************************************************************************************
              RIGHT SIDEBAR CONTENT
              *********************************************************************************************************************************************************** -->
          <div class="col-lg-3 ds" style="height:1020">
            <!-- 이번달 이벤트 목록  -->
            <h4 class="centered mt"><font style="font-size:12pt;">이번달 이벤트</font></h4>
           	<c:if test="${!empty requestScope.monthEvnt}">
           		<c:forEach items='${requestScope.monthEvnt}' var="monthEvnt" varStatus="loopTagStatus">
	            	<div class="desc">
	              		<div class="thumb">
	                		<span class="badge bg-theme"><i class="fa fa-clock-o"></i></span>
	              		</div>
	             		<div class="details" style="width:80%;">
		                	<p>
		                  		<muted><font style="font-size:11pt;">${monthEvnt.evnt_start_dt} - ${monthEvnt.evnt_end_dt}</font></muted>
		                  		<a href="#"><font style="font-size:11pt;">${monthEvnt.event_type}&nbsp;&nbsp;</font></a><font style="font-size:11pt;">${monthEvnt.evnt_title}</font><br/>
		                	</p>
	              		</div>
	             	</div>
             	</c:forEach> 
           	</c:if>
           	<c:if test="${empty requestScope.monthEvnt}">
           		<div align="center" style="height:30%; color:orange; vertical-align:center;">진행중인 이벤트가 없습니다.</div>
            </c:if>
            
           
            
            <!-- CALENDAR-->
            <div id="calendar" class="mb">
              <div class="panel green-panel no-margin">
                <div class="panel-body">
                  <div id="date-popover" class="popover top" style="cursor: pointer; disadding: block; margin-left: 33%; margin-top: -50px; width: 175px;">
                    <div class="arrow"></div>
                    <h3 class="popover-title" style="disadding: none;"></h3>
                    <div id="date-popover-content" class="popover-content"></div>
                  </div>
                  <div id="my-calendar"></div>
                </div>
              </div>
            </div>
            <!-- / calendar -->
            
            
          </div>
          <!-- /col-lg-3 -->
        </div>
        <!-- /row -->
      </section>
    </section>
  </section>
  
  <!-- js placed at the end of the document so the pages load faster -->
  <script src="${ctRootlib}/jquery/jquery.min.js"></script>
  <script src="${ctRootlib}/bootstrap/js/bootstrap.min.js"></script>
  <script class="include" type="text/javascript" src="${ctRootlib}/jquery.dcjqaccordion.2.7.js"></script>
  <script src="${ctRootlib}/jquery.scrollTo.min.js"></script>
  <script src="${ctRootlib}/jquery.nicescroll.js" type="text/javascript"></script>
  <script src="${ctRootlib}/jquery.sparkline.js"></script>
  <!--common script for all pages-->
  <script src="${ctRootlib}/common-scripts.js"></script>
  <!--script for this page-->
  <script src="${ctRootlib}/sparkline-chart.js"></script>
  <script src="${ctRootlib}/zabuto_calendar.js"></script>
  <script src="${ctRootlib}/morris/morris.min.js"></script>
  <script src="${ctRootlib}/raphael/raphael.min.js"></script>
</body>

</html>