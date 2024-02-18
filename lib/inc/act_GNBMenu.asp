<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	'// GNB 메뉴 선언 (Name || Link || isNew)
	Dim arrGNB(), gnblp, GnbStrSqlData, sGnbNum
	Dim sCurrUrl, sCurrFile, sCurrPar, sCurrFUrl
	sCurrFile = right(sCurrUrl,len(sCurrUrl)-inStrRev(sCurrUrl,"/"))
	sCurrUrl = left(sCurrUrl,inStrRev(sCurrUrl,"/"))
	sCurrPar = Request.ServerVariables("QUERY_STRING")

	sCurrUrl = ReplaceRequestSpecialChar(request("CurrUrl"))
	sCurrFUrl = ReplaceRequestSpecialChar(request("CurrFUrl"))

	arrPush("투데이||/today/||0||fnAmplitudeEventMultiPropertiesAction('click_gnb_menu', 'menucode|menuname|index', 'today|투데이|1');||0")

	'GnbMenuData 가져오기
    Dim strSql, rsMem, arrEBList, intLoop, menuNameStringCount, intMenuNameLoop, tmpMenuName
	Dim gnbFrontIdx, gnbFrontMenuCode, gnbFrontMenuName, gnbFrontLinkUrl, gnbFrontUsingNewIcon, gnbFrontUsingAnimation, gnbFrontTabBar, gnbFrontSortNumber
	strSql = "db_sitemaster.dbo.usp_SCM_GnbMenu_GnbMenuFrontView_Get"
	set rsMem = getDBCacheSQL(dbget,rsget,"GnbGet",strSql,60*5)  ''5분
	if NOT (rsMem is Nothing) then 
    	IF Not (rsMem.EOF OR rsMem.BOF) THEN
    		arrEBList = rsMem.GetRows()
    	END IF
	    rsMem.close
	end if
	set rsMem = Nothing

    IF isArray(arrEBList) THEN
        '// 0 - idx, 1 - menuCode, 2 - menuName, 3 - linkUrl, 4 - usingNewIcon, 5 - usingAnimation, 6 - TabBar, 7 - sortnumber
        For intLoop =0 To UBound(arrEBList,2)
			gnbFrontIdx = arrEBList(0,intLoop)
			gnbFrontMenuCode = arrEBList(1,intLoop)
			gnbFrontMenuName = arrEBList(2,intLoop)
			gnbFrontLinkUrl = arrEBList(3,intLoop)
			gnbFrontUsingNewIcon = arrEBList(4,intLoop)
			gnbFrontUsingAnimation = arrEBList(5,intLoop)
			gnbFrontTabBar = arrEBList(6,intLoop)
			gnbFrontSortNumber = arrEBList(7,intLoop)
			If gnbFrontUsingAnimation > 0 Then
				tmpMenuName = ""
				For intMenuNameLoop = 1 To Len(Trim(gnbFrontMenuName))
					tmpMenuName = tmpMenuName & "<i>"& MID(Trim(gnbFrontMenuName), intMenuNameLoop, 1) &"</i>"
				Next
				gnbFrontMenuName = tmpMenuName
			End If
            If instr(lcase(gnbFrontLinkUrl),"gnbeventmain") > 0 Then
                gnbFrontLinkUrl  = "/subgnb"&gnbFrontLinkUrl&"&gnbflag=1"
            Else
                If instr(lcase(gnbFrontLinkUrl),"shoppingchance_allevent") > 0 Then
                    gnbFrontLinkUrl  = "/gnbevent"&gnbFrontLinkUrl
                End If
            End If
            If gnbFrontUsingNewIcon Then
                gnbFrontUsingNewIcon = 1
            Else
                gnbFrontUsingNewIcon = 0
            End If

			arrPush(gnbFrontMenuName&"||"&gnbFrontLinkUrl&"||"&gnbFrontUsingNewIcon&"||fnAmplitudeEventMultiPropertiesAction('click_gnb_menu', 'menucode|menuname|index', '"&gnbFrontMenuCode&"|"&arrEBList(2,intLoop)&"|"&gnbFrontSortNumber&"');||"&gnbFrontUsingAnimation)
        Next
    End If

	'// 요청에 따른 play 메뉴 맨 뒤로 이동 (2020-02-27)
	arrPush("스토리||/play/||0||fnAmplitudeEventMultiPropertiesAction('click_gnb_menu', 'menucode|menuname|index', 'play|PLAY|0');||0")
	IF application("Svr_Info") = "Dev" THEN
	    arrPush("링커||/linker/forum.asp?idx=1||0||fnAmplitudeEventMultiPropertiesAction('click_gnb_menu', 'menucode|menuname|index', 'linker|링커|0');||0")
	End If

	sGnbNum = -1
	IF sCurrUrl="/" then sGnbNum = 0
	for gnblp=0 to ubound(arrGNB)
		if inStr(sCurrFUrl,replace(split(arrGNB(gnblp),"||")(1),"&gnbflag=1",""))>0 then
			sGnbNum = gnblp
		end if
	Next

	'// 배열에 동적 데이터 추가
	Sub arrPush(dt)
		if Not isArray(arrGNB) then Exit Sub
		dim arrSz
		On Error Resume Next
			arrSz = ubound(arrGNB)
		ON Error Goto 0
		if arrSz="" then arrSz=-1
		
		if dt<>"" then
			reDim preserve arrGNB(arrSz+1)
			arrGNB(arrSz+1) = dt
		end if
	end Sub

	'// gnb animation addclass
	function gnbAddClass(animationCode)
		If animationCode > 0 Then
			gnbAddClass = " ani ani"&animationCode&" "
		Else
			gnbAddClass = ""
		End If
	end function
%>
<div id="navGnb" class="nav-gnb">
	<nav class="swiper-container">
		<ul class="swiper-wrapper">
			<%
				'// GNB 출력
				dim gnbDtl, gnbRst
				for gnblp=0 to ubound(arrGNB)
					gnbDtl = split(arrGNB(gnblp),"||")
					gnbRst = "<li class=""swiper-slide"">"
					gnbRst = gnbRst & "<a href=""" & wwwUrl & chkIIF(gnbDtl(1)="/today/","/",gnbDtl(1)) & """"
					gnbRst = gnbRst & " class="""& gnbAddClass(gnbDtl(4)) & chkiif(inStr(sCurrFUrl,replace(gnbDtl(1),"&gnbflag=1",""))>0 or (gnbDtl(1)="/today/" and sCurrUrl="/"),"on","")&" """
					gnbRst = gnbRst & "onclick="""&gnbDtl(3)&""">" & gnbDtl(0)
					if gnbDtl(2) then
						gnbRst = gnbRst & " <span class=""badge new"">new</span>"
					end if
					gnbRst = gnbRst & "</a></li>"
					Response.Write gnbRst
				next
			%>
		</ul>
	</nav>
</div>
<script type="text/javascript">
$(function(){
	//Nav(GNB)
	var chkTch=false, chkIdx;
	var navSwiper = new Swiper('#navGnb .swiper-container', {
		slidesPerView: 'auto',
		<% if sGnbNum >= 2 then %>
			initialSlide:<%=sGnbNum%>,
		<% end if %>
		onTap:function(gns){
			var vLnk = $(gns.slides[gns.clickedIndex]).find("span").attr("link");
			if(!(vLnk==""||!vLnk)) {
				top.location.href=vLnk;
			}
		}
	});
});

</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->