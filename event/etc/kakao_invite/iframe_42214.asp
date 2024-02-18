<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
'#######################################################
'	History	: 2013.06.10 이종화 생성
'	Description : 또닥 이벤트
'#######################################################
	dim eCode , sqlStr , sDate , eDate , i
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "20913"
	Else
		eCode 		= "42214"
	End If

	'// 이벤트 기간 확인 //
	sqlStr = "Select evt_startdate, evt_enddate " &_
			" From db_event.dbo.tbl_event " &_
			" WHERE evt_code='" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	if rsget.EOF or rsget.BOF then
		Response.Write	"<script>" &_
						"alert('존재하지 않는 이벤트입니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") then
		Response.Write	"<script>" &_
						"alert('죄송합니다. 이벤트 기간이 아닙니다.');" &_
						"</script>"
		dbget.close()	:	response.End
	Else 
		sDate =  rsget("evt_startdate")
		eDate =  rsget("evt_enddate")
	end If
	rsget.Close

	'response.write  eDate

	Dim dfDate : dfDate = #06/10/2013 12:2:0#  ''티저 종료 시간 유동적으로 처리 요

	dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage 
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt	
	Dim timeTern, totComCnt
		
	'파라미터값 받기 & 기본 변수 값 세팅	
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)
	
	IF iCCurrpage = "" THEN iCCurrpage = 1	
	IF iCTotCnt = "" THEN iCTotCnt = -1	

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 4		'한 페이지의 보여지는 열의 수
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
<script src="/event/etc/kakao_invite/42214.js"></script>
<script src="/lib/js/kakao.Link.js"></script>
<script>
<!--
	window.onload = function(){
		<% If Now() < dfDate Then %>
			var v = new Date(<%=Year(sDate)%>,<%=Month(sDate)-1%>,<%=Day(sDate)%>,12,0,0); //티져종료
			teaserCountdown(v);
		<% else %>
			var v = new Date(<%=Year(eDate)%>,<%=Month(eDate)-1%>,<%=Day(eDate)+1%>,11,59,59 ); //이벤트종료
			countdown(v);
		<% end if %>
	}
	var yr = "<%=Year(sDate)%>";
	var mo = "<%=TwoNumber(Month(sDate))%>";
	var da = "<%=TwoNumber(Day(sDate))%>";
	var tmp_hh = "99";
	var tmp_mm = "99";
	var tmp_ss = "99";
	var minus_second = 0;
	var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
	var today=new Date(<%=Year(now())%>, <%=Month(now())-1%>, <%=Day(now())%>, <%=Hour(now())%>, <%=Minute(now())%>, <%=Second(now())%>);

	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();	
	}

	function checkform() {
	<% if datediff("d",date(),eDate)>=0 then %>
		<% If IsUserLoginOK Then %>
		var frm = document.frmcom;

		if (frm.kakaomsg.value == "" || frm.kakaomsg.value == "응원 메시지를 작성해 주세요. (최대 100자)" )
		{
			alert("응원 메시지를 작성해 주세요");
		}else{
			frm.action = "/event/etc/kakao_invite/doEventSubscript_42214.asp";
			frm.submit();

			kakaosend();
		}
		<% Else %>
			alert('로그인후에 이용가능 합니다.');
			return;
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if($("#kakaomsg").attr("value") =="응원 메시지를 작성해 주세요. (최대 100자)"){
				$("#kakaomsg").text("");
			}
			return;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur()
	{
		if($("#kakaomsg").attr("value") == ""){
			$("#kakaomsg").text("응원 메시지를 작성해 주세요. (최대 100자)");
		}
	}

	function trim(txt) {
		return txt.replace(/(^\s*)|(\s*$)/g, "");
	}

	function kakaosend(){
		var msg = document.getElementById('kakaomsg').value;
		var url =  "http://m.10x10.co.kr/event/eventmain.asp?eventid="+<%=eCode%>;
		
		if(trim(msg) == ''){
			alert('메세지를 작성하세요');
			document.getElementById('kakaomsg').value="";
			document.getElementById('kakaomsg').focus();
			return;
		}

			kakao.link("talk").send({
			msg : "띵동! 나른한 수요일 당신의 멋진 친구가 응원의 메시지를 보냈어요 : ) \n메시지 확인하고 , 또닥또닥 혜택 누리세요~\n ▶이벤트기간 : 05.12(수) 낮12시 ~ 05.13(목) 낮12시 (24시간!)\n\n\n[친구의 응원 메시지]\n"+msg+"\n\n\n<텐바이텐의 또닥또닥 3가지혜택>\n***kaffe duo 커피메이커! 더블마일리지! 영화예매권!",
			url : url,
			appid : "m.10x10.co.kr",
			appver : "2.0",
			appname : "텐바이텐의 또닥 또닥 Time!!",
			type : "link"    
		});
	}
	function textCounter(field, countfield, maxlimit) {
		if (field.value.length > maxlimit){ 
			field.blur();
			field.value = field.value.substring(0, maxlimit);
			alert("최대 100자 까지 적으실수 있습니다.");
			field.focus();
		}
	}

	function jshcommit(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>
	   frm.action = "/event/etc/kakao_invite/doEventSubscript_42214.asp";
	   return true;
	}
//-->
</script>
<% If Now() < dfDate Then %>
	<style type="text/css">
		.mEvt42214 {font-size:11px;}
		.mEvt42214 img {vertical-align:top;}
		.mEvt42214 .ddodak {padding:40% 0 18px; line-height:1.4; color:#535353; text-align:center; background:url('http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_teaser_img01.png') left top no-repeat #eafcff; background-size:100% auto;}
		.mEvt42214 .ddodak strong {color:#000;}
		.mEvt42214 .ddodak span {font-weight:bold; color:#ff4005;}
		.mEvt42214 .timer {position:relative; text-align:center; color:#333;}
		.mEvt42214 .timer .count {position:absolute; top:22%; width:100%;}
		.mEvt42214 .timer .count img {vertical-align:middle;}
	</style>
	<!-- content area -->
	<div class="mEvt42214">
		<div class="ddodak">
			<% If IsUserLoginOK then%>
			<p><strong><%=GetLoginUserName%></strong> 고객님! 한 주 잘 보내고 계시나요?<br />열심히 하루를 보내고 있을 고객님을 위해 또닥또닥 이벤트가<br />다시 찾아왔어요. <span>6월의 &lt;또닥또닥 Time&gt;</span> 곧 시작합니다.<br />HAVE A NICE DAY! DDO DAK!</p>
			<% else %>
			<p>텐바이텐 고객님! 한 주 잘 보내고 계시나요?<br />지친 여러분을 응원할 또닥또닥 이벤트가 다시 찾아왔어요.<br /><span>6월의 &lt;또닥또닥 Time&gt;</span> 곧 시작합니다.<br />HAVE A NICE DAY! DDO DAK!</p>
			<% End If %>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_teaser_img02.png" alt="학교에서, 일터에서, 열심히 한 주를 보내고 있는 당신! 텐바이텐이 여러분을 또닥또닥 응원합니다. 나른한 수요일 오후, 텐바이텐의 또닥또닥 Time과 함께 하세요!" style="width:100%;" /></p>
		<div class="timer">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_teaser_img03.png" alt="" style="width:100%;" /></p>

			<div class="count">
				<p class="bMar10">앞으로</p>
				<img id="hour1" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_num0.gif?t=h1" alt="0" style="width:8%" />
				<img id="hour2" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_num0.gif?t=h2" alt="1" style="width:8%" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_colon.gif" alt=":" style="width:4%" />
				<img id="minute1" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_num0.gif?t=m1" alt="2" style="width:8%" />
				<img id="minute2" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_num0.gif?t=m2" alt="3" style="width:8%" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_colon.gif" alt=":" style="width:4%" />
				<img id="second1" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_num0.gif?t=s1" alt="4" style="width:8%" />
				<img id="second2" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_teaser_num0.gif?t=s2" alt="5" style="width:8%" />
				<p class="tMar10">후에 시작합니다</p>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_teaser_img04.png" alt="텐텐 고객님! 또닥또닥 혜택누리면서 이번주도 힘! 내세요~" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_teaser_img05.png" alt="또닥또닥 TIME 이란? 수요일 낮 12시 ~  목요일 낮 12시까지, 24시간동안 진행되는 텐바이텐 고객을 위한 스페셜 혜택시간! (모바일 전용)" style="width:100%;" /></p>
	</div>
<% Else %>
	<style type="text/css">
		.mEvt42214 img {vertical-align:top;}
		.mEvt42214 .timer {height:43px; text-align:center; color:#fff; font-size:0.75em; background:url('http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_bg01.png') left top no-repeat; background-size:100% 43px;}
		.mEvt42214 .timer .count {padding-top:10px;}
		.mEvt42214 .timer .count span {vertical-align:middle;}
		.mEvt42214 .comment {padding:0 8px 15px; background:#eafcff; text-align:center; }
		.mEvt42214 .comment .write {border:3px solid #53d2ff; padding:8px; background:#fff;}
		.mEvt42214 .comment .write textarea {width:100%; height:37px; border:0; color:#a4a4a4; font-size:0.688em; line-height:1.2;}
		.mEvt42214 .commentList .total {text-align:right; padding:20px 6px 8px; color:#888; font-weight:bold; font-size:0.625em;}
		.mEvt42214 .commentList li {position:relative; height:76px; padding:25px 13px 0; margin-bottom:15px; font-size:0.688em; background-position:left top; background-repeat:no-repeat; background-size:100% 101px;}
		.mEvt42214 .commentList li.type01 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_bg02.png');}
		.mEvt42214 .commentList li.type02 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_bg03.png');}
		.mEvt42214 .commentList li.type03 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_bg04.png');}
		.mEvt42214 .commentList li.type04 {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_bg05.png');}
		.mEvt42214 .commentList li .writer {position:absolute; left:27px; top:11px; line-height:10px; color:#fff; font-weight:bold;}
		.mEvt42214 .commentList li .txt {overflow:hidden; height:45px; padding:10px 12px; border-radius:5px; line-height:1.2; color:#555; word-break:break-word; background:#fff;}
	</style>
	<div class="mEvt42214">
		<div class="timer">
			<div class="count"  id="limittime" style="display:block;">
				<span class="rMar05">또닥또닥 남은 시간</span>
				<img id="hour11" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_num0.gif?t=h11" alt="0" style="width:17px" />
				<img id="hour22" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_num0.gif?t=h22" alt="1" style="width:17px" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_colon.gif" alt=":" style="width:7px" />
				<img id="minute11" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_num0.gif?t=m11" alt="2" style="width:17px" />
				<img id="minute22" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_num0.gif?t=m22" alt="3" style="width:17px" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_colon.gif" alt=":" style="width:7px" />
				<img id="second11" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_num0.gif?t=s11" alt="4" style="width:17px" />
				<img id="second22" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/ddodak_num0.gif?t=s22" alt="5" style="width:17px" />
			</div>
			<div class="count" id="limittimeend" style="display:none;"><span class="rMar05">이벤트가 종료 되었습니다.</span></div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img01.png" alt="6월의 또닥또닥 TIME 시~작!" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img02.png" alt="응모버튼 누르기만 하면 이벤트 참여 완료!(1시간마다 1회씩, 총 24회 응모가능)" style="width:100%;" /></p>
		<form name="frmcom" method="post" onSubmit="return jshcommit(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="mode" value="enter">
		<p><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_btn01.png" alt="응모하기" style="width:100%;"/></p>
		</form>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img03.png" alt="텐텐 모바일에서 상품을 구매하신 모든 분들에게 더블 마일리지 지급! (6월 17일, 오전 11시, 일괄 지급)" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img04.png" alt="소중한 살마에게 응원의 메시지를 보내세요! 10분에게 CGV 주말예매권을 드려요!(이벤트 하단 설명 참고)" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img05.png" alt="다음 또닥또닥 TIME - 7월초에 다시 찾아옵니다. 텐바이텐 고객님 파이팅!" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img06.png" alt="또닥또닥 TIME 이란? 수요일 낮 12시 ~  목요일 낮 12시까지, 24시간동안 진행되는 텐바이텐 고객을 위한 스페셜 혜택시간! (모바일 전용)" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img07.png" alt="COMMENT EVENT" style="width:100%;" /></p>
		<form name="frmcom" method="post" style="margin:0px;">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"> 
		<input type="hidden" name="iCTot" value=""> 
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>"> 
		<div class="comment">
			<div class="write">
				<textarea name="kakaomsg" id="kakaomsg" title="응원 메시지 작성" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyDown="textCounter(this.form.kakaomsg,this.form.remLen,100);" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');textCounter(this.form.kakaomsg,this.form.remLen,100);" onblur="jsChkUnblur()" autocomplete="off">응원 메시지를 작성해 주세요. (최대 100자)</textarea>
			</div>
		</div>
		<p><a href="javascript:checkform();"><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_btn02.png" alt="카카오톡 메시지 보내기" style="width:100%;cursor:pointer;" /></a></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/42214/42214_img08.png" alt="메시지 작성 후, 카카오톡 메시지 보내기를 누르면 응모가 완료됩니다. 통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>
		<% IF isArray(arrCList) THEN %>
		<div class="commentList">
			<p class="total">Total <%=iCTotCnt%></p>
			<ul>
				<%For intCLoop = 0 To UBound(arrCList,2)%>
				<li class="type0<%=intCLoop+1%>">
					<p class="writer"><img src="http://fiximage.10x10.co.kr/m/event/42214/42214_img07.png" alt="FROM" style="width:38px" /> <%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
					<p class="txt"><%=nl2br(arrCList(1,intCLoop))%></p>
				</li>
				<% Next %>
			</ul>
			<div class="paging tMar25">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
		</div>
		<% End If %>
	</div>
<% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->