<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event43248Cls.asp" -->
<%

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20947
Else
	eCode   =  44878
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

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
	iCPerCnt = 10		'보여지는 페이지 간격

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
	set cEComment = nothing

function selchg()
		dim	aa
		aa	= arrCList(3,intCLoop)
	select case aa
		case 1
			response.write "A"
		case 2
			response.write "B"
		case 3
			response.write "C"
		case 4
			response.write "D"
	End select
End function

function selchg1()
		dim	aa
		aa	= arrCList1(3,intCLoop)
	select case aa
		case 1
			response.write "A"
		case 2
			response.write "B"
		case 3
			response.write "C"
		case 4
			response.write "D"
	End select
End function

%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 어느 날 당신에게 생긴 서프라이즈~!</title>
	<style type="text/css">
	.mEvt44879 {}
	.mEvt44879 img {vertical-align:top; display:inline;}
	.mEvt44879 .research {padding:0 10px; text-align:center; background:#fffae8;}
	.mEvt44879 .research ul {overflow:hidden; _zoom:1;}
	.mEvt44879 .research ul li {float:left; width:25%;}
	.mEvt44879 .research ul li p {display:block; padding:0 6px; margin-bottom:10px;}
	.mEvt44879 .research .myCollab {border:5px solid #fcc2c4; padding:10px; background:#fff; margin:10px 0;}
	.mEvt44879 .research .myCollab textarea {overflow:hidden; width:100%; height:50px; color:#888; border:0;}
	.mEvt44879 .research .enroll {border-radius:0;}
	.mEvt44879 .total {text-align:right; color:#888; font-size:11px; padding:0 8px 5px 0;}
	.mEvt44879 .story {overflow:hidden; /*background:url('http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_bg_story.png') left top repeat-y; background-size:100% auto;*/}
	.mEvt44879 .story ul {padding:10px 8px 25px;}
	.mEvt44879 .story li {position:relative;}
	.mEvt44879 .story li .like {display:inline-block; position:absolute; right:5px; bottom:5px; color:#000; text-align:right; cursor:pointer; border:1px solid #d8d8d8; border-radius:3px;}
	.mEvt44879 .story li .like em {display:inline-block; font-size:11px; width:27px; padding:4px 5px 5px 15px; border:1px solid #fff; background:url('http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_bg_heart.png') #f1f1f1 5px center no-repeat; background-size:8px 7px; border-radius:2px;}
	.mEvt44879 .story li .txt {overflow:hidden; padding:10px; font-size:11px; line-height:1.2; color:#777; background:#fff;}
	.mEvt44879 .story li .txt strong {color:#000; padding-right:3px;}
	.mEvt44879 .story li .txt img {vertical-align:middle; padding-right:5px;}
	.mEvt44879 .story li .txt .cmt {height:48px; margin-top:5px; line-height:1.4;}
	.mEvt44879 .story li .txt .cmt .mob {margin-top:-3px;}
	.mEvt44879 .story li .txt .writer {color:#2c2c2c;}
	.mEvt44879 .story li .txt .writer .btn {margin:-3px 0 0 5px;}
	.mEvt44879 .story li .typeA,
	.mEvt44879 .story li .typeB,
	.mEvt44879 .story li .typeC,
	.mEvt44879 .story li .typeD {position:relative; padding:5px 5px 32px; margin-top:15px; border-radius:4px; background-position:left top; background-repeat:repeat; background-size:5px auto;}
	.mEvt44879 .story li .typeA {border:1px solid #c30000; background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_bg_cmt01.png');}
	.mEvt44879 .story li .typeB {border:1px solid #4bb7ae; background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_bg_cmt02.png');}
	.mEvt44879 .story li .typeC {border:1px solid #df4b9d; background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_bg_cmt03.png');}
	.mEvt44879 .story li .typeD {border:1px solid #10b534; background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_bg_cmt04.png');}
	.mEvt44879 .story .best {padding:0 8px 25px 8px; border-top:1px solid #ddd; border-bottom:1px solid #ddd; background:url('http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_bg_best.png') left top repeat-y; background-size:100% auto;}
	.mEvt44879 .story .best li {padding-top:40px;}
	.mEvt44879 .story .best li .rank {position:absolute; left:-9px; top:-30px; width:100%;}
	.mEvt44879 .story .best li:last-child .rank {left:-12px; top:-20px;}
</style>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		location.href="/event/etc/iframe_suprise43248.asp?iCC="+iP;
	}
	function goPage(page)
	{
		scrollToAnchor('rank');
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();

	}

function scrollToAnchor(where){
 scrollY=document.getElementById(where).offsetTop;
 scrollTo(0,scrollY);
}



	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked)){
	    alert("이미지를 선택해주세요");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="여러분의 생각을 입력해보세요. (최대100자)"){
	    alert("코멘트를 입력해주세요");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm.value)>200){
			alert('최대 한글 100자 까지 입력 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}

	   frm.action = "/event/etc/doEventSubscript43248.asp";
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
			if(document.frmcom.txtcomm.value =="여러분의 생각을 입력해보세요. (최대100자)"){
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
			document.frmcom.txtcomm.value="여러분의 생각을 입력해보세요. (최대100자)";
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

//-->
</script>
</head>
<body>


			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt44879">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_head.png" alt="어느 날, 당신에게 생긴 서프라이즈~!" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_img01.png" alt="선물이미지" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_txt01.png" alt="텐바이텐이 어플리케이션을 만든다면? 텐바이텐의 어플은 어떤 모습일까요?" style="width:100%;" /></p>
					<div class="research">
					<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="mode" value="add">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
						<ul>
							<li>
								<p><input type="radio" name="spoint" value="1" id="cmt01" /></p>
								<p><label for="cmt01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_item01.png" alt="선택1" style="width:100%;" /></label></p>
							</li>
							<li>
								<p><input type="radio" name="spoint" value="2" id="cmt02" /></p>
								<p><label for="cmt02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_item02.png" alt="선택2" style="width:100%;" /></label></p>
							</li>
							<li>
								<p><input type="radio" name="spoint" value="3" id="cmt03" /></p>
								<p><label for="cmt03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_item03.png" alt="선택3" style="width:100%;" /></label></p>
							</li>
							<li>
								<p><input type="radio" name="spoint" value="4" id="cmt04" /></p>
								<p><label for="cmt04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_item04.png" alt="선택4" style="width:100%;" /></label></p>
							</li>
						</ul>
						<div class="myCollab"><textarea name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="여러분의 생각을 입력해보세요. (최대100자)" autocomplete="off">여러분의 생각을 입력해보세요. (최대100자)</textarea></div>
						<p><input type="image" alt="등록하기" class="enroll" src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_btn01.png" style="width:35%;" /></p>
					</form>
					</div>
					<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript43248.asp" style="margin:0px;">
						<input type="hidden" name="eventid" value="<%=eCode%>">
						<input type="hidden" name="bidx" value="<%=bidx%>">
						<input type="hidden" name="Cidx" value="">
						<input type="hidden" name="mode" value="del">
						<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					</form>
					<form name="frmupdatecom" method="post" action="/event/etc/doEventSubscript43248.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="update">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					</form>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_txt02.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>

					<p class="total">Total <%=iCTotCnt%></p>
					<div class="story">
						<ul class="best">
						<a name="rank" id="rank"></a>
						<% IF isArray(arrCList1) THEN %>
							<% For intCLoop = 0 To UBound(arrCList1,2) %>
							<li>
								<div class="type<% selchg1() %>">
									<p class="rank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44879/44879_tag_best0<%= intCLoop+1 %>.png" alt="공감 <%= intCLoop+1 %>위" style="width:90px;" /></p>
									<div class="txt">
										<p class="writer"><%=printUserId(arrCList1(2,intCLoop),2,"*")%> 님의 스토리
										<% if ((GetLoginUserID = arrCList1(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList1(2,intCLoop)<>"") then %>
											<span class="btn btn6 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList1(0,intCLoop) %>')">삭제</a></span>
										<% End If %>
										</p>
										<p class="cmt"><%=db2html(arrCList1(1,intCLoop))%>
										<% If arrCList1(8,intCLoop)="M" Then %>
										<img width="9" class="mob" alt="모바일에서 작성" src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" />
										<% End If %>
										</p>
									</div>
									<a href="javascript:jsupdateComment('<% = arrCList1(0,intCLoop) %>')"><span class="like"><em><% response.write arrCList1(6,intCLoop) %></em></span></a>
								</div>
							</li>
							<% Next %>
						<%	End If	%>
						</ul>
						<% IF isArray(arrCList) THEN %>
						<ul>
							<% For intCLoop = 0 To UBound(arrCList,2)%>
							<li>
								<div class="type<% selchg() %>">
									<div class="txt">
										<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님의 스토리
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')"><img src="http://fiximage.10x10.co.kr/web2009/common/cmt_del.gif" width="19" height="11" style="padding-left:5px;" border="0"></a>
										<% end if %>
										</p>
										<p class="cmt"><%=db2html(arrCList(1,intCLoop))%>
										<% If arrCList(8,intCLoop)="M" Then %>
										<span><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" alt="모바일에서 작성" width="9px" /></span><!--for dev msg : 모바일에서 작성시 노출 -->
										<% End If %>
										</p>
									</div>
									<a href="javascript:jsupdateComment('<% = arrCList(0,intCLoop) %>')"><span class="like"><em><% response.write arrCList(6,intCLoop) %></em></span></a>
								</div>
							</li>
							<% next %>
						</ul>
					<% End If %>
					</div>
						<div id="paging" style="padding-top:10px;">
							<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
						</div>
				</div>
			</div>
			<!-- //content area -->

</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->