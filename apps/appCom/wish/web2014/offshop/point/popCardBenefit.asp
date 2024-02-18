<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_mileage_logcls.asp" -->
<%

dim userid, yyyymmdd
userid = getEncLoginUserID()
yyyymmdd = requestCheckvar(request("yyyymmdd"),10)

if (yyyymmdd="") then
    yyyymmdd=Left(now(),4) & "-12-31"
   yyyymmdd = "2019-12-31"
end if


''현재 마일리지
dim myMileage
set myMileage = new TenPoint
myMileage.FRectUserID = userid
if (userid<>"") then
    myMileage.getTotalMileage
end if


''만료예정 마일리지 년도별 리스트
dim myMileageLog
set myMileageLog = New CMileageLog
myMileageLog.FPageSize=1000
myMileageLog.FCurrPage= 1
myMileageLog.FRectUserid = userid
myMileageLog.FRectMileageLogType = "X"

if (userid<>"") then
	myMileageLog.getMileageLog
end if


''만료예정  마일리지 합계
dim oExpireMileTotal
set oExpireMileTotal = new CMileageLog
oExpireMileTotal.FRectUserid = userid
oExpireMileTotal.FRectExpireDate = yyyymmdd
if (userid<>"") then
    oExpireMileTotal.getNextExpireMileageSum
end if

dim i
dim Tot_GainMileage, Tot_YearMaySpendMileage, Tot_YearMayRemainMileage, Tot_realExpiredMileage
%>
</head>
<script type="text/javascript">
$(function(){
    $(".own-history ul").hide();
    $(".own-history > p").click(function(){
        $( ".own-history ul" ).slideToggle();
        $( ".own-history" ).toggleClass("on");
	});
	if($(".own-history ul li").length == 0) $(".own-history").css("display","none")
});
</script>
<body class="default-font body-popup">
		<!-- contents -->
		<div id="content" class="content mileage-guide">
			<h2>살 때 마다 쌓이는<br/><em>텐바이텐<br/>멤버십 마일리지</em></h2>
			<div class="guide guide1">
				<h3>적립 방법</h3>
				<p class="ftLt">
					<span class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2019/my10x10/img_card.png" alt=""></span>
					<span class="txt">
						<em>온라인 구매 시</em><br/>등급별,<br/>구매 금액의 최대<br/>
						<b><strong>~1.3%</strong>적립</b><br/>
						<span>등급별 적립율</span>
					</span>					
					<a href="" onclick="fnAPPpopupBrowserURL('등급별 혜택','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/userinfo/grade_guide.asp');return false;"></a>																							   
				</p>
				<p class="ftRt">
					<span class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2019/my10x10/img_shoppingbag.png" alt=""></span>
					<span class="txt">
						<em>매장 구매 시</em><br/>구매금액의 최대<br/>
						<b><strong>~3%</strong>적립</b>
					</span>
				</p>
			</div>
			<div class="guide guide2">
				<h3>사용 방법</h3>
				<p class="ftLt">
					<span class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2019/my10x10/img_card_2.png" alt=""></span>
					<span class="txt">
						온라인 구매 시<br/><em>현금처럼 사용</em><br/>
						<span><em>상품 30,000원 이상 구매 시</em><br/>사용 가능</span>
					</span>
				</p>
				<p class="ftRt">
					<span class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2019/my10x10/img_shoppingbag_2.png" alt=""></span>
					<span class="txt">
						매장 구매 시<br/><em>현금처럼 사용</em><br/>
						<span><em>3,000P 이상 적립 시</em><br/>사용 가능</span>
					</span>
				</p>
			</div>
			<div class="noti">
				<h3>알아두기</h3>
				<ul>
					<li>쿠폰 사용 및 세일 기간, 특정 상품 구매 등 여러 특수한 상황에 따라 마일리지 적립/사용이 제한될 수 있습니다.</li>
					<li>마일리지의 수명(사용기한)은 5년입니다.</li>
					<li>5년 후, 사용되지 않아 수명을 다한 마일리지는 천천히 소멸됩니다.</li>
				</ul>
			</div>
		<%
		if IsUserLoginOK() then
			if oExpireMileTotal.FOneItem.getMayExpireTotal <> 0 then
		%>			
			<div class="expired-mileage">
				<p><span><%=getLoginUserName%></span>님 <%=Left(oExpireMileTotal.FOneItem.Fexpiredate, 4)%>년 소멸 예정 마일리지</p>
				<span><%= FormatNumber(oExpireMileTotal.FOneItem.getMayExpireTotal,0) %>P</span>
			</div>
		<%
			end if
		end if	
		%>				
	<%
	if (myMileageLog.FresultCount > 0) then
	%>									
			<div class="own-history fold">
				<p>최근 3년간 소멸된 마일리지</p>
				<ul>	
		<%
			for i = 0 to myMileageLog.FResultCount - 1				
				if Cdate(FormatDateTime(myMileageLog.FItemList(i).FRegdate, 2)) > Cdate(dateadd("yyyy", -3, date)) then		
		%>			
					<li>
						<span class="date">
							<span class="day"><%= Replace(Left(myMileageLog.FItemList(i).FRegdate,10), "-", ".") %></span>
						</span>
						<span class="desc">
							<em><%= myMileageLog.FItemList(i).Fjukyo %></em>
							<span class="point"><%= FormatNumber(myMileageLog.FItemList(i).Fmileage,0) %>P</span>
						</span>
					</li>
		<%	
				end if
			next
		%>			
	<%	
	end if	
	%>					
				</ul>
			</div>
		</div>			
		<!-- //contents -->
</body>
</html>
<%

set myMileage = Nothing
set oExpireMileTotal = Nothing

%>