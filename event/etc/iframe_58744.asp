<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  도라에몽 고민상담소
' History : 2015.01.20 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event58744Cls.asp" -->

<%
dim eCode, iCCurrpage, isMyComm, iCTotCnt, iCPerCnt, iCPageSize, cEComment, arrCList, iCTotalPage, com_egCode, bidx, tmponload
	eCode   =  getevt_code()
	tmponload	= requestCheckVar(request("upin"),2)
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	isMyComm	= requestCheckVar(request("isMC"),1)

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

com_egCode = 0
iCPerCnt = 5		'보여지는 페이지 간격
iCPageSize = 5
iCCurrpage = 1

'데이터 가져오기
set cEComment = new ClsEvtComment

cEComment.FECode 		= eCode
cEComment.FComGroupCode	= com_egCode
cEComment.FEBidx    	= bidx
cEComment.FCPage 		= iCCurrpage	'현재페이지
cEComment.FPSize 		= iCPageSize	'페이지 사이즈
if isMyComm="Y" then cEComment.FUserID = GetLoginUserID
cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

arrCList = cEComment.fnGetComment		'리스트 가져오기
iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

dim commentexistscount, userid, i
commentexistscount=0
userid = getloginuserid()

if userid<>"" then
	commentexistscount=getcommentexistscount(userid, eCode, "", "", "", "Y")
end if

'response.write tmponload &"!!!!!!"
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt58745 img {vertical-align:top;}
.consulting {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_stripe.gif) left top repeat-y; background-size:100% auto;}
.consulting .selectTool {overflow:hidden; width:100%; padding:0 6%;}
.consulting .selectTool li {position:relative; float:left; width:50%; padding:0 2.5% 24px; margin-bottom:15px; text-align:center;}
.consulting .selectTool li input {position:absolute; left:50%; bottom:0; margin-left:-15px;}
.consulting .selectTool li label {display:block; width:100%; height:100%; margin-bottom:10px; background-position:left top; background-repeat:no-repeat; background-size:100% 100%; text-indent:-9999px; cursor:pointer;}
.consulting .selectTool li.m01 label {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic01_off.jpg)}
.consulting .selectTool li.m02 label {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic02_off.jpg)}
.consulting .selectTool li.m03 label {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic03_off.jpg)}
.consulting .selectTool li.m04 label {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic04_off.jpg)}
.consulting .selectTool li.m01 label.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic01_on.jpg)}
.consulting .selectTool li.m02 label.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic02_on.jpg)}
.consulting .selectTool li.m03 label.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic03_on.jpg)}
.consulting .selectTool li.m04 label.on {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/img_select_magic04_on.jpg)}
.consulting .writeWorry {padding:0 8%;}
.consulting .writeWorry .inp01 {width:100%; height:100px; font-size:12px; padding:13px; color:#1e1e1e; border:1px solid #b1cedd; color:#484848; border-radius:0;}
.consulting .writeWorry .inp02 {width:100%; margin-top:3px;}
.consulting .solution {display:none; position:absolute; left:2%; top:25%; width:96%; z-index:40;}
.consulting .solution p {background-position:center top; background-repeat:no-repeat; background-size:100% 100%;}
.consulting .solution p.s01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply01.png);}
.consulting .solution p.s02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply02.png);}
.consulting .solution p.s03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply03.png);}
.consulting .solution p.s04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply04.png);}
.consulting .solution p.s05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply05.png);}
.consulting .solution p.s06 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply06.png);}
.consulting .solution p.s07 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply07.png);}
.consulting .solution p.s08 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply08.png);}
.consulting .solution p.s09 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply09.png);}
.consulting .solution p.s10 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply10.png);}
.consulting .solution p.s11 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply11.png);}
.consulting .solution p.s12 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply12.png);}
.consulting .solution p.s13 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply13.png);}
.consulting .solution p.s14 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply14.png);}
.consulting .solution p.s15 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply15.png);}
.consulting .solution p.s16 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_reply16.png);}
.consulting .solution .close {display:block; position:absolute; right:9%; top:10%; width:6.5%; z-index:50; cursor:pointer;}
.worryList {position:relative;}
.worryList ol {position:absolute; left:10%; top:25%; width:80%; height:50%; text-align:left; color:#fff; font-weight:bold; font-size:11px; line-height:1.4;}
.movieTrailer {position:relative; text-align:left;}
.movieTrailer .movieSection {position:absolute; left:5%; top:0; width:90%; height:100%;}
.movieTrailer .movieSection .movie {width:100%; height:100%;}
.movieTrailer .movieSection .movie div {overflow:hidden; position:relative; height:100%; padding-bottom:56.25%;}
.movieTrailer .movieSection .movie div iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.door {position:relative;}
.door a {display:none;}

@media all and (min-width:480px){
	.consulting .selectTool li {padding:0 2% 36px; margin-bottom:23px;}
	.worryList ol {top:27%; font-size:17px;}
}
</style>
<script type="text/javascript">
$(function(){
	$('.selectTool li label').click(function(){
		$('.selectTool li label').removeClass('on');
		$(this).addClass('on');
	});
	$('.selectTool li input').click(function(){
		$('.selectTool li label').removeClass('on');
		$(this).prev('label').addClass('on');
	});

	//$('.inp02').click(function(){
	//	$('.solution').show();
	//});
	$('.solution .close').click(function(){
		//$('.solution').hide();
		location.reload();
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	}

	if(frmcom.txtcomm.value =="(20자 내외) 고민 입력하기"){
		frmcom.txtcomm.value ="";
	}
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(){
	<% If IsUserLoginOK() Then %>
		<% If not( getnowdate>="2015-01-21" and getnowdate<"2015-02-11") Then %>
			alert('이벤트 응모 기간이 아닙니다.');
			return;
		<% end if %>
		<% if commentexistscount>=3 then %>
			alert('한 아이디당 3회까지만 참여할 수 있습니다.');
			return;
		<% end if %>

		var tmpgubun='';
		for (var i=0; i < frmcom.gubun.length ; i++){
			if (frmcom.gubun[i].checked){
				tmpgubun=frmcom.gubun[i].value;
			}
		} 
		if (tmpgubun==''){
			alert('마법도구 네 가지 중 한 개를 선택해주세요.');
			return;
		}
		if(frmcom.txtcomm.value =="(20자 내외) 고민 입력하기"){
			frmcom.txtcomm.value ="";
		}
		if(!frmcom.txtcomm.value){
			alert("신중하게 생각하는 건 좋지만, 고민을 입력해주세요.");
			frmcom.txtcomm.focus();
			return false;
		}
		if (GetByteLength(frmcom.txtcomm.value) > 40){
			alert("코맨트가 제한길이를 초과하였습니다. 20자 까지 작성 가능합니다.");
			frmcom.txtcomm.focus();
			return;
		}

		var txtcomm=frmcom.txtcomm.value

		var str = $.ajax({
			type: "GET",
			url: "/event/etc/doEventSubscript58744.asp",
			data: "mode=add&gubun="+tmpgubun+"&txtcomm="+txtcomm,
			dataType: "text",
			async: false
		}).responseText;
	
		if (str==''){
			alert('정상적인 경로가 아닙니다');
			return;
		}else if (str=='99'){
			alert('로그인을 하셔야 참여가 가능 합니다.');
			return;
		}else if (str=='02'){
			alert('이벤트 응모 기간이 아닙니다.');
			return;
		}else if (str=='03'){
			alert('내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.');
			return;
		}else if (str=='04'){
			alert('한번에 5회 이상 연속 등록 불가능합니다.');
			return;
		}else if (str=='05'){
			alert('데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해 주십시오.');
			return;
		}else if (str=='06'){
			alert('한아이디당 3회 까지만 참여가 가능 합니다.');
			return;
		}else if (str=='07'){
			alert('마법도구 네 가지 중 한 개를 선택해주세요.');
			return;
		}else if (str=='01'){
			$('.solution').show();
		}else{
			alert('정상적인 경로가 아닙니다');
			return;
		}
		//frmcom.action='/event/etc/doEventSubscript58744.asp';
		//frmcom.submit();
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	<% If IsUserLoginOK() Then %>
		if (cidx==""){
			alert('정상적인 경로가 아닙니다');
			return;
		}
		
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
			document.frmdelcom.action='/event/etc/doEventSubscript58744.asp';
	   		document.frmdelcom.submit();
		}
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<!-- 도라에몽 고민상담소 (M/APP) -->
<div class="mEvt58745">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/tit_doraemon.jpg" alt="도라에몽 고민상담소" /></h2>
	<div class="doraemon">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/tit_write_worry.jpg" alt="재치있는 고민을 남겨주신 150분에게는 영화 (도라에몽:스탠바이미) 전용 예매권을 선물로 드려요!" /></h3>
		<div class="consulting">

			<form name="frmcom" method="post" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="com_egC" value="<%=com_egCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<input type="hidden" name="iCTot" value="">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="spoint" value="0">
			<input type="hidden" name="isMC" value="<%=isMyComm%>">
			<!-- 도구선택, 고민입력 -->
			<ul class="selectTool">
				<li class="m01">
					<label for="magic01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_select.png" alt="마법도구1" /></label>
					<input type="radio" name="gubun" value="1" id="magic01" />
				</li>
				<li class="m02">
					<label for="magic02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_select.png" alt="마법도구2" /></label>
					<input type="radio" name="gubun" value="2" id="magic02" />
				</li>
				<li class="m03">
					<label for="magic03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_select.png" alt="마법도구3" /></label>
					<input type="radio" name="gubun" value="3" id="magic03" />
				</li>
				<li class="m04">
					<label for="magic04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_select.png" alt="마법도구4" /></label>
					<input type="radio" name="gubun" value="4" id="magic04" />
				</li>
			</ul>
			<div class="writeWorry">
				<textarea name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> class="inp01" cols="10" rows="5"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>(20자 내외) 고민 입력하기<%END IF%></textarea>
				<input type="image" onclick="jsSubmitComment(); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/58745/btn_submit.gif" alt="고민접수" class="inp02" />
			</div>
			<div class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_tip.jpg" alt="고민입력 예시" /></div>
			<!--// 도구선택, 고민입력 -->
			</form>
			<form name="frmdelcom" method="post" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			</form>

			<%
			dim rndNo
				rndNo=1
			randomize
			rndNo = Int((16 * Rnd) + 1)
			%>
			<!-- 도라에몽의 답변 -->
			<div class="solution" id="solution">
				<p class="s<%= Format00(2,rndNo) %>">
					<!-- 답변은 총 16개로 클래스 s01~s16 입니다 -->
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_reply.png" alt="" />
				</p>
				<span class="close"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/btn_close.png" alt="닫기" /></span>
			</div>
			<!--// 도라에몽의 답변 -->
			
			<% IF isArray(arrCList) THEN %>
				<!-- 실시간 고민 리스트 -->
				<div class="worryList">
					<ol>
						<%
						dim tmpcomment, tmpcommentgubun , tmpcommenttext
						For i = 0 To UBound(arrCList,2)
						
						tmpcomment = ReplaceBracket(db2html(arrCList(1,i)))
						tmpcomment = split(tmpcomment,"!@#")
						if isarray(tmpcomment) then
							tmpcommentgubun=tmpcomment(0)
							tmpcommenttext=tmpcomment(1)
						end if
						%>
						<li><%= i + 1 %>. <%= tmpcommenttext %></li>
						<% next %>
					</ol>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_worry_list.jpg" alt="" /></p>
				</div>
				<!--// 실시간 고민 리스트 -->
			<% end if %>

			<!-- 영화소개 -->
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/tit_movie_trailer.gif" alt="MOVIE TRAILER" /></h3>
			<div class="movieTrailer">
				<div class="movieSection">
					<div class="movie">
						<div><iframe src="//www.youtube.com/embed/s4YnlkKAPaI" frameborder="0" allowfullscreen></iframe></div>
					</div>
				</div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/bg_movie.gif" alt="" /></p>
			</div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/txt_movie_info.gif" alt="영화소개" /></p>
			<p class="door">
				<a href="/event/eventmain.asp?eventid=58748" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/btn_door.jpg" alt="놀라운 상품들이 가득한 곳으로! '어디로든 문'을 클릭해보세요!" /></a>
				<a href="#" onclick="fnAPPpopupEvent('58748'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58745/btn_door.jpg" alt="놀라운 상품들이 가득한 곳으로! '어디로든 문'을 클릭해보세요!" /></a>
			</p>
			<!--// 영화소개 -->

		</div>
	</div>
</div>
<!--// 도라에몽 고민상담소 (M/APP) -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->