<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">



<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="">
  <meta name="author" content="Dashboard">
  <meta name="keyword" content="Dashboard, Bootstrap, Admin, Template, Theme, Responsive, Fluid, Retina">
  <meta http-equiv="Conpatible" content="no-cache"/>
  <title>Dashio - Bootstrap Admin Template</title>

   <!-- Favicons -->
  <link href="${ctRootImg}/favicon.png" rel="icon">
  <link href="${ctRootImg}/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Bootstrap core CSS -->
  <link href="${ctRootlib}/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!--external css-->
  <link href="${ctRootlib}/font-awesome/css/font-awesome.css" rel="stylesheet" />
  <!-- Custom styles for this template -->
  <link href="${ctRootcss}/style.css" rel="stylesheet">
  <link href="${ctRootcss}/style-responsive.css" rel="stylesheet">

  


  <!-- =======================================================
    Template Name: Dashio
    Template URL: https://templatemag.com/dashio-bootstrap-admin-template/
    Author: TemplateMag.com
    License: https://templatemag.com/license/
  ======================================================= -->
</head>

<style>

/*datepicer 버튼 롤오버 시 손가락 모양 표시*/
.ui-datepicker-trigger{cursor: pointer;}
/*datepicer input 롤오버 시 손가락 모양 표시*/
.hasDatepicker{cursor: pointer;}

 input[type="date"]::-webkit-calendar-picker-indicator,
 input[type="date"]::-webkit-inner-spin-button {
     display: none;
     appearance: none;
 }
 
 input[type="date"]::-webkit-calendar-picker-indicator {
   color: rgba(0, 0, 0, 0); /* 숨긴다 */
   opacity: 1;
   display: block;
   background: url(https://mywildalberta.ca/images/GFX-MWA-Parks-Reservations.png) no-repeat; /* 대체할 아이콘 */
   width: 20px;
   height: 20px;
   border-width: thin;
}

.searchTable{
	border-collapse: 1px collapse !important;
}

.searchTable td{
	height: 32px;
    padding-left: 7;
}

.searchTable th {
	height: 32px;
    padding-right: 7;
    
}

.searchTable-bordered td,
.searchTable-bordered th {
    border: 1px solid #ddd !important;
}

.tableth th{
	text-align: right;
	font-weight: bold;
}

</style>

<script>

   $(document).ready(function(){
      
	   startTime();
	   
      $("#datepicker1").datepicker({
         dateFormat: 'yy-mm-dd'
         ,onClose: function( selectedDate ) {
            $("#datepicker2").datepicker( "option", "minDate", selectedDate );
         } 
          ,onSelect: function() { 
              var dateObject = $(this).datepicker('getDate');
          }
      });
      $("#datepicker2").datepicker({
         dateFormat: 'yy-mm-dd'
         ,onClose: function( selectedDate ) {
              $("#datepicker1").datepicker( "option", "maxDate", selectedDate );
          }
          ,onSelect: function() { 
              var dateObject = $(this).datepicker('getDate');
          }
      });
      
      $('[name=rowCntPerPageDown]').change(function(){
			 $('[name=rowCntPerPage]').val( $(this).val() );
			 goSearch();
		 });
      
      $(".pagingNumber").html(
               getPagingNumber(
                  "${returnOrderCnt}"                  //검색 결과 총 행 개수
                  ,"${returnSearchDTO.selectPageNo}"         //선택된 현재 페이지 번호
                  ,"${returnSearchDTO.rowCntPerPage}"      //페이지 당 출력행의 개수
                  ,"10"                              //페이지 당 보여줄 페이지번호 개수
                  ,"goSearch();"                  //페이지 번호 클릭 후 실행할 자스코드
               )
            );

      inputData('[name=rowCntPerPageDown]',"${returnSearchDTO.rowCntPerPage}");
      inputData('[name=selectPageNo]',"${returnSearchDTO.selectPageNo}");
      inputData('[name=dateFrom]',"${returnSearchDTO.dateFrom}");
      inputData('[name=dateTill]',"${returnSearchDTO.dateTill}");
      inputData('[name=searchKeyword]',"${returnSearchDTO.searchKeyword}");
      inputData('[name=sort]', "${returnSearchDTO.sort}");
      <c:forEach items="${returnSearchDTO.return_cd}" var="cdReturn">
         inputData( "[name=return_cd]", "${cdReturn}" );
      </c:forEach>
      
   });


   function goSearchToday(){
	      $('[name=searchToday]').val('y');
	      
	      var date = new Date();
	      
	      var todayY = date.getFullYear();
	      var todayM = date.getMonth()+1;
	      var todayD = date.getDate();
	      
	      if(todayM<10) todayM = '0'+todayM;
	      if(todayD<10) todayD = '0'+todayD;
	      
	      var today = todayY+'-'+todayM+'-'+todayD;
	      
	      
	      $('[name=dateFrom]').val(today);
	      $('[name=dateTill]').val(today);
	      
	      goSearch();
	   }
   
   function goSearch() {

      var keyword = $("[name=returnSearchForm] [name=searchKeyword]").val();
      keyword = $.trim(keyword);
      $("[name=returnSearchForm] [name=searchKeyword]").val(keyword);
      
      //alert( $('[name=returnSearchForm]').serialize() );
      //return;
      
      
      document.returnSearchForm.submit();
   }

   function goSearchAll() {
      document.returnSearchForm.reset();

      $('[name=returnSearchForm] [name=selectPageNo]').val("1");
      $('[name=returnSearchForm] [name=rowCntPerPage]').val("10");
      $("[name=returnSearchForm] [name=sort]").val('');
      goSearch();
   }
   
   function goReturnInfo(idx, pk_no){
      //alert("반품 사유 상세정보 기능 구현중");
      
      //alert("this="+idx+"pk_no="+pk_no);
      
      var thisTr = $(idx);
      
      var delTr = $('[name=thisTr]');
       if(delTr.size()>0){
            delTr.remove();
       }
      
      var datastr = "pk_no="+pk_no;
      
      $.ajax({

            url : "/group4erp/goReturnOrderContent.do"
            
            , type: "post"
            
            , data : datastr
            
            //, dataType:"JSON"
            
            ,success : function(data){
                  if(data != null){
                         $("#contentTable td:eq(0)").text(data.id);
                         $("#contentTable td:eq(1)").text(data.return_order_dt);
                         $("#contentTable td:eq(2)").text(data.book_name);
                         $("#contentTable td:eq(3) [name=info]").text(data.return_comment);

                  var insert = "<tr name='thisTr' bgcolor='white'><td colspan=5>"+$("#contecnt").html()+"</td></tr>"
                  
                  thisTr.after(insert);
                  
                  $('[name=thisTr]').hide();
                  $('[name=thisTr]').show(1000);
                  
                  }
            }
         , error : function(){
                 alert("서버 접속 실패");
           }
      
      });
   }
      
   function goClose(){

      $('[name=thisTr]').hide(1000);
      
    }
   
   
	function goReset(){
		//alert(1)
			document.returnSearchForm.reset();
		//$('[name=bookReleaseSearch]').reset();
	}

</script>

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
          <li><!-- 
            <table>
               <tr>
                  <td align="left"> <font style="color:#D8E8E4;"><h4><span id="nowTime" align="right"></span> </h4></font></td>
               </tr>
            </table> -->
          </li>
        </ul>
        <!--  notification end -->
      </div>
      <div class="top-menu">
        <ul class="nav pull-right top-menu">
          <!-- <li>
            <a class="goBackss" href="javascript:goBack();">뒤로 가기</a>
          </li> -->
          <li>
             <a class="logout" href="/group4erp/logout.do">Logout</a>
          </li>
        </ul>
      </div>
      <div class="top-menu">
        <ul class="nav pull-right top-menu">
          <!-- <li>
            <a class="goBackss" href="javascript:goBack();">뒤로 가기</a>
          </li> -->
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
            <a href="/group4erp/goMain.do">
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
              <!-- 
              <li>
                <a href="/group4erp/goMyWorkTime.do"><i class="fa fa-list"></i>근태 조회</a>
              </li>
              <li>
               -->
              <li>
                <a href="/group4erp/viewApprovalList.do"><i class="fa fa-pencil"></i>문서 결재</a>
              </li>
              <li>
                <a href="/group4erp/goEmpDayOffjoin.do"><i class="fa fa-edit"></i>휴가 신청</a>
              </li>
            </ul>
          </li>
          <li class="sub-menu">
            <a class="active" href="javascript:;">
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
              <li class="active">
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
              <li>
                <a href="/group4erp/viewSalList.do"><i class="fa fa-file"></i>급여명세서 조회</a>
              </li>
              <!-- 
              <li>
                <a href="/group4erp/viewEmpWorkStateList.do"><i class="fa fa-list"></i>직원별 근무현황</a>
              </li>
               -->
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
              <li class="active">
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
      <section class="wrapper" style="text-align:left;">
        <h3><i class="fa fa-angle-right"></i> 반품 현황</h3>
        <div class="row">
          <div class="col-md-12">
            <div class="content-panel">
              <h4><i class="fa fa-angle-right"></i> 검색</h4>
              <hr>
			<form name="returnSearchForm" method="post" action="/group4erp/goReturnOrderList.do">
			<!-- <div class="divcss"> -->
			<table class="searchTable" style="border: 0px;">
				<tr>
					<th width="8%" style="text-align:right;"><b>* 지역&nbsp;</b></th>
					
					<td width="42%" align=left>
						   &nbsp;&nbsp;<input type="checkbox" value="01" name="return_cd">파손
                           &nbsp;&nbsp;<input type="checkbox" value="03" name="return_cd">변심
                           &nbsp;&nbsp;<input type="checkbox" value="02" name="return_cd">오배송
                           &nbsp;&nbsp;<input type="checkbox" value="04" name="return_cd">제작사 요청
                           &nbsp;&nbsp;<input type="checkbox" value="05" name="return_cd">기타
            		</td>
				<tr>
					<th width="8%" style="text-align:right;"><b>* 일자&nbsp;</b>
					<td colspan=2 width="42%" align=left>
						<input type="text" id="datepicker1" name="dateFrom" size=30>
						&nbsp; ~ &nbsp;
						<input type="text" id="datepicker2" name="dateTill" size=30>&nbsp;&nbsp;
						
						<button type="button" class="btn btn-default" onclick="goSearchToday();"><i class="fa fa-calendar-o"></i>금일 검색</button>
						
				<tr>
					<th width="8%" style="text-align:right;"><b>* 키워드&nbsp;</b>
					<td width="42%"> <input type="text" name="searchKeyword" size=76>
					<th>
					<td>
					<th>
					<td  width="20%">
						<button type="button" class="btn btn-default" onclick="goSearch();"><input type="image" src="/group4erp/resources/image/magnifying-glass.png" width="15" height="15">검색</button>
						&nbsp;
						<button type="button" class="btn btn-default" onclick="goSearchAll();"><input type="image" src="/group4erp/resources/image/searchA.png" width="15" height="15">모두검색</button>
						&nbsp;
						<button type="button" class="btn btn-default" onclick="goReset();"><input type="image" src="/group4erp/resources/image/reset.png" width="15" height="15">초기화</button>
			</table>

			<br>
			<!-- </div> -->
			<input type="hidden" name="searchToday">
			<input type="hidden" name="selectPageNo" value="${returnSearchDTO.selectPageNo}">
			<input type="hidden" name="rowCntPerPage" value="${returnSearchDTO.rowCntPerPage}">
			<!-- header sort를 하기 위한 hidden Tag -->
			<input type="hidden" name="sort">
			</form>
            </div>
          </div>
          <!-- /col-md-12 -->
          <div class="col-md-12 mt">
            <div class="content-panel">
            <div class="adv-table">
            <table border=0 width=98%>
					<tr>
						<td><h4><i class="fa fa-angle-right"></i>검색 결과</h4>
						<td align=right> [검색 수량] : ${returnOrderCnt}개
						<select name="rowCntPerPageDown">
								<option value="10">10</option>
								<option value="15">15</option>
								<option value="20">20</option>
								<option value="25">25</option>
								<option value="30">30</option>
						</select> 행보기
			</table>
			<table><tr><td height="10"></td></tr></table>
             <table class="table table-striped table-advance table-hover table-bordered">
             <thead>
					 <tr>
					 	<th>NO
				      <c:choose>
				         <c:when test="${param.sort=='1 desc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val(''); goSearch();  "> ▲ 반품접수번호</th>
				         </c:when>
				         <c:when test="${param.sort=='1 asc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('1 desc'); goSearch(); "> ▼ 반품접수번호</th>
				         </c:when>         
				         <c:otherwise>
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('1 asc'); goSearch();  ">반품접수번호</th>
				         </c:otherwise>
				      </c:choose>
				      
				      <c:choose>
				         <c:when test="${param.sort=='2 desc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val(''); goSearch();  "> ▲ 주문번호</th>
				         </c:when>
				         <c:when test="${param.sort=='2 asc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('2 desc'); goSearch(); "> ▼ 주문번호</th>
				         </c:when>         
				         <c:otherwise>
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('2 asc'); goSearch();  ">주문번호</th>
				         </c:otherwise>
				      </c:choose>
				      
				      <c:choose>
				         <c:when test="${param.sort=='3 desc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val(''); goSearch();  "> ▲ isbn</th>
				         </c:when>
				         <c:when test="${param.sort=='3 asc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('3 desc'); goSearch(); "> ▼ isbn</th>
				         </c:when>         
				         <c:otherwise>
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('3 asc'); goSearch();  ">isbn</th>
				         </c:otherwise>
				      </c:choose>
				      
				      <c:choose>
				         <c:when test="${param.sort=='4 desc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val(''); goSearch();  "> ▲ 반품사유</th>
				         </c:when>
				         <c:when test="${param.sort=='4 asc'}">
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('4 desc'); goSearch(); "> ▼ 반품사유</th>
				         </c:when>         
				         <c:otherwise>
				            <th style="cursor:pointer" onClick="$('[name=sort]').val('4 asc'); goSearch();  ">반품사유</th>
				         </c:otherwise>
				      </c:choose>
				
				      </tr>
					</thead>
					<tbody>
					<c:forEach items='${returnOrderList}' var="reOrder" varStatus="loopTagStatus">
				         <tr style="cursor:pointer" onclick="goReturnInfo(this, '${reOrder.return_sales_no}');">
				         	<td align="center">${returnOrderCnt-(returnSearchDTO.selectPageNo*returnSearchDTO.rowCntPerPage-returnSearchDTO.rowCntPerPage+1+loopTagStatus.index)+1}</td>
				            <td align="center">${reOrder.return_sales_no}</td>
				            <td align="center">${reOrder.order_no}</td>
				            <td align="center">${reOrder.isbn13}</td>
				            <td align="center">${reOrder.return_cause}</td>
				         </tr>
				      </c:forEach>
					</tbody>
			</table>
			<br>
			<div align=center>&nbsp;<span class="pagingNumber"></span>&nbsp;</div>
			<br>
            </div>
          </div>
          <!-- /col-md-12 -->
        </div>
        <br>
        <!-- /row -->
      </section>
    </section>
    <div id="contecnt" style="display:none;">
      <table width=99%> <tr> <td width=30%> <td width=40% align=center>
 			⏷<br>[상세 정보]<br>
 				<td width=30% align=right>
					<h3 align=right><i class='fa fa-times' onclick='goClose();' style='cursor:pointer;'></i>&nbsp;&nbsp;</h3>
		</table>
      <table class="searchTable searchTable-bordered tableth" width=50% id="contentTable" align=center>
         <tr>
            <th>ID</th>
            <td></td>
            <th>반품 접수 날짜</th>
            <td></td>
         </tr>
         <tr>
            <th>책 제목</th>
            <td align=center colspan=4></td>
         </tr>
         <tr>
            <th>세부내용</th>
            <td align=center colspan=4>
               <textarea name="info" cols=80 rows=10 readonly> </textarea>
            </td>
         </tr>
      </table>
      <table><tr height=1><td></td></tr></table>
   </div>
    <!-- /MAIN CONTENT -->
    <!--main content end-->
    <!--footer start-->
<!--     <footer class="site-footer">
      <div class="text-center">
        <p>
			KOSMO 자바&빅데이터 과정 팀프로젝트
        </p>
        <div class="credits">
        <font style="font-size:12pt;">
        ⓒ Copyrights <strong>조충래, 김태현, 박현우, 이동하, 임남희, 최민지</strong>
         </font>
        </div>
        <a href="basic_table.html#" class="go-top">
          <i class="fa fa-angle-up"></i>
          </a>
      </div>
    </footer> -->
    <!--footer end-->
  </section>
  <!-- js placed at the end of the document so the pages load faster -->
  
  <script src="${ctRootlib}/bootstrap/js/bootstrap.min.js"></script>
  <script src="${ctRootlib}/jquery/jquery.min.js"></script>
  <script class="include" type="text/javascript" src="${ctRootlib}/jquery.dcjqaccordion.2.7.js"></script>
  <script src="${ctRootlib}/jquery.scrollTo.min.js"></script>
  <script src="${ctRootlib}/jquery.nicescroll.js" type="text/javascript"></script>
  <!--common script for all pages-->
  <script src="${ctRootlib}/common-scripts.js"></script>
  <!--script for this page-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  
</body>

</html>
