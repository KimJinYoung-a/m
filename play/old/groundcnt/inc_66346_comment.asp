<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'########################################################
' PLAY #25 CAMERA 찰칵_코맨트
' 2015-09-18 원승현 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64891
Else
	eCode   =  66346
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, iColorVal, eCC, vchk

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	
	vchk = requestCheckVar(Request("gb"),2)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	iColorVal = 1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 8		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
body {background-color:#ff915b;}
.heightGrid {background-color:#ff915b;}

.form legend {visibility:hidden; width:0; height:0}
.form .field {text-align:center;}
.form .itext {width:65px; height:65px; border:1px solid #6b4431; color:#656565; font-size:27px; vertical-align:top; text-align:center;}
.form .btnsubmit {width:131px;}

.commentlist {padding-top:5%;}
.commentlist ul {overflow:hidden; width:290px; margin:0 auto; padding-left:10px;}
.commentlist ul li {float:left; width:140px; height:114px; background-repeat:no-repeat; background-position:50% 0; background-size:140px 114px;}
.commentlist ul li.bg1 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150921/bg_comment_01.png);}
.commentlist ul li.bg2 {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150921/bg_comment_02.png);}
.commentlist ul li span, .commentlist ul li strong {display:block;}
.commentlist ul li .no {position:relative; margin-top:10px; padding-left:3px; font-size:10px; color:#000;}
.commentlist ul li .no em {position:absolute; top:0; right:18px; text-align:right;}
.commentlist ul li strong {width:125px; margin-top:55px; color:#fff; font-size:15px; text-align:center;}

.paging {margin-top:20px;}
.paging span, .paging span.arrow {border:1px solid #af653f;}
.paging span a {color:#000;}
.paging span.arrow {background-color:#af653f;}
.paging span.current {background-color:rgba(255,255,255,0.8);}

@media all and (min-width:480px){
	.form .itext {width:97px; height:97px; font-size:40px;}
	.form .btnsubmit {width:196px;}

	.commentlist ul {width:460px; padding-left:30px;}
	.commentlist ul li {width:210px; height:171px; background-size:210px 171px;}
	.commentlist ul li .no {position:relative; margin-top:15px; padding-left:3px; font-size:14px;}
	.commentlist ul li .no em {right:27px;}
	.commentlist ul li strong {width:187px; margin-top:82px; font-size:22px;}
}
</style>
<script type="text/javascript">

 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" or vchk<>"" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>

		<% if not(left(now(), 10) >= "2015-09-18" And left(now(), 10) < "2015-10-03") then %>
		    alert("이벤트 기간이 아닙니다..");
			return false;
		<% end if %>
	   
	   if(frm.caText1.value == "" ){
	    alert("상상하신 셔터음을 입력해주세요.");
		document.frmcom.caText1.value="";
	    frm.caText1.focus();
	    return false;
	   }

	   if(frm.caText2.value == "" ){
	    alert("상상하신 셔터음을 입력해주세요.");
		document.frmcom.caText2.value="";
	    frm.caText2.focus();
	    return false;
	   }


	   frm.action = "/play/groundcnt/doEventSubscript66346.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}
//-->
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
	<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="bidx" value="<%=bidx%>"/>
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
	<input type="hidden" name="iCTot" value=""/>
	<input type="hidden" name="mode" value="add"/>
	<input type="hidden" name="userid" value="<%=GetEncLoginUserID%>"/>
		<% If isApp="1" Or vchk<>"" Then %>

		<% Else %>
			<div class="header">
				<h1>셔터음 상상해보기</h1>
				<p class="btnPopClose"><button class="pButton" onclick="self.close();">닫기</button></p>
			</div>
		<% End If %>
		<!-- content area -->
		<div class="content" id="contentArea">

			<!-- CAMERA #3 -->
			<div class="mPlay20150921">
				<!-- form -->
				<div class="form">
					<form action>
						<fieldset>
						<legend>새로운 셔터음 만들기</legend>
							<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150921/txt_imagine.png" alt="여러분의 상상을 더해 새로운 셔터음을 만들어보세요! 추첨을 통해 총 5분께 일회용카메라와 필름을 선물로 드립니다." /></p>
							<div class="field">
								<input type="text" name="caText1" id="caText1" class="itext" maxLength="1" />
								<input type="text" name="caText2" id="caText2" class="itext" maxLength="1" />
								<input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20150921/btn_submit.png" alt="응모하기" class="btnsubmit" onclick="jsSubmitComment();return false;" />
							</div>
							<img src="http://webimage.10x10.co.kr/playmo/ground/20150921/img_line_02.png" alt="" />
						</fieldset>
					</form>
				</div>

				<% IF isArray(arrCList) THEN %>
				<!-- comment list -->
				<div class="commentlist">
					<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
						<% 
								Dim opt1 , opt2 , opt3
								If arrCList(1,intCLoop) <> "" then
									opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
									opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
									opt3 = SplitValue(arrCList(1,intCLoop),"//",2)
								End If 

							If iColorVal > 3 Then
								iColorVal = 1
							End If

						%>
						<li>
							<span class="no">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %> <em><%=printUserId(arrCList(2,intCLoop),2,"*")%></em></span>
							<strong><%=opt1%></strong>
						</li>
						<% Next %>
					</ul>

					<div class="paging">
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
					</div>
				</div>
				<% End If %>
			</div>

		</div>
		<!-- //content area -->
	</div>
	</form>
</div>

<script type="text/javascript">
$(function(){
	/* comment random bg */
	var classes = ["bg1", "bg2"];
	$(".commentlist ul li").each(function(){
		$(this).addClass(classes[~~(Math.random()*classes.length)]);
	});
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->