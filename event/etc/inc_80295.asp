<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 2017 추석세끼
' History : 2017.09-07 허진원
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
	eCode = "80295"
End If

If inStr(Request.ServerVariables("QUERY_STRING"),"gnbflag=1")>0 Then 
	gnbUse = true
End If 

'// 오늘의 특사 상품 접수
Dim baseDt: baseDt = date & " " & Num2Str(Hour(now),2,"0","R") & ":" & Num2Str(Minute(now),2,"0","R") & ":" & Num2Str(Second(now),2,"0","R")

'// 날짜별 원데이 상품 지정
Select Case left(baseDt,10)
	Case "2017-09-11": trgItem="949487"			'영국 무설탕 슈퍼잼 선물세트
	Case "2017-09-12": trgItem="1556834"		'MADVANILLA 바닐라라떼 선물세트 싱글
	Case "2017-09-13": trgItem="1285004"		'인테이크 닥터넛츠 오리지널뉴
	Case "2017-09-14": trgItem="1783983"		'제주감귤파이/제주차 이야기 선물세트
	Case "2017-09-15","2017-09-16","2017-09-17": trgItem="1549045"		'꿀,건,달 벌꿀 3종 미니 선물세트
	Case "2017-09-18": trgItem="1639500"		'인테이크 힘내 2종 선물세트+쇼핑백
	Case "2017-09-19": trgItem="1253348"		'마이빈스 더치커피- 더치한첩 40
	Case "2017-09-20": trgItem="52732"			'신 꽃피는 차 선물세트
	Case "2017-09-21": trgItem="1547074"		'힘내! 홍삼 젤리스틱
	Case "2017-09-22","2017-09-23","2017-09-24": trgItem="1781907"			'마이빈스 더치커피 - 추석 선물세트
	Case "2017-09-25": trgItem="1791664"		'해일 곶감 선물세트 1DAY 특가 모음전
	Case "2017-09-26": trgItem="1536908"		'힘내! 멀티비타민 오렌지 구미
	Case "2017-09-27": trgItem="1783924"		'MADVANILLA 바닐라라떼 선물세트 더블
	Case "2017-09-28","2017-09-29","2017-09-30": trgItem="1780969"		'정성견과 선물세트
	Case Else
		trgItem="0"
		baseDt=""
end Select

'// 메인 상품 목록
dim arrItem(3), arrTmp, strSort, i, j, arrTit(6,2)

'단독
arrItem(1) = "1780969,1780601,1515948,1780970,1780971,1780603,1515949,1780972,1544992"
'전통
arrItem(2) = "1253348,915264,1549045,1630836,1059384,1780974,1774051,1421169,1536908,1780965"
'신상
arrItem(3) = "1781962,1780978,1780968,1780976,1780975,1702197,1780977"

arrTit(0,1) = "today"
arrTit(0,2) = "오늘의 특가선물"
arrTit(1,1) = "only"
arrTit(1,2) = "텐바이텐 단독선물"
arrTit(2,1) = "best"
arrTit(2,2) = "베스트셀러"
arrTit(3,1) = "new"
arrTit(3,2) = "떠오르는 신상"
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
'arrItem(1) = "123125,123123"
'arrItem(2) = "456789,123127"
'arrItem(3) = "266397,123124"

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
%>
<style type="text/css">
.thanksgiving {background-color:#fcb280;}
.swiper {position:relative; padding-bottom:2.6rem; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bg_slide.jpg) no-repeat 0 0; background-size:100% auto; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.swiper .swiper-slide > a {display:block;}
.swiper .label {position:absolute; left:50%; top:0; z-index:20; width:26%; margin-left:16.7%; margin-top:4%; opacity:0; transition:all .5s .3s;}
.swiper .swiper-slide-active .label {margin-top:0; opacity:1;}
.swiper .thumbnail {position:relative; overflow:hidden; width:78%; margin:0 auto; border-radius:50%; border:0.9rem solid rgba(140,85,0,.2); background:transparent;}
.swiper .thumbnail img {border-radius:50%;}
.swiper .thumbnail .time {position:absolute; left:0; bottom:0; z-index:10; width:100%; padding:0.8rem 0 1rem; background:rgba(0,0,0,.65);}
.swiper .thumbnail .time span {display:inline-block; position:relative; padding-left:1.2rem; color:#f8eabf; font-size:1.2rem;}
.swiper .thumbnail .time span:before {content:''; display:inline-block; position:absolute; left:0; top:0; width:0.8rem; height:0.8rem; border:0.12rem solid #f8eabf; border-radius:50%;}
.swiper .thumbnail .time span:after {content:''; display:inline-block; position:absolute; left:0.35rem; top:0.3rem; width:0.2rem; height:0.25rem; border:0.1rem solid #f8eabf; border-top:0; border-right:0;}
.swiper .thumbnail .time em {display:block; padding-top:0.4rem; color:#fff; font-size:1.5rem;}
.swiper .name {overflow:hidden; width:78%; margin:0 auto; padding:1.9rem 0 0.8rem; color:#000; font-size:1.4rem; text-overflow:ellipsis; white-space:nowrap;}
.swiper .price {padding-bottom:1.2rem; letter-spacing:-0.08em;}
.swiper .price s {color:#7f5437; font-size:1.3rem; padding-right:0.4rem; vertical-align:middle;}
.swiper .price span {font-size:1.7rem; color:#000; vertical-align:middle;}
.swiper .price s + span {color:#d60000;}
.swiper button {position:absolute; top:26%; z-index:20; width:12.5%; background:transparent;}
.swiper button.btnPrev {left:0;}
.swiper button.btnNext {right:0;}
.swiper .pagination {position:absolute; left:0; bottom:0; z-index:20; width:100%; height:0.7rem; padding-top:0;}
.swiper .pagination span {width:0.7rem; height:0.7rem; margin:0 0.5rem; background:#e1742b; transition:all .4s;}
.swiper .pagination span.swiper-active-switch {width:2.2rem; background:#fff; border-radius:0.4rem;}
.bnr {overflow:hidden; padding:3.5rem 1.25% 1.8rem;}
.bnr li {float:left; width:50%; padding:0 1.12% 2.4%;}
</style>
<script type="text/javascript">
var nowDt;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var minus_second = 0;

$(function(){
	// 메인배너 스와이핑
	slideTemplate = new Swiper('.swiper .swiper-container',{
		loop:true,
		autoplay:3000,
		speed:700,
		pagination:".swiper .pagination",
		paginationClickable:true,
		nextButton:'.swiper .btnNext',
		prevButton:'.swiper .btnPrev'
	});

	<% if arrTgt(0,0)>0 then %>
	nowDt = new Date('<%=replace(baseDt,"-","/")%>');
	countdown();
	<% end if %>
});

// 오늘의 특가 타이머
function countdown(){
	var usrDt=new Date();	// 현재 브라우저 시간
	var vTerm = parseInt(usrDt.getTime()/1000)-parseInt(nowDt.getTime()/1000);	// 시작시 시간과의 차이(초)
	minus_second = vTerm;	// 증가시간에 차이 반영

	var cntDt = new Date(Date.parse(nowDt) + (1000*minus_second));	//서버시간에 변화값(1초) 증가
	var todayy=cntDt.getYear()

	if(todayy < 1000) todayy+=1900;
		
	var todaym=cntDt.getMonth();
	var todayd=cntDt.getDate();
	var todayh=cntDt.getHours();
	var todaymin=cntDt.getMinutes();
	var todaysec=cntDt.getSeconds();
	var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec;
	var futurestring=montharray[todaym]+" "+(todayd+1)+", "+todayy+" 00:00:00";

	dd=Date.parse(futurestring)-Date.parse(todaystring);
	dday=Math.floor(dd/(60*60*1000*24)*1);
	dhour=Math.floor((dd%(60*60*1000*24))/(60*60*1000)*1);
	dmin=Math.floor(((dd%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
	dsec=Math.floor((((dd%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

	//console.log(futurestring);

	if(dday < 0) {
		$("#countdown").html("00 : 00 : 00");
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
	
	setTimeout("countdown()",500);
}
</script>

<!-- 2017 추석기획전 -->
<div class="mEvt80295 thanksgiving">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/tit_thanksgiving.jpg" alt="내 손으로 직접 고르는 추석선물 가이드 추석세끼" /></h2>
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
						<p class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/txt_<%=arrTit(i,1)%>.png" alt="arrTit(i,2)"></p>
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
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/btn_buy.png" alt="구매하러 가기"></p>
					</a>
				</div>
			<%
					end if
				Next
			%>
			</div>
		</div>
		<div class="pagination"></div>
		<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/btn_prev.png" alt="이전" /></button>
		<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/btn_next.png" alt="다음" /></button>
	</div>
	<ul class="bnr">
		<% If gnbUse Then %>
		<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=80284'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_1.jpg" alt="효도/조카 선물" /></a></li>
		<% Else %>
		<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=80284"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_1.jpg" alt="효도/조카 선물" /></a></li>
		<% End If %>
		
		<% If gnbUse Then %>
		<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=80238'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_2.jpg" alt="손님맞이 상차림" /></a></li>
		<% Else %>
		<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=80238"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_2.jpg" alt="손님맞이 상차림" /></a></li>
		<% End If %>

		<% If gnbUse Then %>
		<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=80286'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_3.jpg" alt="센스있는 용돈봉투" /></a></li>
		<% Else %>
		<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=80286"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_3.jpg" alt="센스있는 용돈봉투" /></a></li>
		<% End If %>

		<% If gnbUse Then %>
		<li><a href="" onclick="fnAPPpopupBrowserURL('기획전','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=80289'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_4.jpg" alt="도란도란 다과상" /></a></li>
		<% Else %>
		<li><a href="<%=chkIIF(isapp="1","/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=80289"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/bnr_event_4.jpg" alt="도란도란 다과상" /></a></li>
		<% End If %>

	</ul>
	<div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80295/m/txt_comment.jpg" alt="COMMENT EVENT 이번 명절, 혼자 외롭게 보내야 하는 분들이 있으신가요? 코멘트를 남겨주신 13분을 추첨하여 텐바이텐이 정성껏 고른 선물을 드립니다." /></a></div>
</div>
<!--// 2017 추석기획전 -->