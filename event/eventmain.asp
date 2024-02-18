<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%'쇼핑찬스 이벤트 내용보기
dim eCode : eCode   = requestCheckVar(Request("eventid"),10) '이벤트 코드번호
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG , intT
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate, bimg, eItemListType, eOnlyName
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply, edispcate
dim etemplate_mo, emimg , emimg_mo , eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL
dim itemid : itemid = ""
Dim evtFile_mo,  evtFileyn_mo
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt, isMyFavEvent, clsEvt, vDateView
Dim j
Dim arrTopGroup , sgroup_m '//그룹 랜덤
Dim cEventadd , slide_m_flag '//슬라이드 사용 미사용
Dim ThemeColorCode, ThemeBarColorCode, endlessView, videoFullLink
Dim comm_isusing, comm_text, freebie_img, comm_start, comm_end, gift_isusing, gift_text1, gift_img1, gift_text2, gift_img2
Dim gift_text3, gift_img3, usinginfo, using_text1, using_contents1, using_text2, using_contents2, using_text3, using_contents3
Dim mdthememo, themecolormo, textbgcolormo, mdbntypemo, salePer, saleCPer, SocName_Kor, evt_type, title_mo, eventtype_mo
dim eval_isusing, eval_text, eval_freebie_img, eval_start, eval_end
Dim board_isusing, board_text, board_freebie_img, board_start, board_end
Dim etc_itemid, arrGiftBox, isNew, isOnePlusOne, isOnlyTen, evt_html, contentsAlign, saleTxt, CopyHide, topSlideCheck

'//logparam
Dim logparam : logparam = "&pEtr="&eCode
Dim searchback_Param : searchback_Param = requestCheckVar(request("pNtr"),20)
Dim addparam
If searchback_Param <> "" Then
    addparam = "&pNtr="& server.URLEncode(searchback_Param)
End If

'//2015이벤트
Dim evt_bannerimg_mo , evt_mo_listbanner , evt_html_mo , vIsweb , vIsmobile , vIsapp , evt_subname , blnbookingsell
Dim arrTextTitle
Dim arrAddbanner , evt_m_addimg_cnt , intAi '이미지 추가
Dim gaparamChkVal, gaparamStr
    gaparamChkVal = requestCheckVar(request("gaparam"),30)
    if gaparamChkVal <> "" then
        gaparamStr      = "&gaparam=" & gaparamChkVal
    end if
Dim upin '카카오 이벤트 key값 parameter
    upin = requestCheckVar(Request("upin"),200)

Dim vScope '// 별에서 온 운세 값(58021)
    vScope = requestCheckVar(Request("vScope"),200)

IF eCode = "" THEN
    'response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
    Call Alert_Return("이벤트번호가 없습니다.")
    dbget.close()   :   response.End
elseif Not(isNumeric(eCode)) then
    Call Alert_Return("잘못된 이벤트번호입니다.")
    dbget.close()   :   response.End
ElseIf eCode = "75209" THEN     '2016-12-27 10:46 김진영 수정 / 사은품 품절로 다른 이벤트로 리다이렉트
    response.redirect("/event/eventmain.asp?eventid=75249")
    dbget.close()   :   response.End
ElseIf eCode = "77547" THEN     '2017-04-17 이종화 수정 // 브랜드 위크 리스트로 리다이렉트
    response.redirect("/shoppingtoday/shoppingchance_allevent.asp?scTgb=bw")
    dbget.close()   :   response.End
ElseIf eCode = "85159" THEN     '2018-03-30 정태훈 수정 // 웨딩 이벤트의 경우 웨딩 메인으로 보낸다
    response.redirect("/wedding/")
    dbget.close()   :   response.End
END IF

'// pc일경우 m -> pc 리다이렉트
Dim redirect_url : redirect_url = fnRedirectToPc()
If redirect_url <> "" Then
    dbget.close()
    Response.redirect redirect_url & "/event/eventmain.asp?eventid=" & eCode
    Response.end
End If

egCode = requestCheckVar(Request("eGC"),10) '이벤트 그룹코드
IF egCode = "" THEN egCode = 0

    itemlimitcnt = 105  '상품최대갯수
    '이벤트 개요 가져오기
    set cEvent = new ClsEvtCont
        cEvent.FECode = eCode

        cEvent.fnGetEvent

        eCode       = cEvent.FECode
        ekind       = cEvent.FEKind
        emanager    = cEvent.FEManager
        escope      = cEvent.FEScope
        eName       = cEvent.FEName
        esdate      = cEvent.FESDate
        eedate      = cEvent.FEEDate
        estate      = cEvent.FEState
        eregdate    = cEvent.FERegdate
        epdate      = cEvent.FEPDate
        ecategory   = cEvent.FECategory
        ecateMid    = cEvent.FECateMid
        blnsale     = cEvent.FSale
        blngift     = cEvent.FGift
        blncoupon   = cEvent.FCoupon
        blncomment  = cEvent.FComment
        blnbbs      = cEvent.FBBS
        blnitemps   = cEvent.FItemeps
        blnapply    = cEvent.FApply
		isOnlyTen	= cEvent.FisOnlyTen
		isOnePlusOne	= cEvent.FisOnePlusOne
		isNew	= cEvent.FisNew
        etemplate_mo= cEvent.FTemplate_mo
        emimg       = cEvent.FEMimg
        emimg_mo    = cEvent.FEMimg_mo
        eitemsort   = cEvent.FItemsort
        ebrand      = cEvent.FBrand
        gimg        = cEvent.FGimg
        blnFull     = cEvent.FFullYN
        blnItemifno = cEvent.FIteminfoYN
        blnitempriceyn = cEvent.FItempriceYN
        LinkEvtCode = cEvent.FLinkEvtCode
        blnBlogURL  = cEvent.FblnBlogURL
        edispcate   = cEvent.FEDispCate
        eItemListType = cEvent.FEItemListType
        evtFileyn_mo    = cEvent.FevtFileyn_mo
        evtFile_mo      = cEvent.FevtFile_mo
        SocName_Kor = cEvent.FSocName_Kor

        vDateView           = cEvent.FDateViewYN
        '//2015추가
        evt_mo_listbanner   = cEvent.FEmolistbanner
        evt_html_mo         = cEvent.Fevt_html_mo
        vIsweb              = cEvent.Fisweb
        vIsmobile           = cEvent.Fismobile
        vIsapp              = cEvent.Fisapp
        evt_subname         = cEvent.Fevt_subname
        blnbookingsell      = cEvent.Fisbookingsell
        evt_bannerimg_mo    = cEvent.Fevt_bannerimg_mo

        sgroup_m            =   cEvent.FEsgroup_m '//그룹형 랜덤 플레그

        slide_m_flag        =   cEvent.FESlide_M_Flag '// 슬라이드 모바일 플레그
        evt_m_addimg_cnt    =   cEvent.FEvt_m_addimg_cnt '// 이벤트 추가 이미지 카운트

        mdthememo = cEvent.Fmdthememo
        themecolormo = cEvent.Fthemecolormo
        textbgcolormo = cEvent.Ftextbgcolormo
        mdbntypemo = cEvent.Fmdbntypemo
        comm_isusing = cEvent.Fcomm_isusing
        comm_text = cEvent.Fcomm_text
        freebie_img = cEvent.Ffreebie_img
        comm_start = cEvent.Fcomm_start
        comm_end = cEvent.Fcomm_end
        gift_isusing = cEvent.Fgift_isusing
        gift_text1 = cEvent.Fgift_text1
        gift_img1 = cEvent.Fgift_img1
        gift_text2 = cEvent.Fgift_text2
        gift_img2 = cEvent.Fgift_img2
        gift_text3 = cEvent.Fgift_text3
        gift_img3 = cEvent.Fgift_img3
        usinginfo = cEvent.Fusinginfo
        using_text1 = cEvent.Fusing_text1
        using_contents1 = cEvent.Fusing_contents1
        using_text2 = cEvent.Fusing_text2
        using_contents2 = cEvent.Fusing_contents2
        using_text3 = cEvent.Fusing_text3
        using_contents3 = cEvent.Fusing_contents3
        salePer = cEvent.FsalePer
        saleCPer = cEvent.FsaleCPer
        evt_type = cEvent.fnEventTypeName
        title_mo = cEvent.Ftitle_mo
        endlessView = cEvent.FendlessView
        eventtype_mo = cEvent.Feventtype_mo
        videoFullLink = cEvent.FvideoFullLink
        eval_isusing = cEvent.Feval_isusing
        eval_text = cEvent.Feval_text
        eval_freebie_img = cEvent.Feval_freebie_img
        eval_start = cEvent.Feval_start
        eval_end = cEvent.Feval_end
        evt_html= cEvent.FEHtml
        contentsAlign= cEvent.FcontentsAlign
        CopyHide= cEvent.FCopyHide

        board_isusing = cEvent.Fboard_isusing
        board_text = cEvent.Fboard_text
        board_freebie_img = cEvent.Fboard_freebie_img
        board_start = cEvent.Fboard_start
        board_end = cEvent.Fboard_end
        '// 대표 상품 코드 
        etc_itemid = cEvent.FEItemID

        If blnsale Or blncoupon Then
            If blnsale Then
                saleTxt = salePer
            end if
            If blncoupon and saleTxt="" Then
                saleTxt = saleCPer
            end if
        end if
        '수작업 할인율 적용 추가 - 정태훈 2020.02.03
        if saleTxt <> "" and evt_html_mo<>"" then
            evt_html_mo = replace(evt_html_mo,"#[SALEPERCENT]",saleTxt)
        end if

        If Not(cEvent.FEItemImg="" or isNull(cEvent.FEItemImg)) then
            bimg        = cEvent.FEItemImg
        ElseIf cEvent.FEItemID<>"0" Then
            If cEvent.Fbasicimg600 <> "" Then
                bimg        = "http://webimage.10x10.co.kr/image/basic600/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg600 & ""
            Else
                bimg        = "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg & ""
            End IF
        Else
            bimg        = ""
        End IF

        'PC, 모바일 타입 분리 체크 2017.12.12 정태훈
        If evt_type="90" Then
            If eventtype_mo="80" Then
                etemplate_mo="9"
            End If
        End If
        
        if evt_type="multi3" then '멀티3
            etemplate_mo = "10"
        end if

        '그룹형(etemplate_mo = "3")일때만 그룹내용 가져오기
        IF etemplate_mo = "3" OR etemplate_mo = "9" OR etemplate_mo = "11" OR etemplate_mo = "6" Then
            If sgroup_m And egCode = "0" Then '// 그룹형 랜덤 체크 되었을때
                arrTopGroup = cEvent.fnGetEventGroupTop
                egCode = arrTopGroup(0,0)
            End If
        cEvent.FEGCode =    egCode
        arrGroup =  cEvent.fnGetEventGroup_mo
        END If
        ThemeColorCode=cEvent.fnEventColorCode
		'if etemplate_mo="11" OR etemplate_mo = "6" then
			ThemeBarColorCode=cEvent.fnEventThemeColorCode
		'else
		'	ThemeBarColorCode=cEvent.fnEventBarColorCode
		'end if
        '//2015추가 코멘트(테스터) or 상품후기 or 사은품 or 예약판매 체크가 되어 있을때만 가저오기
        If blncomment Or blnitemps Or blngift Or blnbookingsell Then
            cEvent.FEGCode  =   egCode
            arrTextTitle    =   cEvent.fnGetEventTextTitle
        End If

        cEvent.FECategory  = ecategory
        'arrRecent = cEvent.fnGetRecentEvt

        '// 모바일 전용 추가 이미지
        '#######################################################################################
        If evt_m_addimg_cnt > 0 Then
            arrAddbanner    =   cEvent.fnGetMoAddimg
        End If

        If isArray(arrAddbanner) Then '//이미지들 있음
            Dim tArea , mArea , bArea
            For intAi = 0 To UBound(arrAddbanner,2)
                If arrAddbanner(1,intAi) <> "" Then
                    If arrAddbanner(0,intAi) = "1" And (CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
                        tArea = tArea & "<a href='"& chkiif(arrAddbanner(3,intAi) <> "" And InStr("#",arrAddbanner(3,intAi)) < 0,arrAddbanner(3,intAi) & gaparamchk(arrAddbanner(3,intAi),"&pEtr="&eCode),arrAddbanner(3,intAi)) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
                    ElseIf arrAddbanner(0,intAi) = "2" And (CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
                        mArea = mArea & "<a href='"& chkiif(arrAddbanner(3,intAi) <> "" And InStr("#",arrAddbanner(3,intAi)) < 0,arrAddbanner(3,intAi) & gaparamchk(arrAddbanner(3,intAi),"&pEtr="&eCode),arrAddbanner(3,intAi)) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
                    ElseIf arrAddbanner(0,intAi) = "3" And (CStr(Date()) >= CStr(arrAddbanner(4,intAi)) and CStr(Date()) <= CStr(arrAddbanner(5,intAi))) Then
                        bArea = bArea & "<a href='"& chkiif(arrAddbanner(3,intAi) <> "" And InStr("#",arrAddbanner(3,intAi)) < 0,arrAddbanner(3,intAi) & gaparamchk(arrAddbanner(3,intAi),"&pEtr="&eCode),arrAddbanner(3,intAi)) &"'><img src='"& arrAddbanner(1,intAi) &"' alt='"& arrAddbanner(2,intAi) &"'></a>"
                    End If
                End If
            Next
        End If
        '#######################################################################################

        '#######################################################################################
        '// 기프트박스 가져오기
        '#######################################################################################
        arrGiftBox = cEvent.fnGetGiftBox
        Dim newGiftBox
        If gift_isusing>0 Then '//이미지들 있음
            newGiftBox="        <div class='gift-eventV19'>" & vbcrlf
            newGiftBox=newGiftBox+"         <ul>" & vbcrlf
            
            newGiftBox=newGiftBox+"             <li>" & vbcrlf
            newGiftBox=newGiftBox+"                 <div class='box'>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='desc'>" & vbcrlf
			If gift_isusing>1 Then
			newGiftBox=newGiftBox+"							<p class='tit' style='color:" + ThemeBarColorCode + ";'>GIFT1</p>" & vbcrlf
			else
			newGiftBox=newGiftBox+"							<p class='tit' style='color:" + ThemeBarColorCode + ";'>GIFT</p>" & vbcrlf
			end if
            newGiftBox=newGiftBox+"                         <p class='txt'>" + gift_text1 + "</p>" & vbcrlf
            newGiftBox=newGiftBox+"                     </div>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='thumb' style='background-image:url(" + gift_img1 + ")'></div>" & vbcrlf
            newGiftBox=newGiftBox+"                 </div>" & vbcrlf
            newGiftBox=newGiftBox+"             </li>" & vbcrlf
            If gift_isusing>1 Then
            newGiftBox=newGiftBox+"             <li>" & vbcrlf
            newGiftBox=newGiftBox+"                 <div class='box'>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='desc'>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='tit' style='color:" + ThemeBarColorCode + ";'>GIFT2</p>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='txt'>" + gift_text2 + "</p>" & vbcrlf
            newGiftBox=newGiftBox+"                     </div>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='thumb' style='background-image:url(" + gift_img2 + ")'></div>" & vbcrlf
            newGiftBox=newGiftBox+"                 </div>" & vbcrlf
            newGiftBox=newGiftBox+"             </li>" & vbcrlf
            End If
            If gift_isusing>2 Then
            newGiftBox=newGiftBox+"             <li>" & vbcrlf
            newGiftBox=newGiftBox+"                 <div class='box'>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='desc'>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='tit' style='color:" + ThemeBarColorCode + ";'>GIFT3</p>" & vbcrlf
            newGiftBox=newGiftBox+"                         <p class='txt'>" + gift_text3 + "</p>" & vbcrlf
            newGiftBox=newGiftBox+"                     </div>" & vbcrlf
            newGiftBox=newGiftBox+"                     <div class='thumb' style='background-image:url(" + gift_img3 + ")'></div>" & vbcrlf
            newGiftBox=newGiftBox+"                 </div>" & vbcrlf
            newGiftBox=newGiftBox+"             </li>" & vbcrlf
            End If
            newGiftBox=newGiftBox+"         </ul>" & vbcrlf
            if contentsAlign="Y" then
            newGiftBox=newGiftBox+"         <p class='caution'>* 사은품은 한정수량으로 조기소진 또는 종료될 수 있습니다.</p>" & vbcrlf
            End If
            newGiftBox=newGiftBox+"     </div>" & vbcrlf
        End If
        '상단 슬라이드 컨텐츠 유무 확인
        topSlideCheck = cEvent.fnGetMultiContentsTopSlideSetCnt
    set cEvent = nothing
        cdl_e = ecategory
        cdm_e = ecateMid

        IF cdl_e = "" THEN blnFull= True    '카테고리가 없을경우 전체페이지로
        IF eCode = "" THEN
        Alert_return("유효하지 않은 이벤트 입니다.")
        dbget.close()   :   response.End
        END IF

    '// 이벤트 시작전이면 STAFF를 제외한 이벤트 메인으로 리다이렉션
    if datediff("d",esdate,date)<0 and GetLoginUserLevel<>"7" then
        response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
        dbget.close()   :   response.End
    end If

    '// 컬쳐스테이션일 경우 이벤트 메인으로 리다이렉션
    If Trim(ekind)="5" Then
        response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
        dbget.close()   :   response.End
    End If

    '// 상품이벤트(kind13)일경우 상품상세로 리다이렉션
    If Trim(ekind)="13" Then
        Response.redirect ("/category/category_itemprd.asp?itemid="&etc_itemid&"&pEtr="&eCode&gaparamStr)
        dbget.close()   :   response.End
    End If

    '// 상품이벤트(kind13)일경우 상품상세로 리다이렉션
    If etemplate_mo="9" And mdthememo="5" Then
        Response.redirect ("/category/category_itemprd.asp?itemid="&etc_itemid&"&pEtr="&eCode&gaparamStr)
        dbget.close()   :   response.End
    End If

    '// 내 관심 이벤트 확인
    if IsUserLoginOK then
        set clsEvt = new CMyFavoriteEvent
            clsEvt.FUserId = getEncLoginUserID
            clsEvt.FevtCode = eCode
            isMyFavEvent = clsEvt.fnIsMyFavEvent
        set clsEvt = nothing
    end If

    '//이벤트 명 할인이나 쿠폰시
    eOnlyName = eName
    If blnsale Or blncoupon Then
        if ubound(Split(eName,"|"))> 0 Then
            eOnlyName = cStr(Split(eName,"|")(0))
            If blnsale Or (blnsale And blncoupon) then
                eName   = cStr(Split(eName,"|")(0)) &" <span style=color:red>"&cStr(Split(eName,"|")(1))&"</span>"
            ElseIf blncoupon Then
                eName   = cStr(Split(eName,"|")(0)) &" <span style=color:green>"&cStr(Split(eName,"|")(1))&"</span>"
            End If
        end if
    End If

    '// sns공유용 이미지
    dim snpImg, ogImg
    if bimg<>"" then
        snpImg = bimg
    elseIf evt_mo_listbanner <> "" Then
        snpImg = evt_mo_listbanner
    End If
    If evt_mo_listbanner <> "" Then
        ogImg = evt_mo_listbanner
    elseif bimg<>"" then
        ogImg = bimg
    End If

    'head.asp에서 출력
    strOGMeta = strOGMeta & "<meta property=""og:title"" content=""" & eOnlyName & """>" & vbCrLf
    strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
    strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=" & eCode & """ />" & vbCrLf
    strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & ogImg & """>" & vbCrLf
    if trim(evt_subname)<>"" then
        If ekind="28" Then
            strOGMeta = strOGMeta & "<meta property=""og:description"" content=""" & "[텐바이텐] 이벤트 - " & evt_subname & """>" & vbCrLf
        Else
            strOGMeta = strOGMeta & "<meta property=""og:description"" content=""" & "[텐바이텐] 기획전 - " & evt_subname & """>" & vbCrLf
        End If
    end if

    If ekind="28" Then
        strPageKeyword = "이벤트, " & replace(eOnlyName,"""","")
        strHeadTitleName = "이벤트"
    Else
        strPageKeyword = "기획전, " & replace(eOnlyName,"""","")
        strHeadTitleName = "기획전"
    End If

    '//이벤트 종료시 레이어 2016-02-02 유태욱 추가
    Dim strExpireMsg : strExpireMsg=""
    If endlessView <> "Y" Then endlessView = "N"
    If endlessView = "N" Then
        IF (datediff("h",eedate,now())>0) OR (estate=9) Then
            strExpireMsg = "<script type=""text/javascript"" src=""/common/addlog.js?tp=noresult&ror="&server.UrlEncode(Request.serverVariables("HTTP_REFERER"))&"""></script><div class=""finish-event"">이벤트가 종료되었습니다.</div>"
        END If
    END If

    '// 이벤트 로그 사용여부(2017.01.12)
    Dim LogUsingCustomChk
    If getEncLoginUserId="thensi7" Then
        LogUsingCustomChk = True
    Else
        LogUsingCustomChk = True
    End If

    '// 이벤트 로그저장(2017.01.11 원승현)
    If LogUsingCustomChk Then
        If IsUserLoginOK() Then
            '// 마케팅이벤트(ekind=28)
            If ekind="28" Then
                Call fnUserLogCheck("mktevt", getEncLoginUserId, "", eCode, "", "mw")
            Else
                Call fnUserLogCheck("planevt", getEncLoginUserId, "", eCode, "", "mw")
            End If
        End If
    End If

    '// 이벤트 유형 및 테마번호 Web Log에 추가(2017.06.26; 허진원)
    Response.AppendToLog "&evttp=" & evt_type & mdthememo

    '// 구글 ADS 스크립트 관련(2018.09.21 신규버전 추가)
    googleADSCRIPT = " <script> "&vbCrLf
    googleADSCRIPT = googleADSCRIPT & "   gtag('event', 'page_view', { "&vbCrLf
    googleADSCRIPT = googleADSCRIPT & "     'send_to': 'AW-851282978', "&vbCrLf
    googleADSCRIPT = googleADSCRIPT & "     'ecomm_pagetype': 'other', "&vbCrLf
    googleADSCRIPT = googleADSCRIPT & "     'ecomm_prodid': '', "&vbCrLf
    googleADSCRIPT = googleADSCRIPT & "     'ecomm_totalvalue': '' "&vbCrLf
    googleADSCRIPT = googleADSCRIPT & "   }); "&vbCrLf
    googleADSCRIPT = googleADSCRIPT & " </script> "

    '// Amplitude로 보낼 데이터
    Dim evtQuery, vAmplitudeCategoryName
    If edispcate <> "" Then
        evtQuery = "select [db_item].[dbo].getDisplayCateName('" & Left(edispcate, 3) & "')"
        rsget.CursorLocation = adUseClient
        rsget.Open evtQuery, dbget, adOpenForwardOnly, adLockReadOnly  '' 수정.2015/08/12

            if NOT(rsget.EOF or rsget.BOF) then
                vAmplitudeCategoryName = db2html(rsget(0))
            else
                vAmplitudeCategoryName = ""
            end if
        rsget.Close
    End If

function EvtFormatDate(ddate)
dim s
    if hour(ddate) > 0 then
        s = CStr(year(ddate)) & "." &_
        Num2Str(month(ddate),2,"0","R") & "." &_
        Num2Str(day(ddate),2,"0","R") & " " &_
        Num2Str(hour(ddate),2,"0","R") & ":" &_
        Num2Str(minute(ddate),2,"0","R")
    else
        s = CStr(year(ddate)) & "." &_
        Num2Str(month(ddate),2,"0","R") & "." &_
        Num2Str(day(ddate),2,"0","R")
    end if
    EvtFormatDate = s
end function

dim currentDate : currentDate = date()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%=eOnlyName%></title>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="application/x-javascript" src="/lib/js/jquery.rwdImageMaps.js"></script>
<script type="application/x-javascript" src="/lib/js/jquery.rwdImageMaps.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<script type="text/javascript">
    let items_id_list = [];

    $(function(){
        /* 코멘트 남기러 가기, 공유하기 스크롤 이동 */
        $(".btnCmtV15 .button a, .evtShareV15 a").click(function(event){
            event.preventDefault();
            window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
        });

        <%' amplitude 이벤트 로깅 %>
            setTimeout(function(){
                amplitude_view_event_data();
            }, 2000);
        <%'// amplitude 이벤트 로깅 %>
    });

    function amplitude_view_event_data(){
        list.items.forEach(function(data){
            <% IF isArray(arrGroup) THEN %>
                data.itemlists.forEach(function(data2){
                    items_id_list.push(data2.itemID);
                });
            <% ELSE %>
                items_id_list.push(data.itemID);
            <% END IF %>
        });

        let view_event_data = {
            eventkind : "<%=ekind%>"
            , eventcode  : "<%=eCode%>"
            , eventtype : "<%=evt_type%>"
            , categoryname : "<%=vAmplitudeCategoryName%>"
            , item_id : items_id_list
        };
        fnAmplitudeEventActionJsonData('view_event', JSON.stringify(view_event_data));
    }

    function fnMyEvent() {
    <% If IsUserLoginOK Then %>
        $.ajax({
            url: "/my10x10/myfavorite_eventProc.asp?hidM=U&eventid=<%=eCode%>",
            cache: false,
            async: false,
            success: function(message) {
                if($("#myfavoriteevent").attr("class") == "btnWish on"){
                    $("#myfavoriteevent").removeClass("on");
                    alert("선택하신 이벤트가 삭제 되었습니다.");
                }else{
                    $("#myfavoriteevent").addClass("on");
                    alert("관심 이벤트로 등록되었습니다.");
                }
            }
        });
    <% Else %>
        if(confirm("로그인 하시겠습니까?") == true) {
            top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
         }
            return  ;
    <% End If %>
    }

    function DelComments(v){
        if (confirm('삭제 하시겠습니까?')){
            document.frmact.mode.value= "del";
            document.frmact.Cidx.value = v;
            document.frmact.submit();
        }
    }

    function goGroupSelect(v,a){
        $('html, body').animate({
            scrollTop: $("#groupBar"+v+"").offset().top
        }, 300)

        $("#groupBar"+a+" > option[value="+a+"]").attr("selected", "true");
    }

    //앵커이동
    function goToByScroll(valtop){
        $('html,body').animate({scrollTop: valtop},'fast');
    }

    function goWishPop(i,ecd){
    <% If IsUserLoginOK() Then ''ErBValue.value -> 공통파일의 구분값 (cate는 1) %>
        var wishpop = window.open('/common/popWishFolder.asp?ErBValue=10&ecode='+ecd+'&gb=search2017&itemid='+i+'','wishpop','')

        //document.sFrm.itemid.value = i;
        //document.sFrm.action = "/common/popWishFolder.asp";
        //sFrm.submit();
    <% Else %>
        top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
    <% End If %>
    }

    function jsAfterWishBtn(i){
        if($("#wish"+i+"").hasClass("on")){

        }else{
            $("#wish"+i+"").addClass("on");

            var cnt = $("#cnt"+i+"").text();

            if(cnt == ""){
                $("#wish"+i+"").empty();
                $("#cnt"+i+"").empty().text("1");
            }else{
                cnt = parseInt(cnt) + 1;
                if(cnt > 999){
                    $("#cnt"+i+"").empty().text("999+");
                }else{
                    $("#cnt"+i+"").empty().text(cnt);
                }
            }
        }
    }

    // gnb용 이벤트 URL
    function jsEventlinkURL(ecode){
        location.href = '/event/eventmain.asp?eventid='+ecode;
        return false;
    }

    function jsMobAppUrlChange(e,g,m){
            var ecode = e;
            var gcode = g;
            var mcode=m;
            <% if isapp = "1" then %>
                    <% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
                    jsGNBEventlink(ecode,gcode);
                <% else %>
                    location.href = '/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
                <% end if %>
            <% else %>
                <% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
                    jsGNBEventlink(ecode,gcode);
                <% else %>
                    location.href = '/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
                <% end if %>
            <% end if %>
            return false;
        }

    function confirmAdultAuth(cPath){
        if(confirm('이 상품은 성인 인증이 필요한 상품입니다. 성인 확인을 위해 성인 인증을 진행합니다.')){
            var url = '/login/login_adult.asp?backpath='+ cPath;
            location.href = url;
        }
    }
    function jsMobAppUrlChangeFocus(e,g,f){
        var ecode = e;
        var gcode = g;
        var focus = f;
        <% if isapp = "1" then %>
            <% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
                jsGNBEventlink(ecode,gcode);
            <% else %>
                location.href = '/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&#"+focus;
            <% end if %>
        <% else %>
            <% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
                jsGNBEventlink(ecode,gcode);
            <% else %>
                location.href = '/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&#"+focus;
            <% end if %>
        <% end if %>
        return false;
    }

    function GoToBrandShop(designerid){
        if (designerid == ""){
            alert("브랜드가 없습니다.")
        }
        //location.href = "/street/brandshop.asp?designerid=" + designerid;
        location.href = "/brand/brand_detail2020.asp?brandid=" + designerid;
    }

    function goEventSubscript(){
        const eCode = "<%= eCode %>";
        console.log("goEventSubscript", eCode);

        <% If Not(IsUserLoginOK) Then %>
            <% If isApp="1" or isApp="2" Then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid="&eCode&"")%>');
                return false;
            <% end if %>
        <% else %>
            <% If not( left(currentDate,10) >= left(esdate,10) and left(currentDate,10) <= left(eedate,10) ) Then %>
                alert("이벤트 응모 기간이 아닙니다.");
                return;
            <% else %>
                const subscription_apiurl = apiurl + '/event/common/subscription';

                const post_data = {
                    event_code: '<%=eCode%>',
                    check_option1: false
                };
                $.ajax({
                    type: "POST",
                    url: subscription_apiurl,
                    data: post_data,
                    ContentType: "json",
                    crossDomain: true,
                    xhrFields: {
                        withCredentials: true
                    },
                    success: function (data) {
                        if( data.result ) {
                            alert(data.message);
                            fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode', post_data.event_code);
                        } else {
                            alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 001)');
                        }
                    },
                    error: function (xhr) {
                        console.log(xhr.responseText);
                        try {
                            const err_obj = JSON.parse(xhr.responseText);
                            console.log(err_obj);
                            switch (err_obj.code) {
                                case -10: alert('알림 신청을 하려면 로그인이 필요합니다.'); return false;
                                default: alert(err_obj.message); return false;
                            }
                        }catch(error) {
                            console.log(error);
                            alert('데이타를 저장하는 도중에 에러가 발생하였습니다. 관리자 문의 요망. (에러코드 : 002)');
                        }
                    }
                });
            <% end if %>
        <% End IF %>
    }
</script>
<style>[v-cloak] { display: none; }</style>
</head>
<%
    '// SNS 공유 관련 HEADER 포함
    Dim snpTitle , snpLink , snpPre
    snpTitle = eOnlyName
    'snpLink = wwwUrl&CurrURLQ()
    snpLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&CStr(eCode)
    snpPre = "10x10 이벤트"
%>
<body class="default-font body-sub bg-grey"><%'!-- for dev msg : GNB메뉴에서 들어갈때만 body-main클래스가 붙습니다. 그 이외의 페이지에서는 body-sub가 붙습니다. --%>
    <!-- #include virtual="/lib/inc/incHeader.asp" -->

    <!-- contents -->
    <% if etemplate_mo="11" then %>
    <div id="content" class="content typeI">
    <% else %>
    <div id="content" class="content">
    <% End If %>
        <!-- for dev msg : 기존 이벤트 상세 타이틀 영역 이렇게 교체되요. MD가 등록한 이벤트와 동일 -->
        <% If etemplate_mo<>"9" and vDateView = False Then %>
        <div class="section-event event-head">
            <p class="date"><%=EvtFormatDate(esdate)%> ~ <%=EvtFormatDate(eedate)%></p>
            <!--
            <div class="btnGroup">
                <a href="" onClick="popSNSShare('<%=eOnlyName%>','<%=wwwUrl&CurrURLQ()%>','10x10 이벤트','<%=snpImg%>'); return false;" class="btnShare"><span></span>공유하기</a>
                <% If evt_mo_listbanner <> "" Then %>
                    <button type="button" id="myfavoriteevent" class="btnWish<%=chkIIF(isMyFavEvent," on","")%>" onclick="fnMyEvent()" ><span></span>관심 기획전으로 등록하기</button>
                <% End If %>
            </div>
            -->
        </div>
        <% End If %>
        <%'// 이벤트 하단 배너 %>
        <!-- #include virtual="/event/include_event_top_banner.asp" -->
        
        <%
            If eCode = "96681" AND currentDate >= Cdate("2019-08-26") And currentDate < Cdate("2019-08-28") Then %>
            <!-- 할인쿠폰 배너 (20190826) -->
            <% If currentDate = Cdate("2019-08-26") Then %>
                <% if isapp = "1" then %>
                    <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;" class="mApp">
                        <img src="//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0826.jpg" alt="coupon 40,000원 내일까지 사용 가능한 즉시 할인 쿠폰!">
                    </a>
                <% else %>
                    <a href="/my10x10/couponbook.asp" class="mWeb">
                        <img src="//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0826.jpg" alt="coupon 40,000원 내일까지 사용 가능한 즉시 할인 쿠폰!">
                    </a>
                <% end if %>
            <% End if %>
            <% If currentDate = Cdate("2019-08-27") Then %>
                <% if isapp = "1" then %>
                    <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;" class="mApp">
                        <img src="//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0827.jpg" alt="coupon 40,000원 오늘 자정까지 즉시 할인 쿠폰!">
                    </a>
                <% else %>
                    <a href="/my10x10/couponbook.asp" class="mWeb">
                        <img src="//fiximage.10x10.co.kr/m/2019/common/bnr_coupon_0827.jpg" alt="coupon 40,000원 오늘 자정까지 즉시 할인 쿠폰!">
                    </a>
                <% end if %>
            <% End If %>
            <!--// MKT 할인쿠폰 배너 (20190826) -->
        <% end if %>

        <% SELECT CASE etemplate_mo
            CASE "3" '그룹형
        %>
            <div class="evtContV15">
                <%= strExpireMsg %>
                <div class="bnrTemplate"><%=tArea%></div><%'모바일 상단 추가 이미지 %>
                <% If slide_m_flag ="Y" Then %><% sbSlidetemplate '//slide template %><% End If %>
                <%
                If isArray(arrGroup) Then
                    If arrGroup(0,0) <> "" Then
                        if arrGroup(3,0) <> "" then
                %>
                        <div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
                <%
                        End If
                %>
                        <%'excute 추가%>
                        <% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
                        <map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
                        <% Else %>
                            <% If checkFilePath(server.mappath(evtFile_mo)) Then %>
                                <div width="100%"><% server.execute(evtFile_mo)%></div>
                            <% Else %>
                                <map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
                            <% End If %>
                        <% End If %>
                <%
                    End If
                End If
                %>
                <div class="bnrTemplate"><%=mArea%></div><%'모바일 중간 추가 이미지 %>
                </div>
                <% egCode = arrGroup(0,0) %>
                <% if blncomment then %>
                <!-- <div class="btnCmtV15">
                    <span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
                </div> -->
                <% end if %>
                <% If isArray(arrTextTitle) Then %>
                <!-- 코멘트 타이틀 영역 -->
                <!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
                <!-- 코멘트 타이틀 영역 -->
                <% End If %>

                <%'// 상품 리스트 분리 -- 이종화 %>
                <div id="eventitemlist" v-cloak>
                    <div class="exhibition-list-wrap<% If UBound(arrGroup, 2)>0 Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                        <% If UBound(arrGroup, 2)>0 Then %>
                            <group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" ></group-itemlist>
                        <% Else %>
                            <nogroup-itemlist :items="sliced" :ltype="listType" ></nogroup-itemlist>
                        <% End If %>
                        <temp-layout v-if="tempFlag"></temp-layout>
                    </div>
                </div>

                <script>
                $(function(){
                    /* rolling for md event */
                    if ($("#mdRolling .swiper-container .swiper-slide").length > 1) {
                        var mdRolling = new Swiper("#mdRolling .swiper-container", {
                            pagination:"#mdRolling .pagination-line",
                            paginationClickable:true,
                            autoplay:1700,
                            loop:true,
                            speed:800,
                            nextButton:"#mdRolling .btnNext",
                            prevButton:"#mdRolling .btnPrev"
                        });
                    } else {
                        var mdRolling = new Swiper("#mdRolling .swiper-container", {
                            pagination:false,
                            noSwipingClass:".noswiping",
                            noSwiping:true
                        });
                    }

                    $("#mdRolling .pagination-line").each(function(){
                        var checkItem = $(this).children(".swiper-pagination-switch").length;
                        if (checkItem == 2) {
                            $(this).addClass("grid2");
                        }
                        if (checkItem == 3) {
                            $(this).addClass("grid3");
                        }
                        if (checkItem == 4) {
                            $(this).addClass("grid4");
                        }
                        if (checkItem == 5) {
                            $(this).addClass("grid5");
                        }
                    });

                    $(window).scroll(function(){
                        var headerTop = $(window).scrollTop() + $(".header_wrap").outerHeight();
                        var menuTop = $("#eventitemlist").offset().top;

                        if( headerTop >= menuTop ) {
                            $(".dropdownWrap").css({"position":"fixed","top":"4.1rem"});
                        } else {
                            $(".dropdownWrap").css({"position":"absolute","top":"0"});
                        }
                        <% If isArray(arrGroup) Then %>
                        <% For intG = 1 To UBound(arrGroup,2) %>
                        // for dev msg : 2017.06.08 id값은 기차코드로 뿌려주세요 group******
                        if($("#group<%=arrGroup(0,intG)%>").length) {
                            if( $(window).scrollTop()>=$("#group<%=arrGroup(0,intG)%>").offset().top-$(".dropdownWrap").outerHeight()) {
                                var groupbar = $("#group<%=arrGroup(0,intG)%>").children("h3").text();
                                $("#eventitemlist").find(".btnDrop").text(groupbar);
                            }
                        }
                        <% next %>
                        <% end if %>
                        if($("#remove").length) {
                            if( $(window).scrollTop()>=$("#remove").offset().top-$(".dropdownWrap").outerHeight()) {
                                $(".dropdownWrap").css({"position":"absolute","top":"0"});
                            }
                        }
                    });
                });
                </script>
            <div class="bnrTemplate"><%=bArea%></div><%'모바일 하단 추가 이미지 %>
            <div id="remove"></div>
        <%
            CASE "5" '수작업
        %>
            <div class="evtContV15">
                <%= strExpireMsg %>
                <div class="bnrTemplate"><%=tArea%></div>
                <% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
                    <div><%=evt_html_mo%></div>
                <% Else %>
                    <% If checkFilePath(server.mappath(evtFile_mo)) Then %>
                        <div width="100%"><% server.execute(evtFile_mo)%></div>
                    <% Else %>
                        <div><%=evt_html_mo%></div>
                    <% End If %>
                <% End If %>
                <div class="bnrTemplate"><%=mArea%></div>
            </div>
            <% If isArray(arrTextTitle) Then %>
            <!-- 코멘트 타이틀 영역 -->
            <!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
            <!-- 코멘트 타이틀 영역 -->
            <% End If %>
            <div class="bnrTemplate"><%=bArea%></div>
        <%
            CASE "6" '수작업+상품목록
        %>
            <div class="evtContV15">
                <%= strExpireMsg %>
                <% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
                    <div><%=evt_html_mo%></div>
                <% Else %>
                    <% If checkFilePath(server.mappath(evtFile_mo)) Then %>
                        <div><%=evt_html_mo%></div>
                        <div width="100%"><% server.execute(evtFile_mo)%></div>
                    <% Else %>
                        <div><%=evt_html_mo%></div>
                    <% End If %>
                <% End If %>
                <div class="bnrTemplate"><%=tArea%></div>
                <% If emimg_mo <> "" Then %><div><img src="<%=emimg_mo%>" alt="<%=eOnlyName%>" /></div><% End If %>
                <% If slide_m_flag ="Y" Then %><% sbSlidetemplate '//slide template %><% End If %>

                <%
                If isArray(arrGroup) Then
                    If arrGroup(0,0) <> "" Then
                        if arrGroup(3,0) <> "" then
                %>
                        <div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
                <%
                        End If
                %>
                        <%'excute 추가%>
                        <% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
                            <map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
                        <% Else %>
                            <map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
                        <% End If %>
                <%
                    End If
                End If
                %>
                <div class="bnrTemplate"><%=mArea%></div>
            </div>

            <%=newGiftBox%>

            <!-- 코멘트 박스 -->
            <% If blncomment and ekind<>"33" Then %>
            <section class="comment-eventV19">
                <h3 style="color:<%=ThemeBarColorCode%>;">Comment Event</h3>
                <p class="topic"><%=nl2br(comm_text)%></p>
                <ul>
                    <li>작성기간 <span class="date"><%=Replace(comm_start,"-",".")%> ~ <%=Replace(comm_end,"-",".")%></span></li>
                    <li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
                </ul>
                <div class="btnGroup">
                    <a href="#replyList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
                </div>
                <% if freebie_img<>"" then %><div class="thumbnail"><img src="<%=freebie_img%>" alt=""></div><% End If %>
            </section>
            <% End If %>

            <!-- 상품후기 박스 -->
            <% If blnitemps Then %>
            <section class="comment-eventV19">
                <h3 style="color:<%=ThemeBarColorCode%>;">Review Event</h3>
                <p class="topic"><%=nl2br(eval_text)%></p>
                <ul>
                    <li>작성기간 <span class="date"><%=Replace(eval_start,"-",".")%> ~ <%=Replace(eval_end,"-",".")%></span></li>
                    <li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
                </ul>
                <div class="btnGroup">
                    <a href="#replyPrdList" class="btn-go">리뷰 쓰러가기<span class="icon"></span></a>
                </div>
                <% if eval_freebie_img<>"" then %><div class="thumbnail"><img src="<%=eval_freebie_img%>" alt=""></div><% End If %>
            </section>
            <% End If %>

            <!-- 포토 코멘트 박스 -->
            <% If blnbbs Then %>
            <section class="comment-eventV19">
                <h3 style="color:<%=ThemeBarColorCode%>;">Photo Comment Event</h3>
                <p class="topic"><%=nl2br(board_text)%></p>
                <ul>
                    <li>작성기간 <span class="date"><%=Replace(board_start,"-",".")%> ~ <%=Replace(board_end,"-",".")%></span></li>
                    <li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
                </ul>
                <div class="btnGroup">
                    <a href="#replyPhotoList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
                </div>
                <% if board_freebie_img<>"" then %><div class="thumbnail"><img src="<%=board_freebie_img%>" alt=""></div><% End If %>
            </section>
            <% End If %>

            <%'// 상품 리스트 분리 -- 이종화 %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap<% If isArray(arrGroup) Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                    <% If isArray(arrGroup) Then %>
                        <group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" ></group-itemlist>
                    <% Else %>
                        <nogroup-itemlist :items="sliced" :ltype="listType" ></nogroup-itemlist>
                    <% End If %>
                    <temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>
            <script>
            $(function(){
                /* rolling for md event */
                if ($("#mdRolling .swiper-container .swiper-slide").length > 1) {
                    var mdRolling = new Swiper("#mdRolling .swiper-container", {
                        pagination:"#mdRolling .pagination-line",
                        paginationClickable:true,
                        autoplay:1700,
                        loop:true,
                        speed:800,
                        nextButton:"#mdRolling .btnNext",
                        prevButton:"#mdRolling .btnPrev"
                    });
                } else {
                    var mdRolling = new Swiper("#mdRolling .swiper-container", {
                        pagination:false,
                        noSwipingClass:".noswiping",
                        noSwiping:true
                    });
                }

                $("#mdRolling .pagination-line").each(function(){
                    var checkItem = $(this).children(".swiper-pagination-switch").length;
                    if (checkItem == 2) {
                        $(this).addClass("grid2");
                    }
                    if (checkItem == 3) {
                        $(this).addClass("grid3");
                    }
                    if (checkItem == 4) {
                        $(this).addClass("grid4");
                    }
                    if (checkItem == 5) {
                        $(this).addClass("grid5");
                    }
                });

                $(window).scroll(function(){
                    var headerTop = $(window).scrollTop() + $(".header_wrap").outerHeight();
                    var menuTop = $("#eventitemlist").offset().top;

                    if( headerTop >= menuTop ) {
                        $(".dropdownWrap").css({"position":"fixed","top":"4.1rem"});
                    } else {
                        $(".dropdownWrap").css({"position":"absolute","top":"0"});
                    }

                    <% If isArray(arrGroup) Then %>
                    <% For intG = 1 To UBound(arrGroup,2) %>
                    // for dev msg : 2017.06.08 id값은 기차코드로 뿌려주세요 group******
                    if($("#group<%=arrGroup(0,intG)%>").length) {
                        if( $(window).scrollTop()>=$("#group<%=arrGroup(0,intG)%>").offset().top-$(".dropdownWrap").outerHeight()) {
                            var groupbar = $("#group<%=arrGroup(0,intG)%>").children("h3").text();
                            $("#eventitemlist").find(".btnDrop").text(groupbar);
                        }
                    }
                    <% next %>
                    <% end if %>
                    if($("#remove").length) {
                        if( $(window).scrollTop()>=$("#remove").offset().top-$(".dropdownWrap").outerHeight()) {
                            $(".dropdownWrap").css({"position":"absolute","top":"0"});
                        }
                    }
                });
            });
            </script>
            <div class="bnrTemplate"><%=bArea%></div>
        <%
            CASE "9" 'MD 등록 이벤트
        %>
            <% If vDateView = False Then %>
            <div class="section-event event-head">
                <p class="date"><%=EvtFormatDate(esdate)%> ~ <%=EvtFormatDate(eedate)%></p>
                <!--
                <div class="btnGroup">
                    <a href="" onClick="popSNSShare('<%=title_mo%>','<%=wwwUrl&CurrURLQ()%>','10x10 이벤트','<%=snpImg%>'); return false;" class="btnShare"><span></span>공유하기</a>
                    <% If evt_mo_listbanner <> "" Then %><button type="button" id="myfavoriteevent" class="btnWish<%=chkIIF(isMyFavEvent," on","")%>" onclick="fnMyEvent()"><span></span><%=chkIIF(isMyFavEvent,"관심 기획전으로 선택하기","관심 기획전으로 해제하기")%></button><% End If %>
                </div>
                -->
            </div>
            <% end if %>
            <div class="evtContV15">
                <%= strExpireMsg %>
                <div class="bnrTemplate"><%=tArea%></div><%'모바일 상단 추가 이미지 %>
            </div>
            <% If mdthememo="1" Then %>
            <div class="event-article event-text-type"><!-- type 1 : text 타입 -->
                <section class="section-event hgroup-event">
                    <h2 style="word-break:keep-all;"><%=title_mo%></h2>
                    <p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
                    <% If blnsale Or blncoupon Then %><div class="discount"><% If blnsale Then %><b class="red"><span>~<%=salePer%>%</span></b><% end if %>&nbsp;<% If blncoupon Then %><b class="green"><small>쿠폰</small><span><%=saleCPer%>%</span></b><% end if %></div><% end if %>
                    <!-- 브랜드 링크 -->
                    <% If ebrand<>"" Then %><div class="btnGroup"><a href="/brand/brand_detail2020.asp?brandid=<%=ebrand%>" class="btnV16a"><%=SocName_Kor%></a></div><% end if %>
                </section>
            </div>
            <% ElseIf mdthememo="2" Then %>
            <!-- type 2 : full rolling 타입 -->
            <div class="event-article event-full-rolling-type">
                <!-- rolling -->
                <div id="mdRolling" class="swiper">
                    <div class="swiper-container">
                        <% If fnGetMoSlideImgCnt(eCode) > 1 Then %>
                        <div class="swiper-wrapper">
                            <% If videoFullLink<>"" Then %>
                            <div class="swiper-slide has-vod">
                                <div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
                            </div>
                            <% End If %>
                            <% sbSlidetemplateMD %>
                        </div>
                        <div class="pagination-line"></div>
                        <button type="button" class="btnNav btnPrev">이전</button>
                        <button type="button" class="btnNav btnNext">다음</button>
                        <% ElseIf fnGetMoSlideImgCnt(eCode) > 0 And videoFullLink<>"" Then %>
                        <div class="swiper-wrapper">
                            <% If videoFullLink<>"" Then %>
                            <div class="swiper-slide has-vod">
                                <div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
                            </div>
                            <% End If %>
                            <% sbSlidetemplateMD %>
                        </div>
                        <div class="pagination-line"></div>
                        <button type="button" class="btnNav btnPrev">이전</button>
                        <button type="button" class="btnNav btnNext">다음</button>
                        <% ElseIf fnGetMoSlideImgCnt(eCode) < 1 And videoFullLink<>"" Then %>
                            <div class="swiper-slide has-vod">
                                <div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
                            </div>
                        <% Else %>
                            <% sbSlidetemplateMD %>
                        <% End If %>
                    </div>
                </div>
                <section class="section-event hgroup-event">
                    <h2 style="word-break:keep-all;"><%=title_mo%></h2>
                    <p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
                    <% If blnsale Or blncoupon Then %><div class="discount"><% If blnsale Then %><b class="red"><span>~<%=salePer%>%</span></b><% end if %>&nbsp;<% If blncoupon Then %><b class="green"><small>쿠폰</small><span><%=saleCPer%>%</span></b><% end if %></div><% end if %>
                    <% If ebrand<>"" Then %><div class="btnGroup"><a href="/brand/brand_detail2020.asp?brandid=<%=ebrand%>" class="btnV16a"><%=SocName_Kor%></a></div><% end if %>
                </section>
            </div>
            <% ElseIf mdthememo="3" Then %>
            <!-- type 3 : rolling 타입 -->
            <div class="event-article event-rolling-type" style="background-color:<%=ThemeBarColorCode%>;"><!-- for dev msg : 어드민에서 배경 등록 부분입니다. -->
                <section class="section-event hgroup-event">
                    <% If ebrand<>"" Then %><div class="btnGroup"><a href="/brand/brand_detail2020.asp?brandid=<%=ebrand%>" class="btnV16a"><%=SocName_Kor%></a></div><% end if %>
                    <h2 style="word-break:keep-all;"><%=title_mo%></h2>
                    <p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
                    <% If blnsale Or blncoupon Then %><div class="discount"><% If blnsale Then %><b class="red"><span>~<%=salePer%>%</span></b><% end if %>&nbsp;<% If blncoupon Then %><b class="green"><small>쿠폰</small><span><%=saleCPer%>%</span></b><% end if %></div><% end if %>
                </section>
                <div id="mdRolling" class="swiper">
                    <div class="swiper-container">
                        <% If fnGetMoItemSlideImgCnt(eCode) > 1 Then %>
                        <div class="swiper-wrapper">
                            <% sbSlidetemplateItemMD %>
                        </div>
                        <div class="pagination-line"></div>
                        <button type="button" class="btnNav btnPrev">이전</button>
                        <button type="button" class="btnNav btnNext">다음</button>
                        <% Else %>
                            <% sbSlidetemplateItemMD %>
                        <% End If %>
                    </div>
                </div>
            </div>
            <% End If %>
            <div class="bnrTemplate"><%=mArea%></div><%'모바일 중간 추가 이미지 %>
            <% If using_text1 <> "" And usinginfo>0 Then %>
            <section class="section-event brand-event">
                <h3 lang="ko"><%=using_text1%></h3>
                <div class="desc">
                    <p><%=using_contents1%></p>
                </div>
            </section>
            <% End If %>
            <% If using_text2 <> "" And usinginfo>1 Then %>
            <section class="section-event book-event">
                <h3 lang="ko"><%=using_text2%></h3>
                <p><%=using_contents2%></p>
            </section>
            <% End If %>
            <% If using_text3 <> "" And usinginfo>2 Then %>
            <section class="section-event book-event">
                <h3 lang="ko"><%=using_text3%></h3>
                <p><%=using_contents3%></p>
            </section>
            <% End If %>
            <% If gift_isusing > 0 Then %>
            <section class="section-event gift-event">
                <h3 lang="en">GIFT</h3>
                <% If gift_text1 <> "" And gift_isusing>0 Then %>
                <div class="desc">
                    <p><%=gift_text1%></p>
                    <% If gift_img1 <> "" Then %><div class="thumbnail"><img src="<%=gift_img1%>" alt="" /></div><% End If %>
                </div>
                <% End If %>
                <% If gift_text2 <> "" And gift_isusing>1 Then %>
                <div class="desc">
                    <p><%=gift_text2%></p>
                    <% If gift_img2 <> "" Then %><div class="thumbnail"><img src="<%=gift_img2%>" alt="" /></div><% End If %>
                </div>
                <% End If %>
                <% If gift_text3 <> "" And gift_isusing>2 Then %>
                <div class="desc">
                    <p><%=gift_text3%></p>
                    <% If gift_img3 <> "" Then %><div class="thumbnail"><img src="<%=gift_img3%>" alt="" /></div><% End If %>
                </div>
                <% End If %>
            </section>
            <% End If %>

			<!-- 코멘트 박스 -->
			<% If blncomment Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeColorCode%>;">Comment Event</h3>
				<p class="topic"><%=nl2br(comm_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(comm_start,"-",".")%> ~ <%=Replace(comm_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
				</div>
				<% if freebie_img<>"" then %><div class="thumbnail"><img src="<%=freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

            <% If eval_isusing="Y" Then %>
            <section class="section-event comment-event">
                <h3 lang="en">REVIEW EVENT</h3>
                <p class="gift"><%=nl2br(eval_text)%></p>
                <ul>
                    <li>기간 : <span class="date"><%=Replace(eval_start,"-",".")%> ~ <%=Replace(eval_end,"-",".")%></span></li>
                    <li>당첨자 발표 : <span class="date"><%=Replace(epdate,"-",".")%></span></li>
                </ul>
                <div class="btnGroup">
                    <a href="#replyPrdList" class="btnV16a">리뷰 남기러가기<span class="icon"></span></a>
                </div>
            </section>
            <% End If %>

            <%'// 상품 리스트 분리 -- 이종화 %>
            <% If isArray(arrGroup) Then %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap<% If UBound(arrGroup, 2)>0 Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                    <% If UBound(arrGroup, 2)>0 Then %>
                        <group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" ></group-itemlist>
                    <% Else %>
                        <nogroup-itemlist :items="sliced" :ltype="listType" ></nogroup-itemlist>
                    <% End If %>
                    <temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>
            <% End If %>
            <script>
            $(function(){
                /* rolling for md event */
                if ($("#mdRolling .swiper-container .swiper-slide").length > 1) {
                    var mdRolling = new Swiper("#mdRolling .swiper-container", {
                        pagination:"#mdRolling .pagination-line",
                        paginationClickable:true,
                        autoplay:1700,
                        loop:true,
                        speed:800,
                        nextButton:"#mdRolling .btnNext",
                        prevButton:"#mdRolling .btnPrev"
                    });
                } else {
                    var mdRolling = new Swiper("#mdRolling .swiper-container", {
                        pagination:false,
                        noSwipingClass:".noswiping",
                        noSwiping:true
                    });
                }

                $("#mdRolling .pagination-line").each(function(){
                    var checkItem = $(this).children(".swiper-pagination-switch").length;
                    if (checkItem == 2) {
                        $(this).addClass("grid2");
                    }
                    if (checkItem == 3) {
                        $(this).addClass("grid3");
                    }
                    if (checkItem == 4) {
                        $(this).addClass("grid4");
                    }
                    if (checkItem == 5) {
                        $(this).addClass("grid5");
                    }
                });

                $(window).scroll(function(){
                    var headerTop = $(window).scrollTop() + $(".header_wrap").outerHeight();
                    var menuTop = $("#eventitemlist").offset().top;

                    if( headerTop >= menuTop ) {
                        $(".dropdownWrap").css({"position":"fixed","top":"4.1rem"});
                    } else {
                        $(".dropdownWrap").css({"position":"absolute","top":"0"});
                    }

                    <% If isArray(arrGroup) Then %>
                    <% For intG = 1 To UBound(arrGroup,2) %>
                    // for dev msg : 2017.06.08 id값은 기차코드로 뿌려주세요 group******
                    if($("#group<%=arrGroup(0,intG)%>").length) {
                        if( $(window).scrollTop()>=$("#group<%=arrGroup(0,intG)%>").offset().top-$(".dropdownWrap").outerHeight()) {
                            var groupbar = $("#group<%=arrGroup(0,intG)%>").children("h3").text();
                            $("#eventitemlist").find(".btnDrop").text(groupbar);
                        }
                    }
                    <% next %>
                    <% end if %>
                    if($("#remove").length) {
                        if( $(window).scrollTop()>=$("#remove").offset().top-$(".dropdownWrap").outerHeight()) {
                            $(".dropdownWrap").css({"position":"absolute","top":"0"});
                        }
                    }
                });
            });
            </script>
            <div class="bnrTemplate"><%=bArea%></div>
            <div id="remove"></div>
        <%
            CASE "10" '멀티3
        %>
            <div class="evtContV15">
                <%= strExpireMsg %>
                <div class="bnrTemplate"><%=tArea%></div>
                    <div width="100%"><% server.execute("/event/etc/multi3/index.asp")%></div>
                <div class="bnrTemplate"><%=mArea%></div>
            </div>
            <% If isArray(arrTextTitle) Then %>
            <!-- 코멘트 타이틀 영역 -->
            <!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
            <!-- 코멘트 타이틀 영역 -->
            <% End If %>
            <div class="bnrTemplate"><%=bArea%></div>
        <%  CASE "11" 'MD 등록 이벤트 I형 %>
			<div class="evtContV15">
			<%= strExpireMsg %>
            <% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
            <% else %>
                <% If checkFilePath(server.mappath(evtFile_mo)) Then %>
                    <div width="100%"><% server.execute(evtFile_mo)%></div>
                <% End If %>
            <% End If %>
            <% If Trim(evt_html_mo)="" Or not isnull(evt_html_mo) Then %>
                <%=evt_html_mo%>
            <% End If %>
			<div class="bnrTemplate"><%=tArea%></div><%'모바일 상단 추가 이미지 %>
			</div>

			<!-- type 2 : full rolling 타입 -->
			<div class="event-article event-full-rolling-type"<%=CHKIIF(topSlideCheck>0," style='display:none'","")%>>
				<!-- I형 이미지 슬라이더 -->
				<div class="evt-sliderV19">
					<div class="swiper-container">
						<% If fnGetMoTopSlideImgCnt(eCode) > 1 Then %>
						<div class="swiper-wrapper">
							<% If videoFullLink<>"" Then %>
							<div class="swiper-slide has-vod">
								<div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
							</div>
							<% End If %>
							<% sbTopSlidetemplateMD %>
						</div>
						<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
						<% ElseIf fnGetMoTopSlideImgCnt(eCode) > 0 And videoFullLink<>"" Then %>
						<div class="swiper-wrapper">
							<% If videoFullLink<>"" Then %>
							<div class="swiper-slide has-vod">
								<div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
							</div>
							<% End If %>
							<% sbTopSlidetemplateMD %>
						</div>
						<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
						<% ElseIf fnGetMoTopSlideImgCnt(eCode) < 1 And videoFullLink<>"" Then %>
							<div class="swiper-slide has-vod">
								<div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
							</div>
						<% Else %>
						<div class="swiper-wrapper">
							<% sbTopSlidetemplateMD %>
						</div>
						<div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
						<% End If %>
					</div>
				</div>
				<section class="hgroup-event"<% if CopyHide="1" then %> style="display:none"<% end if %>>
					<h2 style="word-break:keep-all;" id="title"><%=title_mo%></h2>
					<p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
					<div class="labels">
						<% If blnsale Or blncoupon Then %>
						<% If blnsale And salePer>"0" Then %><span class="labelV19 label-red" id="esale">~<%=salePer%>%</span><% end if %>
						<% If blncoupon And saleCPer>"0" Then %>&nbsp;<span class="labelV19 label-green">~<%=saleCPer%>%</span><% end if %>
						<% end if %>
						<% If blngift Then %>&nbsp;<span class="labelV19 label-blue">GIFT</span><% end if %>
						<% If isOnePlusOne Then %>&nbsp;<span class="labelV19 label-blue">1+1</span><% end if %>
						<% If isNew Then %>&nbsp;<span class="labelV19 label-black">런칭</span><% end if %>
						<% If blncomment or blnbbs or blnitemps Then %>&nbsp;<span class="labelV19 label-black">참여</span><% end if %>
						<% If isOnlyTen Then %>&nbsp;<span class="labelV19 label-black">단독</span><% end if %>
					</div>
				</section>
			</div>
			<div class="bnrTemplate"><%=mArea%></div><%'모바일 중간 추가 이미지 %>

			<% sbMultiContentsView %>

            <%=newGiftBox%>

			<!-- 코멘트 박스 -->
			<% If blncomment Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeBarColorCode%>;">Comment Event</h3>
				<p class="topic"><%=nl2br(comm_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(comm_start,"-",".")%> ~ <%=Replace(comm_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
				</div>
				<% if freebie_img<>"" then %><div class="thumbnail"><img src="<%=freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<!-- 상품후기 박스 -->
			<% If blnitemps Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeBarColorCode%>;">Review Event</h3>
				<p class="topic"><%=nl2br(eval_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(eval_start,"-",".")%> ~ <%=Replace(eval_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyPrdList" class="btn-go">리뷰 쓰러가기<span class="icon"></span></a>
				</div>
				<% if eval_freebie_img<>"" then %><div class="thumbnail"><img src="<%=eval_freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<!-- 포토 코멘트 박스 -->
			<% If blnbbs Then %>
			<section class="comment-eventV19">
				<h3 style="color:<%=ThemeBarColorCode%>;">Photo Comment Event</h3>
				<p class="topic"><%=nl2br(board_text)%></p>
				<ul>
					<li>작성기간 <span class="date"><%=Replace(board_start,"-",".")%> ~ <%=Replace(board_end,"-",".")%></span></li>
					<li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
				</ul>
				<div class="btnGroup">
					<a href="#replyPhotoList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
				</div>
				<% if board_freebie_img<>"" then %><div class="thumbnail"><img src="<%=board_freebie_img%>" alt=""></div><% End If %>
			</section>
			<% End If %>

			<%'// 상품 리스트 분리 -- 이종화 %>
			<div id="eventitemlist" v-cloak>
				<div class="exhibition-list-wrap<% If isArray(arrGroup) Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                    <% If isArray(arrGroup) Then %>
                        <group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" ></group-itemlist>
                    <% Else %>
                        <nogroup-itemlist :items="sliced" :ltype="listType" ></nogroup-itemlist>
                    <% End If %>
                    <temp-layout v-if="tempFlag"></temp-layout>
				</div>
			</div>

            <script>
			$(function(){
                $('img[usemap]').rwdImageMaps();
				$('.evt-sliderV19 .pagination-progressbar-fill').css('background', '<%=ThemeBarColorCode%>'); // for dev msg : 테마색상 등록
                // I형 이미지 슬라이더
                $('.evt-sliderV19').each(function(index, slider) {
                    var slider = $(this).find('.swiper-container');
                    var amt = slider.find('.swiper-slide').length;
                    var progress = $(this).find('.pagination-progressbar-fill');
                    if (amt > 1) {
                        var evtSwiper = new Swiper(slider, {
                            autoplay: 1700,
                            loop: true,
                            speed: 800,
                            autoplayDisableOnInteraction: false,
                            onInit: function(evtSwiper) {
                                var init = (1 / amt).toFixed(2);
                                progress.css('transform', 'scaleX(' + init + ') scaleY(1)');
                            },
                            onSlideChangeStart: function(evtSwiper) {
                                var activeIndex = evtSwiper.activeIndex;
                                var realIndex = parseInt(evtSwiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
                                var calc = ( (realIndex+1) / amt ).toFixed(2);
                                progress.css('transform', 'scaleX(' + calc + ') scaleY(1)');
                            }
                        });
                    } else {
                        var evtSwiper = new Swiper(slider, {
                            noSwiping: true,
                            noSwipingClass: '.noswiping'
                        });
                        $(this).find('.pagination-progressbar').hide();
                    }
                });

                $(window).scroll(function(){
                    var headerTop = $(window).scrollTop() + $(".header_wrap").outerHeight();
                    var menuTop = $("#eventitemlist").offset().top;

                    if( headerTop >= menuTop ) {
                        $(".dropdownWrap").css({"position":"fixed","top":"4.1rem"});
                    } else {
                        $(".dropdownWrap").css({"position":"absolute","top":"0"});
                    }

                    <% If isArray(arrGroup) Then %>
                    <% For intG = 1 To UBound(arrGroup,2) %>
                    // for dev msg : 2017.06.08 id값은 기차코드로 뿌려주세요 group******
                    if($("#group<%=arrGroup(0,intG)%>").length) {
                        if( $(window).scrollTop()>=$("#group<%=arrGroup(0,intG)%>").offset().top-$(".dropdownWrap").outerHeight()) {
                            var groupbar = $("#group<%=arrGroup(0,intG)%>").children("h3").text();
                            $("#eventitemlist").find(".btnDrop").text(groupbar);
                        }
                    }
                    <% next %>
                    <% end if %>
                    if($("#remove").length) {
                        if( $(window).scrollTop()>=$("#remove").offset().top-$(".dropdownWrap").outerHeight()) {
                            $(".dropdownWrap").css({"position":"absolute","top":"0"});
                        }
                    }
                });
			});
			</script>
			<div class="bnrTemplate"><%=bArea%></div>
			<div id="remove"></div>
        <%
            CASE ELSE '기본:메인이미지+상품목록
        %>
            <div class="evtContV15">
                <%= strExpireMsg %>
                <div class="bnrTemplate"><%=tArea%></div>
                <% If slide_m_flag ="Y" Then %><% sbSlidetemplate '//slide template %><% End If %>
                <% If emimg_mo <> "" Then %><div><img src="<%=emimg_mo%>" alt="<%=eOnlyName%>" /></div><% End If %>
                <div class="bnrTemplate"><%=mArea%></div>
            </div>
            <% if blncomment then %>
            <!-- <div class="btnCmtV15">
                <span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
            </div> -->
            <% end if %>
            <% If isArray(arrTextTitle) Then %>
            <!-- 코멘트 타이틀 영역 -->
            <!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
            <!-- 코멘트 타이틀 영역 -->
            <% End If %>

            <%'// 상품 리스트 분리 -- 이종화 %>
            <div id="eventitemlist" v-cloak>
                <div class="exhibition-list-wrap exhibition-list-wrap-nogroupbar">
                    <nogroup-itemlist :items="sliced" :ltype="listType"></nogroup-itemlist>
                    <temp-layout v-if="tempFlag"></temp-layout>
                </div>
            </div>

            <div class="bnrTemplate"><%=bArea%></div>
        <%
            End SELECT
        %>

        <%'상품 이후 하단 컨텐츠 %>
        <!-- #include virtual="/event/lib/add_footcontents.asp" -->

        <% If blnitemps Then %>
        <div class="inner5 tMar25" id="replyPrdList">
            <!-- #include virtual="/event/lib/evaluate_lib.asp" -->
        </div>
        <% End If %>

        <% if blncomment then
            dim cEComment, iCTotCnt, arrCList, intCLoop

            '코멘트 데이터 가져오기
            set cEComment = new ClsEvtComment

            if LinkEvtCode>0 then
                cEComment.FECode        = LinkEvtCode   '관련코드 = 온라인 코드
            else
                ''2017 웨딩 이벤트 코멘트 통합 171010 유태욱
                if eCode = "80615" or eCode = "80616" or eCode = "80617" then
                    cEComment.FECode        = 80833
                else
                    cEComment.FECode        = eCode
                end if
            end if
            cEComment.FComGroupCode = com_egCode
            cEComment.FEBidx        = bidx
            cEComment.FCPage        = 1 '현재페이지
            cEComment.FPSize        = 5 '페이지 사이즈
            cEComment.FTotCnt       = -1  '전체 레코드 수
            arrCList = cEComment.fnGetComment
            iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
            set cEComment = nothing
        %>
        <div class="inner5 tMar25">
            <div id="replyList" class="replyList box1 evtReplyV15">
                <p class="total">총 <%=iCTotCnt%>개의 댓글이 있습니다.</p>
                <% If Trim(epdate) <> "" Then %>
                    <% If Left(epdate, 10) <= Left(Now(), 10) Then %>
                        <a href="" onClick="alert('당첨자 발표일이 지난 이벤트 입니다.'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                    <% Else %>
                        <% if eCode = "80615" or eCode = "80616" or eCode = "80617" then %>
                            <a href="" onClick="fnOpenModal('/event/event_comment.asp?view=w&eventid=80833&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                        <% else %>
                            <a href="" onClick="fnOpenModal('/event/event_comment.asp?view=w&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                        <% end if %>
                    <% End If %>
                <% Else %>
                    <% if eCode = "80615" or eCode = "80616" or eCode = "80617" then %>
                        <a href="" onClick="fnOpenModal('/event/event_comment.asp?view=w&eventid=80833&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                    <% else %>
                        <a href="" onClick="fnOpenModal('/event/event_comment.asp?view=w&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
                    <% end if %>
                <% End If %>
                <%IF isArray(arrCList) THEN
                    dim arrUserid, bdgUid, bdgBno
                    '사용자 아이디 모음 생성(for Badge)
                    for intCLoop = 0 to UBound(arrCList,2)
                        arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(arrCList(2,intCLoop)) & "''"
                    next

                    '뱃지 목록 접수(순서 랜덤)
                    Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
                %>
                <ul>
                    <%For intCLoop = 0 To UBound(arrCList,2)%>
                    <li>
                        <p class="num"><%=iCTotCnt-intCLoop-(Int(iCTotCnt/3)*(1-1))%><% If arrCList(8,intCLoop) <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
                        <div class="replyCont">
                            <%
                                Dim strBlog
                                'URL이 존재하고 본인 또는 STAFF가 접속해있다면 링크 표시
                                strBlog = ReplaceBracket(db2html(arrCList(7,intCLoop)))
                                if trim(strBlog)<>"" and (GetLoginUserLevel=7 or arrCList(2,intCLoop)=GetLoginUserID) then
                                    Response.Write "<p class='bMar05'><strong>URL :</strong> <a href='" & ChkIIF(left(trim(strBlog),4)="http","","http://") & strBlog & "' target='_blank'>" & strBlog & "</a></p>"
                                end if
                            %>
                            <p><%=striphtml(db2html(arrCList(1,intCLoop)))%></p>
                            <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                            <p class="tPad05">
                                <span class="button btS1 btWht cBk1"><a href="" onClick="DelComments('<% = arrCList(0,intCLoop) %>'); return false;">삭제</a></span>
                            </p>
                            <% end if %>
                            <div class="writerInfo">
                                <p><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%> <span class="bar">/</span> <% if arrCList(2,intCLoop)<>"10x10" then %><%=printUserId(arrCList(2,intCLoop),2,"*")%><% End If %></p>
                                <p class="badge">
                                    <%=getUserBadgeIcon(arrCList(2,intCLoop),bdgUid,bdgBno,3)%>
                                </p>
                            </div>
                        </div>
                    </li>
                    <% Next %>
                </ul>
                <% ELSE %>
                    <p class="no-data ct">해당 게시물이 없습니다.</p>
                <% END IF %>
                <% If isArray(arrCList) Then %>
                <div class="btnWrap tPad15">
                    <% if eCode = "80615" or eCode = "80616" or eCode = "80617" then %>
                        <span class="button btM1 btBckBdr cBk1 w100p"><a href="" onClick="fnOpenModal('/event/event_comment.asp?view=l&eventid=80833&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>&epdate=<%=epdate%>'); return false;"><em>전체보기</em></a></span>
                    <% else %>
                        <span class="button btM1 btBckBdr cBk1 w100p"><a href="" onClick="fnOpenModal('/event/event_comment.asp?view=l&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>&epdate=<%=epdate%>'); return false;"><em>전체보기</em></a></span>
                    <% end if %>
                </div>
                <% End If %>
            </div>
        </div>
        <% end if %>
        <form name="frmact" method="post" action="/event/lib/doEventComment.asp" target="iframeDB" style="margin:0px;">
        <input type="hidden" name="mode" value="del">
        <input type="hidden" name="Cidx" value="">
        <input type="hidden" name="userid" value="<%= GetLoginUserID %>">
        <% if eCode = "80615" or eCode = "80616" or eCode = "80617" then %>
            <input type="hidden" name="returnurl" value="/event/eventmain.asp?eventid=80833&comm=o">
            <input type="hidden" name="eventid" value="80833">
        <% else %>
            <input type="hidden" name="returnurl" value="/event/eventmain.asp?eventid=<%= eCode %>&comm=o">
            <input type="hidden" name="eventid" value="<%= eCode %>">
        <% end if %>
        <input type="hidden" name="linkevt" value="<%= LinkEvtCode %>">
        </form>
        <%
            '관련기획전 가져오기
            Dim vArrIssue, vLink , vName , vSale, vArrIssue2, vSale2, vLink2, vName2
            set cEvent = new ClsEvtCont
                cEvent.FECode = eCode
                cEvent.FEKind = ekind
                cEvent.FBrand = ebrand
                cEvent.FDevice = "M" 'device
                cEvent.FEDispCate = edispcate
                vArrIssue = cEvent.fnEventISSUEList
                vArrIssue2 = cEvent.fnEventISSUEList2
            set cEvent = nothing
        %>

        <% If eCode <> "83586" Then %>
        <% If ekind<>"29" Then %>
        <% If isArray(vArrIssue) THEN %>
        <div class="itemAddWrapV16a evtIsuV17a" style="margin-top:3rem;">
            <div class="bxLGy2V16a">
                <h3>관련 기획전</h3>
            </div>
            <div class="bxWt1V16a">
                <div class="pdtListV15a">
                    <ul>
                        <% If eCode="82739" Or eCode="82741" Or eCode="82742" Or eCode="82740" Or eCode="82738" Or eCode="82744" then %>
                        <% For intCLoop = 0 To UBound(vArrIssue2,2)
                            vSale2 = ""
                            vName2 = ""
                            If vArrIssue2(4,intCLoop) Or vArrIssue2(5,intCLoop) Then '//issale ,  iscoupon
                                if ubound(Split(vArrIssue2(1,intCLoop),"|"))> 0 Then
                                    If vArrIssue2(4,intCLoop) Or (vArrIssue2(4,intCLoop) And vArrIssue2(5,intCLoop)) then
                                        vName2  = cStr(Split(vArrIssue2(1,intCLoop),"|")(0))
                                        vSale2  = cStr(Split(vArrIssue2(1,intCLoop),"|")(1))
                                    ElseIf vArrIssue2(5,intCLoop) Then
                                        vName2  = cStr(Split(vArrIssue2(1,intCLoop),"|")(0))
                                        vSale2  = cStr(Split(vArrIssue2(1,intCLoop),"|")(1))
                                    End If
                                Else
                                    vName2 = vArrIssue2(1,intCLoop)
                                end If
                            Else
                                vName2 = vArrIssue2(1,intCLoop)
                            End If

                            IF vArrIssue2(2,intCLoop)="I" and vArrIssue2(3,intCLoop)<>"" THEN '링크타입 체크
                                vLink2 = "location.href='" & vArrIssue2(3,intCLoop) & "';"
                            ELSE
                                ''vLink2 = """ onClick=""TnGotoEventMain('" & vArrIssue2(0,intCLoop) & "'); return false;"
                                vLink2 = "/event/eventmain.asp?eventid="&vArrIssue2(0,intCLoop)&"&pEtr="&eCode  ''2018/04/30
                            END If
                        %>
                        <li>
                            <a href="<%=vLink2%>">
                                <div class="pPhoto">
                                    <img src="<%=vArrIssue2(6,intCLoop)%>" alt="<%=db2html(vName2)%>" />
                                </div>
                                <div class="pdtCont">
                                    <div class="inner">
                                        <p class="pName"><%=db2html(vName2)%></p>
                                        <p class="pDesc"><%=vArrIssue2(7,intCLoop)%></p>
                                        <div class="pTag">
                                            <% If vSale2 <>"" Then %><span class="color-red"><%=db2html(vSale2)%></span><% End If %>
                                            <% If vArrIssue2(5,intCLoop) Then %><span class="color-green">쿠폰</span><% End If %>
                                            <% If vArrIssue2(8,intCLoop) Then %><span class="color-blue">GIFT</span><% End If %>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <% Next %>
                        <% End If %>
                        <% For intCLoop = 0 To UBound(vArrIssue,2)
                            vSale = ""
                            vName = ""
                            If vArrIssue(4,intCLoop) Or vArrIssue(5,intCLoop) Then '//issale ,  iscoupon
                                if ubound(Split(vArrIssue(1,intCLoop),"|"))> 0 Then
                                    If vArrIssue(4,intCLoop) Or (vArrIssue(4,intCLoop) And vArrIssue(5,intCLoop)) then
                                        vName   = cStr(Split(vArrIssue(1,intCLoop),"|")(0))
                                        vSale   = cStr(Split(vArrIssue(1,intCLoop),"|")(1))
                                    ElseIf vArrIssue(5,intCLoop) Then
                                        vName   = cStr(Split(vArrIssue(1,intCLoop),"|")(0))
                                        vSale   = cStr(Split(vArrIssue(1,intCLoop),"|")(1))
                                    End If
                                Else
                                    vName = vArrIssue(1,intCLoop)
                                end If
                            Else
                                vName = vArrIssue(1,intCLoop)
                            End If

                            IF vArrIssue(2,intCLoop)="I" and vArrIssue(3,intCLoop)<>"" THEN '링크타입 체크
                                vLink = "location.href='" & vArrIssue(3,intCLoop) & "';"
                            ELSE
                                ''vLink = """ onClick=""TnGotoEventMain('" & vArrIssue(0,intCLoop) & "'); return false;"
                                vLink = "/event/eventmain.asp?eventid="&vArrIssue(0,intCLoop)&"&pEtr="&eCode  ''2018/04/30
                            END If
                        %>
                        <li>
                            <a href="<%=vLink%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_event_recent_list','eventkind|eventcode|eventtype|categoryname|move_eventcode|list_number','<%=ekind%>|<%=eCode%>|<%=evt_type%>|<%=vAmplitudeCategoryName%>|<%=vArrIssue(0,intCLoop)%>|<%=intCLoop+1%>');">
                                <div class="pPhoto">
                                    <img src="<%=vArrIssue(6,intCLoop)%>" alt="<%=db2html(vName)%>" />
                                </div>
                                <div class="pdtCont">
                                    <div class="inner">
                                        <p class="pName"><%=db2html(vName)%></p>
                                        <p class="pDesc"><%=vArrIssue(7,intCLoop)%></p>
                                        <div class="pTag">
                                            <% If vSale <>"" Then %><span class="color-red"><%=db2html(vSale)%></span><% End If %>
                                            <% If vArrIssue(5,intCLoop) Then %><span class="color-green">쿠폰</span><% End If %>
                                            <% If vArrIssue(8,intCLoop) Then %><span class="color-blue">GIFT</span><% End If %>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <% Next %>

                    </ul>
                </div>
            </div>
        </div>
        <% End If %>
        <% End If %>
        <% End If %>
    </div>
    <!-- //contents -->
    <script>
        function jsDownCoupon(stype,idx){
        <% IF IsUserLoginOK THEN %>
        var frm;
            frm = document.frmC;
            //frm.target = "iframecoupon";
            frm.action = "/shoppingtoday/couponshop_process.asp";
            frm.stype.value = stype;
            frm.idx.value = idx;
            frm.submit();
        <%ELSE%>
            if(confirm("로그인하시겠습니까?")) {
                self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
            }
        <%END IF%>
        }

        function jsevtlogin(){
            if(confirm("로그인 후에 응모하실 수 있습니다.")) {
                self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
            }
        }

        //' 일단 하단데 v2 버전으로 생성
        function parent_kakaolink(label , imageurl , width , height , linkurl ){
            //카카오 SNS 공유
            Kakao.init('c967f6e67b0492478080bcf386390fdd');

            Kakao.Link.sendTalkLink({
                label: label,
                image: {
                src: imageurl,
                width: width,
                height: height
                },
                webButton: {
                    text: '10x10 바로가기',
                    url: linkurl
                }
            });
        }

        //카카오 SNS 공유 v2.0
        function event_sendkakao(label , description , imageurl , linkurl){
            Kakao.Link.sendDefault({
                objectType: 'feed',
                content: {
                  title: label,
                  description : description,
                  imageUrl: imageurl,
                  link: {
                    mobileWebUrl: linkurl
                  }
                },
                buttons: [
                  {
                    title: '웹으로 보기',
                    link: {
                      mobileWebUrl: linkurl
                    }
                  }
                ]
            });
        }
    </script>
    <form name="frmC" method="post">
        <input type="hidden" name="stype" value="">
        <input type="hidden" name="idx" value="">
    </form>
    <!-- #include virtual="/common/LayerShare.asp" -->
    <iframe src="about:blank" name="iframecoupon" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
    <iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
    <% If requestCheckVar(Request("comm"),1) = "o" Then %>
    <script>$('html, body').animate({ scrollTop: $(".replyList").offset().top }, 0)</script>
    <% End If %>
    <script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
    <% If slide_m_flag = "Y" Then '// slide template %>
    <script type="text/javascript">
        $(function(){
            slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
                loop:true,
                autoplay:3000,
                autoplayDisableOnInteraction:false,
                speed:800,
                pagination:".slideTemplateV15 .pagination",
                paginationClickable:true,
                nextButton:'.slideTemplateV15 .btnNext',
                prevButton:'.slideTemplateV15 .btnPrev'
            });
        });
    </script>
    <% End If %>
    <script>
    <%
        dim apitest : apitest = true
        dim apiurl : apiurl = ""
        IF application("Svr_Info") = "Dev" THEN
            apiurl = "//testfapi.10x10.co.kr/api/web/v1/event/items-v2"
            //apiurl = "//localhost:8080/api/web/v1/event/items-v2"
        Else
            apiurl = "//fapi.10x10.co.kr/api/web/v1/event/items-v2"
        End If

        if apitest then
    %>
        var itemparam = "?eventid=<%=eCode%>&eventGroupCode=<%=egCode%>&itemsort=<%=eitemsort%>&listtype=<%=eItemListType%>&themebarcolor=<%=replace(ThemeBarColorCode,"#","")%>&ekind=<%=ekind%>&eventtype=<%=evt_type%>&pNtr=<%=server.URLEncode(searchback_Param)%>&userid=<%= GetLoginUserID %>";

        var dataObject = {
            eventid : <%=eCode%>,
            logparam : "&pEtr=<%=eCode%>",
            addparam : "&pNtr=<%=server.URLEncode(searchback_Param)%>",
            eventkind : "<%=ekind%>",
            eventtype : "<%=evt_type%>",
            listtype : "<%=eItemListType%>",
        }

        var data_itemlist = "<%=apiurl%>"+itemparam;
    <% else %>
        var itemparam = "?eventid=<%=eCode%>&eGC=<%=egCode%>&itemsort=<%=eitemsort%>&listtype=<%=eItemListType%>&themebarcolor=<%=replace(ThemeBarColorCode,"#","")%>&ekind=<%=ekind%>&eventtype=<%=evt_type%>&pNtr=<%=server.URLEncode(searchback_Param)%>";

        var data_itemlist = "/event/lib/act_eventgroupjson.asp"+itemparam;
    <% end if %>
    </script>
    <script src="/event/lib/eventgroupitemlist2021.js?v=1.09"></script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->