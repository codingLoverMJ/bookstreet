<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/WEB-INF/views/common.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="Dashboard">
	<meta name="keyword" content="Dashboard, Bootstrap, Admin, Template, Theme, Responsive, Fluid, Retina">
	<meta http-equiv="Conpatible" content="no-cache"/>
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<title>직원별 휴가현황</title>
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
 
   <style type="text/css" media="screen">
       .ko_day { 
       		text-indent : -9999px; 
       		background: #eee url(/imgs/korea.png) no-repeat center;
       	}
		.searchTable{
			border-collapse: 1px collapse !important;
		}
		.searchTable td{
			height: 40px;
		    padding-left: 7;
		}
		.searchTable th {
			height: 40px;
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
	  	   startTime(); //상단 매 초마다 시간 변경하여 출력
	
	   	   //행보기에 change 이벤트 발생 시 goDayoffSearch() 호출하여 페이지 reload
	       $('[name=rowCntPerPageDown]').change(function(){
	 		   $('[name=rowCntPerPage]').val( $(this).val() );
	          goDayoffSearch();
	       });
	
	  	   //paging 처리 함수 실행
	       $(".pagingNumber").html(
	           getPagingNumber(
	              "${getDayOffListCnt}"               		//검색 결과 총 행 개수
	              ,"${hrListSearchDTO.selectPageNo}"      	//선택된 현재 페이지 번호
	              ,"${hrListSearchDTO.rowCntPerPage}"     	//페이지 당 출력행의 개수
	              ,"5"                           			//페이지 당 보여줄 페이지번호 개수
	              ,"goDayoffSearch();"               		//페이지 번호 클릭 후 실행할 자스 코드
	           )
	        );
	
	        //데이터가 변경된 것을 화면에도 동일하게 보여주기 위해 inputData 함수 실행
	        inputData('[name=rowCntPerPageDown]',"${hrListSearchDTO.rowCntPerPage}");
	        inputData('[name=selectPageNo]',"${hrListSearchDTO.selectPageNo}");
	        inputData("[name=dy_keyword]", "${hrListSearchDTO.dy_keyword}");
	        inputData("[name=sort]", "${hrListSearchDTO.sort}");
	        <c:forEach items="${hrListSearchDTO.dayoff_state}" var="dy_state">
	           inputData( "[name=dayoff_state]", "${dy_state}" );
	        </c:forEach>
	        $("[name=dayOffList]").addClass('dayOffList');
      });//----document ready end

      // 검색 버튼 누를 시 실행되는 함수
      function goDayoffSearch(){
         document.empDayoffSearch.submit();
      }
      
      // 모두 검색 버튼 누를 시 실행되는 함수
      function goSearchAll(){
		document.empDayoffSearch.reset();
		$("[name=empDayoffSearch] [name=selectPageNo]").val(1);
		$("[name=empDayoffSearch] [name=rowCntPerPage]").val(20);
		$("[name=empDayoffSearch] [name=sort]").val('');
		goDayoffSearch();
			
	  }
      
      // 검색 설정 초기화 누를 시 실행되는 함수
      function goAllReset(){
		document.empDayoffSearch.reset();
	  }
      
      var empNo = null;				//사원번호
      var dateS = null; 			//휴가 자동계산기 안에서 사용할 휴가 시작일
      var dateE = null;				//휴가 자동계산기 안에서 사용할 휴가 종료일
      
      var remainD = null;			//변경된 남은 휴가일
      var remainD_origin = null;	//원본 남은 휴가일
      var realDy = null;			//수정된 휴가 신청일수
      var updatedata = null;		//ajax호출로 수정할 때 보낼 테이터
      var dayoff_apply_dt = null;	//휴가 신청일
      var dtfromval = null;			
      var dttillval = null;
      var dayoff_apply_no = null; 	//휴가 신청번호
      var cd = $("[name=addTr]").find("[name=dayoff_name]").val();

      // 테이블의  tr 클릭 시 새로운 tr이 삽입되면서 수정화면 나타내는 함수
      function addUpdelTr(ele, emp_no, apply_no){ // 매개변수로 this, 사원번호, 신청번호를 받음
         dayoff_apply_no = apply_no;
      
      	 //tr을 누를 때 마다 새로운 tr이 계속적으로 삽입되는 것을 방지
         var delTr = $('[name=addTr]');
         if(delTr.size()>0){
               delTr.remove();
          }
		 
         
         var dayoff_apply_dt_origin =  $(ele).children().eq(11).text();
         dayoff_apply_dt = dayoff_apply_dt_origin.replace(dayoff_apply_dt_origin.substr(10,2),"").trim();

         //현재 클릭한 tr 뒤에 넣을 html 소스를 변수에 저장해두기
         var addhtmlTr = "<tr name='addTr'><td colspan='14' align=center><center><div align='center' style='position:absoulte text-align:center'>";
         addhtmlTr += "<table width=99%> <tr> <td width=30%> <td width=40% align=center>"
         addhtmlTr += "⏷<br>[휴가 수정]<br>"
         addhtmlTr += "<td width=30% align=right>"
         addhtmlTr += "<h3 align=right><i class='fa fa-times' onClick='dayoffClose(this);' style='cursor:pointer;'></i>&nbsp;&nbsp;</h3> </table>"
         addhtmlTr += "<div style='height:10'></div><form name='upData' action=''><table name='upDayoff' class='searchTable tableth' width=35% id='contentTable' align=center>";
         // 휴가 종류를 수정할 수 있는 select 태그
         addhtmlTr += "<tr><th>휴가종류</th><td><select class='form-control' name=dayoff_name>";
         addhtmlTr += "<option value='연차'>연차</option><option value='월차'>월차</option>"
         addhtmlTr += "<option value='생리'>생리</option><option value='출산'>출산</option>"
         addhtmlTr += "<option value='반차'>반차</option><option value='보상'>보상</option></select></td></tr>"
         
         //datepicker에 값을 넣어주기 위해 원본 휴가 시작 날짜에 있던 요일을 제거
         var dtfrom = $(ele).children().eq(6).text();
         dtfromval = dtfrom.replace(dtfrom.substr(11,2),"").trim();
         addhtmlTr += "<tr><th>휴가 시작일</th><td><input type='text' class='form-control round-form' name='start_dayoff' id='dateFrom' size='15' value='"+dtfromval+"'></td></tr>";
         
         //datepicker에 값을 넣어주기 위해 원본 휴가 종료 날짜에 있던 요일을 제거
         var dttill = $(ele).children().eq(7).text();
         dttillval = dttill.replace(dttill.substr(11,2),"").trim();
         addhtmlTr += "<tr><th>복귀 예정일</th><td><input type='text' class='form-control round-form' name='end_dayoff' id='dateTill' size='15' value='"+dttillval+"'><input type='hidden' name='emp_no' value='"+emp_no+"'></td></tr>";
         
         addhtmlTr += "<tr><th>휴가 신청일수</th><td>";
         addhtmlTr += "<input type='text' class='form-control round-form' style='background-color:#EBEBE4; box-shadow:none; border: 1px solid lightgray; text-align:center;' name='using_dayoff' size='1' value='"+$(ele).children().eq(8).text()+"'readonly/>";
         addhtmlTr += "&nbsp;<font size='1px'>*수정 불가(자동계산)</font></td></tr>";
         
         //사용가능 휴가일수를 hidden 태그에 숨기기 (남은 휴가일보다 신청일수가 많으면 신청을 막기 위함)
         addhtmlTr += "<input type='hidden' name='remain_dayoff' size='1' value='"+$(ele).children().eq(9).text()+"'/></table></form>";
         
         //수정, 삭제, 초기화 버튼
         addhtmlTr += "<div style='height:10'></div><button type='button' class='btn btn-theme02' onClick='dayoffUpdate(this);'><i class='fa fa-check'></i> 수정</button>&nbsp;&nbsp;<button type='button' class='btn btn-theme04' onClick='dayoffDelete("+emp_no+","+remainD_origin+");'><i class='fa fa-eraser'></i> 삭제</button>";
         addhtmlTr += "&nbsp;&nbsp;<button type='button' class='btn btn-default' onclick='goReset();'><input type='image' src='/group4erp/resources/image/reset.png' width='13' height='13'>초기화</button>"
         addhtmlTr += "&nbsp;&nbsp;</div><div style='height:20'></div></td><tr>";
         
         //가리킴 태그 다음에 addhtmlTr변수에 저장되어있던 html코드를 삽입
         $(ele).after(addhtmlTr);
         
         //휴가 종류를 inputData함수 호출로 select태그의 값으로 넣기
         inputData("[name=dayoff_name]", $(ele).children().eq(5).text());

         //애니메이션 효과
         $('[name=addTr]').hide();
         $('[name=addTr]').show(1000);

         // 삽입된 tr 수정화면에서 select 태그의 휴가 종류에 change 이벤트 발생 시
         $("[name=dayoff_name]").change(function(){
	         cd = $("[name=addTr]").find("[name=dayoff_name]").val();
	         dateS = $("[name=addTr]").find("[name=start_dayoff]").val();
	         dateE = $("[name=addTr]").find("[name=end_dayoff]").val();
	         empNo = $("[name=addTr]").find("[name=emp_no]").val();
	         remainD = $("[name=addTr]").find("[name=remain_dayoff]").val();
      		 $("[name=addTr]").find("[name=end_dayoff]").val('');

	         if(dateS=='' || dateE=='' || dateS==null || dateE==null){
	            $("[name=addTr]").find("[name=using_dayoff]").val(1);
	         }
            
	         //반차일 경우, 시작일만 존개 / 휴가 신청일수는 0.5일로 계산
             if(cd=='반차'){
	             $("[name=upDayoff] tr:eq(2)").hide();
	             inputData("[name=end_dayoff]", dateS);
	             realDy = 0.5;
	             $("[name=addTr]").find("[name=using_dayoff]").val(realDy);
	         //반차를 제외한 경우, 시작일/종료일 모두 존재
             }else{
                  $("[name=upDayoff] tr:eq(2)").show();
                  $("[name=addTr]").find("[name=start_dayoff]").val('');
               	  $("[name=addTr]").find("[name=end_dayoff]").val('');
               	  realDy = 0;
                  inputData("[name=using_dayoff]", realDy);
                  //if(dateS=='' || dateE=='' || dateS==null || dateE==null){$("[name=addTr]").find("[name=using_dayoff]").val(1);}
                  $("[name=addTr]").find("[name=using_dayoff]").val(realDy);
            }
         });
  
         // datepicker 설정 - 휴가 시작일
         $("#dateFrom").datepicker({ 
	         dateFormat: 'yy-mm-dd'
	         ,defaultDate : dtfromval
	         ,minDate : 'today'
	         // 시작일(dateFrom) datepicker가 닫힐 때 종료일(dateTill)의 선택할 수 있는 최소 날짜(minDate)를 선택한 시작일로 지정
	         ,onClose: function( selectedDate ) {   
	            $("#dateTill").datepicker( "option", "minDate", selectedDate );
	         }   
         	 // 시작 일자 선택된 후 이벤트 발생
             ,onSelect: function() { 
	              var dateObject = $(this).datepicker('getDate');
	              cd = $("[name=addTr]").find("[name=dayoff_name]").val();
	              dateS = $("[name=addTr]").find("[name=start_dayoff]").val();
	              dateE = $("[name=addTr]").find("[name=end_dayoff]").val();
	              empNo = $("[name=addTr]").find("[name=emp_no]").val();
	              remainD = $("[name=addTr]").find("[name=remain_dayoff]").val();
                  
	              //datepicker에 이벤트 발생 시, 
	              //변경된 날짜로부터의 휴가일 계산값은 finalDayoff함수를 호출하여 값을 리턴받음
                  var realDy = finalDayoff(dateS, dateE, remainD); 
   
                  if(cd=='반차'){
                  		realDy = 0.5;
                        inputData("[name=end_dayoff]", dateS);
                        if(realDy < 0){realDy = 1;}
                   //출산일 경우 사용 가능한 휴가일 제한 기준이 없음
                   }else if(cd=='출산'){
                        if(realDy < 0){realDy = 1;}   
                   }else{
                         if(realDy < 0){realDy = 1;}
                         //사용가능한 휴가일보다 신청일이 클 경우 경고 후 return (예시 : 사용가능 휴가일 = 3일 / 신청일 = 4일 )
                         if(realDy > remainD){
                            alert( realDy+"일 선택 => 사용 가능한 휴가일을 초과하였습니다.");
                            $("[name=addTr]").find("[name=end_dayoff]").val("");
                            $("[name=addTr]").find("[name=using_dayoff]").val("");
                            return;
                         }
                         //1회 최대 휴가 사용 가능 일수는 5일로 설정 (신청일이 5일 초과일 경우, 경고후 return)
                         if(realDy > 5){
                            alert( realDy+"일 선택=> 1회 최대 휴가 사용 가능 일수는 5일입니다.");
                            $("[name=addTr]").find("[name=end_dayoff]").val("");
                            $("[name=addTr]").find("[name=using_dayoff]").val("");
                            return;
                         } 
                    }
               
                  	// ajax 호출을 통해 서버로 넘겨줄 데이터를 저장하기 위한 code
                    $("[name=addTr]").find("[name=using_dayoff]").val(realDy);
                    var usingD = $("[name=addTr]").find("[name=using_dayoff]").val();
                    updatedata = "dayoff_name="+cd+"&start_dayoff="+dateS+"&end_dayoff="+dateE+"&emp_no="+empNo+"&using_dayoff="+usingD+"&dayoff_apply_no="+dayoff_apply_no;
             }
             ,beforeShowDay:$.datepicker.noWeekends 
         }); //-----휴가 시작일 datepicker end



            
         $("#dateTill").datepicker({ 
	         dateFormat: 'yy-mm-dd'
	         ,defaultDate : dttillval
	         ,minDate : dtfromval
	         ,onClose: function( selectedDate ) {}
             ,onSelect: function() { 
	              var dateObject = $(this).datepicker('getDate');
	              cd = $("[name=addTr]").find("[name=dayoff_name]").val();
	              dateS = $("[name=addTr]").find("[name=start_dayoff]").val();
	              dateE = $("[name=addTr]").find("[name=end_dayoff]").val();
	              empNo = $("[name=addTr]").find("[name=emp_no]").val();
	              remainD = $("[name=addTr]").find("[name=remain_dayoff]").val();
                  var realDy = finalDayoff(dateS, dateE, remainD); 
   
                  if(cd=='반차'){
                     realDy = 0.5;
                     inputData("[name=end_dayoff]", dateS);
                     if(realDy < 0){realDy = 1;}
                  }else if(cd=='출산'){
                     if(realDy < 0){realDy = 1;}   
                  }else{
                     if(realDy < 0){realDy = 1;}
                     if(realDy > remainD){
                        alert( realDy+"일 선택 => 사용 가능한 휴가일을 초과하였습니다.");
                        $("[name=addTr]").find("[name=end_dayoff]").val("");
                        $("[name=addTr]").find("[name=using_dayoff]").val("");
                        return;
                     }
                     if(realDy > 5){
                        alert( realDy+"일 선택=> 1회 최대 휴가 사용 가능일 수는 5일입니다.");
                        $("[name=addTr]").find("[name=end_dayoff]").val("");
                        $("[name=addTr]").find("[name=using_dayoff]").val("");
                        return;
                     } 
                  }
                  $("[name=addTr]").find("[name=using_dayoff]").val(realDy);
                  var usingD = $("[name=addTr]").find("[name=using_dayoff]").val();
                  updatedata = "dayoff_name="+cd+"&start_dayoff="+dateS+"&end_dayoff="+dateE+"&emp_no="+empNo+"&using_dayoff="+usingD+"&dayoff_apply_no="+dayoff_apply_no;
             } 
             ,beforeShowDay:$.datepicker.noWeekends
                           
         }); //-----휴가 종료일 datepicker end
            
      }//-----function addUpdelTr end


      // 삽입된 tr의 수정버튼을 누를 시 실행되는 함수
      function dayoffUpdate(up){
         if(cd=='반차'){
            inputData("[name=end_dayoff]", dateS);
            var usingD = $("[name=addTr]").find("[name=using_dayoff]").val();
            updatedata = "dayoff_name="+cd+"&start_dayoff="+dateS+"&end_dayoff="+dateE+"&emp_no="+empNo+"&using_dayoff="+usingD+"&dayoff_apply_no="+dayoff_apply_no;
         }
         if(cd==null || dateS==null || dateE==null || dateS=='' || dateE=='' || empNo==null || realDy=='' || updatedata==null){
            alert('모두 선택해주시기 바랍니다.');
         }
         
         //비동기 방식으로 서버와 브라우저가 데이터를 주고 받기 위하여 사용
         $.ajax({
                url : "/group4erp/dayoffUpdateProc.do"
                , type: "post"
                , data : updatedata
                , success : function(dayoffUpdateCnt){
                      if(dayoffUpdateCnt == 1){
                            //alert("수정되었습니다.");
                            location.replace("/group4erp/viewEmpDayOffList.do");
                      }
                      else{
                            alert("서버쪽 DB 연동 실패. 관리자에게 문의");
                      }
                } 
                , error : function(){
                   alert("서버 접속 실패");
                }
         });
         
      } //----- function dayoffUpdate end

      
      
      
      
      function dayoffDelete(emp_no,remainD_origin){
         var Deletedata = "dayoff_name="+cd+"&start_dayoff="+dateS+"&end_dayoff="+dateE+"&emp_no="+empNo+"&using_dayoff="+usingD+"&dayoff_apply_no="+dayoff_apply_no;
         $.ajax({
                url : "/group4erp/dayoffDeleteProc.do"
                , type: "post"
                , data : Deletedata
                , success : function(dayoffDeleteCnt){
                      if(dayoffDeleteCnt == 1){
                            //alert("삭제되었습니다.");
                            location.replace("/group4erp/viewEmpDayOffList.do");
                      }
                      else{
                            alert("서버쪽 DB 연동 실패. 관리자에게 문의");
                      }
                } 
                , error : function(){
                   alert("서버 접속 실패");
                }
          });
      }
      
      
      function dayoffClose(close){
         $("[name=addTr]").hide(1000, function(){
        	 $("[name=addTr]").remove();
         });
      }

      
      
      
      
      
      
      
      
      var holidays = [
         	[2020,01,01,'신정'],
            [2020,1,24,'설날휴일'],
            [2020,1,25,'설날'],
            [2020,1,26,'설날휴일'],
            [2020,1,27,'대체휴일'],
            [2020,3,1,'3.1절'],
            [2020,4,15,'국회의원선거'],
            [2020,4,30,'부처님오신날'],
            [2020,5,5,'어린이날'],
            [2020,6,6,'현충일'],
            [2020,8,15,'광복절'],
            [2020,9,30,'추석연휴'],
            [2020,10,1,'추석'],
            [2020,10,2,'추석연휴'],
            [2020,10,3,'개천절'],
            [2020,10,9,'한글날'],
            [2020,12,25,'크리스마스']
      ]

      // 배열의 데이터를 날짜데이터로 변경하는 함수
      function dateObj(date){
         var dyarr = [];
         for( var i=0; i<date.length; i++ ){
            var pushdy = new Date(date[i][0],date[i][1]-1,date[i][2]);
            dyarr.push(pushdy);
         }
         if(dyarr.length > 0){
            return dyarr;
         }
         else{
            alert('데이터가 날짜로 변경되지 않았습니다.');
            return;
         }
      }

      
      function finalDayoff(dateE, dateE, remainD){
	       var cnt = 0;
	       
	       //매개변수로 받은 값(날짜)을 '-'로 쪼개어 년,월,일을 배열에 저장하여 날짜 데이터로 변환하는 작업
	       var arrS = dateS.split("-");
	       var arrE = dateE.split("-");
	       var startD = new Date(arrS[0], arrS[1]-1, arrS[2]);
	       var endD = new Date(arrE[0], arrE[1]-1, arrE[2]);
	       
	       //매개변수로 받은 종료일에서 시작일을 뺀 일수 
	       var count = (endD.getTime() - startD.getTime())/1000/(60*60*24);
	       
	       //변수 배열로 저장되어있는 올해 공휴일을 dateObj 함수 호출하면서 날짜 데이터로 변환하는 작업
	       var hldys = dateObj(holidays);
	       
	       //신청일수만큼 반복문을 돌려 변수에 신청한 모든 날짜를 담고 
	       //if문을 사용하여 공휴일, 주말과 겹치면 cnt변수에 +1하기
           var applyhldys = [];
           for(var i=0; i <= count; i++){
               applyhldys.push(new Date(arrS[0],arrS[1]-1,(parseInt(arrS[2],10))+i));
	           if( (applyhldys[i].getDay() == 0) || (applyhldys[i].getDay() == 6) ){
	              cnt++;
	           }
	           else{
	              for(var k=0; k < hldys.length; k++){
	                 if( (applyhldys[i].getTime() == hldys[k].getTime()) ){
	                    cnt++;
	                 }
	              }
	           }

           } 
           
           //따라서 cnt => 내가 신청한 일수와 겹치는 공휴일, 주말의 일수가 저장
           //최종 휴가일 계산 => 내가 신청한 휴가일수 - cnt(공휴일, 주말) +1
           realDy = count-cnt+1;
             
           if( isNaN(realDy) ){ realDy = 0; }
           return realDy;
           
      }

      function logout() {
         location.href="/group4erp/logout.do";
      }


      function goReset(){
         inputData("[name=dayoff_name]", "");
         inputData("[name=start_dayoff]", "");
         inputData("[name=end_dayoff]", "");
         inputData("[name=using_dayoff]", "");
         $("[name=addTr]").find("[name=using_dayoff]").val(0);
      }

   </script>
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
            <a class="active" href="javascript:;">
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
              <li  class="active">
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
	      <table width=99%>
	      	<tr>
	      		<td><h3><i class="fa fa-angle-right"></i> 직원 휴가 신청 현황</h3></td>
	       		<td align=right><div id="getTime" onload="getTime();"></div></td>
	       	</tr>
	      </table>
      	  <table><tr><td height=10></td></tr></table>  
      	  
          <div class="row">
          	<div class="col-md-12">
            	<div class="content-panel">
              		<h4><i class="fa fa-angle-right"></i> 검색</h4><hr>
      				<form name="empDayoffSearch" method="post" action="/group4erp/viewEmpDayOffList.do">
				         <!-- <div class="divcss"> -->
				         <table class="searchTable" style="border: 0px;">
				            <tr>
				               <th width="8%" style="text-align:right;"><b>* 구분&nbsp;</b></th>
				               <td width="32%" style="text-align:left">   
				                  &nbsp;&nbsp;<input type="checkbox" name="dayoff_state" value="휴가전">휴가전
				                  &nbsp;&nbsp;<input type="checkbox" name="dayoff_state" value="휴가중">휴가중
				                  &nbsp;&nbsp;<input type="checkbox" name="dayoff_state" value="휴가후">휴가후
				            </tr>
				            <tr>
				               <th width="8%" style="text-align:right;"><b>* 키워드&nbsp;</b></th>
				               <td colspan="3" width="32%"><input type="text" name="dy_keyword" size=78></td>
				               <td></td>
				               <td width="20%">
				                     <button type="button" class="btn btn-default" onclick="goDayoffSearch();">
					                     <input type="image" src="/group4erp/resources/image/magnifying-glass.png" style="width:13; height:13;"> 
					                     <font style="font-size:9pt;" >검색</font>
				                     </button>&nbsp;
				                     <button type="button" class="btn btn-default" onclick="goSearchAll();">
				                     	<input type="image" src="/group4erp/resources/image/searchA.png" style="width:13; height:13;">
				                     	<font style="font-size:9pt;">모두검색</font>
				                     </button>&nbsp;
				                     <button type="button" class="btn btn-default" onclick="goAllReset();">
				                     	<input type="image" src="/group4erp/resources/image/reset.png" style="width:13; height:13;">
				                     	<font style="font-size:9pt;">초기화</font>
				                     </button>
				               </td>
				            </tr>
				         </table><br>
				         <input type="hidden" name="selectPageNo" value="${hrListSearchDTO.selectPageNo}">
				         <input type="hidden" name="rowCntPerPage" value="${hrListSearchDTO.rowCntPerPage}">
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
				            	<td><h4><i class="fa fa-angle-right"></i>검색 결과</h4></td>
				                <td align=right>
				                   [신청 수] : ${getDayOffListCnt} 건 
				                   &nbsp;&nbsp;&nbsp;&nbsp;
				                   <select name="rowCntPerPageDown">
				                         <option value="10">10</option>
				                         <option value="15">15</option>
				                         <option value="20">20</option>
				                         <option value="25">25</option>
				                         <option value="30">30</option>
				                   </select> 행보기
				                 </td>
				         	</tr>
				         </table>
         				 <table><tr><td height="10"></td></tr></table>
         				 <form name="empDayOffList" method="post" action="/group4erp/viewEmpDayOffList.do">
             			 	<table class="table table-striped table-advance table-hover table-bordered" width="90%" border=0 cellspacing=0 cellpadding=5>
             					<thead>
						            <tr>
						               <th width="6%">No
						                <!-- 신청번호 sort -->
										<c:choose>
						                  <c:when test="${param.sort=='dayoff_apply_no desc'}">
						                     <th style="cursor:pointer" onClick="$('[name=sort]').val(''); goDayoffSearch();">▼ 신청번호</th>
						                  </c:when>
						                  <c:when test="${param.sort=='dayoff_apply_no asc'}">
						                     <th style="cursor:pointer" onClick="$('[name=sort]').val('dayoff_apply_no desc'); goDayoffSearch();">▲ 신청번호</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onClick="$('[name=sort]').val('dayoff_apply_no asc'); goDayoffSearch();">신청번호</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 소속 부서 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='3 desc'}">
						                     <th style="cursor:pointer" onClick="$('[name=sort]').val(''); goDayoffSearch();">▼ 소속 부서</th>
						                  </c:when>
						                  <c:when test="${param.sort=='3 asc'}">
						                     <th style="cursor:pointer" onClick="$('[name=sort]').val('3 desc'); goDayoffSearch();">▲ 소속 부서</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onClick="$('[name=sort]').val('3 asc'); goDayoffSearch();">소속 부서</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 직급 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='(select j.jikup_cd from code_jikup j, employee e where e.jikup_cd = j.jikup_cd and e.emp_no = da.emp_no) desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 직급</th>
						                  </c:when>
						                  <c:when test="${param.sort=='(select j.jikup_cd from code_jikup j, employee e where e.jikup_cd = j.jikup_cd and e.emp_no = da.emp_no) asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('(select j.jikup_cd from code_jikup j, employee e where e.jikup_cd = j.jikup_cd and e.emp_no = da.emp_no) desc'); goDayoffSearch();">▲ 직급
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('(select j.jikup_cd from code_jikup j, employee e where e.jikup_cd = j.jikup_cd and e.emp_no = da.emp_no) asc'); goDayoffSearch();">직급
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 성명 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='5 desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 성명</th>
						                  </c:when>
						                  <c:when test="${param.sort=='5 asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('5 desc'); goDayoffSearch();">▲ 성명
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('5 asc'); goDayoffSearch();">성명
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 휴가 종류 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='6 desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 휴가 종류</th>
						                  </c:when>
						                  <c:when test="${param.sort=='6 asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('6 desc'); goDayoffSearch();">▲ 휴가 종류
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('6 asc'); goDayoffSearch();">휴가 종류
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 휴가 시작일 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='start_dayoff desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 휴가 시작일</th>
						                  </c:when>
						                  <c:when test="${param.sort=='start_dayoff asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('start_dayoff desc'); goDayoffSearch();">▲ 휴가 시작일</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('start_dayoff asc'); goDayoffSearch();">휴가 시작일</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 휴가 종료일 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='end_dayoff desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 휴가 종료일</th>
						                  </c:when>
						                  <c:when test="${param.sort=='end_dayoff asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('end_dayoff desc'); goDayoffSearch();">▲ 휴가 종료일</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('end_dayoff asc'); goDayoffSearch();">휴가 종료일</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 휴가 신청일수 종류 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='da.using_dayoff desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 휴가 신청일수</th>
						                  </c:when>
						                  <c:when test="${param.sort=='da.using_dayoff asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('da.using_dayoff desc'); goDayoffSearch();">▲ 휴가 신청일수</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('da.using_dayoff asc'); goDayoffSearch();">휴가 신청일수</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 사용가능 휴가일 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='(select remain_dayoff from emp_dayoff_info where emp_no = da.emp_no) desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 사용가능 휴가일</th>
						                  </c:when>
						                  <c:when test="${param.sort=='(select remain_dayoff from emp_dayoff_info where emp_no = da.emp_no) asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('(select remain_dayoff from emp_dayoff_info where emp_no = da.emp_no) desc'); goDayoffSearch();">▲ 사용가능 휴가일</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('(select remain_dayoff from emp_dayoff_info where emp_no = da.emp_no) asc'); goDayoffSearch();">사용가능 휴가일</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 총 휴가일 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='(select dayoff_tot from emp_dayoff_info where emp_no = da.emp_no) desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 총 휴가일</th>
						                  </c:when>
						                  <c:when test="${param.sort=='(select dayoff_tot from emp_dayoff_info where emp_no = da.emp_no) asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('(select dayoff_tot from emp_dayoff_info where emp_no = da.emp_no) desc'); goDayoffSearch();">▲ 총 휴가일</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('(select dayoff_tot from emp_dayoff_info where emp_no = da.emp_no) asc'); goDayoffSearch();">총 휴가일</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 신청일 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='dayoff_apply_dt desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 신청일</th>
						                  </c:when>
						                  <c:when test="${param.sort=='dayoff_apply_dt asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('dayoff_apply_dt desc'); goDayoffSearch();">▲ 신청일</th>
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('dayoff_apply_dt asc'); goDayoffSearch();">신청일</th>
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 결재 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='13 desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 결재</th>
						                  </c:when>
						                  <c:when test="${param.sort=='13 asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('13 desc'); goDayoffSearch();">▲ 결재
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('13 asc'); goDayoffSearch();">결재
						                  </c:otherwise>
						               </c:choose>
						               
						               <!-- 휴가상태 sort -->
						               <c:choose>
						                  <c:when test="${param.sort=='14 desc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val(''); goDayoffSearch();">▼ 휴가상태</th>
						                  </c:when>
						                  <c:when test="${param.sort=='14 asc'}">
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('14 desc'); goDayoffSearch();">▲ 휴가상태
						                  </c:when>
						                  <c:otherwise>
						                     <th style="cursor:pointer" onclick="$('[name=sort]').val('14 asc'); goDayoffSearch();">휴가상태
						                  </c:otherwise>
						               </c:choose>
						            </tr>
								</thead>
								<tbody>
						            <c:forEach items="${requestScope.getDayOffList}" var="dayoff" varStatus="loopTagStatus">
						               <tr style="cursor:pointer; font-size:11pt;" onclick="addUpdelTr(this,'${dayoff.emp_no}', '${dayoff.dayoff_apply_no}')">
						                  <td align=center>
						                  ${getDayOffListCnt-(hrListSearchDTO.selectPageNo*hrListSearchDTO.rowCntPerPage-hrListSearchDTO.rowCntPerPage+1+loopTagStatus.index)+1}
						                  </td>
						                  <td align=center>${dayoff.dayoff_apply_no}</td>
						                  <td align=center>${dayoff.dep_name}</td>
						                  <td align=center>${dayoff.jikup}</td>
						                  <td align=center>${dayoff.emp_name}</td>
						                  <td align=center>${dayoff.dayoff_name}</td>
						                  <td align=center>${dayoff.start_dayoff}</td>
						                  <td align=center>${dayoff.end_dayoff}</td>
						                  <td align=center>${dayoff.using_dayoff=='.5'?'0.5':dayoff.using_dayoff}</td>
						                  <td align=center>${dayoff.remain_dayoff}</td>
						                  <td align=center>${dayoff.dayoff_tot}</td>
						                  <td align=center>${dayoff.dayoff_apply_dt}</td>
						                  <td align=center>${dayoff.confirm}</td>
						                  <td align=center>${dayoff.dayoffState}</td>
						               </tr>
						            </c:forEach>
               					</tbody>
         				   </table> <br>
      					   <div align=center>&nbsp;<span class="pagingNumber"></span>&nbsp;</div><br>
      					</form>
            		</div>
		         </div>
		         <!-- /col-md-12 -->
        	</div><br>
        </div>
        <!-- /row -->
      </section>
    </section>
    <!-- /MAIN CONTENT -->
    <!--main content end-->
  </section>
  <!-- js placed at the end of the document so the pages load faster -->
  <script src="${ctRootlib}/jquery/jquery.min.js"></script>
  <script src="${ctRootlib}/bootstrap/js/bootstrap.min.js"></script>
  <script class="include" type="text/javascript" src="${ctRootlib}/jquery.dcjqaccordion.2.7.js"></script>
  <script src="${ctRootlib}/jquery.scrollTo.min.js"></script>
  <script src="${ctRootlib}/jquery.nicescroll.js" type="text/javascript"></script>
  <!--common script for all pages-->
  <script src="${ctRootlib}/common-scripts.js"></script>
  <!--script for this page-->
   <script src="${ctRootlib}/jquery-ui-1.9.2.custom.min.js"></script>
   <!--custom switch-->
   <script src="${ctRootlib}/bootstrap-switch.js"></script>
   <!--custom tagsinput-->
   <script src="${ctRootlib}/jquery.tagsinput.js"></script>
   <!--custom checkbox & radio-->
</body>
</html>
