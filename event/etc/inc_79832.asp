<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 설문조사
' History : 2017-08-17 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/dysonCls.asp" -->
<%
dim eCode, userid, currenttime, DayCount
IF application("Svr_Info") = "Dev" THEN
	eCode = "66413"
Else
	eCode = "79832"
End If
currenttime = now()
userid = GetEncLoginUserID()

dim subscriptcountend
subscriptcountend=0

'//본인 참여 여부
if userid<>"" then
	subscriptcountend = getevent_subscriptexistscount(eCode, userid, "", "2", "")
end If

Dim cEvtFan
Set cEvtFan = New CDyson
cEvtFan.FECode = eCode	'이벤트 코드
cEvtFan.FRectUserID = userid
cEvtFan.GetDysonCount
DayCount=cEvtFan.FTotalCount
Set cEvtFan = Nothing
%>
<style type="text/css">
h2 {position:relative;}
h2 a {overflow:hidden; display:block; position:absolute; left:38%; top:12%; width:53%; height:65%; text-indent:-999em;}
.evtEntry {position:relative;}
.evtEntry .btnEntry {position:absolute; left:0; top:71%; z-index:10; width:100%;}
.mine {position:relative;}
.mine h3 {position:absolute; left:0; top:15%; width:100%; text-align:center; font-size:1.9rem; color:#fff; font-weight:bold; letter-spacing:0.15rem;}
.mine h3 span {display:inline-block; padding:0 0.1rem; border-bottom:2px solid #fff; color:#ffd32a; line-height:0.9;}
.mine ul {overflow:hidden; position:absolute; left:0; top:30%; width:100%; padding:0 3%; text-align:center;}
.mine ul li {overflow:hidden; float:left; width:25%; padding:0.5rem; text-align:center;}
.mine ul li div {position:relative; width:100%; height:100%;}
.mine ul li div:after {display:none; position:absolute; left:0; top:0; right:0; bottom:0; content:''; background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_sticker1.png); background-repeat:no-repeat; background-position:50% 50%; background-size:100% 100%;}
.mine ul li + li div:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_sticker2.png);}
.mine ul li + li + li div:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_sticker3.png);}
.mine ul li + li + li + li div:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_sticker4.png);}
.mine ul li + li + li + li + li {margin-left:13%;}
.mine ul li + li + li + li + li div:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_sticker5.png);}
.mine ul li + li + li + li + li + li {margin-left:0;}
.mine ul li + li + li + li + li + li div:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_sticker6.png);}
.mine ul li + li + li + li + li + li + li div:after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_sticker7.png);}
.mine ul li.entry div:after {display:block;}
.evtNoti {padding:2.6rem 0; background-color:#12185e;}
.evtNoti h3 {padding-bottom:1.6rem; font-size:1.6rem; font-weight:bold; color:#ffcc33; text-align:center;}
.evtNoti h3 span {border-bottom:0.15rem solid #ffcc33;}
.evtNoti ul {padding:7.5%;}
.evtNoti li {position:relative; font-size:1.2rem; color:#fff; padding:0.3rem 0 0.3rem 1.3rem; line-height:1.4;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:1rem; width:0.5rem; height:1px; background-color:#fff;}
</style>
<script>
function chkevt(){
	<% If not(IsUserLoginOK()) Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			//return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			//return false;
		<% end if %>
	<% else %>
	jsEventSubmit();
	<% End IF %>
}

function jsEventSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If now() > #08/27/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return false;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/doEventSubscript79832.asp",
				data: $("#frm").serialize(),
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			console.log(str);
			if (str1[0] == "01"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "02"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "03"){
				alert(str1[1]);
				return false;
			}else if (str1[0] == "05"){
				alert(str1[1]);
				location.reload();
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
					<div class="mEvt79832">
						<h2>
							<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1750502&pEtr=79832" onclick="fnAPPpopupProduct('1750502&pEtr=79832');return false;" class="mApp">다이슨V8 앱솔루트 플러스</a>
							<a href="/category/category_itemPrd.asp?itemid=1750502&pEtr=79832" class="mWeb">다이슨V8 앱솔루트 플러스</a>
							<img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/tit_dyson_v2.jpg" alt="多다이슨" />
						</h2>
						<div class="evtEntry">
							<a href="javascript:chkevt();" class="btnEntry"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/btn_entry.png" alt="응모하기" /></a>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/txt_dyson_v2.png" alt="하루에 한번씩 응모하고 다이슨 청소기 득템하세요" /></p>
						</div>
						<div class="mine">
							<h3>나의 응모 횟수 <span><%=DayCount%></span>번</h3>
							<ul>
								<li<% If DayCount > 0 Then %> class="entry"<% End If %>><div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_1day.png" alt="1Day" /></div></li>
								<li<% If DayCount > 1 Then %> class="entry"<% End If %>><div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_2day.png" alt="2Day" /></div></li>
								<li<% If DayCount > 2 Then %> class="entry"<% End If %>><div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_3day.png" alt="3Day" /></div></li>
								<li<% If DayCount > 3 Then %> class="entry"<% End If %>><div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_4day.png" alt="4Day" /></div></li>
								<li<% If DayCount > 4 Then %> class="entry"<% End If %>><div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_5day.png" alt="5Day" /></div></li>
								<li<% If DayCount > 5 Then %> class="entry"<% End If %>><div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_6day.png" alt="6Day" /></div></li>
								<li<% If DayCount > 6 Then %> class="entry"<% End If %>><div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/img_7day.png" alt="7Day" /></div></li>
							</ul>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79832/m/bg_mine.png" alt="" /></p>
						</div>
						<div class="evtNoti">
							<h3><span>이벤트 유의사항</span></h3>
							<ul>
								<li>본 이벤트는 하루에 한 번씩 응모하실 수 있습니다.</li>
								<li>응모 횟수가 많을수록 당첨 확률도 높아집니다.</li>
								<li>당첨자 발표는 8월 28일(월) 사이트 공지사항에 게시될 예정입니다.</li>
								<li>제세공과금은 텐바이텐 부담이며, 세무신고를 위해 개인정보를 취합한 뒤에 경품이 증정됩니다.</li>
							</ul>
						</div>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->