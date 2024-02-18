<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2015오픈이벤트 - 쫄깃한 득템! 텐바이텐 핫 딜 - 이 기적 쇼핑!
' History : 2015.04.10 허진원 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/inc_const.asp" -->
<style type="text/css">
.aprilHoney img {vertical-align:top;}
.aprilHoney button {background-color:transparent;}
.honeyGet .topic h1 {visibility:hidden; width:0; height:0;}

.brandbox {background-color:#fff;}
.item ul {overflow:hidden;}
.item1 ul {padding:10% 0;}
.item1 ul li {float:left; width:33.3333%;}
.item1 ul li a {display:block;}
.item2 ul li {overflow:hidden;}
.item2 ul li {float:left; width:33.3333%; margin:8% 0;}
.item2 ul li:nth-child(1), .item2 ul li:nth-child(2) {width:50%; margin:0;}
.item3 ul {padding:3% 0 8%;}
.item3 ul li {float:left; width:50%;}
.item4 ul li, .item5 ul li {float:left; width:50%;}
.item6 ul li {float:left; width:50%;}
.item6 ul li.last {width:100%;}
.item7 ul, .item8 ul {padding:0 3.5%;}
.item7 ul li, .item8 ul li {float:left; width:33.333%;}
.item9 ul li, .item10 ul li, .item11 ul li {float:left; width:50%;}
.item9 ul li.last {width:100%;}
.item12 ul {padding:0 3.5%;}
.item12 ul li {float:left; width:33.333%;}
.item12 ul li.half {width:50%;}

.brandbox .mo .btndown , .brandbox .app .btnget {margin:5% 0;}

.schedule {background-color:#f6f4f2;}
.schedule h2 {margin-bottom:-4%;}
.timetable {overflow:hidden; margin-bottom:-2px; padding:0 5%;}
.timetable li {float:left; width:25%; padding:5% 0.5%; border-bottom:2px dashed #cfcecd;}
.timetable li span {display:block; margin-bottom:3%;}
.noti {position:relative; z-index:5; padding:30px 10px; border-top:3px solid #ffc2b1; background-color:#fffaeb;}
.noti h2 {color:#444; font-size:13px; line-height:1.25em;}
.noti h2 span {position:relative; padding:0 10px;}
.noti h2 span:after, .noti h2 span:before {content:' '; position:absolute; top:50%; width:2px; height:12px; margin-top:-6px; background-color:#ffa689;}
.noti h2 span:after {left:0;}
.noti h2 span:before {right:0;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#555; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #f4c0bb; border-radius:50%; background-color:transparent;}

.bnr {border-top:3px solid #fff;}
@media all and (min-width:480px){
	.noti {padding:45px 15px;}
	.noti h2 {font-size:20px;}
	.noti h2 span {padding:0 15px;}
	.noti h2 span:after, .noti h2 span:before {width:3px; height:18px; margin-top:-9px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:6px; width:3px; height:3px; border:3px solid #f4c0bb;}
}
</style>
<script type="text/javascript">
$(function(){
	fnGetGetHoneyVeiw('');
});

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>';
	}
};

function fnGetGetHoneyVeiw(dd) {
	$.ajax({
		type:"POST",
		url: "/event/etc/iframe_61491_veiw.asp",
		data: "tgd="+dd,
		cache: false,
		success: function(message) {
			$("#lyrGetHoney").html(message);
			if(dd!="") {
				$('html,body').animate({scrollTop: $("#lyrGetHoney").offset().top},'fast');
			}
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

</script>
<div class="aprilHoney">
	<div class="honeyGet">
		<div class="topic">
			<h1>쫄깃한 득템</h1>
			<!--<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_get.png" alt="매일 오후 3시 가장 착한 가격 &amp; 다신 없을 구성 매일, 최고의 브랜드를 가장 좋은 가격에 누구보다 빠르게 만나보세요!" /></p>-->
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_get_12pm.png" alt="매일 정오 12시 가장 착한 가격 &amp; 다신 없을 구성 매일, 최고의 브랜드를 가장 좋은 가격에 누구보다 빠르게 만나보세요!" /></p>
		</div>

		<!-- 날짜별 상품 -->
		<div id="lyrGetHoney"></div>

		<!-- schedule -->
		<%
			'// 오늘 날짜 설정
			dim nowDay: nowDay = cStr(day(date))
			'if nowDay<13 then nowDay = "13"
			'if nowDay>24 then nowDay = "24"
			'nowDay = "16"

			'// 날짜별 브랜드명 설정
			dim arrMkNm
			arrMkNm = split("roomet,iriver,snurk,coleman,bomann,fashionbox,instax,playmobil,mybeans,lamy,method,iconic",",")

			'// 이벤트 상품 재고여부 확인 (날짜순서와 상품코드 순서가 같음※)
			dim sqlstr, arrIsSoldout(12), i, vRIcon
			sqlstr = "select itemid "
			sqlstr = sqlstr & "	, Case when sellyn='Y' and ((limityn='Y' and limitno>limitsold) or limityn='N') then 'N' else 'Y' end as soldyn "
			sqlstr = sqlstr & "from db_item.dbo.tbl_item "

			IF application("Svr_Info") = "Dev" THEN
				sqlstr = sqlstr & "where itemid in (1239205,1239115,1232978,1234671,1239177,1239176,1239175,1239174,1239173,1239172,1239171,1239170) "
			else
				sqlstr = sqlstr & "where itemid in (1250336,1250337,1250338,1250339,1250340,1250341,1250342,1250343,1250344,1250345,1250346,1250347) "
			end if

			sqlstr = sqlstr & "order by itemid asc"

			rsget.Open sqlstr,dbget
			IF not rsget.EOF THEN
				i = 0
				Do Until rsget.EOF
					arrIsSoldout(i) = rsget("soldyn")
					rsget.MoveNext
					i = i+1
				Loop
			end if
			rsget.Close
		%>
		<div class="schedule">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/tit_schedule.png" alt="쫄깃하게 득템할 스케줄" /></h2>
			<!-- for dev msg : 지난 브랜드 내용은 확인 할 수 있습니다. -->
			<ul class="timetable">
			<%
				'// 일정 아이콘 출력
				' (tab_브랜드_속성.png : 오늘 today / 판매완료 soldout / 진행중 ing / 진행예정 coming (투데이 다음날) / 디폴트 off)
				for i=0 to 11
					vRIcon = "<li>"

					'# 일자
					if nowDay=cStr(i+13) then
						vRIcon = vRIcon & "<span><img src=""http://webimage.10x10.co.kr/eventIMG/2015/60832/m/tab_april_today.png"" alt=""4월 " & (i+13) & "일"" /></span>"
					else
						vRIcon = vRIcon & "<span><img src=""http://webimage.10x10.co.kr/eventIMG/2015/60832/m/tab_april_" & (i+13) & ".png"" alt=""4월 " & (i+13) & "일"" /></span>"
					end if

					'# 브랜드 이미지
					'vRIcon = vRIcon & "<em>"
					
					if cInt(nowDay)>=(i+12) then
						vRIcon = vRIcon & "<em><img src=""http://webimage.10x10.co.kr/eventIMG/2015/60832/m/tab_" & arrMkNm(i) & "_"

						if nowDay=cStr(i+13) then
							if hour(now)>=12 then		'12시 OPEN
								if arrIsSoldout(i)="Y" then
									vRIcon = vRIcon & "soldout"
								else
									vRIcon = vRIcon & "today"
								end if
							else
								vRIcon = vRIcon & "coming"
							end if
						elseif nowDay=cStr(i+12) then
							vRIcon = vRIcon & "coming"
						elseif arrIsSoldout(i)="Y" then
							vRIcon = vRIcon & "soldout"
						else
							vRIcon = vRIcon & "ing"
						end if

						vRIcon = vRIcon & ".png"" alt=""4월 " & (i+13) & "일"""
						if (cInt(nowDay)>(i+13) and arrIsSoldout(i)<>"Y") or (nowDay=cstr(i+13)) then
							vRIcon = vRIcon & " onclick=""fnGetGetHoneyVeiw(" & i+13 & ")"" style=""cursor:pointer;"""
						end if

						vRIcon = vRIcon & " /></em>"
					else
						vRIcon = vRIcon & "<em><img src=""http://webimage.10x10.co.kr/eventIMG/2015/60832/m/tab_off.png"" alt=""준비중"" /></em>"
					end if

					vRIcon = vRIcon & "</li>" & vbCrLf

					Response.Write vRIcon
				next
			%>
			</ul>
		</div>

		<div class="noti">
			<h2><span>이벤트 유의사항</span></h2>
			<ul>
				<li>텐바이텐 고객님을 위한 이벤트 입니다. (비회원 참여 불가)</li>
				<li>한정수량으로 실시간 결제로만 구매할 수 있습니다.</li>
				<li>상품은 결제순으로 판매/배송 처리 되며, 초과될 경우 결제순으로 환불처리 됩니다.</li>
				<li>상품 정보 및 교환/환불 정책은 상품의 상세 페이지를 반드시 확인해주시기 바랍니다.</li>
			</ul>
		</div>

		<!-- 사월의 꿀맛 셋콤달콤으로 링크 -->
		<%
			dim vEvtLink
			if isApp then
				if date<="2015-04-16" then
					vEvtLink = "60930"
				elseif date<="2015-04-20" then
					vEvtLink = "60931"
				else
					vEvtLink = "60932"
				end if
			else
				vEvtLink = "60933"
			end if
		%>
		<div class="bnr"><a href="<%=appUrlPath%>/event/eventmain.asp?eventid=<%=vEvtLink%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_event_bnr_sweet.png" alt="사월의 꿀맛 셋콤달콤 가기" /></a></div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->