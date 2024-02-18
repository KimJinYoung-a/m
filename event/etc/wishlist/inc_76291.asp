<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  위시이벤트 - 무지개 라이브
' History : 2017-02-20 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/wishlist/wisheventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim eCode, userid , iCTotCnt , gubun , vreturnurl , pagedown
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "66282"
	Else
		eCode   =  "76291"
	End If

	vreturnurl = Request.ServerVariables("url") &"?"&Request.ServerVariables("QUERY_STRING")
	gubun = requestCheckvar(request("gubun"),1)

	If gubun <> "" Then pagedown = "ON"

	If gubun = "" Then
		gubun = dategubun(Date())
	End If 

	'// 날짜 구분 없을때 구분값
	function dategubun(v)
		Select Case CStr(v)
			Case "2017-02-22"
				dategubun = "1"
			Case "2017-02-23"
				dategubun = "2"
			Case "2017-02-24"
				dategubun = "3"
			Case "2017-02-25"
				dategubun = "4"
			Case "2017-02-26"
				dategubun = "5"
			Case "2017-02-27"
				dategubun = "6"
			Case "2017-02-28"
				dategubun = "7"
			Case Else
				dategubun = "1"
		end Select
	end function

	userid = GetEncLoginUserID()

	Dim ifr, page, i, y
	page = requestCheckvar(request("page"),4)

	If page = "" Then page = 1

	set ifr = new evt_wishfolder
	ifr.FPageSize	= 6
	ifr.FCurrPage	= page
	ifr.FeCode		= eCode

	ifr.Frectuserid = userid
	ifr.Fgubun		= gubun
	ifr.evt_daily_itemselect

	iCTotCnt		= ifr.FTotalCount '리스트 총 갯수

	Dim sp, spitemid, spimg
	Dim arrCnt

	Dim strSql, todayCount
	todayCount = 0

	strSql = "Select COUNT(idx) From db_temp.dbo.tbl_event_itemwish  WHERE userid='" & userid & "' and gubun = '"& gubun &"' "
	'response.write strSql
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		todayCount = rsget(0)
	else
		todayCount = 0
	END IF
	rsget.Close
%>
<style type="text/css">
.rainbow {background-color:#efefef;}
.rainbow button {background-color:transparent;}
.rainbow input::-webkit-input-placeholder {color:#9b9b9b; font-weight:normal;}
.rainbow input::-moz-placeholder {color:#9b9b9b; font-weight:normal;} /* firefox 19+ */
.rainbow input:-ms-input-placeholder {color:#9b9b9b; font-weight:normal;} /* ie */
.rainbow input:-moz-placeholder {color:#9b9b9b; font-weight:normal;}

.rainbow .mission {padding-top:1.5rem; background-color:#f1f1f1;}

.navigator ul {overflow:hidden; width:27.2rem; margin:0 auto;}
.navigator ul li {float:left; width:4.8rem; height:5rem; margin:0.3rem 1rem 0;}
.navigator ul li a {overflow:hidden; display:block; position:relative; width:100%; height:100%; line-height:5rem; text-align:center;}
.navigator ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/img_navigator_01.png) no-repeat 50% 49.6%; background-size:100% auto;}
.navigator ul li .coming span {background-position:50% 0; cursor:default;}
.navigator ul li a.on span {background-position:0 100%;}
.navigator ul li.nav2 a span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/img_navigator_02.png);}
.navigator ul li.nav3 a span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/img_navigator_03.png);}
.navigator ul li.nav4 a span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/img_navigator_04.png);}
.navigator ul li.nav5 {margin-left:4.35rem;}
.navigator ul li.nav5 a span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/img_navigator_05.png);}
.navigator ul li.nav6 a span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/img_navigator_06.png);}
.navigator ul li.nav7 a span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/img_navigator_07.png);}

.rainbow .mission .form {width:28.85rem; margin:0 auto; padding:1.25rem 0; background-color:#fff;}
.rainbow .mission .form .fieldset {width:24.6rem; margin:0 auto; padding-right:7.4rem; position:relative; border:2px solid #3c3c3c;}
.rainbow .mission .form input[type=number] {width:100%; height:3rem; border:0; color:#000; font-size:1.1rem; font-weight:bold; line-height:3rem;}
.rainbow .mission .form .btnCheck {position:absolute; top:50%; right:1rem; width:6.1rem; height:2.45rem; margin-top:-1.225rem;}

.rainbow .mission .check {padding-top:2rem; text-align:center;}
.rainbow .mission .check .thumbnail {width:11.5rem; margin:0 auto;}
.rainbow .mission .check p em {overflow:hidden; display:block; width:16.9rem; height:2.2rem; margin:1.3rem auto 0.6rem; padding:0 1rem; background-color:#f4f4f4; color:#3c3c3c; font-size:1.1rem; line-height:2.2rem; text-overflow:ellipsis; white-space:nowrap;}
.rainbow .mission .check p img {width:11.2rem;}
.rainbow .mission .check .btnArea {margin-top:1.8rem;}
.rainbow .mission .check .btnArea input,
.rainbow .mission .check .btnArea button {width:10.9rem; margin:0 0.2rem; vertical-align:top;}

.rainbow .result {padding-bottom:4rem; background-color:#fff;}
.rainbow .result ul {overflow:hidden; width:27.15rem; margin:0 auto;}
.rainbow .result ul li {float:left; width:7.25rem; margin:0 0.9rem;}

.rainbow .mine ul {height:16.35rem; margin-top:1.05rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/bg_nodata.png) 50% 0 no-repeat; background-size:25.35rem auto;}
.rainbow .mine ul li {margin-bottom:1.85rem;}
.rainbow .mine ul li img {border:2px solid #dfdfdf;}
.rainbow .mine ul li:nth-child(4) {margin-left:5.3rem;}

.rainbow .friends {margin-top:5%;}
.rainbow .friends ul li {margin-top:1.1rem; text-align:center;}
.rainbow .friends ul li .desc {margin-top:1rem; color:#818181; font-size:1rem;}
.rainbow .friends ul li .no,
.rainbow .friends ul li .id {display:block;}
.rainbow .friends ul li .no {width:4.2rem; height:1.15rem; margin:0 auto; padding-top:0.1rem; background-color:#818181; color:#fff; line-height:1rem;}
.rainbow .friends ul li .id {margin-top:0.5rem;}
.rainbow .friends ul li .id b {overflow:hidden; display:inline-block; max-width:80%; padding-bottom:0.2rem; text-overflow:ellipsis; white-space:nowrap; vertical-align:top;}

.pagingV15a {margin-top:1.8rem; width:100%;}
.pagingV15a span {width:2.15rem; height:2.15rem; margin:0 0.2rem; border-color:#828282; border-radius:0;}
.pagingV15a span a {color:#818181; font-size:1.2rem; font-weight:bold; line-height:0.5em;}
.pagingV15a span.current {border-color:#d50f0f;}
.pagingV15a span.current a {color:#d50f0f;}
.pagingV15a span.arrow {margin:0; border-color:#828282; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/btn_pagination_nav.png) 50% 0 no-repeat; background-size:100% auto;}
.pagingV15a span.nextBtn {background-position:50% 100%;}

.noti {padding:1.8rem 2rem; background-color:#f0f0f0;}
.noti h3 {color:#818181; font-size:1.5rem; font-weight:bold; text-align:center;}
.noti h3 span {display:inline-block; width:1.65rem; height:1.65rem; margin:0 0.6rem 0.1rem 0; background:url(http://webimage.10x10.co.kr/eventIMG/2017/76291/m/blt_exclamation_mark.png) 50% 50% no-repeat; background-size:100%; vertical-align:bottom;}
.noti ul {margin-top:1.2rem;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#818181; font-size:1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#818181;}
</style>
<script type="text/javascript">
$(function(){
	$(".mission .check").hide();

	<% if page > 1 then %>
		setTimeout(function(){
			$('html, body').animate({scrollTop:$("#friendlist").offset().top}, 'fast');
		}, 300);
	<% else %>
		<% if pagedown = "ON" then %>
			setTimeout(function(){
				$('html, body').animate({scrollTop:$(".navigator").offset().top}, 'fast');
			}, 300);
		<% end if %>
	<% end if %>
});

function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}

function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% if todayCount > 4 then %>
			alert("한 ID당 하루 최대 5개의 상품을 등록하실 수 있습니다.");
			return;
		<% end if %>
		<% If Now() > #02/28/2017 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If Now() > #02/22/2017 00:00:00# and Now() < #02/28/2017 23:59:59# Then %>
				var frm = document.frm;
				frm.action="/event/etc/wishlist/itemwishProc.asp";
				frm.hidM.value='I';
				frm.target = "frmgo";
				frm.submit();
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% end if %>
	<% else %>
		<% if isApp then %>
			calllogin();
		<% else %>
			jsevtlogin();
		<% end if %>
	<% end if %>
}

// 상품정보 접수
function fnItemInfo() {
	<% If IsUserLoginOK() Then %>
	var iid  = document.frm.itemid.value;
	if (!iid){
		alert("상품코드를 입력해주세요");
		document.frm.itemid.focus();
		return;
	}
	$.ajax({
		type: "GET",
		url: "/common/act_iteminfo.asp?itemid="+iid,
		dataType: "xml",
		async:false,
		cache:false,
		success: function(xml) {
			if($(xml).find("itemInfo").find("item").length>0) {
				var rst = "<div class='thumbnail'><img src='" + $(xml).find("itemInfo").find("item").find("basicimage").text() + "' alt='"+ $(xml).find("itemInfo").find("item").find("itemname").text() +"'/></div>"
					rst += "<p><em>" + $(xml).find("itemInfo").find("item").find("itemname").text() +"</em><img src='http://webimage.10x10.co.kr/eventIMG/2017/76291/txt_check.png' alt='으로 응모하시겠어요?' /></p>"
					rst += "<div class='btnArea'><input type='image' src='http://webimage.10x10.co.kr/eventIMG/2017/76291/btn_submit_v1.png' alt='응모하기' onclick='jsSubmit()'/><button type='reset' onclick='resetitem();'><img src='http://webimage.10x10.co.kr/eventIMG/2017/76291/btn_resubmit.png' alt='다시 입력하기' /></button></div>";
				$("#lyItemInfo").fadeIn();
				$("#lyItemInfo").html(rst);
				$(".mission .check").slideDown();
			} else {
				$("#lyItemInfo").fadeOut();
			}
		},
		error: function(xhr, status, error) {
			alert("상품코드를 다시 확인 해주세요");
			document.frm.itemid.value = "";
			document.frm.itemid.focus();
			$("#lyItemInfo").fadeOut();
		}
	});
	<% else %>
		<% if isApp then %>
			calllogin();
		<% else %>
			jsevtlogin();
		<% end if %>
	<% end if %>
}

//reset
function resetitem(){
	$(".mission .check").hide();
	document.frm.itemid.value = "";
	$("#lyItemInfo").empty();
}

function jsViewItem(i){
	<% if isApp=1 then %>
		fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>
<div class="mEvt76291 rainbow">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/txt_rainbow.jpg" alt="매일매일 미션에 맞는 상품을 찾아주세요!" /></p>

	<div class="mission">
		<div class="navigator">
			<ul>
				<li class="nav1">
					<% If Date() < "2017-02-22" Then %>
					<a href="#" class="coming" onclick="return false;"><span></span>2월 22일 빨간색</a>
					<% Else %>
					<a href="/event/eventmain.asp?eventid=<%=ecode%>&gubun=1" class="<%=chkiif(gubun = 1,"on","")%>"><span></span>2월 22일 빨간색</a>
					<% End If %>
				</li>
				<li class="nav2">
					<% If Date() < "2017-02-23" Then %>
					<a href="#" class="coming" onclick="return false;"><span></span>2월 23일 주황색</a>
					<% Else %>
					<a href="/event/eventmain.asp?eventid=<%=ecode%>&gubun=2" class="<%=chkiif(gubun = 2,"on","")%>"><span></span>2월 23일 주황색</a>
					<% End If %>
				</li>
				<li class="nav3">
					<% If Date() < "2017-02-24" Then %>
					<a href="#" class="coming" onclick="return false;"><span></span>2월 22일 노랑색</a>
					<% Else %>
					<a href="/event/eventmain.asp?eventid=<%=ecode%>&gubun=3" class="<%=chkiif(gubun = 3,"on","")%>"><span></span>2월 22일 노랑색</a>
					<% End If %>
				</li>
				<li class="nav4">
					<% If Date() < "2017-02-25" Then %>
					<a href="#" class="coming" onclick="return false;"><span></span>2월 22일 초록색</a>
					<% Else %>
					<a href="/event/eventmain.asp?eventid=<%=ecode%>&gubun=4" class="<%=chkiif(gubun = 4,"on","")%>"><span></span>2월 22일 초록색</a>
					<% End If %>
				</li>
				<li class="nav5">
					<% If Date() < "2017-02-26" Then %>
					<a href="#" class="coming" onclick="return false;"><span></span>2월 22일 파랑색</a>
					<% Else %>
					<a href="/event/eventmain.asp?eventid=<%=ecode%>&gubun=5" class="<%=chkiif(gubun = 5,"on","")%>"><span></span>2월 22일 파랑색</a>
					<% End If %>
				</li>
				<li class="nav6">
					<% If Date() < "2017-02-27" Then %>
					<a href="#" class="coming" onclick="return false;"><span></span>2월 22일 남색</a>
					<% Else %>
					<a href="/event/eventmain.asp?eventid=<%=ecode%>&gubun=6" class="<%=chkiif(gubun = 6,"on","")%>"><span></span>2월 22일 남색</a>
					<% End If %>
				</li>
				<li class="nav7">
					<% If Date() < "2017-02-28" Then %>
					<a href="#" class="coming" onclick="return false;"><span></span>2월 22일 보라색</a>
					<% Else %>
					<a href="/event/eventmain.asp?eventid=<%=ecode%>&gubun=7" class="<%=chkiif(gubun = 7,"on","")%>"><span></span>2월 22일 보라색</a>
					<% End If %>
				</li>
			</ul>
		</div>

		<div class="inner">
			<h3>
				<% If Date() <= "2017-02-22" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_mission_01.png" alt="텐바이텐 속 빨간색을 찾아주세요!" />
				<% ElseIf Date() = "2017-02-23" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_mission_02.png" alt="텐바이텐 속 주황색을 찾아주세요!" />
				<% ElseIf Date() = "2017-02-24" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_mission_03.png" alt="텐바이텐 속 노랑색을 찾아주세요!" />
				<% ElseIf Date() = "2017-02-25" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_mission_04.png" alt="텐바이텐 속 초록색을 찾아주세요!" />
				<% ElseIf Date() = "2017-02-26" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_mission_05.png" alt="텐바이텐 속 파랑색을 찾아주세요!" />
				<% ElseIf Date() = "2017-02-27" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_mission_06.png" alt="텐바이텐 속 남색을 찾아주세요!" />
				<% ElseIf Date() >= "2017-02-28" Then %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_mission_07.png" alt="텐바이텐 속 보라색을 찾아주세요!" />
				<% End If %>
			</h3>

			<div class="form">
				<form name="frm" method="post">
				<input type="hidden" name="hidM" value="I">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="returnurl" value="<%=vreturnurl%>">
					<fieldset>
						<div class="fieldset">
							<div class="itext"><input type="number" name="itemid" title="상품코드 입력" placeholder=" 상품코드 입력 (숫자 6~7자)" value=""/></div>
							<button type="button" class="btnCheck" onclick="fnItemInfo();"><img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/btn_check.png" alt="상품 확인" /></button>
						</div>
						<div class="check" id="lyItemInfo"></div>
					</fieldset>
				</form>
			</div>

			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/txt_mission_guide.png" alt="이벤트 참여방법 텐바이텐 사이트에서 미션 색깔에 맞는 상품을 찾아보아요 상품 상세페이지로 들어가보아요 우측 상단에 있는 상품코드를 이벤트 페이지에서 입력! 응모하기 버튼을 클릭하면 완료! 이벤트에 참여하신 고객님 중 20분을 추첨하여 텐바이텐 기프트카드 3만원권을 드립니다 이벤트 기간은 2월 22일 수요일부터 2월 28일 화요일까지며, 당첨자 발표는 3월 2일 목요일입니다." /></p>
		</div>
	</div>
	
	<% if todayCount > 0 then %>
	<div class="result mine">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_result_mine.png" alt="나의 컬러별 미션수행 상품을 확인해보세요!" /></h3>
		<% if ifr.FmyTotalCount > 0 then %>
		<ul>
			<%
				if isarray(Split(ifr.Fmylist,",")) then
					arrCnt = Ubound(Split(ifr.Fmylist,","))
				else
					arrCnt=0
				end if

				If ifr.FmyTotalCount > 4 Then
					arrCnt = 5
				Else
					arrCnt = ifr.FmyTotalCount
				End If

				For y = 0 to CInt(arrCnt) - 1
					sp = Split(ifr.Fmylist,",")(y)
					spitemid = Split(sp,"|")(0)
					spimg	 = Split(sp,"|")(1)
			%>
			<li><a href="" onClick="jsViewItem('<%=spitemid%>'); return false;"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" /></a></li>
			<%
				Next
			%>
		</ul>
		<% end if %>
	</div>
	<% End If %>

	<% If ifr.FResultCount > 0 Then %>
	<div class="result friends" id="friendlist">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/76291/m/tit_result_friends.png" alt="다른 친구들의 미션수행 결과는?" /></h3>
		<ul>
			<% For i = 0 to ifr.FResultCount -1 %>
			<li>
				<a href="" onClick="jsViewItem('<%=ifr.FList(i).Fitemid%>'); return false;">
					<img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(ifr.FList(i).Fitemid)%>/<%=ifr.FList(i).Ficonimg%>" alt="<%=ifr.FList(i).Fitemname%>" />
					<div class="desc">
						<span class="no">No.<%=iCTotCnt-i-(10*(page-1))%></span>
						<span class="id"><b><%=printUserId(ifr.FList(i).FUserid,2,"*")%></b> 님</span>
					</div>
				</a>
			</li>
			<% Next %>
		</ul>
		<div class="paging pagingV15a">
			<%= fnDisplayPaging_New(page,ifr.FTotalCount,6,4,"jsGoPage") %>
		</div>
	</div>
	<% End If %>

	<div class="noti">
		<h3><span></span>이벤트 유의사항</h3>
		<ul>
			<li>한 ID당 하루 최대 5개의 상품을 등록하실 수 있습니다.</li>
			<li>동일한 상품을 2번 이상 등록하실 수 없습니다.</li>
			<li>참여 횟수가 많을수록 당첨 확률이 올라갑니다.</li>
			<li>미션 색깔에 맞는 상품을 등록할수록 당첨확률이 높아집니다.</li>
			<li>당첨자는 3월 2일 사이트 공지사항에 게시될 예정입니다.</li>
			<li>정확한 발표를 위해 마이텐바이텐의 개인정보를 업데이트 해주세요.</li>
		</ul>
	</div>
	<iframe src="" name="frmgo" frameborder="0" width="0" height="0"></iframe>
</div>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
	<input type="hidden" name="eventid" value="<%=eCode%>"/>
	<input type="hidden" name="gubun" value="<%=gubun%>"/>
	<input type="hidden" name="page" value=""/>
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->
