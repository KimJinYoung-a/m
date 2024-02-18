<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event41913Cls.asp" -->
<%
dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  20972
	Else
		eCode   =  45881
	End If

dim com_egCode, bidx
	Dim cEComment
	Dim cEComment1
	Dim iCTotCnt, arrCList,arrClist1,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, FCpage

	'파라미터값 받기 & 기본 변수 값 세팅
	FCpage =requestCheckVar(Request("FCpage"),10)
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 5		'한 페이지의 보여지는 열의 수
	iCPerCnt = 3		'보여지는 페이지 간격

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

	set cEComment1 = new ClsEvtComment			'Top2

	cEComment1.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment1.FEBidx    	= bidx
	cEComment1.FCPage 		= iCCurrpage	'현재페이지
	cEComment1.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment1.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList1 = cEComment1.fnGetComment1		'리스트 가져오기
	set cEComment = Nothing

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/default.css">
<link rel="stylesheet" type="text/css" href="/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="/lib/css/content.css">
<style type="text/css">
.mEvt45949 img {vertical-align:top;}kuyn
.mEvt45949 .tenten12th {position:relative; width:100%; overflow:hidden;}
.mEvt45949 .tenten12th .cmtCont {padding-bottom:30px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_bg_cmt_list.png) left top repeat-y; background-size:100% auto;}
.mEvt45949 .tenten12th .cmtCont .tit {text-align:center;}
.mEvt45949 .cmtType {margin:25px 10px 0; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type.png) left bottom no-repeat; background-size:100% 100%;}
.mEvt45949 .cmtType:after {content:" "; display:block; height:0; clear:both; visibility:hidden;}
.mEvt45949 .cmtType li {position:relative; float:left; width:25%; text-align:center;}
.mEvt45949 .cmtType li label {display:block; margin-top:8px;}
.mEvt45949 .cmtType li input { vertical-align:top;}
.mEvt45949 .cmtType li span {display:inline-block; width:100%; text-align:center; position:absolute; left:0; top:-25px;}
.mEvt45949 .cmtWrite {position:relative; overflow:hidden; margin:24px 10px 0; text-align:center;}
.mEvt45949 .cmtWrite div {text-align:left; border:5px solid #f44d25; background:#fff;}
.mEvt45949 .cmtWrite div textarea {display:block; width:94%; height:70px; padding:2%; text-align:left; border:1px solid #fff; vertical-align:top; font-size:11px; line-height:16px;}
.mEvt45949 .cmtWrite .enroll {margin-top:10px; width:33%; -webkit-border-radius:0; -webkit-appearance:none; vertical-align:top;}
.mEvt45949 .congList {overflow:hidden; margin:0 10px 20px; }
.mEvt45949 .congList li {position:relative; width:100%; font-size:11px; line-height:16px; color:#555; text-align:center; margin-top:14px; padding-bottom:8px;  background-position:left bottom; background-repeat:no-repeat; background-size:100% auto;}
.mEvt45949 .congList li.type01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type01_btm.png);}
.mEvt45949 .congList li.type02{background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type02_btm.png);}
.mEvt45949 .congList li.type03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type03_btm.png);}
.mEvt45949 .congList li.type04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type04_btm.png);}
.mEvt45949 .congList li.type05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type05_btm.png);}
.mEvt45949 .congList li.type06 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type06_btm.png);}
.mEvt45949 .congList li div {padding:0 10px; background-position:left top; background-repeat:no-repeat; background-size:100% auto; }
.mEvt45949 .congList li.type01 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type01.png);}
.mEvt45949 .congList li.type02 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type02.png);}
.mEvt45949 .congList li.type03 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type03.png);}
.mEvt45949 .congList li.type04 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type04.png);}
.mEvt45949 .congList li.type05 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type05.png);}
.mEvt45949 .congList li.type06 div {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type06.png);}
.mEvt45949 .congList li .txt {padding:14% 12px 0; line-height:17px; word-break:break-all;}
.mEvt45949 .congList li .writer {margin-top:15px;}
.mEvt45949 .congList li .writer .btn {margin:-1px 0 0 4px;}
.mEvt45949 .congList li .writer img {vertical-align:middle; display:inline-block; margin-top:-2px;}
.mEvt45949 .congList li .info {overflow:hidden; margin:5px 12px 0; border-top:1px solid #c2c2c2;}
.mEvt45949 .congList li .info .num {float:left;}
.mEvt45949 .congList li .info .date {float:right;}
.mEvt45949 .cmtType.t02 {margin-top:30px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_img_cmt_type2.png) left bottom no-repeat; background-size:100% 100%;}
.mEvt45949 .cmtType.t02 li:first-child {margin-left:24%;}
.mEvt45949 .evtNav li {position:relative;}
</style>
<script type="text/javascript">
<!--
	function goPage(page)
	{
		document.frmcom.iCC.value=page;
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked||frm.spoint[5].checked)){
	    alert("이미지를 선택해주세요");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="최대 200자까지 입력 가능합니다."){
	    alert("코멘트를 입력해주세요");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm.value)>200){
			alert('최대 한글 200자 까지 입력 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}

	   frm.action = "doEventSubscript45949.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsupdateComment(cidx)	{
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return;
		<% end if %>

			document.frmupdatecom.Cidx.value = cidx;
	   		document.frmupdatecom.submit();
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm.value =="최대 200자까지 입력 가능합니다."){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur()
	{

		if(document.frmcom.txtcomm.value ==""){
			document.frmcom.txtcomm.value="최대 200자까지 입력 가능합니다.";
		}
	}
	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 최대 200자 입니다.");
		obj.value = obj.value.substring(0,maxLength); //200자 이하 튕기기
		}
	}
//-->
</script>
<script>
<!--
	function jsDownCoupon(stype,idx){
	<% IF IsUserLoginOK THEN %>
	var frm;
		frm = document.frmC;
		//frm.target = "iframecoupon";
		frm.action = "/shoppingtoday/couponshop_process.asp";
		frm.stype.value = stype;
		frm.idx.value = idx;
		frm.submit();
	<%ELSE%>
		if(confirm("로그인하시겠습니까?")) {
			top.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
		}
	<%END IF%>
	}

//-->
</script>
</head>
<body>
<form name="frmC" method="post">
<input type="hidden" name="stype" value="">
<input type="hidden" name="idx" value="">
</form>
<iframe src="about:blank" name="iframecoupon" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
<div class="mEvt45949">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_head.png" alt="텐바이텐 가을운동회" style="width:100%;" /></p>
	<div class="evtNav">
		<ul>
			<li>
				<a href="/event/eventmain.asp?eventid=45952" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_menu01.png" alt="" style="width:100%;" /></a>
			</li>
			<li>
				<a href="javascript:jsDownCoupon('prd,prd,prd','8819,8820,8821');"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_coupon.png" alt="" style="width:100%;" /></a>
			</li>
			<li>
				<a href="/event/eventmain.asp?eventid=45950" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_menu02.png" alt="" style="width:100%;" /></a>
			</li>
			<li>
				<a href="/event/eventmain.asp?eventid=45951" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_menu03.png" alt="" style="width:100%;" /></a>
			</li>
			<li>
				<a href="/event/eventmain.asp?eventid=45954"  target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_menu04.png" alt="" style="width:100%;" /></a>
			</li>
			<li>
				<a href="https://m.facebook.com/your10x10/posts/648073438546505?substory_index=0" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_menu05.png" alt="" style="width:100%;" /></a>
			</li>
		</ul>
	</div>
	<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_txt_pc.png" style="width:100%;" alt="PCWEB에서 만나요!" /></p>
	<div class="tenten12th">
		<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<div class="cmtCont">
			<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_comment_tit.png" style="width:100%;" alt="텐바이텐의 12번째 생일을 축하해주세요!" /></p>
			<ul class="cmtType">
				<li>
					<span><input type="radio" id="cmt01" name="spoint" value="1" /></span>
					<label for="cmt01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_blank.png" style="width:100%;" alt="Happy Birthday" /></label>
				</li>
				<li>
					<span><input type="radio" id="cmt02" name="spoint" value="2" /></span>
					<label for="cmt02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_blank.png" style="width:100%;" alt="Thank you" /></label>
				</li>
				<li>
					<span><input type="radio" id="cmt03" name="spoint" value="3"/></span>
					<label for="cmt03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_blank.png" style="width:100%;" alt="With you" /></label>
				</li>
				<li>
					<span><input type="radio" id="cmt04" name="spoint" value="4"/></span>
					<label for="cmt04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_blank.png" style="width:100%;" alt="Congratulation" /></label>
				</li>
			</ul>
			<ul class="cmtType t02">
				<li>
					<span><input type="radio" id="cmt05" name="spoint" value="5"/></span>
					<label for="cmt05"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_blank.png" style="width:100%;" alt="Congratulation" /></label>
				</li>
				<li>
					<span><input type="radio" id="cmt06" name="spoint" value="6"/></span>
					<label for="cmt06"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_blank.png" style="width:100%;" alt="Congratulation" /></label>
				</li>
			</ul>
			<div class="cmtWrite">
				<div><textarea cols="30" rows="3" maxlength="200" name="txtcomm" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="최대 200자까지 입력 가능합니다." autocomplete="off">최대 200자까지 입력 가능합니다.</textarea></div>
				<input type="image" alt="등록하기" class="enroll" src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_btn_enroll.png" />
			</div>
		</div>
		</form>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45949/45949_txt_notice.png" style="width:100%;" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다." /></p>
		<form name="frmdelcom" method="post" action="doEventSubscript45949.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
		<form name="frmupdatecom" method="post" action="/event/12th/index_proc.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="update">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		</form>
		<% IF isArray(arrCList) THEN %>
		<ul class="congList">
			<% For intCLoop = 0 To UBound(arrCList,2)%>
			<li class="type0<%=arrCList(3,intCloop)%>">
				<div>
					<p class="txt"><%=db2html(arrCList(1,intCLoop))%></p>
					<p class="writer">
						<% If arrCList(8,intCLoop)="M" Then %>
						<img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" width="9px" alt="모바일에서 작성" />
						<% End If %>
						<%=printUserId(arrCList(2,intCLoop),2,"*")%>님
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<span class="btn btn6 gryB w40B"><a href="#" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');" class="btn btnS2 btnGry2 fn">삭제</a></span>
						<% End If %>
					</p>
					<p class="info">
						<span class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
						<span class="date"><%=FormatDate(arrCList(4,intCloop),"0000.00.00")%></span>
					</p>
				</div>
			</li>
			<% Next %>
		</ul>
		<% End If %>
		<% IF isArray(arrCList) THEN %>
		<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,3,"goPage")%>
		<% End If %>
	</div>
</div>
</body>
</html>