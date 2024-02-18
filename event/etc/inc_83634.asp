<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 2017 설식당
' History : 2018-01-19 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<%
dim eCode, vUserID, nowdate, trgItem, oItem
Dim gnbUse : gnbUse = false

IF application("Svr_Info") = "Dev" THEN
	eCode = "66423"
Else
	eCode = "80634"
End If

If inStr(Request.ServerVariables("QUERY_STRING"),"gnbflag=1")>0 Then
	gnbUse = true
End If

'// 오늘의 특사 상품 접수
Dim baseDt: baseDt = date & " " & Num2Str(Hour(now),2,"0","R") & ":" & Num2Str(Minute(now),2,"0","R") & ":" & Num2Str(Second(now),2,"0","R")
'// 테스트용
'baseDt = Date()+3
'// 날짜별 원데이 상품 지정
Select Case left(baseDt,10)
	'// 1주차
	Case "2018-01-22": trgItem=949487		'영국 무설탕 슈퍼잼 선물세트
	Case "2018-01-23": trgItem=1556834		'MADVANILLA 바닐라라떼 선물세트 싱글
	Case "2018-01-24": trgItem=1212217		'인테이크 에센셜 조미료 3종(허브/향신료/천연조미료)
	Case "2018-01-25": trgItem=52732			'신꽃피는차 - 선물 셋트
	Case "2018-01-26","2018-01-27","2018-01-28": trgItem=1780969		'정성견과 선물세트

	'// 2주차
	Case "2018-01-29": trgItem=1860800		'제주 더치커피_ 마이빈스 새해기원 선물세트 (210mlx4ea)
	Case "2018-01-30": trgItem=1285004		'아몬드/캐슈넛/호두/피스타치오/피칸 닥터넛츠 오리지널뉴(30팩)
	Case "2018-01-31": trgItem=1596901		'현미 연강정 선물세트 M 생강/초코/사과 (쇼핑백 포함)
	Case "2018-02-01": trgItem=1871349		'[꽃을담다]설한정_오리지널꽃차&티스틱세트+쑥꽃티스틱세트(5ea)
	Case "2018-02-02","2018-02-03","2018-02-04": trgItem=1549045		'[꿀.건.달] ★보자기묶음 벌꿀 3종 미니 선물세트

	'// 3주차
	Case "2018-02-05": trgItem=1887287		'해일 곶감 설 선물세트
	Case "2018-02-06": trgItem=1630836		'현미 연강정&정과&편강&부각 선물세트L 생강/초코/사과칩
	Case "2018-02-07": trgItem=1253348		'마이빈스 더치한첩 40
	Case "2018-02-08": trgItem=1792350		'인시즌 생강 5종 선물세트
	Case "2018-02-09","2018-02-10","2018-02-11": trgItem=1212217		'인테이크 에센셜 조미료 3종

	'// 4주차
	Case "2018-02-12": trgItem=1780968		'인테이크 모닝죽
	Case "2018-02-13": trgItem=1630095		'[SuperNuts]100%땅콩 슈퍼너츠-선물세트
	Case Else
		trgItem="0"
		baseDt=""
end Select

'// 메인 상품 목록
dim arrItem(3), arrTmp, strSort, i, j, arrTit(6,2)

'단독
arrItem(1) = "1878642,1878643,1780969,1789995,1780973,1515948,1515949,1780971,1881035,1544992,1626956,1626955,1626954,1878641,1878647,1878648,1881738,1878640"
'전통
arrItem(2) = "1791664,1468740,1226845,1546789,1549045,949487,1549037,1638559,1285004,52732,1868009,1630836,1549042,1253348,1875073,1596901,1553228,1059384,1553228"
'신상
arrItem(3) = "1781962,1868010,1860800,1294226,1791964,1792349,1871349,1881339,1860800,1199665,1212217,1791962,1880881"

arrTit(0,1) = "today"
arrTit(0,2) = "오늘의 특가선물"
'arrTit(1,1) = "only"
'arrTit(1,2) = "텐바이텐 단독선물"
'arrTit(2,1) = "best"
'arrTit(2,2) = "베스트셀러"
'arrTit(3,1) = "new"
'arrTit(3,2) = "떠오르는 신상"
arrTit(1,1) = "only"
arrTit(1,2) = "텐바이텐 단독선물"
arrTit(2,1) = "only"
arrTit(2,2) = "텐바이텐 단독선물"
arrTit(3,1) = "best"
arrTit(3,2) = "베스트셀러"
arrTit(4,1) = "best"
arrTit(4,2) = "베스트셀러"
arrTit(5,1) = "new"
arrTit(5,2) = "떠오르는 신상"
arrTit(6,1) = "new"
arrTit(6,2) = "떠오르는 신상"

'테스트용
'arrItem(1) = "1878642,1878643"
'arrItem(2) = "1791664,1468740"
'arrItem(3) = "1781962,1868010"

'// 랜덤으로 2개씩 취합
for i=1 to 3
	arrTmp = split(arrItem(i),",")
	Randomize
	'j = int((ubound(arrTmp)+1)*rnd)			'1개일때
	j = int(ubound(arrTmp)*rnd)
	trgItem = trgItem & "," & arrTmp(j)
	trgItem = trgItem & "," & arrTmp(j+1)	'추가 1개 더
next

'// 정렬순서 쿼리
dim srt: i=0
for each srt in split(trgItem,",")
	i = i +1
	strSort = strSort & "When itemid=" & srt & " then " & i & " "
next

'// 상품 정보 접수
dim sqlStr, arrTgt(6,5)
sqlStr = "Select itemid, itemname, basicimage, orgprice, sellcash, sailyn, itemdiv "
sqlStr = sqlStr & "from db_item.dbo.tbl_item "
sqlStr = sqlStr & "where itemid in (" & trgItem & ") and itemid<>0 "
sqlStr = sqlStr & "order by case " & strSort & " end"
rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
if Not(rsget.EOF or rsget.BOF) then
	Do Until rsget.EOF
		i=0
		for each srt in split(trgItem,",")
			if cstr(rsget("itemid"))=cstr(srt) then
				arrTgt(i,0) = rsget("itemid")
				arrTgt(i,1) = rsget("itemname")
				arrTgt(i,2) = chkiif(rsget("basicimage")<>"","http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(rsget("itemid")) & "/" & rsget("basicimage"),"")
				arrTgt(i,3) = FormatNumber(rsget("orgprice"),0) & chkIIF(rsget("itemdiv")="82","Pt","원")
				arrTgt(i,4) = FormatNumber(rsget("sellcash"),0) & chkIIF(rsget("itemdiv")="82","Pt","원")
				If (rsget("sailyn")="Y") and (rsget("orgprice") - rsget("sellcash") > 0) THEN
					arrTgt(i,5) = cStr(int((rsget("orgprice")-rsget("sellcash"))/rsget("orgprice")*100)) & "%"
				end if
			end if
			i = i +1
		next
		rsget.MoveNext
	loop
end if
rsget.Close

'response.Write arrTgt(0,0) &"/" & arrTgt(1,0) &"/" & arrTgt(2,0) &"/" & arrTgt(3,0)

Dim vTimerDate
	vTimerDate = DateAdd("d",1,Date())
%>
<style type="text/css">
.newyear-item {position:relative;}
.newyear-item .swiper {position:absolute; left:0; top:0; width:100%; text-align:center; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.newyear-item .swiper .swiper-slide {padding:4% 11% 0;}
.newyear-item .swiper .swiper-slide > a {display:block;}
.newyear-item .swiper .label {position:absolute; left:50%; top:0; z-index:20; width:24%; margin-left:17%; margin-top:4%; opacity:0; transition:all .5s .3s;}
.newyear-item .swiper .swiper-slide-active .label {margin-top:0; opacity:1;}
.newyear-item .swiper .thumbnail {position:relative; border:0.34rem solid #fff; border-radius:1.02rem; box-shadow:1rem 1rem 1.9rem rgba(109,103,82,.32);}
.newyear-item .swiper .thumbnail img {border-radius:1.02rem;}
.newyear-item .swiper .thumbnail .time {position:absolute; left:0; bottom:0; z-index:10; width:100%; font-size:1.28rem; padding:1.37rem 0; background:rgba(0,0,0,.65); border-radius:0 0 1.02rem 1.02rem;}
.newyear-item .swiper .thumbnail .time span {padding-left:1.8rem; color:#f8eabf; background:url(http://webimage.10x10.co.kr/eventIMG/2018/83634/m/ico_clock.png?v=1) 0 30% no-repeat; background-size:1.37rem 1.38rem;}
.newyear-item .swiper .thumbnail .time em {padding-left:0.7rem; color:#fff;}
.newyear-item .swiper .name {overflow:hidden; padding:2.13rem 1rem 1.2rem; color:#000; font-size:1.54rem; line-height:1; text-overflow:ellipsis; white-space:nowrap;}
.newyear-item .swiper .price {padding-bottom:1.2rem; line-height:1;}
.newyear-item .swiper .price s {color:#868274; font-size:1.3rem; padding-right:0.4rem; vertical-align:middle;}
.newyear-item .swiper .price span {font-size:1.6rem; color:#000; vertical-align:middle;}
.newyear-item .swiper .price s + span {color:#ff0000;}
.newyear-item .swiper .buy {width:77%; margin:0 auto;}
.newyear-item .swiper button {position:absolute; top:29%; z-index:20; width:9.5%; background:transparent;}
.newyear-item .swiper button.btnPrev {left:0;}
.newyear-item .swiper button.btnNext {right:0;}
.bnr-event {overflow:hidden; padding:0 4.6% 4.4rem; background:#1f2a4d;}
.bnr-event li {float:left; width:50%; padding:0 1.7% 3.4%;}
</style>
<script type="text/javascript">
$(function(){
	// 메인배너 스와이핑
	slideTemplate = new Swiper('.swiper .swiper-container',{
		loop:true,
		//autoplay:3000,
		speed:700,
		nextButton:'.swiper .btnNext',
		prevButton:'.swiper .btnPrev'
	});

	<% if arrTgt(0,0)>0 then %>
	nowDt = new Date('<%=replace(baseDt,"-","/")%>');
	countdown();
	<% end if %>
});


var j1yr = "<%=Year(vTimerDate)%>";
var j1mo = "<%=TwoNumber(Month(vTimerDate))%>";
var j1da = "<%=TwoNumber(Day(vTimerDate))%>";
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var j1today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

var j1minus_second = 0;		// 변경될 증가시간(초)
var j1nowDt=new Date();		// 시작시 브라우저 시간
// 오늘의 특가 타이머
function countdown(){
	var cntDt = new Date(Date.parse(j1today) + (1000*j1minus_second));	//서버시간에 변화값(1초) 증가
	var todayy=cntDt.getYear()

	if(todayy < 1000) todayy+=1900;

	var todaym=cntDt.getMonth();
	var todayd=cntDt.getDate();
	var todayh=cntDt.getHours();
	var todaymin=cntDt.getMinutes();
	var todaysec=cntDt.getSeconds();
	var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
	var futurestring=montharray[j1mo-1]+" "+j1da+", "+j1yr+" 00:00:00";

	dd=Date.parse(futurestring)-Date.parse(todaystring);
	dday=Math.floor(dd/(60*60*1000*24)*1);
	dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
	dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
	dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

	if(dday < 0) {
		$("#countdown").html("00:00:00 남음");
		return;
	}

	if(dhour < 10) dhour = "0" + dhour;
	if(dmin < 10) dmin = "0" + dmin;
	if(dsec < 10) dsec = "0" + dsec;
	dhour = dhour+'';
	dmin = dmin+'';
	dsec = dsec+'';

	// Print Time
	$("#lyrGift0 .time em").html(dhour.substr(0,1)+dhour.substr(1,1) +" : "+ dmin.substr(0,1)+dmin.substr(1,1) +" : "+ dsec.substr(0,1)+dsec.substr(1,1));

	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(j1nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	j1minus_second = vTerm;	// 증가시간에 차이 반영

	setTimeout("countdown()",500);
}
</script>

<%'!-- 2017 추석기획전 --%>
<div class="mEvt83634">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/tit_restaurant.png?v=1" alt="감사한 마음을 전하는 설식당" /></h2>
	<div class="newyear-item">
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
				<%
					for i=0 to 6
						if arrTgt(i,0)>0 and arrTgt(i,0)<>"" then
				%>
					<div class="swiper-slide" id="lyrGift<%=i%>">
					<% If isapp="1" Then %>
						<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=arrTgt(i,0)%>&amp;pEtr=<%=ecode%>'); return false;">
					<% else %>
						<a href="/category/category_itemPrd.asp?itemid=<%=arrTgt(i,0)%>&pEtr=<%=ecode%>">
					<% end if %>
							<p class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/label_<%=arrTit(i,1)%>.png" alt="<%=arrTit(i,2)%>"></p>
							<div class="thumbnail">
								<img src="<%=arrTgt(i,2)%>" alt="<%=arrTgt(i,1)%>">
								<% if i=0 then %><p class="time"><span>남은시간</span><em>-- : -- : --</em></p><% end if %>
							</div>
							<p class="name"><%=arrTgt(i,1)%></p>
						<% if arrTgt(i,5)<>"" then %>
							<p class="price"><s><%=arrTgt(i,3)%></s><span><%=arrTgt(i,4) & " [" & arrTgt(i,5) & "]"%></span></p>
						<% else %>
							<p class="price"><span><%=arrTgt(i,4)%></span></p>
						<% end if %>
							<p class="buy"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/btn_<%=arrTit(i,1)%>.png" alt="구매하러 가기"></p>
						</a>
					</div>
				<%
						end if
					Next
				%>
				</div>
			</div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/btn_next.png" alt="다음" /></button>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bg_item.png?v=1" alt="" /></div>
	</div>
	<div class="bnr-event">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/tit_menu.png" alt="감사한 마음을 전하는 설식당" /></h3>
		<ul>
			<% If gnbUse Then %>
			<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=83763'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_1.jpg" alt="센스있는 용돈봉투" /></a></li>
			<% Else %>
			<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=83763"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_1.jpg" alt="센스있는 용돈봉투" /></a></li>
			<% End If %>

			<% If gnbUse Then %>
			<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=83833'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_2.jpg" alt="효도/조카 선물" /></a></li>
			<% Else %>
			<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=83833"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_2.jpg" alt="효도/조카 선물" /></a></li>
			<% End If %>

			<% If gnbUse Then %>
			<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=83829'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_3.jpg" alt="도란도란 다과상" /></a></li>
			<% Else %>
			<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=83829"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_3.jpg" alt="도란도란 다과상" /></a></li>
			<% End If %>

			<% If gnbUse Then %>
			<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=83700'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_4.jpg" alt="설 연휴에는 떠나요" /></a></li>
			<% Else %>
			<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=83700"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/bnr_event_4.jpg" alt="설 연휴에는 떠나요" /></a></li>
			<% End If %>

		</ul>
	</div>
	<div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83634/m/txt_comment.jpg" alt="COMMENT EVENT 설식당에서 어떤 선물세트를 누구에게 선물하고 싶으신가요? 코멘트를 남겨주신 10분을 추첨하여 텐바이텐이 정성껏 고른 선물을 드립니다" /></a></div>
</div>
<%'!--// 2018 설식당 --%>