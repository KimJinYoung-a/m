<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 플레잉 내 이름은 KYOTO 스페셜 뱃지 응모 MA
' History : 2017.07.13 유태욱
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, vUserID, myevt, vDIdx, myselect
dim arrList, sqlStr

IF application("Svr_Info") = "Dev" THEN
	eCode = "66394"
Else
	eCode = "79254"
End If

vDIdx = request("didx")
vUserID = getEncLoginUserID
myselect = 0

'참여했는지 체크
myevt = getevent_subscriptexistscount(eCode, vUserID,"","","")

sqlStr = ""
sqlStr = sqlStr & " select isnull([1],0) as '1',isnull([2],0) as '2',isnull([3],0) as '3',isnull([4],0) as '4',isnull([5],0) as '5',isnull([6],0) as '6',isnull([7],0) as '7',isnull([8],0) as '8',isnull([9],0) as '9' " & vbCrlf
sqlStr = sqlStr & " from  " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & "		SELECT  sub_opt2 as so2, COUNT(*) as cnt " & vbCrlf
sqlStr = sqlStr & "			FROM db_event.[dbo].[tbl_event_subscript]  " & vbCrlf
sqlStr = sqlStr & "				where evt_code = '"& eCode &"' " & vbCrlf
sqlStr = sqlStr & "				group by sub_opt2 " & vbCrlf
sqlStr = sqlStr & " ) as a " & vbCrlf
sqlStr = sqlStr & " pivot " & vbCrlf
sqlStr = sqlStr & " ( " & vbCrlf
sqlStr = sqlStr & "		sum(cnt) for so2 in ([1],[2],[3],[4],[5],[6],[7],[8],[9]) " & vbCrlf
sqlStr = sqlStr & " ) as tp "
rsget.Open sqlStr,dbget,1
If not rsget.EOF Then
	arrList = rsget.getRows()
End If
rsget.close

dim numcols, rowcounter, colcounter, thisfield(8)
if isArray(arrList) then
	numcols=ubound(arrList,1)
		FOR colcounter=0 to numcols
			thisfield(colcounter)=arrList(colcounter,0)
			if isnull(thisfield(colcounter)) or trim(thisfield(colcounter))=""then
				thisfield(colcounter)="0"
			end if
		next
end if
'response.write thisfield(8)

sqlstr = "select top 1 sub_opt2 " &_
		"  from db_event.dbo.tbl_event_subscript where evt_code = '" & eCode & "' and userid = '" & vUserID & "' "
		'response.write sqlstr
rsget.Open sqlStr,dbget,1
	IF Not rsget.Eof Then
		myselect = rsget(0)
	end if
rsget.Close
%>
<style type="text/css">
.thingVol019 {background-color:#fff;}
.topic {position:relative;}
.topic h2 {position:absolute; left:50%; top:13.5%; z-index:40;width:42%; margin-left:-21%;}
.topic p {position:absolute; left:50%; z-index:40;}
.topic p.collabo {top:8.7%; width:50%; margin-left:-25%;}
.topic p.meet {top:32%; width:73%; margin-left:-36.5%;}
.topic .pagination {position:absolute; left:0; bottom:2rem; z-index:40; width:100%; height:0.7rem; padding-top:0;}
.topic .pagination span {width:0.7rem; height:0.7rem; margin:0 0.5rem; background-color:#fff;}
.topic .pagination span.swiper-active-switch {background-color:#fd4f00;}
.aboutHitchhiker {position:relative;}
.aboutHitchhiker a {position:absolute; left:0; top:0; width:100%; height:100%; background:transparent; text-indent:-999em;}
.pickBadge {padding-bottom:5rem; background-color:#9ce1f7;}
.pickBadge ul {padding:0 3.125% 1.6rem; }
.pickBadge ul:after {content:' '; display:block; clear:both;}
.pickBadge li {float:left; width:33.33333%; padding:0 1.6% 1.5rem; text-align:center;}
.pickBadge li input[type=radio] {position:absolute; left:0; top:0; visibility:hidden; width:0; height:0; font-size:0; line-height:0;}
.pickBadge li label {display:block; position:relative; background-color:#fff; border-radius:50%; cursor:pointer; transition:all .2s;}
.pickBadge li span {display:inline-block; padding:0.9rem 0 0.4rem; font-size:1.1rem; font-weight:bold; color:#000; white-space:nowrap;}
.pickBadge li p {font-size:1rem; font-weight:600; color:#1c5263;}
.pickBadge li input[type=radio]:checked + label {background-color:#4bc7ec;}
.pickBadge li input[type=radio]:checked + label:after {content:''; display:inline-block; position:absolute; left:50%; top:-1.2rem; width:2.05rem; height:2.05rem; margin-left:-0.8rem; background:url(http://webimage.10x10.co.kr/playing/thing/vol019/m/ico_select.png) 0 0 no-repeat; background-size:100%; animation:bounce1 .4s;}
.evtNoti {padding:4rem 6.25%; color:#000; background-color:#e6e6e6;}
.evtNoti h3 {padding-bottom:1.5rem; font-size:1.5rem; font-weight:bold;}
.evtNoti li {position:relative; font-size:1.1rem; line-height:1.4; padding:0.3rem 0 0 1rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.85rem; width:0.35rem; height:0.35rem; background-color:#000; border-radius:50%;}
@keyframes bounce1{
	from,to {transform:translateY(0);}
	50% {transform:translateY(5px);}
}
</style>
<script type="text/javascript">
$(function(){

	$(".pickBadge li").click(function(){
		$("#gubunval").val($(this).val());
	});

	mySwiper = new Swiper(".topic .swiper-container",{
		loop:true,
		autoplay:2500,
		speed:600,
		effect:"fade",
		pagination:".topic .pagination",
		paginationClickable:true
	});

	titleAnimation();
	$(".topic h2").css({"margin-top":"10px","opacity":"0"});
	$(".topic p.meet").css({"margin-top":"10px","opacity":"0"});
	function titleAnimation() {
		$(".topic h2").delay(600).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
		$(".topic p.meet").delay(1100).animate({"margin-top":"-5px","opacity":"1"},600).animate({"margin-top":"0"},400);
	}
});


function fnBadge() {
	var badgeval = $("#gubunval").val();
	<% If vUserID = "" Then %>
		<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
		<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
		<% end if %>	
	<% End If %>
	<% If vUserID <> "" Then %>
	if(!badgeval > 0 && !badgeval < 10){
		alert('뱃지를 선택해 주세요.');
		return false;
	}
	
	var reStr;
	var str = $.ajax({
		type: "GET",
		url:"/playing/sub/doEventSubscript79254.asp",
		data: "mode=down&gubunval="+badgeval,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "dn") {
				$("#badgebtn").hide();
				$("#badgehd").show();
				alert('응모가 완료 되었습니다!');
				document.location.reload();
				return false;
			}else{
				alert('오류가 발생했습니다.');
				document.location.reload();
				return false;
			}
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
			document.location.reload();
			return false;
		}
	<% End If %>
}

function fnBadgeok() {
	alert('응모 완료 되었습니다.');
	return false;
}

function fnaftalt() {
	alert('이미 응모 하셨습니다.');
	return false;
}
</script>
	<div class="thingVol019 imKyoto">
		<div class="topic">
			<p class="collabo"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_collabo.png" alt="" /></p>
			<h2><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/tit_kyoto.png" alt="내 이름은 KYOTO" /></h2>
			<p class="meet"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_meet.png" alt="월간 THING. 뱃지가 감성 매거진 히치하이커를 만나 스페셜 뱃지가 탄생하였습니다." /></p>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_slide_4.jpg" alt="" /></div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>
		<div class="item">
			<div class="mWeb">
				<a href="/category/category_itemPrd.asp?itemid=1750843"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_1.jpg" alt="히치하이커 + PLAYing 뱃지 KYOTO SET" /></a>
				<a href="/category/category_itemPrd.asp?itemid=1745808"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_2.jpg" alt="PLAYing THING. 스페셜 뱃지 KYOTO" /></a>
				<a href="/category/category_itemPrd.asp?itemid=1732642"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_3.jpg" alt="10X10 히치하이커 vol.64 KYOTO" /></a>
			</div>
			<div class="mApp">
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1750843" onclick="fnAPPpopupProduct('1750843');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_1.jpg" alt="히치하이커 + PLAYing 뱃지 KYOTO SET" /></a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1745808" onclick="fnAPPpopupProduct('1745808');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_2.jpg" alt="PLAYing THING. 스페셜 뱃지 KYOTO" /></a>
				<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1732642" onclick="fnAPPpopupProduct('1732642');return false;"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_item_3.jpg" alt="10X10 히치하이커 vol.64 KYOTO" /></a>
			</div>
		</div>
		<div class="aboutHitchhiker">
			<p><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_hitchhiker.jpg" alt="히치하이커는 격월간으로 발행되는 텐바이텐의 감성 매거진입니다. 매 호 다른 주제로 우리 주변의 평범한 이야기와 일상의 풍경을 담아냅니다. 히치하이커가 당신에게 소소한 즐거움, 작은 위로가 될 수 있길 바랍니다." /></p>
			<% if date() < "2017-08-01" then %>
				<div>
					<a href="/event/eventmain.asp?eventid=79038" class="mWeb">히치하이커 이벤트 바로가기</a>
					<a href="#" onclick="fnAPPpopupEvent('79038'); return false;" class="mApp">히치하이커 이벤트 바로가기</a>
				</div>
			<% else %>
			<div>
				<a href="/street/street_brand.asp?makerid=hitchhiker" class="mWeb">히치하이커 바로가기</a>
				<a href="#" onclick="fnAPPpopupBrand('hitchhiker'); return false;" class="mApp">히치하이커 바로가기</a>
			</div>
			<% end if %>
		</div>
		<div class="aboutBadge">
			<div><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_thing.jpg" alt="" /></div>
			<a href="/street/street_brand.asp?makerid=1010play" class="mWeb"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_thing_v2.jpg" alt="THING. 뱃지는 텐바이텐이 디자인한 뱃지에 고객님이 지어주신 이름으로 매월 한정수량 출시됩니다. 이름 지어주기 이벤트는 텐바이텐의 다양한 콘텐츠를 만날 수 있는 코너 PLAYing에서 매달 참여할 수 있습니다." /></a>
			<a href="#" onclick="fnAPPpopupBrand('1010play'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_thing_v2.jpg" alt="THING. 뱃지는 텐바이텐이 디자인한 뱃지에 고객님이 지어주신 이름으로 매월 한정수량 출시됩니다. 이름 지어주기 이벤트는 텐바이텐의 다양한 콘텐츠를 만날 수 있는 코너 PLAYing에서 매달 참여할 수 있습니다." /></a>
		</div>
		<!-- 뱃지 선택 -->
		<div class="pickBadge">
			<h3><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_event.jpg" alt="출시된 THING. 뱃지 중 어떤 뱃지가 가장 마음에 들었나요? 뱃지를 선택해주신 분 중 30분께 교토 뱃지와 히치하이커 교토편이 들어있는 [KYOTO SET]를 드립니다." /></h3>
			<ul>
				<li value="1" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge1" name="badge" <%=chkIIF(myselect="1","checked","")%> />
					<label for="badge1"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_1.png" alt="" /></label>
					<span>11월 포구미</span>
					<p><%= thisfield(0) %>명의 PICK♡</p>
				</li>
				<li value="2" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge2" name="badge" <%=chkIIF(myselect="2","checked","")%> />
					<label for="badge2"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_2.png" alt="" /></label>
					<span>12월 말양말양</span>
					<p><%= thisfield(1) %>명의 PICK♡</p>
				</li>
				<li value="3" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge3" name="badge" <%=chkIIF(myselect="3","checked","")%> />
					<label for="badge3"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_3.png" alt="" /></label>
					<span>1월 둥근해가떠썬</span>
					<p><%= thisfield(2) %>명의 PICK♡</p>
				</li>
				<li value="4" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge4" name="badge" <%=chkIIF(myselect="4","checked","")%> />
					<label for="badge4"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_4.png" alt="" /></label>
					<span>2월 띵띵빵빵</span>
					<p><%= thisfield(3) %>명의 PICK♡</p>
				</li>
				<li value="5" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge5" name="badge" <%=chkIIF(myselect="5","checked","")%> />
					<label for="badge5"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_5.png" alt="" /></label>
					<span>3월 봄달새</span>
					<p><%= thisfield(4) %>명의 PICK♡</p>
				</li>
				<li value="6" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge6" name="badge" <%=chkIIF(myselect="6","checked","")%> />
					<label for="badge6"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_6.png" alt="" /></label>
					<span>4월 봄빨간화분이</span>
					<p><%= thisfield(5) %>명의 PICK♡</p>
				</li>
				<li value="7" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge7" name="badge" <%=chkIIF(myselect="7","checked","")%> />
					<label for="badge7"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_7.png" alt="" /></label>
					<span>5월 달릴레옹</span>
					<p><%= thisfield(6) %>명의 PICK♡</p>
				</li>
				<li value="8" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge8" name="badge" <%=chkIIF(myselect="8","checked","")%> />
					<label for="badge8"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_8.png" alt="" /></label>
					<span>6월 행보캡</span>
					<p><%= thisfield(7) %>명의 PICK♡</p>
				</li>
				<li value="9" <%=chkIIF(myselect<>"0"," onclick='fnaftalt(); return false;'","")%> >
					<input type="radio" id="badge9" name="badge" <%=chkIIF(myselect="9","checked","")%> />
					<label for="badge9"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/img_badge_9.png" alt="" /></label>
					<span>7월 날아갈꺼에어</span>
					<p><%= thisfield(8) %>명의 PICK♡</p>
				</li>
			</ul>
			<% if myevt > 0 and myevt <> 99999 then %>
				<p id="badgeok"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_finish.png" alt="응모완료" /></p>
			<% else %>
				<button type="button" onclick="fnBadge(); return false;" id="badgebtn"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/btn_submit.png" alt="응모하기" /></button>
			<% end if %>
			<p id="badgehd" style="display:none"><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_finish.png" alt="응모완료" /></p>
			<%' 당첨자발표 했다고 요청오면 응모버튼 없애고 이거 띄움<p><img src="http://webimage.10x10.co.kr/playing/thing/vol019/m/txt_end.png" alt="당첨자가 발표되었습니다. 감사합니다" /></p> %>
			<input type="hidden" id="gubunval" name="gubunval">
		</div>
		<!--// 뱃지 선택 -->
		<div class="evtNoti">
			<h3>유의사항</h3>
			<ul>
				<li>본 이벤트는 한 ID 당 1회 응모할 수 있습니다.</li>
				<li>당첨자 발표는 8월 2일 사이트에 공지될 예정이며, 메일과 문자로 당첨안내 될 예정입니다.</li>
				<li>사은품은 회원 정보상의 기본주소로 사은품이 배송됩니다. MY10X10에서 개인정보를 업데이트해주세요.</li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->	