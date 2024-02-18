<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 꽃보다 예쁜 우리 엄마 
' History : 2015.04.24 유태욱
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #04/24/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61761
	eCodedisp = 61760
Else
	eCode   =  61867
	eCodedisp = 61828
End If

dim userid, commentcount, i
	userid = getloginuserid()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 4		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 4		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
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

.mEvt61828 {padding-bottom:8%; background-color:#fff;}
.rolling {padding:8% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/bg_paper.png) repeat-y 0 0; background-size:100% auto;}
.slide-wrap {position:relative; width:280px; margin:0 auto; padding-bottom:7px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/bg_shadow.png) no-repeat 50% 100%; background-size:300px auto;}
.slide-wrap .slide {overflow:visible !important; position:relative; background-color:#fff; padding:5px;}
.slide .slidesjs-navigation {position:absolute; z-index:50; top:42%; width:13px; height:25px; text-indent:-999em;}
.slide .slidesjs-previous {left:-13px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/btn_prev.png) no-repeat 0 0; background-size:100% auto;}
.slide .slidesjs-next {right:-13px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/btn_next.png) no-repeat 0 0; background-size:100% auto;}
.slidesjs-pagination {position:absolute; bottom:-11%; left:0; z-index:10; width:100%; padding-top:0; text-align:center;}
.slidesjs-pagination li {display:inline;}
.slidesjs-pagination li a {display:inline-block; width:12px; height:12px; margin:0 8px; border-radius:50%; background-color:#ccb68a; cursor:pointer; text-indent:-999em;}
.slidesjs-pagination li a.active {background-color:#94a43e;}

.about {padding-top:12%;}
.about .btnwrap {overflow:hidden; margin-top:4%; padding:0 6% 0 9%;}
.about .btnwrap a {float:left; width:50%; padding:0 1%;}

.commentevt {padding-bottom:7%; background-color:#e0e8b1;}
.field {padding:7% 7% 0;}
.field legend {visibility:hidden; width:0; height:0;}
.field ul {overflow:hidden; width:78%; margin:0 auto;}
.field ul li {float:left; width:50%;}
.field ul li input {margin-right:2%;}
.field ul li label img {width:68px;}
.field textarea {width:100%; height:120px; margin-top:10px; border:1px solid #c1d164; border-radius:0; font-size:12px; line-height:1.5em;}
.field .btnsubmit {margin-top:8px;}
.field .btnsubmit input {width:100%; vertical-align:top;}

.commentlist {overflow:hidden; padding:5% 3% 2%;}
.commentlist .col {overflow:hidden; position:relative; height:0; margin-top:5%; padding-bottom:35%; text-align:left;}
.commentlist .col .bg {position:absolute; top:0; left:0; width:100%; height:100%; background-repeat:no-repeat; background-size:100% auto;}
.commentlist .col1 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/bg_comment_box_01.png);}
.commentlist .col2 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/bg_comment_box_02.png);}
.commentlist .col3 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/bg_comment_box_03.png);}
.commentlist .col4 .bg {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/61828/bg_comment_box_04.png);}
.commentlist .col .no {position:absolute; bottom:17%; left:3%; width:20%; color:#82a509; font-size:11px; text-align:center;}
.commentlist .col .no span {display:block; margin-top:1.5%; font-size:10px; font-weight:normal;}
.commentlist .col .msg {overflow:auto; height:42%; margin:7% 7% 0 25%; padding:0 2% 0 0; color:#111; font-size:11px; line-height:1.5em; -webkit-overflow-scrolling:touch; word-break:break-all;}
.commentlist .col .writer {margin-top:3.5%; padding-left:25%; font-size:11px; line-height:1.375em;}
.commentlist .col .writer img {width:7px; margin-left:5px; vertical-align:middle;}
.commentlist .col .btndel {width:14px; height:14px; margin-left:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60281/btn_del.png) no-repeat 50% 0; background-size:100% auto; text-indent:-999em; vertical-align:middle;}

@media all and (min-width:360px){
	.slide-wrap {width:320px;}
}

@media all and (min-width:480px){
	.slide-wrap {width:360px;}
	.field textarea {height:180px; font-size:16px;}
	.field ul li label img {width:102px;}
	.commentlist .col .msg {font-size:16px;}
	.commentlist .col .no {font-size:16px;}
	.commentlist .col .no span {font-size:14px;}
	.commentlist .col .writer {font-size:16px;}
	.commentlist .col .writer img {width:9px;}
	.commentlist .col .btndel {width:18px; height:18px;}
}

@media all and (min-width:600px){
	.slide-wrap {width:560px; padding-bottom:10px; background-size:560px auto;}
	.slide-wrap .slide {padding:10px;}
	.slide .slidesjs-navigation {width:20px; height:34px; background-size:20px 34px;}
	.slide .slidesjs-previous {left:-20px;}
	.slide .slidesjs-next {right:-20px;}
	.slidesjs-pagination li a {width:15px; height:15px; margin:0 10px;}
}
</style>
<script type="text/javascript">

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-04-24" and left(currenttime,10)<"2015-05-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>5 then %>
				alert("이벤트는 5회까지 응모하실수 있습니다.\n5월 1일(금) 당첨자 발표를 기다려 주세요!");
				return false;
			<% else %>
				var tmpdateval='';
				for (var i=0; i < frm.dateval.length; i++){
					if (frm.dateval[i].checked){
						tmpdateval = frm.dateval[i].value;
					}
				}
				if (tmpdateval==''){
					alert('촬영을원하는 날짜를 선택해 주세요.');
					return false;
				}
				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 400 || frm.txtcomm1.value == '원하는 날짜를 선택하고 엄마와 나의 이야기를 들려주세요 : ) (200자 이내)'){
					alert("원하는 날짜를 선택하고\n엄마와 나의 이야기를 들려주세요.\n200자 까지 작성 가능합니다.");
					frm.txtcomm1.focus();
					return false;
				}

			   frm.txtcomm.value = tmpdateval + "|!/" +frm.txtcomm1.value
			   frm.action = "/event/lib/doEventComment.asp";
			   frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCodedisp)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCodedisp)%>');
			return false;
		<% end if %>
		return false;
	}

	if (frmcom.txtcomm1.value == '원하는 날짜를 선택하고 엄마와 나의 이야기를 들려주세요 : ) (200자 이내)'){
		frmcom.txtcomm1.value = '';
	}
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

</script>
</head>
<body>

<!-- iframe -->
<div class="mEvt61828">
	<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/tit_mom.png" alt="꽃보다 아름다운 우리엄마 아름다운 엄마와 딸의 향기로운 추억 만들기 프로젝트" /></h1>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/txt_collabo.png" alt="텐바이텐 PLAY GROUND 5월 주제는 우리를 설레게 하는, 달콤하고 아름다운 꽃 FLOWER 입니다. 세상에는 수많은 꽃들이 있습니다. 텐바이텐 플레이는 꽃처럼 아름다운 것에 대해 생각하다 ’엄마’를 떠올렸습니다. 언제나, 그 자리에서 지친 일상에 좋은 향기가 되어주는 우리 엄마. 흔히 친구, 남자친구 또는 새로 맞이하는 남편과 추억을 담는 화보. 이번만큼은 여전히 아름답게 피고 있는 엄마와의 화보를 촬영해드립니다. 우리의 프로젝트를 함께 해 줄 엄마와 딸을 기다립니다" /></p>

	<div class="rolling">
		<div class="slide-wrap">
			<div id="slide1" class="slide">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/img_slide_01.jpg" alt="" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/img_slide_02.jpg" alt="" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/img_slide_03.jpg" alt="" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/img_slide_04.jpg" alt="" />
			</div>
		</div>

		<div class="about">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/txt_lalasnap.png" alt="랄라스냅은 남는 건 사진뿐이라는 슬로건 아래 기존 웨딩 촬영과는 차별화된 촬영으로 특별한 날을 아름다운 추억으로 남겨드립니다." /></p>
			<div class="btnwrap">
				<a href="http://www.lalasnap.com/xe/" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/btn_homepage.png" alt="랄라스냅 홈페이지 바로가기" ></a>
				<a href="http://lalasnap_.blog.me/" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/btn_blog.png" alt="랄라스냅 블로그 바로가기" ></a>
			</div>
		</div>
	</div>

	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/txt_way.png" alt="촬영 가능한 날짜를 선택 후 사연과 함께 응모를 하시면 당첨발표 후 사전미팅이 진행됩니다. 사진 촬영 진행 및 간단한 인터뷰를 한 후 촬영 내용을 바탕으로 텐바이텐 PLAY 컨텐츠로 5월 11일 오픈 예정입니다." /></p>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/txt_noti.png" alt="본 이벤트는 화보사진과 메이킹 영상, 간단한 인터뷰 내용이 추후 PLAY 컨텐츠 제작에 활용되는 것’에 동의해주셔야 합니다. 최종 노출 사진은 당첨자와의 협의하에 선정됩니다. 스냅사진 촬영 시 메이킹영상 촬영이 함께 진행될 예정입니다. 엄마와 딸의 촬영을 원칙으로 하되, 신청자의 구분은 없습니다. 촬영일 5일 전까지만 취소가 가능하며, 신청하신 해당 날짜에는 취소 및 변경이 불가능합니다. 촬영지는 야외로 예정되어 있으나, 우천시 실내 스튜디오에서 진행됩니다. 촬영 시간은 최소 약 3시간이 소요될 예정입니다. 당첨자는 촬영 전 사전미팅을 필수로 하며, 미팅 일시는 추후 협의하여 진행합니다." /></p>

	<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="iCC" value="1">
	<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCodedisp %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>">
	<input type="hidden" name="txtcomm">
	<!-- comment event -->
	<div class="commentevt">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/txt_comment_event.png" alt="아름다운 엄머와 딸의 향기로운 추억 만들기 화보 촬영을 원하는 날짜를 선택하고 엄마와 나의 이야기를 들려주세요! 당첨된 모녀 한 쌍에게 화보를 촬영해 드립니다 이벤트 기간은 2015월 4월 24일 금요일부터 4월 30일 목요일 까지며 첨자 발표는 2015년 5월 1일 금요일입니다." ></p>
		<div class="field">
			<fieldset>
			<legend>화보 촬영을 원하는 날짜를 선택하고 엄마와 나의 이야기 쓰기</legend>
				<ul>
					<li>
						<input type="radio" name="dateval" value="1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" id="selectDate01" />
						<label for="selectDate01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/txt_label_01.png" alt="5월 8일 금요일" /></label>
					</li>
					<li>
						<input type="radio" name="dateval" value="1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" id="selectDate02" />
						<label for="selectDate02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61828/txt_label_02.png" alt="5월 10일 일요일" /></label>
					</li>
				</ul>
				<textarea name="txtcomm1" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> cols="60" rows="5" title="엄마와 나의 이야기 쓰기"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>원하는 날짜를 선택하고 엄마와 나의 이야기를 들려주세요 : ) (200자 이내)<%END IF%></textarea>
				<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/61828/btn_submit.png" onclick="jsSubmitComment(frmcom); return false;" alt="응모하기" /></div>
			</fieldset>
		</div>
	</div>
	</form>

	<!-- comment list -->
	<div class="commentlist">
		<%
		IF isArray(arrCList) THEN
			dim rndNo : rndNo = 1
			
			For intCLoop = 0 To UBound(arrCList,2)
			
			randomize
			rndNo = Int((4 * Rnd) + 1)
		%>
		<% '<!-- for dev msg : <div class="col">...</div>이 한 묶음입니다. col1 ~ col4 랜덤으로 클래스명 뿌려주세요 --> %>
		<% '<!-- for dev msg : 한페이지당 8개 --> %>
		<div class="col col<%=rndNo%>">
			<div class="bg">
				<strong class="no">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%>
					<span>
						<% if isarray(split(arrCList(1,intCLoop),"|!/")) then %>
							<% if ubound(split(arrCList(1,intCLoop),"|!/")) > 0 then %>
								<% if ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(0) )) = 1 then response.write "5월8일" else response.write "5월10일" %>
							<% end if %>
						<% end if %>
					</span>
				</strong>
				<p class="msg">
					<% if isarray(split(arrCList(1,intCLoop),"|!/")) then %>
						<% if ubound(split(arrCList(1,intCLoop),"|!/")) > 0 then %>
							<%=ReplaceBracket(db2html( split(arrCList(1,intCLoop),"|!/")(1) ))%>
						<% end if %>
					<% end if %>
				</p>
				<div class="writer">
					<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
					<% If arrCList(8,i) <> "W" Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60280/ico_mobile.png" alt="모바일에서 작성" width="7" />
					<% end if %>
					
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;" class="btndel">삭제</button>
					<% end if %>
				</div>
			</div>
		</div>
		<%
			Next
		end if
		%>
	</div>
	<!-- paging -->
	<% IF isArray(arrCList) THEN %>
		<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
	<% end if %>

	<form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCodedisp %>">
	<input type="hidden" name="userid" value="<%= userid %>">
	<input type="hidden" name="eventid" value="<%= eCodedisp %>">
	<input type="hidden" name="linkevt" value="<%= eCode %>">
	</form>
</div>
<!-- //iframe -->

<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
$(function(){
	$(".slide").slidesjs({
		width:"540",
		height:"379",
		pagination:{effect:"fade"},
		navigation:{effect:"fade"},
		play:{interval:6000, effect:"fade", auto:true},
		effect:{fade: {speed:1500, crossfade:true}
		},
		callback: {
			complete: function(number) {
				var pluginInstance = $('.slide').data('plugin_slidesjs');
				setTimeout(function() {
					pluginInstance.play(true);
				}, pluginInstance.options.play.interval);
			}
		}
	});
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->