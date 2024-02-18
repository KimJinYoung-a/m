<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MIDORI 창립 66주년, 당신의 매일을 풍요롭게 하다
' History : 2015-12-18 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->

<%
Dim eCode, userid, sqlstr
Dim vTotalCount, selcount1, selcount2, selcount3, selcount4, selcount5
Dim selper1, selper2, selper3, selper4, selper5

userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65987
Else
	eCode   =  68207
End If

'// 총 카운트
sqlstr = "select count(*) "
sqlstr = sqlstr & " ,count(case when sub_opt2=1 then 1 end) as selcount1 "
sqlstr = sqlstr & " ,count(case when sub_opt2=2 then 1 end) as selcount2 "
sqlstr = sqlstr & " ,count(case when sub_opt2=3 then 1 end) as selcount3 "
sqlstr = sqlstr & " ,count(case when sub_opt2=4 then 1 end) as selcount4 "
sqlstr = sqlstr & " ,count(case when sub_opt2=5 then 1 end) as selcount5 "
sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript"
sqlstr = sqlstr & " where evt_code='"& eCode &"'  "
rsget.Open sqlstr, dbget, 1

If Not rsget.Eof Then
	vTotalCount =	rsget(0)
	selcount1	=	rsget(1)
	selcount2	=	rsget(2)
	selcount3	=	rsget(3)
	selcount4	=	rsget(4)
	selcount5	=	rsget(5)
End IF
rsget.close

IF isNull(vTotalCount)  then vTotalCount=0

'vTotalCount=100
'selcount1=0

if vTotalCount <> 0 then
	selper1 = Int( selcount1 * 100 / vTotalCount )
	selper2 = Int( selcount2 * 100 / vTotalCount )
	selper3 = Int( selcount3 * 100 / vTotalCount )
	selper4 = Int( selcount4 * 100 / vTotalCount )
	selper5 = Int( selcount5 * 100 / vTotalCount )
else
	selper1 = 0
	selper2 = 0
	selper3 = 0
	selper4 = 0
	selper5 = 0
end if

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68207 {position:relative;}
.myMidori {position:relative; padding-bottom:11%; background:#e3b48d url(http://webimage.10x10.co.kr/eventIMG/2015/68207/m/bg_gift_v1.jpg) no-repeat 0 70%; background-size:100% auto;}
.myMidori ul {overflow:hidden; padding:0 2.6%;}
.myMidori li {position:relative; float:left; width:50%; margin-bottom:13px;}
.myMidori li input {position:absolute; left:50%; bottom:5%; width:16px; height:16px; margin-left:-8px; border-radius:50%;}
.myMidori li input[type=radio]:checked {background-image:none;}
.myMidori li input[type=radio]:checked:after {content:''; display:inline-block; position:absolute; left:50%; top:50%; width:10px; height:10px; margin:-5px 0 0 -5px; background:#d60000; border-radius:50%;}
.myMidori .btnArea {padding-top:5%; text-align:center;}
.myMidori .btnArea a {display:inline-block; width:38.125%; margin:0 6px;}
#layerVoteResult {position:absolute; left:0; top:0; width:100%; height:100%; padding-top:20%; z-index:100; background-color:rgba(0,0,0,.6);}
.resultCont {position:relative; width:90%; padding:20px 25px 5px; margin:0 auto; background:#f9f6ee;}
.resultCont h3 {color:#5a341a; font-size:18px; padding-bottom:3px; font-weight:bold; border-bottom:1px solid #5a341a;}
.resultCont .closeLayer {position:absolute; top:15px; right:25px;width:20px; background-color:transparent;}
.resultCont ul {padding-top:30px;}
.resultCont li {display:table; width:100%; margin-bottom:15px; font-weight:bold; font-size:13px; table-layout:fixed;}
.resultCont li div {display:table-cell; vertical-align:middle;}
.resultCont li .name {width:40%;}
.resultCont li .bar {width:45%;}
.resultCont li .bar p {height:8px;}
.resultCont li .percent {width:15%; text-align:right;}
.resultCont li.nom01 {color:#27404d;}
.resultCont li.nom02 {color:#f5b41b;}
.resultCont li.nom03 {color:#f4476d;}
.resultCont li.nom04 {color:#b78649;}
.resultCont li.nom05 {color:#99b749;}
.resultCont li.nom01 .bar p {background:#27404d;}
.resultCont li.nom02 .bar p {background:#ffe3a1;}
.resultCont li.nom03 .bar p {background:#f4476d;}
.resultCont li.nom04 .bar p {background:#b78649;}
.resultCont li.nom05 .bar p {background:#99b749;}
</style>
<script>
function jsevtchk(){
	<% if Date() < "2015-12-21" or Date() > "2016-12-31" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		var st = $(":input:radio[name=selridio]:checked").val();

		if (typeof st == "undefined")
		{
			alert("내가 좋아하는 MIDORI를 선택해 주세요.");
			return;
		}

		var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript68207.asp",
			data: "mode=midoriadd&itemsel="+st,
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="11")
				{

					alert('투표가 완료 되었습니다.');
					location.reload();

				}
				else if (result.resultcode=="44")
				{
				<% if isApp=1 then %>
					parent.calllogin();
					return false;
				<% else %>
					parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
					return false;
				<% end if %>
				}
				else if (result.resultcode=="77")
				{
					alert('이미 투표 하셨습니다.');
					return false;
				}
				else if (result.resultcode=="88")
				{
					alert("이벤트 기간이 아닙니다.");
					return;
				}
			}
		});
	<% end if %>
}
</script>

	<!-- MIDORI 창립 66주년 -->
	<div class="mEvt68207">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/tit_midori.jpg" alt="MIDORI 창립 66주년, 당신의 매일을 풍요롭게 하다" /></h2>
		<!-- 투표하기 -->
		<div class="myMidori">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/txt_vote.png" alt="내가 좋아하는 MIDORi를 투표해주세요!" /></h3>
			<ul>
				<li class="pdt01">
					<label for="pdt01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/img_nominee_01.png" alt="트래블러스노트" /></label>
					<input type="radio" name="selridio" id="pdt01" value="1" />
				</li>
				<li class="pdt02">
					<label for="pdt02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/img_nominee_02.png" alt="MD노트" /></label>
					<input type="radio" name="selridio" id="pdt02" value="2" />
				</li>
				<li class="pdt03">
					<label for="pdt03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/img_nominee_03.png" alt="CL스테이셔너리" /></label>
					<input type="radio" name="selridio" id="pdt03" value="3" />
				</li>
				<li class="pdt04">
					<label for="pdt04"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/img_nominee_04.png" alt="Brass Product" /></label>
					<input type="radio" name="selridio" id="pdt04" value="4" />
				</li>
				<li class="pdt05">
					<label for="pdt05"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/img_nominee_05.png" alt="PET GIFT" /></label>
					<input type="radio" name="selridio" id="pdt05" value="5" />
				</li>
			</ul>
			<div class="btnArea">
				<a href="" onclick="jsevtchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/btn_vote.png" alt="투표하기" /></a>
				<a href="#layerVoteResult" class="viewResult"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/btn_result.png" alt="결과보기" /></a>
			</div>
		</div>
		<!--// 투표하기 -->
		<!-- 투표결과 레이어 -->
		<div id="layerVoteResult" style="display:none">
			<div class="resultCont">
				<h3>실시간 투표 결과</h3>
				<ul>
					<li class="nom01">
						<div class="name">트래블러스노트</div>
						<div class="bar"><p style="width:<%= selper1 %>%"></p></div>
						<div class="percent"><%= selper1 %>%</div>
					</li>
					<li class="nom02">
						<div class="name">MD노트</div>
						<div class="bar"><p style="width:<%= selper2 %>%"></p></div>
						<div class="percent"><%= selper2 %>%</div>
					</li>
					<li class="nom03">
						<div class="name">CL스테이셔너리</div>
						<div class="bar"><p style="width:<%= selper3 %>%"></p></div>
						<div class="percent"><%= selper3 %>%</div>
					</li>
					<li class="nom04">
						<div class="name">Brass Product</div>
						<div class="bar"><p style="width:<%= selper4 %>%"></p></div>
						<div class="percent"><%= selper4 %>%</div>
					</li>
					<li class="nom05">
						<div class="name">PET GIFT</div>
						<div class="bar"><p style="width:<%= selper5 %>%"></p></div>
						<div class="percent"><%= selper5 %>%</div>
					</li>
				</ul>
				<button type="button" class="closeLayer"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
		<!--// 투표결과 레이어 -->

		<div class="bnr">
			<a href="eventmain.asp?eventid=68288" title="미도리 더 많은 상품 보러가기" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68207/m/btn_more.jpg" alt="MIDORi창립 66주년을 축하합니다! 소비자의 눈높이에 맞추어 개성을 완성해주는 상품, 그 이상의 것" /></a>
		</div>
	</div>
	<!--// MIDORI 창립 66주년 -->

<script type="text/javascript">
$(function(){
	$(".viewResult").click(function(){
		$("#layerVoteResult").show();
		window.parent.$('html,body').animate({scrollTop:150}, 600);
	});
	$(".closeLayer").click(function(){
		$("#layerVoteResult").hide();
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->