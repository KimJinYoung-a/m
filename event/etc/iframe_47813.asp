<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event46226Cls.asp" -->
<%
Dim eCode , sqlStr
Dim chkcnt1 , chkcnt2
Dim totcnt1 ,  totcnt2 

IF application("Svr_Info") = "Dev" THEN
	eCode   =  21044
Else
	eCode   =  47812
End If

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script language='javascript'>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script language='javascript'>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"parent.location.href='http://www.10x10.co.kr' " &_
						"</script>"
		dbget.close()	:	response.End
	end if
	rsget.Close

	'//전체 카운트
	sqlStr = "Select count(case when evtcom_point = 1 then evtcom_idx end) as cnt1 , 	count(case when evtcom_point <> 1 then evtcom_idx end) as cnt2 " &_
			" From db_event.dbo.tbl_event_comment " &_
			" WHERE evt_code='" & eCode & "'" &_
			" and evtcom_using = 'Y' "
	'rw sqlStr
	rsget.Open sqlStr,dbget,1
	totcnt1 = rsget(0)
	totcnt2 = rsget(1)
	rsget.Close

	'// 개수 확인
	If GetLoginUserID <> "" then
		sqlStr = "Select count(case when evtcom_point = 1 then evtcom_idx end) as cnt1 , 	count(case when evtcom_point <> 1 then evtcom_idx end) as cnt2 " &_
				" From db_event.dbo.tbl_event_comment " &_
				" WHERE evt_code='" & eCode & "'" &_
				" and userid='" & GetLoginUserID & "' and evtcom_using = 'Y' "
		'rw sqlStr
		rsget.Open sqlStr,dbget,1
		chkcnt1 = rsget(0)
		chkcnt2 = rsget(1)
		rsget.Close
	End If 

dim com_egCode, bidx
	Dim cEComment
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

	iCPageSize = 16		'한 페이지의 보여지는 열의 수
	iCPerCnt = 10		'보여지는 페이지 간격

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
	set cEComment = Nothing

%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 2014년 새해맞이 보글보글 떡만둣국</title>
	<style type="text/css">
	.mEvt47813 img {vertical-align:top;}
	.mEvt47813 p {max-width:100%;}
	.mEvt47813 .newYearTable {overflow:hidden;}
	.mEvt47813 .newYearTable .bowl {position:relative;}
	.mEvt47813 .newYearTable .bowl .tip {position:absolute; left:0; top:0;}
	.mEvt47813 .newYearTable .bowl .complete {display:none; position:absolute; left:0; top:0;}
	.mEvt47813 .newYearTable .comp01 .tip,
	.mEvt47813 .newYearTable .comp02 .tip {display:none}
	.mEvt47813 .newYearTable .comp01 .rice,
	.mEvt47813 .newYearTable .comp02 .dumpling {display:block;}
	.mEvt47813 .evtApply .cmtWrite {position:relative;}
	.mEvt47813 .evtApply .txtBox {position:absolute; left:10%; top:0; width:80%; padding:10px 15px; margin-left:-20px; border:5px solid #d5c4ad; background:#fff;}
	.mEvt47813 .evtApply .txtBox textarea {overflow:hidden; width:100%; height:50px; font-size:12px; border:0; color:#555; background:none;}
	.mEvt47813 .evtApply .writeBtn {position:absolute; left:15%; bottom:15%; width:70%;}
	.mEvt47813 .gift {position:relative;}
	.mEvt47813 .gift .pic {position:absolute; left:15%; bottom:0; width:70%;}
	.mEvt47813 .viewMyCmt {display:none; position:relative;}
	.mEvt47813 .viewMyCmt .closeLyr {position:absolute; right:3%; top:3%; width:16%; cursor:pointer;}
	.mEvt47813 .viewMyCmt .txt {position:absolute; left:15%; top:40%; width:70%; height:25%; color:#111; font-size:11px; line-height:16px;  text-align:center;}
	.mEvt47813 .viewMyCmt .txt p {display:table; height:100%;}
	.mEvt47813 .viewMyCmt .txt span {width:100%; height:100%; display:table-cell; vertical-align:middle;}
	.mEvt47813 .viewMyCmt .btnArea {position:absolute; left:6%; bottom:10%; width:88%; text-align:center;}
	.mEvt47813 .viewMyCmt .btnArea a {display:inline-block; width:36%; margin:0 5%;}
	.mEvt47813 .boilCmt .total {text-align:center; margin-top:30px;}
	.mEvt47813 .boilCmt .total img {vertical-align:middle;}
	.mEvt47813 .boilCmt .total span {display:inline-block; position:relative; top:1px; color:#7a3f1f; font-size:15px; line-height:20px; padding-left:5px; text-decoration:underline;}
	.mEvt47813 .boilCmt ul li {position:relative; color:#9a9a9a; font-size:11px; margin-bottom:14px; word-break:break-all;}
	.mEvt47813 .boilCmt ul li .num {position:absolute; left:5%; bottom:8%; text-align:center; width:25%; text-align:center; color:#777;}
	.mEvt47813 .boilCmt ul li .txtCont {position:absolute;  left:38%; top:11%; width:53%; color:#000; height:60%;}
	.mEvt47813 .boilCmt ul li .txtCont .tit {font-weight:bold; padding-bottom:10%;}
	.mEvt47813 .boilCmt ul li .txtCont .myWish {display:table; height:68%; line-height:16px;}
	.mEvt47813 .boilCmt ul li .txtCont .myWish p {display:table-cell; vertical-align:middle; width:100%; height:100%;}
	.mEvt47813 .boilCmt ul li .txtCont .myWish .btn {margin-top:-2px;}
	.mEvt47813 .boilCmt ul li .txtInfo {position:absolute; right:5%; bottom:8%; width:60%; text-align:right; color:#777;}
	.mEvt47813 .boilCmt ul li .txtInfo .writer {padding-right:7px; margin-right:3px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_blt_bar.gif) right 2px no-repeat; background-size:1px 11px;}
	.mEvt47813 .boilCmt ul li .txtInfo .writer img {margin-top:-2px;}
	</style>
<script type="text/javascript">
	$(function() {
		$('.rice .txtBox textarea').focus( function() {
			$(this).parent('.txtBox').css('background','#3b3b3b');
		});
		$('.rice .txtBox textarea').blur( function() {
			$(this).parent('.txtBox').css('background','#fff');
		});
		$('.openLyr').click(function(){
			$('.viewMyCmt').show();
			$('#dummycmt').html(document.frmcom.txtcomm.value);
			return false;
		});
		$('.closeLyr').click(function(){
			$('.viewMyCmt').hide();
			document.frmcom.txtcomm.value = "";
			document.frmcom.txtcomm.focus();
		});
		$(".boilCmt li.type01 .bg").append('<img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg_rice.png" alt="" style="width:100%;" />');
		$(".boilCmt li.type02 .bg").append('<img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg_dumpling01.png" alt="" style="width:100%;" />');
		$(".boilCmt li.type03 .bg").append('<img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg_dumpling02.png" alt="" style="width:100%;" />');
		$(".boilCmt li.type04 .bg").append('<img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg_dumpling03.png" alt="" style="width:100%;" />');
	});
</script>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		location.href="<%=CurrURL()%>?iCC="+iP;
	}
	function goPage(page)
	{
		document.frmcom.paging.value="o";
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}

function GetByteLength(val){
 	var real_byte = val.length;
 	for (var ii=0; ii<val.length; ii++) {
  		var temp = val.substr(ii,1).charCodeAt(0);
  		if (temp > 127) { real_byte++; }
 	}

   return real_byte;
}

	//랜덤 숫자 추출
	function randomRange(min,max){
		return Math.floor( (Math.random() * (max - min+1)) + min);
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!frm.txtcomm.value||frm.txtcomm2.value=="50자 이내로 텍스트를 입력해 주세요"){
	    alert("코멘트를 입력해주세요");
	    document.frmcom.txtcomm2.value="";
	    frm.txtcomm2.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm2.value)>100){
			alert('최대 한글 50자 까지 입력 가능합니다.');
	    frm.txtcomm2.focus();
	    return false;
		}

	   frm.spoint.value = randomRange(2,4);
	   frm.action = "/event/etc/doEventSubscript47813.asp";
	   return true;
	}

	function jsgoSubmit(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>
		var frm = document.frmcom;

		if(GetByteLength(frm.txtcomm.value)>100){
			alert('최대 한글 100자 까지 입력 가능합니다.');
			frm.txtcomm.focus();
	    return false;
		}

	   if(!frm.txtcomm.value||frm.txtcomm.value=="50자 이내로 텍스트를 입력해 주세요"){
	    alert("코멘트를 입력해주세요");
		ClosePopLayer();
	    frm.txtcomm.value="";
	    frm.txtcomm.focus();
	   }else{
		   frm.spoint.value = "1";
		   frm.action = "/event/etc/doEventSubscript47813.asp";
		   frm.submit();
	   }
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
			if(document.frmcom.txtcomm.value =="50자 이내로 텍스트를 입력해 주세요"){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChklogin22(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm2.value =="50자 이내로 텍스트를 입력해 주세요"){
				document.frmcom.txtcomm2.value="";
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
			document.frmcom.txtcomm.value="50자 이내로 텍스트를 입력해 주세요";
		}
	}

	function jsChkUnblur2()
	{

		if(document.frmcom.txtcomm2.value ==""){
			document.frmcom.txtcomm2.value="50자 이내로 텍스트를 입력해 주세요";
		}
	}

	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 최대 100자 입니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}

	function jsclear(){ // 다시쓰기 이동
		var frm = document.frmcom;
		frm.txtcomm.value = "";
		$('.viewMyCmt').hide();
		frm.txtcomm.focus();
	}
//-->
</script>
</head>
<body>
	<div class="content" id="contentArea">
		<div class="mEvt47813">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_head.png" alt="2014년 새해맞이 보글보글 떡만둣국" style="width:100%;" /></p>
			<div class="newYearTable">
				<div class="bowl <%=chkiif(chkcnt1>0," comp01"," ")%> <%=chkiif(chkcnt2>0," comp02"," ")%>">
					<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_tip.png" alt="아래 이벤트를 완료하고, 떡과 만두를 넣어주세요." style="width:100%;" /></p>
					<p class="complete rice"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_img_finish_rice.png" alt="떡 넣기 완료!" style="width:100%;" /></p>
					<p class="complete dumpling"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_img_finish_dumpling.png" alt="만두 넣기 완료!" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg_bowl.png" alt="" style="width:100%;" /></p>
				</div>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_badge.png" alt="만두와 떡을 모두 준비하고 12월 스페셜 뱃지를 받아가세요!" style="width:100%;" /></p>
			<!-- 이벤트 참여하기 -->
			<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<input type="hidden" name="iCTot" value="">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="paging" value="">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			<input type="hidden" name="spoint" value="">
			<div class="evtApply">
				<!-- 떡 -->
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_rice.png" alt="불을 끄고, 나는 떡을 썰 테니 너는 글을 쓰거라!" style="width:100%;" /></p>
				<div class="rice cmtWrite">
					<p class="txtBox">
						<textarea cols="20" rows="5"  name="txtcomm" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="50자 이내로 텍스트를 입력해 주세요" autocomplete="off" maxlength="100">50자 이내로 텍스트를 입력해 주세요</textarea>
					</p>
					<p class="writeBtn openLyr"><a href="#"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_btn_write_rice.png" alt="글을 다 썼으니 불을 켜시오" style="width:100%;" /></a></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg01.png" alt="" style="width:100%;" /></p>
				</div>
				<!-- 작성 글 확인 레이어 -->
				<div class="viewMyCmt">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_layer.png" alt="니가 쓴 글을 확인해보거라" style="width:100%;" /></p>
					<p class="closeLyr"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_btn_layer_close.png" alt="닫기" style="width:100%;" /></p>
					<div class="txt"><p><span id="dummycmt"></span></p></div>
					<p class="btnArea">
						<a href="javascript:jsgoSubmit(this.form);"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_btn_finish.png" alt="응모완료" style="width:100%;" /></a>
						<a href="javascript:jsclear();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_btn_rewrite.png" alt="다시쓰기" style="width:100%;" /></a>
					</p>
				</div>
				<!--// 작성 글 확인 레이어 -->
				<!-- 떡 -->

				<!-- 만두 -->
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_dumpling.png" alt="그동안의 근심과 걱정은 모두 만두에 싸먹거라!"  style="width:100%;" /></p>
				<div class="cmtWrite">
					<p class="txtBox">
						<textarea cols="20" rows="5" name="txtcomm2" onClick="jsChklogin22('<%=IsUserLoginOK%>');" onblur="jsChkUnblur2()" onKeyUp="jsChklogin22('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="50자 이내로 텍스트를 입력해 주세요" autocomplete="off" maxlength="100">50자 이내로 텍스트를 입력해 주세요</textarea>
					</p>
					<p class="writeBtn" style="bottom:0;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_btn_write_dumpling.png" alt="속이 터지지 않게 잘 싸주시오" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg02.png" alt="" style="width:100%;" /></p>
				</div>
				<!-- 만두 -->
			</div>
			</form>
			<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript43248.asp" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
			</form>
			<div class="gift">
				<p class="pic"><a href="/category/category_itemPrd.asp?itemid=634401"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_img_gift.png" alt="사은품 레드홀릭 만두떡" style="width:100%;" /></a></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_bg03.png" alt="" style="width:100%;" /></p>
			</div>
			<p style="display:none"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_notice.png" alt="떡만둣국은 이렇게 끓여야 맛있어요!" style="width:100%;" /></p>
			<!--// 이벤트 참여하기 -->

			<% IF isArray(arrCList) THEN %>
			<!-- 코멘트 리스트 -->
			<div class="boilCmt">
				<p class="total">
					<img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_total01.png" alt="현재" style="width:22px;" />
					<span><%=totcnt1%></span>
					<img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_total02.png" alt="개의 떡과" style="width:50px;" />
					<span><%=totcnt2%></span>
					<img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_txt_total03.png" alt="개의 만두가 준비되는 중" style="width:125px;" />
				</p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47813/47813_blt_total.png" alt="" style="width:100%;" /></p>
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<li class="type0<%=arrCList(3,intCLoop)%>">
						<p class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
						<div class="txtCont">
							<p class="tit"><%=chkiif(arrCList(3,intCLoop) = 1,"2014년의 나에게  안녕","2013년 근심&amp;걱정")%></p>
							<div class="myWish">
								<p><%=db2html(arrCList(1,intCLoop))%> <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><span class="btn btn6 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span><% End If %></p>
							</div>
						</div>
						<div class="txtInfo">
							<span class="writer"><% If arrCList(8,intCLoop)="M" Then %><img width="9" class="mob" alt="모바일에서 작성됨" src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" /><% End If %> <%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
							<span class="date"><%=formatdate(arrCList(4,intCLoop),"0000.00.00")%></span>
						</div>
						<p class="bg"></p>
					</li>
					<% next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
			</div>
			<!--// 코멘트 리스트 -->
			<% End If %>
		</div>
	</div>
<script>
<% If vPaging = "o" Then %>
var offset = $("#rank").offset();
window.parent.$("html, body").animate({scrollTop: offset.top},500);
<% End If %>
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->