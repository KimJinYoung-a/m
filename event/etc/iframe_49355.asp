<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
dim eCode, eCodeLink, vUserID, vQuery, vItemID, vArr, vAnswer1, vAnswerDate1, vDay17, vDay18, vDay19, vDay20, vDay21, vOff, vClose, vOn, vClick
	vUserID = GetLoginUserID()
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21082"
		eCodeLink = "21085"
		vItemID = "345677"
	Else
		eCode = "49354"
		eCodeLink = "49355"
		vItemID = "666696"
	End If
	

%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 썸만 타다 끝낼 건가요?!</title>
<style type="text/css">
.mEvt49355 img {vertical-align:top;}
.mEvt49355 p {max-width:100%;}
.puzzleMaking {background:#f5ebd5;}
.puzzleMaking .puzzle {position:relative; width:480px; margin:0 auto;}
.puzzleMaking .puzzle ul {overflow:hidden; position:absolute; left:0; top:0;}
.puzzleMaking .puzzle ul li {float:left;}
.puzzleMaking .puzzle ul li.piece01 {width:35%;}
.puzzleMaking .puzzle ul li.piece05 {width:32.5%;}
.puzzleMaking .puzzle ul li.piece02 {width:32.5%;}
.puzzleMaking .puzzle ul li.piece03 {width:50%;}
.puzzleMaking .puzzle ul li.piece04 {width:50%;}
.puzzleMaking .puzzle ul li img {width:100%;}
.puzzleAnswer legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.puzzleAnswer .answerForm {position:relative; padding:0 200px 0 15px; background-color:#9fd5ce;}
.puzzleAnswer .answerForm .iText {width:100%; height:90px; padding:0 30px 0 18px; border:3px solid #f4628d; border-radius:10px; color:#7b7b7b; font-size:20px; line-height:90px; font-weight:bold;}
.puzzleAnswer .answerForm .btnSubmit {position:absolute; right:15px; top:0;}
.puzzleAnswer .answerForm .btnSubmit img {width:163px;}
@media all and (max-width:480px){
	.puzzleMaking .puzzle {width:320px;}
	.puzzleAnswer .answerForm {padding:0 150px 0 15px;}
	.puzzleAnswer .answerForm .iText {width:100%; height:60px; padding:0 18px; border:2px solid #f4628d; color:#7b7b7b; font-size:13px; line-height:60px;}
	.puzzleAnswer .answerForm .btnSubmit {position:absolute; right:15px; top:0;}
	.puzzleAnswer .answerForm .btnSubmit img {width:109px;}
}
</style>
<script type="text/javascript">
function jsSubmitComment(){
	var frm = document.frmGubun2;
	<% If vUserID = "" Then %>
	if(confirm("로그인 후에 이벤트 참여가 가능합니다\n로그인 하시겠습니까?")){
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCodeLink%>"
	}
	return;
	<% End If %>

	<% If vUserID <> "" Then %>
		if(frm.itemid.value == "상품 코드를 입력해주세요"){
			frm.itemid.value = ""
		    alert("어떤 상품인지 아셨나요?\n상품코드를 입력하고 응모해주세요~");
		    frm.itemid.focus();
		    return;
		}
		
	   if(!frm.itemid.value){
	    alert("어떤 상품인지 아셨나요?\n상품코드를 입력하고 응모해주세요~");
	    frm.itemid.focus();
	    return;
	   }
	   
	   frm.submit();
	<% End If %>

}

function jsChkChk(){
	var frm = document.frmGubun2;
	if(frm.itemid.value == "상품 코드를 입력해주세요"){
		frm.itemid.value = ""
	    frm.itemid.focus();
	}
}

function jsOpenPuzzle(){
<% If vUserID = "" Then %>
	if(confirm("로그인 후에 이벤트 참여가 가능합니다\n로그인 하시겠습니까?")){
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCodeLink%>"
	}
	return;
<% Else %>
	var frm = document.frmGubun1;
	frm.submit();
<% End If %>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
<div class="mEvt49092">
	<div class="mEvt49355">
		<div class="puzzleGame">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/tit_puzzle_event.jpg" alt="텐바이텐과 함께하는 기프트 퍼즐 이벤트 퍼즐 한판을 맞춰라!!" style="width:100%;" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_way_01.jpg" alt="하루에, 한번씩! 상품 퍼즐을 클릭해서 완성해주세요! 5개의 퍼즐을 모두 맞추신 분들 중, 5분을 추첨해서 완성한 퍼즐 속 상품을 선물로 드립니다." style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_date.jpg" alt="이벤트 기간 : 02.17~02.21 / 당첨자 발표일 : 02.24" style="width:100%;" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_way_02.jpg" alt="퍼즐 3개 이상 완성하면, 300마일리지 지급! 퍼즐 5개 모두 완성하면, 이벤트 응모 완료!" style="width:100%;" /></p>
			
			<!-- 퍼즐 만들기 -->
			<div class="puzzleMaking">
				<div class="puzzle">
					<ul>
					<%
						vDay17 = 14
						vDay18 = 15
						vDay19 = 16
						vDay20 = 17
						vDay21 = 18
						
						vDay17 = 17
						vDay18 = 18
						vDay19 = 19
						vDay20 = 20
						vDay21 = 21

						'############################################### 2월 17일 ###############################################
						vOff	= "<li class=""piece01""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_01_off.jpg"" alt=""2월 17일"" /></li>" & vbCrLf
						vClose	= "<li class=""piece01""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_01_close.jpg"" alt=""2월 17일"" /></li>" & vbCrLf
						vOn		= "<li class=""piece01"" style=""cursor:pointer;"" onClick=""jsOpenPuzzle();""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_01_on.jpg"" alt=""2월 17일"" /></li>" & vbCrLf
						vClick	= "<li class=""piece01""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_01_click.jpg"" alt=""2월 17일"" /></li>" & vbCrLf
						
						If date() < CDate("2014-02-"&vDay17) Then	'### 날짜 안됐을때.
							Response.Write vOff
						Else
							If vUserID <> "" Then
								vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt3 = '2014-02-"&vDay17&"' AND sub_opt1 = 'm1'"
								rsget.Open vQuery,dbget,1
								If Not rsget.Eof Then
									vAnswer1 = CStr(rsget(0))
								End If
								rsget.close
							End If
							If vAnswer1 = "" Then	'### 이 날짜에 체크못했을때
								If CDate("2014-02-"&vDay17) < date() Then
									Response.Write vClose
								Else
									Response.Write vOn
								End If
							Else
								Response.Write vClick
								'If CStr(vAnswer1) <> CStr(vItemID) Then
								'	Response.Write vClose
								'End IF
							End IF
						End IF
						
						
						'############################################### 2월 21일 ###############################################
						vAnswer1 = ""
						vOff	= "<li class=""piece05""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_05_off.jpg"" alt=""2월 21일"" /></li>" & vbCrLf
						vClose	= "<li class=""piece05""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_05_close.jpg"" alt=""2월 21일"" /></li>" & vbCrLf
						vOn		= "<li class=""piece05"" style=""cursor:pointer;"" onClick=""jsOpenPuzzle();""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_05_on.jpg"" alt=""2월 21일"" /></li>" & vbCrLf
						vClick	= "<li class=""piece05""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_05_click.jpg"" alt=""2월 21일"" /></li>" & vbCrLf
						
						If date() < CDate("2014-02-"&vDay21) Then
							Response.Write vOff
						Else
							If vUserID <> "" Then
								vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt3 = '2014-02-"&vDay21&"' AND sub_opt1 = 'm1'"
								rsget.Open vQuery,dbget,1
								If Not rsget.Eof Then
									vAnswer1 = CStr(rsget(0))
								End If
								rsget.close
							End If
							If vAnswer1 = "" Then
								If CDate("2014-02-"&vDay21) < date() Then
									Response.Write vClose
								Else
									Response.Write vOn
								End If
							Else
								Response.Write vClick
								'If CStr(vAnswer1) <> CStr(vItemID) Then
								'	Response.Write vClose
								'End IF
							End IF
						End IF
						
						
						'############################################### 2월 18일 ###############################################
						vAnswer1 = ""
						vOff	= "<li class=""piece02""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_02_off.jpg"" alt=""2월 18일"" /></li>" & vbCrLf
						vClose	= "<li class=""piece02""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_02_close.jpg"" alt=""2월 18일"" /></li>" & vbCrLf
						vOn		= "<li class=""piece02"" style=""cursor:pointer;"" onClick=""jsOpenPuzzle();""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_02_on.jpg"" alt=""2월 18일"" /></li>" & vbCrLf
						vClick	= "<li class=""piece02""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_02_click.jpg"" alt=""2월 18일"" /></li>" & vbCrLf
						
						If date() < CDate("2014-02-"&vDay18) Then
							Response.Write vOff
						Else
							If vUserID <> "" Then
								vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt3 = '2014-02-"&vDay18&"' AND sub_opt1 = 'm1'"
								rsget.Open vQuery,dbget,1
								If Not rsget.Eof Then
									vAnswer1 = CStr(rsget(0))
								End If
								rsget.close
							End If
							If vAnswer1 = "" Then
								If CDate("2014-02-"&vDay18) < date() Then
									Response.Write vClose
								Else
									Response.Write vOn
								End If
							Else
								Response.Write vClick
								'If CStr(vAnswer1) <> CStr(vItemID) Then
								'	Response.Write vClose
								'End IF
							End IF
						End IF
						
						
						'############################################### 2월 19일 ###############################################
						vAnswer1 = ""
						vOff	= "<li class=""piece03""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_03_off.jpg"" alt=""2월 19일"" /></li>" & vbCrLf
						vClose	= "<li class=""piece03""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_03_close.jpg"" alt=""2월 19일"" /></li>" & vbCrLf
						vOn		= "<li class=""piece03"" style=""cursor:pointer;"" onClick=""jsOpenPuzzle();""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_03_on.jpg"" alt=""2월 19일"" /></li>" & vbCrLf
						vClick	= "<li class=""piece03""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_03_click.jpg"" alt=""2월 19일"" /></li>" & vbCrLf
						
						If date() < CDate("2014-02-"&vDay19) Then
							Response.Write vOff
						Else
							If vUserID <> "" Then
								vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt3 = '2014-02-"&vDay19&"' AND sub_opt1 = 'm1'"
								rsget.Open vQuery,dbget,1
								If Not rsget.Eof Then
									vAnswer1 = CStr(rsget(0))
								End If
								rsget.close
							End If
							If vAnswer1 = "" Then
								If CDate("2014-02-"&vDay19) < date() Then
									Response.Write vClose
								Else
									Response.Write vOn
								End If
							Else
								Response.Write vClick
								'If CStr(vAnswer1) <> CStr(vItemID) Then
								'	Response.Write vClose
								'End IF
							End IF
						End IF
						
						
						'############################################### 2월 20일 ###############################################
						vAnswer1 = ""
						vOff	= "<li class=""piece04""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_04_off.jpg"" alt=""2월 20일"" /></li>" & vbCrLf
						vClose	= "<li class=""piece04""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_04_close.jpg"" alt=""2월 20일"" /></li>" & vbCrLf
						vOn		= "<li class=""piece04"" style=""cursor:pointer;"" onClick=""jsOpenPuzzle();""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_04_on.jpg"" alt=""2월 20일"" /></li>" & vbCrLf
						vClick	= "<li class=""piece04""><img src=""http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_04_click.jpg"" alt=""2월 20일"" /></li>" & vbCrLf
						
						If date() < CDate("2014-02-"&vDay20) Then
							Response.Write vOff
						Else
							If vUserID <> "" Then
								vQuery = "SELECT sub_opt2 FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' AND userid = '" & vUserID & "' AND sub_opt3 = '2014-02-"&vDay20&"' AND sub_opt1 = 'm1'"
								rsget.Open vQuery,dbget,1
								If Not rsget.Eof Then
									vAnswer1 = CStr(rsget(0))
								End If
								rsget.close
							End If
							If vAnswer1 = "" Then
								If CDate("2014-02-"&vDay20) < date() Then
									Response.Write vClose
								Else
									Response.Write vOn
								End If
							Else
								Response.Write vClick
								'If CStr(vAnswer1) <> CStr(vItemID) Then
								'	Response.Write vClose
								'End IF
							End IF
						End IF
					%>

					</ul>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/img_puzzle_finish.jpg" alt="" style="width:100%;" /></div>
				</div>
			</div>
			<!-- //퍼즐 만들기 -->

			<!-- 정답 입력 폼 -->
			<div class="puzzleAnswer">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_answer.jpg" alt="잠깐! 혹시 어떤 상품인지 느낌 오셨나요? 그렇다면 상품코드를 입력해주세요! 정답을 맞춘 분들 중 5분을 추첨해, cgv 주말 예매권(1인 2매)을 드립니다" style="width:100%;" /></p>
				<form name="frmGubun2" method="post" action="doEventSubscript49355.asp" style="margin:0px;" target="prociframe">
				<input type="hidden" name="gubun" value="2">
				<fieldset>
					<legend>정답 입력하기</legend>
					<div class="answerForm">
						<input type="text" title="상품코드 입력" name="itemid" value="상품 코드를 입력해주세요" onClick="jsChkChk();" class="iText" />
						<div class="btnSubmit"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/btn_submit.jpg" alt="응모하기" style="cursor:pointer;" onClick="jsSubmitComment()" /></div>
					</div>
					<p class="ex"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_product_code.jpg" alt="※ 상품상세페이지에서 상품코드를 확인하세요" style="width:100%;" /></p>
				</fieldset>
				</form>
			</div>
			<!-- //정답 입력 폼 -->

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_event_web.jpg" alt="지금 온라인에서 다른 상품의 퍼즐을 맞출 수 있습니다! 온라인에서도 도전하세요!" style="width:100%;" />
			<div class="eventPcVersion"><a href="http://www.10x10.co.kr/event/eventmain.asp?eventid=<%=eCode%>&mfg=pc" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/btn_go.jpg" alt="이벤트 참여하러 가기" style="width:100%;" /></a></div>

			<div class="puzzleEventNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/tit_puzzle_event_note.jpg" alt="이벤트 안내" style="width:100%;" /></h3>
				<ul>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_event_note_01.gif" alt="하루에 한 번 지정된 퍼즐을 맞춰주세요. 5개의 퍼즐을 모두 완성할 경우, 이벤트에 자동응모 됩니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_event_note_02.gif" alt="온라인과 모바일에서 서로 다른 상품의 퍼즐을 완성할 수 있습니다. 텐바이텐 고객이면 모두 참여 가능합니다. CGV 주말 예매권은 당첨자 발표일(2월24일) 오후 3시에 당첨자 핸드폰 번호로 일괄 발송됩니다." style="width:100%;" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/49355/txt_puzzle_event_note_03.gif" alt="퍼즐 속 상품명과 상품 코드는 당첨자 발표날 공지사항을 통해 확인 가능합니다. 상품 코드 입력 후, 응모하기는 하루에 5회까지만 가능합니다." style="width:100%;" /></li>
				</ul>
			</div>

		</div>
	</div>
</div>
<form name="frmGubun1" method="post" action="doEventSubscript49355.asp" style="margin:0px;" target="prociframe">
<input type="hidden" name="gubun" value="1">
</form>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->