<!-- #include virtual="/chtml/main/loader/banner/inc_banner_assets.asp" -->	
<%
'#######################################################
' Discription : pc_event_top_banner // cache DB경유
' History : 2019-02-18 원승현 생성
'#######################################################
Dim baIntI
Dim baSqlStr , baRsMem , baArrList, baPoscode
Dim baGaParam : baGaParam = "gaparam=event_top_banner" '//GA 체크 변수

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim baCTime , baDummyName
If timer > 10 And Cint(timer/60) < 6 Then
	baCTime = 60*1
	baDummyName = "MBETBAN_"&Cint(timer/60)
Else
	baCTime = 60*1
	baDummyName = "MBETBAN_"
End If

If IsUserLoginOK Then
    baPoscode = "734"
Else
    baPoscode = "735"
End If

baSqlStr = " SELECT idx " & vbcrlf
baSqlStr = baSqlStr & "	, poscode, linktype, fixtype " & vbcrlf
baSqlStr = baSqlStr & "	, posVarname, imageurl, linkurl " & vbcrlf
baSqlStr = baSqlStr & "	, imagewidth, imageheight, startdate " & vbcrlf
baSqlStr = baSqlStr & "	, enddate, regdate, reguserid " & vbcrlf
baSqlStr = baSqlStr & "	, isusing, orderidx, linkText " & vbcrlf
baSqlStr = baSqlStr & "	, itemDesc, workeruserid, imageurl2 " & vbcrlf
baSqlStr = baSqlStr & "	, linkText2, linkText3, linkText4 " & vbcrlf
baSqlStr = baSqlStr & "	, altname, lastupdate, bgcode " & vbcrlf
baSqlStr = baSqlStr & "	, xbtncolor, maincopy, maincopy2 " & vbcrlf
baSqlStr = baSqlStr & "	, subcopy, etctag, etctext " & vbcrlf
baSqlStr = baSqlStr & "	, ecode, bannertype, altname2 " & vbcrlf
baSqlStr = baSqlStr & "	, bgcode2, linkurl2, evt_code " & vbcrlf
baSqlStr = baSqlStr & "	, tag_only, targetOS, targetType " & vbcrlf
baSqlStr = baSqlStr & "	, imageurl3, altname3, linkurl3 " & vbcrlf
baSqlStr = baSqlStr & "	, categoryOptions " & vbcrlf
baSqlStr = baSqlStr & "	, couponidx " & vbcrlf
baSqlStr = baSqlStr & " FROM db_sitemaster.dbo.tbl_main_contents " & vbcrlf
baSqlStr = baSqlStr & " WHERE poscode='"&baPoscode&"' " & vbcrlf
baSqlStr = baSqlStr & "	    AND getdate() >= startdate AND getdate() <= enddate " & vbcrlf
baSqlStr = baSqlStr & "	    AND isusing='Y' " & vbcrlf
baSqlStr = baSqlStr & " ORDER BY orderidx ASC, idx DESC "

set baRsMem = getDBCacheSQL(dbget, rsget, "MAINEVTTOPBANM", baSqlStr, baCTime)
IF Not (baRsMem.EOF OR baRsMem.BOF) THEN
    baArrList = baRsMem.GetRows
END IF
baRsMem.close

on Error Resume Next
Dim baidx, balinktype, bafixtype, baposVarname, baimageurl, baimagewidth, baimageheight, bastartdate, baenddate, baregdate, bareguserid, baisusing, baorderidx, balinkText, balinkurl, layerId
Dim baitemDesc, baworkeruserid, baimageurl2, balinkText2, balinkText3, balinkText4, baaltname, balastupdate, babgcode, baxbtncolor, bamaincopy, bamaincopy2, basubcopy, baetctag, baetctext
Dim baecode, babannertype, baaltname2, babgcode2, balinkurl2, baevt_code, batag_only, batargetOS, batargetType, baimageurl3, baaltname3, balinkurl3, bacategoryOptions
Dim cateCheckBaIdx, allCheckBaIdx, checkBaIdx, baCouponIdx, couponInfo, couponVal, couponMin, checkCouponIssue
checkBaIdx = ""
cateCheckBaIdx = ""
allCheckBaIdx = ""
checkCouponIssue = False

If IsArray(baArrList) Then
    If (request.Cookies("evtPrdLowBannerMA") <> "done" or request.Cookies("evtPrdLowBannerMA")="") Then
        '// 카테고리에 맞는 이벤트 배너가 있는지 확인
        If vDisp <> "" Then
            For baIntI = 0 To ubound(baArrList,2)
                If instr(baArrList(43, baIntI),left(vDisp, 3))>0 Then
                    cateCheckBaIdx = baArrList(0, baIntI)
                    Exit For
                End If
            Next
        End If

        '// 전체로 등록된 이벤트가 있는지 확인
        If checkBaIdx = "" Then
            For baIntI = 0 To ubound(baArrList,2)
                If baArrList(43, baIntI) = "" Then
                    allCheckBaIdx = baArrList(0, baIntI)
                    Exit For
                End If
            Next
        End If

        '// 둘다 있을경우 가장 상위값 불러옴
        If cateCheckBaIdx<>"" And allCheckBaIdx<>"" THen
            checkBaIdx = baArrList(0, 0)
        Else
            If cateCheckBaIdx <> "" Then
                checkBaIdx = cateCheckBaIdx
            End If

            If allCheckBaIdx <> "" Then
                checkBaIdx = allCheckBaIdx
            End If
        End If

        For baIntI = 0 To ubound(baArrList,2)
            baidx             = baArrList(0, baIntI)  '// 고유값
            baposcode         = baArrList(1, baIntI)  '// 배너코드
            balinktype        = baArrList(2, baIntI)  '// 링크구분
            bafixtype         = baArrList(3, baIntI)  '// 적용구분
            baposVarname      = baArrList(4, baIntI)  '// 배너변수명
            baimageurl        = baArrList(5, baIntI)  '// 이미지1url
            balinkurl         = baArrList(6, baIntI)  '// 이미지1linkurl
            baimagewidth      = baArrList(7, baIntI)  '// 이미지 가로사이즈
            baimageheight     = baArrList(8, baIntI)  '// 이미지 세로사이즈
            bastartdate       = baArrList(9, baIntI)  '// 시작일
            baenddate         = baArrList(10, baIntI) '// 종료일
            baregdate         = baArrList(11, baIntI) '// 등록일
            bareguserid       = baArrList(12, baIntI) '// 등록자아이디
            baisusing         = baArrList(13, baIntI) '// 사용여부
            baorderidx        = baArrList(14, baIntI) '// 정렬순서
            balinkText        = baArrList(15, baIntI) '// 링크텍스트1
            baitemDesc        = baArrList(16, baIntI) '// 작업요청사항
            baworkeruserid    = baArrList(17, baIntI) '// 최종작업자
            baimageurl2       = baArrList(18, baIntI) '// 이미지2url
            balinkText2       = baArrList(19, baIntI) '// 링크텍스트2
            balinkText3       = baArrList(20, baIntI) '// 링크텍스트3
            balinkText4       = baArrList(21, baIntI) '// 링크텍스트4
            baaltname         = baArrList(22, baIntI) '// 알트명1
            balastupdate      = baArrList(23, baIntI) '// 최종수정일
            babgcode          = baArrList(24, baIntI) '// 배경색상코드
            baxbtncolor       = baArrList(25, baIntI) '// 폰트컬러
            bamaincopy        = baArrList(26, baIntI) '// 메인카피
            bamaincopy2       = baArrList(27, baIntI) '// 메인카피2
            basubcopy         = baArrList(28, baIntI) '// 서브카피
            baetctag          = baArrList(29, baIntI) '// 태그
            baetctext         = baArrList(30, baIntI) '// 기타 텍스트(검색상단마케팅에선 키워드로 사용)
            baecode           = baArrList(31, baIntI) '// 컬쳐스테이션이벤트id
            babannertype      = baArrList(32, baIntI) '// 배너타입(갯수)
            baaltname2        = baArrList(33, baIntI) '// 알트명2
            babgcode2         = baArrList(34, baIntI) '// 배경색상코드2
            balinkurl2        = baArrList(35, baIntI) '// 이미지2linkurl2
            baevt_code        = baArrList(36, baIntI) '// 이벤트 코드
            batag_only        = baArrList(37, baIntI) '// 태그여부
            batargetOS        = baArrList(38, baIntI) '// 노출할 플랫폼
            batargetType      = baArrList(39, baIntI) '// 노출할 유저타겟
            baimageurl3       = baArrList(40, baIntI) '// 이미지3url
            baaltname3        = baArrList(41, baIntI) '// 알트명3
            balinkurl3        = baArrList(42, baIntI) '// 링크url3
            bacategoryOptions = baArrList(43, baIntI) '// 카테고리 코드(","구분자로 여러개의 카테고리 1뎁스 코드가 들어가 있음)
            baCouponIdx = baArrList(44, baIntI) '// 쿠폰 
            layerId			= "lyrCoupon" & baidx

            If checkBaIdx = baidx Then
                Exit For
            Else
                balinkurl = ""
                baimageurl = ""
            End If
        Next

        '// link에 파라미터 있는지 체크
        If instr(balinkurl, "?")>0 Then
            balinkurl = db2Html(balinkurl) & "&" &bagaParam & "1"
        Else
            balinkurl = db2Html(balinkurl) & "?" &bagaParam & "1"
        End If

        '// 배너타입이 쿠폰발급 일 경우 해당 쿠폰을 받은 사용자는 배너 노출을 시키지 않는다.
        If babannertype = "2" And IsUserLoginOK Then
            Dim monthAppCouponCode
            IF application("Svr_Info") = "Dev" THEN
                monthAppCouponCode = "2949"
            Else
                monthAppCouponCode = "1190"
            End If
            baSqlStr = " SELECT * FROM db_user.dbo.tbl_user_coupon WITH(NOLOCK) "
            baSqlStr = baSqlStr & " WHERE userid='"&getEncLoginUserId&"' "
            baSqlStr = baSqlStr & " AND masteridx = '"&baCouponIdx&"' "
            baSqlStr = baSqlStr & " AND masteridx <> 0 "
            If trim(baCouponIdx) = monthAppCouponCode Then '// 월별 앱쿠폰일경우만 조건 실행
                baSqlStr = baSqlStr & " AND GETDATE() BETWEEN startdate AND expiredate  "
            End If
            rsget.Open baSqlStr, dbget, adOpenForwardOnly, adLockReadOnly
            If not(rsget.bof) Then
                checkCouponIssue = True
            End If
            rsget.close
        End If
    %>
        <% If instr(balinkurl, ecode) < 1 Then '// 동일 이벤트 일 경우는 표시하지 않음 %>
            <% If balinkurl <> "" And baimageurl <> "" Then %>
                <% If Not(checkCouponIssue) Then '// 쿠폰 이벤트일 경우 쿠폰을 발급 받았으면 표시하지 않음%>
                    <script>
                        function setPopupCookie( name, value, expiredays ) {
                            var todayDate = new Date();
                            todayDate = new Date(parseInt(todayDate.getTime() / 86400000) * 86400000 + 54000000);
                            if (todayDate > new Date() ) {
                                expiredays = expiredays - 1;
                            }
                            todayDate.setDate( todayDate.getDate() + expiredays );
                            document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
                        }
                        function bannerCloseToSevenDay(){	//오늘 하루 보지 않기
                            setPopupCookie("evtPrdLowBannerMA", "done", 1)
                            <% ' 18주년 세일 기간 동안 하단 배너 클래스 변경
                            'If date() > "2019-09-30" AND date() < "2019-11-01" Then 
                            '2019-11-13 이후로 18주년 배너와 동일하게 사이즈 및 에니메이션 변경. 혹시 다시 되돌릴 수 있어서 Else 구문 남겨둠. (JIRA : MKTEVTPJT1-337)
                            If date() > "2019-11-12" Then 
                            %>
                                $(".bnr-anniv18").hide();
                            <% Else %>
                                $(".bnr-evtV19").hide();
                            <% End If %>
                        }
                    </script>
                    <%'2019-11-13 이후로 18주년 배너와 동일하게 사이즈 및 에니메이션 변경. 변경 전 class: 'bnr-evtV19 evt-toast2' (JIRA : MKTEVTPJT1-337)%>
                        <div class="bnr-anniv18">
                            <a href="javascript:handleClicKBanner('<%=isapp%>','<%=balinkurl%>', '<%=babannertype%>', '<%=baCouponIdx%>', '<%=layerId%>', 'click_eventtop_banner')">
                                <img src="<%=staticImgUrl & "/main/"&baimageurl%>" alt="<%=baaltname%>">
                            </a>
                            <button class="btn-close" onclick="bannerCloseToSevenDay();"><img src="//fiximage.10x10.co.kr/m/2019/temp/btn_close.png" alt="오늘 하루 보지 않기"></button>				
                        </div>
                        <div class="lyr-coupon" id="<%=layerId%>">
                            <div class="inner">
                                <h2><%=bamaincopy%></h2>
                                <button type="button" class="btn-close btn-close1">닫기</button>
                                <%
                                    if babannertype = "2" then
                                    couponInfo = getCouponInfo(baCouponIdx)
                                        if IsArray(couponInfo) then
                                            for i=0 to ubound(couponInfo,2)
                                                couponVal = formatNumber(couponInfo(1, i), 0)
                                                couponMin = formatNumber(couponInfo(3, i), 0)
                                            next
                                %>						
                                <div class="cpn">
                                    <img src="//fiximage.10x10.co.kr/m/2019/common/bg_cpn.png" alt="">
                                    <p class="amt"><b><%=couponVal%></b>원</p>
                                    <% if couponMin <> "0" and couponMin <> "" then%><p class="txt1"><b><%=couponMin%></b>원 이상 구매 시 사용 가능</p><% end if %>
                                </div>
                                <% 
                                        end if
                                    end if 
                                %>
                                <p class="txt2"><%=bamaincopy2%></p>
                                <div class="btn-area">
                                    <button type="button" class="btn-close btn-close2">닫기</button>
                                    <% if baetctag = "1" then %><button type="button" onclick="handleClickBtn('<%=balinkurl2%>');" class="btn-down"><%=basubcopy%></button><% end if %>
                                </div>
                            </div>
                        </div>
                <% End If %>					                    
            <% End If %>
        <% End If %>
    <% End If %>
<% End If %>
<% on Error Goto 0 %>