<%
''2016/08/04 (pggubun 검사 NPay 관련)
function fnGetPgGubun(iorderserial)
    dim sqlStr

    fnGetPgGubun=""
    if (iorderserial="") then Exit function

    sqlStr = "exec [db_cs].[dbo].sp_Ten_getPgGubunByOrderserial '" & iorderserial & "'"

    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
    if  not rsget.EOF  then
        fnGetPgGubun = rsget("pggubun")
    end if
    rsget.close
end function

function getHisRegedCsCount(iuserid,iorderserial,idivcd)
    dim sqlStr, retCnt : retCnt=0

    if (iorderserial="") and (iuserid="") then
        getHisRegedCsCount = retCnt
        exit function
    end if

    sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsCount 1,'" & iuserid & "','" & iorderserial & "','" & idivcd & "' "

    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
    if  not rsget.EOF  then
        retCnt = rsget("cnt")
    end if
    rsget.close

    getHisRegedCsCount = retCnt
end function

function GetOneDeliveryInfo(byval idivcd, byval isongjangNo, byRef iDlvName, byRef iLinkUrl, byref iTelInfo)
    dim sqlStr

    GetOneDeliveryInfo = False
    if IsNULL(idivcd) or (idivcd="") then Exit function

    sqlStr = "exec db_order.dbo.sp_Ten_OneDeliveryInfo " & CStr(idivcd)
    rsget.Open sqlStr,dbget,1
    if  not rsget.EOF  then
        iDlvName = db2Html(rsget("divname"))
        iLinkUrl = db2Html(rsget("findurl"))
        iTelInfo = db2Html(rsget("tel"))
    end if
    rsget.Close

    if (iLinkUrl<>"") then
        iLinkUrl = iLinkUrl & replace(replace(isongjangNo,"-","")," ","")
    end if

    GetOneDeliveryInfo = True
end function

function drawSelectBoxCSCommCombo(selectBoxName,selectedId,groupCode,onChangefunction)
   dim tmp_str,sqlStr
   %>
     <select name="<%=selectBoxName%>" <%= onChangefunction %> >
     <option value='' <%if selectedId="" then response.write " selected" %> >선택</option>
   <%
       sqlStr = " select comm_cd,comm_name "
       sqlStr = sqlStr + " from  "
       sqlStr = sqlStr + " [db_cs].[dbo].tbl_cs_comm_code "
       sqlStr = sqlStr + " where comm_group='" + groupCode + "' "
       sqlStr = sqlStr + " and comm_isDel='N' "
       sqlStr = sqlStr + " order by comm_cd "

       rsget.Open sqlStr,dbget,1

       if  not rsget.EOF  then
           do until rsget.EOF
               if LCase(selectedId) = LCase(rsget("comm_cd")) then
                   tmp_str = " selected"
               end if
               response.write("<option value='" & rsget("comm_cd") & "' " & tmp_str & ">" + db2html(rsget("comm_name")) + " </option>")
               tmp_str = ""
               rsget.MoveNext
           loop
       end if
       rsget.close
   %>
       </select>
   <%
End function

function drawSelectBoxCancelTypeBox(selectBoxName,selectedId,orgPaymethod,divcd,onChangefunction)
    dim BufStr, selectStr
    BufStr = "<select name='returnmethod' " + onChangefunction + ">"
    BufStr = BufStr + "<option value=''>선택</option>"
    if (orgPaymethod="100")  then
        if (selectedId="R100") then selectStr="selected"
        BufStr = BufStr + "<option value='R100' " + selectStr + ">신용카드 취소</option>"
    elseif (orgPaymethod="20")  then
        if (selectedId="R020") then selectStr="selected"
        BufStr = BufStr + "<option value='R020' " + selectStr + ">실시간이체 취소</option>"
    elseif (orgPaymethod="80")  then
        if (selectedId="R080") then selectStr="selected"
        BufStr = BufStr + "<option value='R080' " + selectStr + ">All@카드 취소</option>"
    elseif (orgPaymethod="50") then
        if (selectedId="R050") then selectStr="selected"
        BufStr = BufStr + "<option value='R050' " + selectStr + ">입점몰결제 취소</option>"
    elseif (orgPaymethod="150") then
        if (selectedId="R150") then selectStr="selected"
        BufStr = BufStr + "<option value='R150' " + selectStr + ">이니렌탈 취소</option>"
    end if

    selectStr = ""

    if (selectedId="R007") then selectStr="selected"
    BufStr = BufStr + "<option value='R007' " + selectStr + ">무통장 환불</option>"

    selectStr = ""

    if (selectedId="R900") then selectStr="selected"
    BufStr = BufStr + "<option value='R900' " + selectStr + ">마일리지 환급</option>"
    BufStr = BufStr + "</select>"

    response.write BufStr
end function


''취소 프로세스
public function fnIsCancelProcess(idivcd)
    fnIsCancelProcess = (idivcd = "A008")
end function

''반품 프로세스
public function fnIsReturnProcess(idivcd)
    fnIsReturnProcess = (idivcd = "A004") or (idivcd = "A010")
end function


''브랜드별 CS 메모
Class CCSBrandMemo
    public Fbrandid

	public Fis_return_allow

	public Fvacation_startday
	public Fvacation_endday

	public Ftel_start
	public Ftel_end

	public Fis_saturday_work

	public Fbrand_comment

	public Flast_modifyday

	public Fbeasongneedday
	public Fbeasong_comment
	public Fbeasong_modifyday

	public Fbeasong_reguserid

	public Freturn_comment
	public Freturn_modifyday
	public Freturn_reguserid

	public FcsName
	public FcsPhone
	public Fcshp
	public FcsEmail
	public FcsModifyDay
	public FcsReguserID

	public Flunch_start
	public Flunch_end
	public Fvacation_div
    public Fcustomer_return_deny

    public FRectMakerid

    public sub GetBrandMemo()
        dim sqlStr

        sqlStr = " select brandid, is_return_allow, vacation_startday, vacation_endday, tel_start, tel_end, is_saturday_work, brand_comment, last_modifyday, beasongneedday, beasong_comment, beasong_modifyday, beasong_reguserid "
		sqlStr = sqlStr + " , return_comment, return_modifyday, return_reguserid, cs_name, cs_phone, cs_hp, cs_email, lunch_start, lunch_end, vacation_div, cs_modifyday, cs_reguserid, IsNull(customer_return_deny, 'N') as customer_return_deny "
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_cs_brand_memo "
        sqlStr = sqlStr + " where brandid='" + FRectMakerid + "'"
        rsget.CursorLocation = adUseClient
		rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

        Fcustomer_return_deny  	= "N"

        if Not rsget.Eof then
            Fbrandid         		= rsget("brandid")
            Fis_return_allow		= rsget("is_return_allow")
            Fvacation_startday  	= rsget("vacation_startday")
            Fvacation_endday     	= rsget("vacation_endday")
            Ftel_start         		= rsget("tel_start")
            Ftel_end         		= rsget("tel_end")
            Fis_saturday_work       = rsget("is_saturday_work")
            Fbrand_comment          = db2html(rsget("brand_comment"))
            Flast_modifyday         = rsget("last_modifyday")

			'// 미출고관련메모
            Fbeasongneedday         = rsget("beasongneedday")
            Fbeasong_comment        = db2html(rsget("beasong_comment"))
            Fbeasong_modifyday      = rsget("beasong_modifyday")
            Fbeasong_reguserid      = rsget("beasong_reguserid")

			'// 반품관련메모
            Freturn_comment     	= db2html(rsget("return_comment"))
            Freturn_modifyday   	= rsget("return_modifyday")
            Freturn_reguserid    	= rsget("return_reguserid")

			FcsName      			= rsget("cs_name")
			FcsPhone     			= rsget("cs_phone")
			Fcshp        			= rsget("cs_hp")
			FcsEmail     			= rsget("cs_email")
			FcsModifyDay   			= rsget("cs_modifyday")
			FcsReguserID   			= rsget("cs_reguserid")

			Flunch_start   			= rsget("lunch_start")
			Flunch_end     			= rsget("lunch_end")
			Fvacation_div  			= rsget("vacation_div")
            Fcustomer_return_deny  	= rsget("customer_return_deny")

        end if
        rsget.Close
    end sub

    Private Sub Class_Initialize()
        '
    End Sub

    Private Sub Class_Terminate()

    End Sub
end Class


''고객 회수, 맞교환.. 주소지정보
Class CCSDeliveryItem
    public Fasid
    public Freqname
    public Freqphone
    public Freqhp
    public Freqzipcode
    public Freqzipaddr
    public Freqetcaddr
    public Freqetcstr
    public Fsongjangdiv
    public Fsongjangno
    public Fregdate
    public Fsenddate


    Private Sub Class_Initialize()

    End Sub

    Private Sub Class_Terminate()

    End Sub
end Class


''반품 주소지 정보
Class CCSReturnAddress
    public FreturnName
    public FreturnPhone
    public Freturnhp
    public FreturnZipcode
    public FreturnZipaddr
    public FreturnEtcaddr
    public Fsongjangdiv
    public Fsongjangno

    public FRectMakerid

	Public Fsj_name
	Public Fsj_tel

    public FResultCount

    public sub GetReturnAddress()
        dim sqlStr
        sqlStr = " select company_name, deliver_phone, deliver_hp, return_zipcode, return_address, return_address2"
        sqlStr = sqlStr + " , b.divname sj_name, b.tel sj_tel"
        sqlStr = sqlStr + " from [db_partner].[dbo].tbl_partner a "
        sqlStr = sqlStr + "     left join db_order.dbo.tbl_songjang_div b "
        sqlStr = sqlStr + "     on a.defaultsongjangdiv = b.divcd "
        sqlStr = sqlStr + " where a.id='" + FRectMakerid + "'"

        rsget.Open sqlStr, dbget, 1

        FResultCount = rsget.RecordCount

        if Not rsget.Eof then
            FreturnName      = db2html(rsget("company_name"))
            FreturnPhone     = db2html(rsget("deliver_phone"))
            Freturnhp        = db2html(rsget("deliver_hp"))
            FreturnZipcode   = rsget("return_zipcode")
            FreturnZipaddr   = db2html(rsget("return_address"))
            FreturnEtcaddr   = db2html(rsget("return_address2"))
            Fsongjangdiv     = ""
            Fsongjangno      = ""

            Fsj_name   = rsget("sj_name")
            Fsj_tel   = rsget("sj_tel")

		end if
        rsget.Close
    end sub

    Private Sub Class_Initialize()
        FreturnName     = "(주)텐바이텐"
        FreturnPhone    = "1644-6030"
        Freturnhp       = ""
        FreturnZipcode  = "132-010"
        FreturnZipaddr  = "서울 도봉구"
        FreturnEtcaddr  = "도봉동 63번지 여인닷컴 3층"
        Fsongjangdiv    = "24"
        Fsongjangno     = ""

    End Sub

    Private Sub Class_Terminate()

    End Sub
end Class


Class CCSASDetailItem
    ''tbl_as_detail's
    public Fid
    public Fmasterid
    public Fgubun01
    public Fgubun02
    public Fgubun01name
    public Fgubun02name
    public Fregdetailstate
    public Fregitemno
    public Fconfirmitemno
    public Fcausediv
    public Fcausedetail
    public Fcausecontent

    ''tbl_order_detail's
    public Forderdetailidx
    public Forderserial
    public Fitemid
    public Fitemoption
    public Fmakerid
    public Fitemname
    public Fitemoptionname
    public Fitemcost
    public FdiscountAssingedCost
	public FreducedPrice
	public FetcDiscount
    public Fbuycash
    public Fitemno
    public Fisupchebeasong
    public Fcancelyn
    public Fcurrstate
    public Frequiredetail
    public Fmileage
    public Foitemdiv
    public Fissailitem
    public Fitemcouponidx
    public Fbonuscouponidx

    public ForderDetailcurrstate
    public FAllAtDiscountedPrice

    ''tbl_item's
    public FSmallImage
    public FIcon1Image
    public FBasicImage
    public FbrandName
    public FItemDiv

	Public FDeliveryName
	Public FDeliveryTel
	Public FsongjangNo
	Public FasId
	Public FPojangok
	Public FIsPacked

    ''2013/12/30 추가
    public function getReducedPrice()
        getReducedPrice = FdiscountAssingedCost
    end function

    ''2013/12/30 추가
    public function IsSaleBonusCouponAssignedItem()
        IsSaleBonusCouponAssignedItem = (Fbonuscouponidx>0)
    end function

    ''All@ 할인된가격
    public function getAllAtDiscountedPrice()
        getAllAtDiscountedPrice =0
        ''기존 상품쿠폰 할인되는경우 추가할인없음.
        ''마일리지샾 상품 추가 할인 없음.
	    ''세일상품 추가할인 없음
	    '' 20070901추가 : 정율할인 보너스쿠폰사용시 추가할인 없음.

	    if (FdiscountAssingedCost=0) then
	        ''기존방식
            if (Fitemcouponidx<>0) or (IsMileShopSangpum) or (Fissailitem="Y") then
    			getAllAtDiscountedPrice = 0
    		else
    			getAllAtDiscountedPrice = round(((1-0.94) * FItemCost / 100) * 100 ) * FItemNo
    		end if
    	else
    	    if (Fbonuscouponidx=0) and (Fitemcost>FdiscountAssingedCost) then
    	            getAllAtDiscountedPrice = Fitemcost-FdiscountAssingedCost
    	    else
    	        getAllAtDiscountedPrice = 0
    	    end if
    	end if
    end function

    '' %할인권 할인금액
    public function getPercentBonusCouponDiscountedPrice()
        getPercentBonusCouponDiscountedPrice = 0

        if (FdiscountAssingedCost=0) then
	        ''기존방식
	        ''getPercentBonusCouponDiscountedPrice = Fitemcost*

	    else
            if (Fbonuscouponidx<>0) and (Fitemcost>FdiscountAssingedCost) then
                getPercentBonusCouponDiscountedPrice = Fitemcost-FdiscountAssingedCost
            end if
        end if
    end function

	public function GetBonusCouponDiscountPrice()
		GetBonusCouponDiscountPrice = Fitemcost - (FreducedPrice + FetcDiscount)
	end function

	public function GetEtcDiscountDiscountPrice()
		GetEtcDiscountDiscountPrice = FetcDiscount
	end function

    ''마일리지샵 상품
    public function IsMileShopSangpum()
		IsMileShopSangpum = false

		if Foitemdiv="82" then
			IsMileShopSangpum = true
		end if
	end function

    public function GetDefaultRegNo(IsRegState)
        if (IsRegState) then
            GetDefaultRegNo = Fitemno
        else
            GetDefaultRegNo = Fregitemno
        end if
    end function

    ''CsAction 접수시 상품 갯수 수정 가능여부
    public function IsItemNoEditEnabled(byval idivcd)
        IsItemNoEditEnabled = false

        if (Fcancelyn="Y") then Exit function

        if (fnIsCancelProcess(idivcd)) then
            IsItemNoEditEnabled = true

            if (ForderDetailcurrstate>=7) then IsItemNoEditEnabled=false
        elseif (fnIsReturnProcess(idivcd)) then
            ''반품 접수
            if (ForderDetailcurrstate>=7) then IsItemNoEditEnabled=true

        else

        end if
    end function


    ''CsAction 접수시 상품별 체크 가능여부
    public function IsCheckAvailItem(byval iIpkumdiv, byval iMasterCancelYn, byval idivcd)
        IsCheckAvailItem = false

        if (Fcancelyn="Y") then Exit function
        if (iMasterCancelYn<>"N") then Exit function

        if (fnIsCancelProcess(idivcd)) then
            IsCheckAvailItem = true
            if (ForderDetailcurrstate>=7) then IsCheckAvailItem=false

        elseif (fnIsReturnProcess(idivcd)) then
            ''반품 접수
            if (ForderDetailcurrstate>=7) then IsCheckAvailItem=true
        elseif (idivcd="A006") then
            ''출고시 유의사항
            IsCheckAvailItem=true

            if (ForderDetailcurrstate>=7) then IsCheckAvailItem=false
        elseif (idivcd="A009") then
            ''기타사항(메모) - All case Avail
            IsCheckAvailItem=true
        else

        end if
    end function

    ''CsAction 접수시 상품별 디폴트 체크드
    public function IsDefaultCheckedItem(byval iIpkumdiv, byval iMasterCancelYn, byval idivcd, byval ckAll)
        IsDefaultCheckedItem =false

        if (Not IsCheckAvailItem(iIpkumdiv,iMasterCancelYn,idivcd)) then Exit function

        if (fnIsCancelProcess(idivcd)) then
            if (ckAll<>"") then
                IsDefaultCheckedItem = true
            else
                IsDefaultCheckedItem = false
            end if

            if (Fcancelyn="Y") or (iMasterCancelYn<>"N") then IsDefaultCheckedItem=false

            if (ForderDetailcurrstate>=3) then IsDefaultCheckedItem=false
        elseif (fnIsReturnProcess(idivcd)) then
            ''반품접수인경우 - No action
        elseif (idivcd="A006") then
            ''출고시 유의사항 - No action
        elseif (idivcd="A009") then
            ''기타사항(메모) - No action
        else

        end if
    end function


    public function CancelStateStr()
		CancelStateStr = "정상"

		if Fcancelyn="Y" then
			CancelStateStr ="취소"
		elseif Fcancelyn="D" then
			CancelStateStr ="삭제"
		elseif Fcancelyn="A" then
			CancelStateStr ="추가"
		end if
	end function

	public function CancelStateColor()
		CancelStateColor = "#000000"

		if Fcancelyn="Y" then
			CancelStateColor ="#FF0000"
		elseif Fcancelyn="D" then
			CancelStateColor ="#FF0000"
		elseif Fcancelyn="A" then
			CancelStateColor ="#0000FF"
		end if
	end function

	''order Detail's State Name : 현상태
	Public function GetStateName()
        if ForderDetailcurrstate="2" then
            if (Fisupchebeasong="Y") then
		        GetStateName = "업체통보"
		    else
		        GetStateName = "물류통보"
		    end if
	    elseif ForderDetailcurrstate="3" then
		    GetStateName = "상품준비"
	    elseif ForderDetailcurrstate="7" then
		    GetStateName = "출고완료"
	    else
		    GetStateName = ForderDetailcurrstate
	    end if
	end Function

	'' 등록시 상태..
	Public function GetRegDetailStateName()
        if (Fregdetailstate="2") then
            if (Fisupchebeasong="Y") then
		        GetRegDetailStateName = "업체통보"
		    else
		        GetRegDetailStateName = "물류통보"
		    end if
	    elseif Fregdetailstate="3" then
		    GetRegDetailStateName = "상품준비"
	    elseif Fregdetailstate="7" then
		    GetRegDetailStateName = "출고완료"
	    else
		    GetRegDetailStateName = Fregdetailstate
	    end if
	end Function

	''order Detail's State color
	public function GetStateColor()
	    if ForderDetailcurrstate="2" then
			GetStateColor="#000000"
		elseif ForderDetailcurrstate="3" then
			GetStateColor="#CC9933"
		elseif ForderDetailcurrstate="7" then
			GetStateColor="#FF0000"
		else
			GetStateColor="#000000"
		end if
	end function

    Private Sub Class_Initialize()

    End Sub

    Private Sub Class_Terminate()

    End Sub
end Class

Class CCSASRefundInfoItem
    public Fasid

    public Forgsubtotalprice    ''원 주문 결제액
    public Forgitemcostsum      ''원 주문 상품합계
    public Forgbeasongpay       ''원 주문 배송료
    public Forgmileagesum       ''원 주문 사용마일리지
    public Forgcouponsum        ''원 주문 사용쿠폰
    public Forgallatdiscountsum ''원 주문 올엣할인

    public Frefundrequire       ''환불요청액
    public Frefundresult        ''환불  금액
    public Freturnmethod        ''환불  방식

    public Frefundmileagesum    ''취소  마일리지 Frefundmileagesum
    public Frefundcouponsum     ''취소  쿠폰     Frefundcouponsum
    public Fallatsubtractsum    ''취소  카드할인 Fallatsubtractsum

    public Frefunditemcostsum   ''취소 상품합계
    public Frefundbeasongpay    ''취소시 배송비 차감액
    public Frefunddeliverypay   ''취소시 회수 배송비? -> Freturndeliverypay
    public Frefundadjustpay     ''취소시 기타 보정액
    public Fcanceltotal         ''총 취소액

    public Frefundgiftcardsum	''기프트카드
    public Frefunddepositsum	''예치금

    public Frebankname          ''환불 은행
    public Frebankaccount       ''환불 계좌
    public Frebankownername     ''예금 주
    public FpaygateTid          ''Pg사 T id
    public FencMethod           ''암호화방식
    public FdecAccount          ''암호화계좌번호

    public FpaygateresultTid
    public FpaygateresultMsg

    public FreturnmethodName    ''환불방식명

    public rebankCode

    public FtotalMayRefundSum   '' Sum(case when Frefundresult=0 then Frefundrequire else Frefundresult end)


    Private Sub Class_Initialize()

    End Sub

    Private Sub Class_Terminate()

    End Sub
End Class

Class CCSASMasterItem

    public Fid
    public Fdivcd
    public Fgubun01
    public Fgubun02

    public FdivcdName
    public Fgubun01Name
    public Fgubun02Name

    public FdivcdColor
    public Fgubun01Color
    public Fgubun02Color

    public Forderserial
    public Fcustomername
    public Fuserid
    public Fwriteuser
    public Ffinishuser
    public Ftitle
    public Fcontents_jupsu
    public Fcontents_finish
    public Fcurrstate
    public FcurrstateName
    public FcurrstateColor
    public Fregdate
    public Ffinishdate

    public Fsongjangdiv
	Public FsongjangdivName
    public Fsongjangno
    public Fbeasongdate

    public Frequireupche
    public Fmakerid
    public Fdeleteyn
    public Fextsitename

    '' tbl_as_refund_info's
    public Frefundrequire       ''환불요청액
    public Frefundresult        ''환불  금액
    public Freturnmethod        ''환불  방식
	Public FreturnMethodName

    public Frebankname          ''환불 은행
    public Frebankaccount       ''환불 계좌
    public Frebankownername     ''예금 주
    public FencMethod           ''암호화방식
    public FdecAccount          ''암호화계좌번호

	Public Frefundcouponsum		' 쿠폰할인차감
	Public Frefundmileagesum	' 마일리지차감
	Public Frefundbeasongpay	' 배송비 차감
	Public Frefunddeliverypay	' 배송비 차감

	Public Frefunddepositsum	' 예치금차감
    public Frefundgiftcardsum	'기프트카드

    public Fopentitle           ''고객 오픈 Title
    public Fopencontents        ''고객 오픈 내용
    public Fsitegubun           '' 10x10 or theFingers

    public Faddmethod			''고객추가배송비(추가방법)
    public Faddbeasongpay		''배송비
    public Freceiveyn			''회수여부
    public Frealbeasongpay		''실제받은 배송비

    public FMitemname
    public FErrMsg

    public function GetCustomerBeasongPayAddMethod()
        if (Faddmethod="1") then
            GetCustomerBeasongPayAddMethod = "박스동봉"
		elseif (Faddmethod="2") then
			GetCustomerBeasongPayAddMethod = "택배비 고객부담"
		elseif (Faddmethod="5") then
			GetCustomerBeasongPayAddMethod = "기타"
		else
			GetCustomerBeasongPayAddMethod = "--"
		end if
    end function

    public function IsCsUserCancelRequire()
        IsCsUserCancelRequire = ((Fcurrstate<"B007") and (Fdivcd="A008"))
    end function

    public function IsAsRegAvail(byval iIpkumdiv, byval iCancelYn, byref descMsg)
        IsAsRegAvail = false

        if (IsCancelProcess) then
            IsAsRegAvail = false

            if (iCancelYn<>"N") then
                IsAsRegAvail = false
                descMsg      = "이미 취소된 거래입니다. - 취소 불가능 "
                exit function
            end if

            IsAsRegAvail = true

        elseif (IsReturnProcess) then
            if Not ((iIpkumdiv=6) or (iIpkumdiv=7)) then
                IsAsRegAvail = false
                descMsg      = "출고 완료/ 일부 출고 상태가 아닙니다. - 반품 접수 불가능 "
                exit function
            end if

            if (iCancelYn<>"N") then
                IsAsRegAvail = false
                descMsg      = "취소된 거래입니다. - 반품 접수 불가능 "
                exit function
            end if

            IsAsRegAvail = true
        elseif (Fdivcd = "A006") then
            '' 출고시 유의사항
            IsAsRegAvail = true

            if (iIpkumdiv>=7) then
                IsAsRegAvail = false
                descMsg      = "출고 이전 상태가 아닙니다. - 출고시 유의사항 접수 불가능 "
                exit function
            end if
        elseif (Fdivcd = "A009") then
            '' 기타사항
            IsAsRegAvail = true
        else
            descMsg = "정의 되지 않았습니다." + Fdivcd
        end if

    end function

    ''취소 프로세스
    public function IsCancelProcess()
        IsCancelProcess = fnIsCancelProcess(Fdivcd)
    end function

    ''반품 프로세스
    public function IsReturnProcess()
        IsReturnProcess = fnIsReturnProcess(Fdivcd)
    end function

    public function IsRefundProcessRequire(iIpkumdiv, iCancelyn)
        FErrMsg = ""
        IsRefundProcessRequire = False

        if (iCancelyn ="Y") or (iCancelyn ="D") then Exit function

        if (iIpkumdiv<4) then  Exit function

        '' 취소, 반품접수
        IsRefundProcessRequire = (IsCancelProcess) or (IsReturnProcess)
    end function

    ''송장 필드가 필요한 정보
    public function IsRequireSongjangNO()
        IsRequireSongjangNO = false

        IsRequireSongjangNO = (Fdivcd="0") or (Fdivcd="1") or (Fdivcd="2") or (Fdivcd="4") or (Fdivcd="10") or (Fdivcd="11")
    end function

    public function GetAsDivCDName()
        GetAsDivCDName = FdivcdName


    end function

    public function GetAsDivCDColor()
        GetAsDivCDColor = FdivcdName


    end function


    public function GetCurrstateName()
        GetCurrstateName = FcurrstateName
        ''업체 처리완료 시 수기
        if (Fcurrstate="B006") then
            if (Fdivcd="A004") then
                GetCurrstateName = "상품입고완료"
            end if
        end if

    end function

     public function GetCurrstateColor()
        GetCurrstateColor = FcurrstateColor
    end function

    public function GetCauseString()
        GetCauseString = Fgubun01Name
    end function

    public function GetCauseDetailString()
        GetCauseDetailString = Fgubun02Name
    end function



    Private Sub Class_Initialize()

    End Sub

    Private Sub Class_Terminate()

    End Sub
end Class

Class CCSASList
    public FItemList()
    public FOneItem

    public FCurrPage
    public FTotalPage
    public FPageSize
    public FResultCount
    public FScrollCount
    public FTotalCount

    public FRectUserID
    public FRectUserName
    public FRectOrderSerial
    public FRectStartDate
    public FRectEndDate
    public FRectSearchType
    public FRectIdx
    public FRectMakerid
    public FRectIdxArray
    public FRectitemidArray
	Public FRectDivCd	' CS AS접수구분

    public FRectCsAsID
    public FRectNotCsID
    ''
    public FDeliverPay
    public IsUpchebeasongExists
    public IsTenbeasongExists
	public FRectExcA003

    public Sub GetOneOldRefundSum()
        dim sqlStr
        sqlStr = "select sum(case when refundresult=0 then refundrequire else refundresult end) as totalMayRefundSum"
        sqlStr = sqlStr + " ,sum(refundrequire) as refundrequire, sum(refundresult) as refundresult"
        'sqlStr = sqlStr + " , orgsubtotalprice, orgitemcostsum, orgbeasongpay, orgmileagesum"
        'sqlStr = sqlStr + " , orgcouponsum, orgallatdiscountsum"
        sqlStr = sqlStr + " , sum(canceltotal) as canceltotal, sum(refunditemcostsum) as refunditemcostsum"
        sqlStr = sqlStr + " , sum(refundmileagesum) as refundmileagesum, sum(refundcouponsum) as refundcouponsum, sum(allatsubtractsum) as allatsubtractsum"
        sqlStr = sqlStr + " , sum(refundbeasongpay) as refundbeasongpay, sum(refunddeliverypay) as refunddeliverypay, sum(refundadjustpay) as refundadjustpay"
        sqlStr = sqlStr + " , sum(refundgiftcardsum) as refundgiftcardsum, sum(refunddepositsum) as refunddepositsum"

        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_as_refund_info r, "
        sqlStr = sqlStr + " [db_cs].[dbo].tbl_new_as_list a"
        sqlStr = sqlStr + " where a.orderserial='" + FRectOrderserial + "'"
        sqlStr = sqlStr + " and a.id=r.asid"
		if (FRectExcA003 = "Y") then
			sqlStr = sqlStr + " and a.divcd in ('A010', 'A004') "
		else
			sqlStr = sqlStr + " and a.divcd in ('A003', 'A010', 'A004') "			''환불접수, 회수신청(텐바이텐배송), 반품접수(업체배송)
		end if
        sqlStr = sqlStr + " and a.deleteyn='N'"
        sqlStr = sqlStr + " and r.returnmethod<>'R000'"     ''환불없음건

        rsget.Open sqlStr, dbget, 1

        FResultCount = rsget.RecordCount

        if Not rsget.Eof then
            set FOneItem = new CCSASRefundInfoItem
            FOneItem.FtotalMayRefundSum     = rsget("totalMayRefundSum")
            FOneItem.Frefundrequire         = rsget("refundrequire")
            FOneItem.Frefundresult          = rsget("refundresult")

            FOneItem.Fcanceltotal           = rsget("canceltotal")
            FOneItem.Frefunditemcostsum     = rsget("refunditemcostsum")
            FOneItem.Frefundmileagesum      = rsget("refundmileagesum")
            FOneItem.Frefundcouponsum       = rsget("refundcouponsum")
            FOneItem.Fallatsubtractsum      = rsget("allatsubtractsum")
            FOneItem.Frefundbeasongpay      = rsget("refundbeasongpay")
            FOneItem.Frefunddeliverypay     = rsget("refunddeliverypay")
            FOneItem.Frefundadjustpay       = rsget("refundadjustpay")

            FOneItem.Frefundgiftcardsum     = rsget("refundgiftcardsum")
            FOneItem.Frefunddepositsum      = rsget("refunddepositsum")


            if IsNULL(FOneItem.FtotalMayRefundSum) then FOneItem.FtotalMayRefundSum=0
            if IsNULL(FOneItem.Frefundrequire) then FOneItem.Frefundrequire=0
            if IsNULL(FOneItem.Frefundresult) then FOneItem.Frefundresult=0

            if IsNULL(FOneItem.Fcanceltotal) then FOneItem.Fcanceltotal=0
            if IsNULL(FOneItem.Frefunditemcostsum) then FOneItem.Frefunditemcostsum=0
            if IsNULL(FOneItem.Frefundmileagesum) then FOneItem.Frefundmileagesum=0
            if IsNULL(FOneItem.Frefundcouponsum) then FOneItem.Frefundcouponsum=0
            if IsNULL(FOneItem.Fallatsubtractsum) then FOneItem.Fallatsubtractsum=0
            if IsNULL(FOneItem.Frefundbeasongpay) then FOneItem.Frefundbeasongpay=0
            if IsNULL(FOneItem.Frefunddeliverypay) then FOneItem.Frefunddeliverypay=0
            if IsNULL(FOneItem.Frefundadjustpay) then FOneItem.Frefundadjustpay=0

            if IsNULL(FOneItem.Frefundgiftcardsum) then FOneItem.Frefundgiftcardsum=0
            if IsNULL(FOneItem.Frefunddepositsum) then FOneItem.Frefunddepositsum=0

        end if

        rsget.close
    end Sub

    public Sub GetHisOldRefundInfo()
        dim i,sqlStr

        sqlStr = " select count(asid) as cnt "
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_as_refund_info r, "
        sqlStr = sqlStr + " [db_cs].[dbo].tbl_new_as_list a"
        sqlStr = sqlStr + " where a.userid='" + FRectUserID + "'"
        sqlStr = sqlStr + " and a.id=r.asid"
        sqlStr = sqlStr + " and a.divcd='A003'"
        sqlStr = sqlStr + " and r.returnmethod='R007'"
        sqlStr = sqlStr + " and a.deleteyn='N'"


        rsget.Open sqlStr, dbget, 1
            FTotalCount = rsget("cnt")
        rsget.Close

        sqlStr = " select top " + CStr(FPageSize*FCurrPage)
        sqlStr = sqlStr + " r.refundrequire, r.rebankname, r.rebankaccount, r.rebankownername"
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_as_refund_info r, "
        sqlStr = sqlStr + " [db_cs].[dbo].tbl_new_as_list a"
        sqlStr = sqlStr + " where a.userid='" + FRectUserID + "'"
        sqlStr = sqlStr + " and a.id=r.asid"
        sqlStr = sqlStr + " and a.divcd='A003'"
        sqlStr = sqlStr + " and r.returnmethod='R007'"
        sqlStr = sqlStr + " and a.deleteyn='N'"
        sqlStr = sqlStr + " order by r.asid desc"

        rsget.pagesize = FPageSize
        rsget.Open sqlStr, dbget, 1

        FTotalPage =  CLng(FTotalCount\FPageSize)
		if ((FTotalCount\FPageSize)<>(FTotalCount/FPageSize)) then
			FTotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if FResultCount<1 then FResultCount=0

		redim preserve FItemList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FItemList(i) = new CCSASRefundInfoItem

                FItemList(i).Frefundrequire         = rsget("refundrequire")
				FItemList(i).Frebankname            = rsget("rebankname")
                FItemList(i).Frebankaccount         = rsget("rebankaccount")
                FItemList(i).Frebankownername       = rsget("rebankownername")
                ''FItemList(i).FrebankCode            = rsget("rebankCode")
				rsget.moveNext
				i=i+1
			loop
		end if

		rsget.Close
    end Sub

    public Sub GetOneRefundInfo()
        dim i,sqlStr

        sqlStr = "select r.* "
        sqlStr = sqlStr + " ,C1.comm_name as returnmethodName"
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_as_refund_info r"
        sqlStr = sqlStr + "     left join [db_cs].[dbo].tbl_cs_comm_code C1"
        sqlStr = sqlStr + "     on C1.comm_group='Z090'"
        sqlStr = sqlStr + "     and r.returnmethod=C1.comm_cd"
        sqlStr = sqlStr + " where asid=" + CStr(FRectCsAsID)

        rsget.Open sqlStr, dbget, 1
        FResultCount = rsget.RecordCount

        set FOneItem = new CCSASRefundInfoItem
        if Not rsget.Eof then

            FOneItem.Fasid                  = rsget("asid")
            FOneItem.Forgsubtotalprice      = rsget("orgsubtotalprice")
            FOneItem.Forgitemcostsum        = rsget("orgitemcostsum")
            FOneItem.Forgbeasongpay         = rsget("orgbeasongpay")
            FOneItem.Forgmileagesum         = rsget("orgmileagesum")
            FOneItem.Forgcouponsum          = rsget("orgcouponsum")
            FOneItem.Forgallatdiscountsum   = rsget("orgallatdiscountsum")

            FOneItem.Frefundrequire         = rsget("refundrequire")
            FOneItem.Frefundresult          = rsget("refundresult")
            FOneItem.Freturnmethod          = rsget("returnmethod")

            FOneItem.Frefundmileagesum      = rsget("refundmileagesum")
            FOneItem.Frefundcouponsum       = rsget("refundcouponsum")
            FOneItem.Fallatsubtractsum      = rsget("allatsubtractsum")

            FOneItem.Frefunditemcostsum     = rsget("refunditemcostsum")
            FOneItem.Frefundbeasongpay      = rsget("refundbeasongpay")
            FOneItem.Frefunddeliverypay     = rsget("refunddeliverypay")
            FOneItem.Frefundadjustpay       = rsget("refundadjustpay")
            FOneItem.Fcanceltotal           = rsget("canceltotal")

            FOneItem.Frebankname            = rsget("rebankname")
            FOneItem.Frebankaccount         = rsget("rebankaccount")
            FOneItem.Frebankownername       = rsget("rebankownername")
            FOneItem.FpaygateTid            = rsget("paygateTid")

            FOneItem.FpaygateresultTid      = rsget("paygateresultTid")
            FOneItem.FpaygateresultMsg      = rsget("paygateresultMsg")


            FOneItem.FreturnmethodName               = rsget("returnmethodName")
        end if
        rsget.Close
    end Sub

    ''취소 요청 리스트가 존재하는지여부
    public function IsCSASCancelRequireListExists()
        dim i,sqlStr
        IsCSASCancelRequireListExists = false

        sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsCancelRequireCount 1,'" & FRectUserID & "','" & FRectOrderSerial & "'"

        rsget.Open sqlStr, dbget, 1

        if  not rsget.EOF  then
            IsCSASCancelRequireListExists = (rsget("cnt")>0)
        end if
        rsget.close

    end function

    ''취소 요청 리스트
    public Sub GetCSASCancelRequireList()
        dim i,sqlStr

        sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsCancelRequireCount 1,'" & FRectUserID & "','" & FRectOrderSerial & "'"

        rsget.Open sqlStr, dbget, 1

        if  not rsget.EOF  then
            FTotalCount = rsget("cnt")
        end if
        rsget.close

        sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsCancelRequireList " & CStr(FPageSize*FCurrPage) & ",1,'" & FRectUserID & "','" & FRectOrderSerial & "'"

        rsget.CursorLocation = adUseClient
        rsget.CursorType = adOpenStatic
        rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize

        rsget.Open sqlStr, dbget

        FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if FResultCount<1 then FResultCount=0

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            i = 0
			rsget.absolutepage = FCurrPage
            do until rsget.eof
                set FItemList(i) = new CCSASMasterItem

                FItemList(i).Fid                = rsget("id")
                FItemList(i).Fdivcd             = rsget("divcd")
                ''FItemList(i).FdivcdName         = db2html(rsget("divcdname"))

                FItemList(i).Forderserial       = rsget("orderserial")
                FItemList(i).Fcustomername      = db2html(rsget("customername"))
                FItemList(i).Fuserid            = rsget("userid")
                FItemList(i).Fwriteuser         = rsget("writeuser")
                FItemList(i).Ffinishuser        = rsget("finishuser")
                FItemList(i).Ftitle             = db2html(rsget("title"))
                FItemList(i).Fcurrstate         = rsget("currstate")

                FItemList(i).Fregdate           = rsget("regdate")
                FItemList(i).Ffinishdate        = rsget("finishdate")

                FItemList(i).Fopentitle         = db2html(rsget("opentitle"))
                FItemList(i).Fopencontents       = db2html(rsget("opencontents"))

                FItemList(i).Fgubun01           = rsget("gubun01")
                FItemList(i).Fgubun02           = rsget("gubun02")

                FItemList(i).Fdeleteyn          = rsget("deleteyn")

                FItemList(i).FMitemname         = db2html(rsget("Mitemname"))
                FItemList(i).FrefundRequire     = rsget("refundRequire")

                FItemList(i).Fgubun02Name       = db2html(rsget("gubun02Name"))
                rsget.MoveNext
                i = i + 1
            loop
        end if
        rsget.close
    end Sub

	' 마스터 리스트
    public Sub GetCSASMasterList()
        dim i,sqlStr, AddSQL

        sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsCount 1,'" & FRectUserID & "','" & FRectOrderSerial & "','" & FRectDivCd & "' "

        rsget.Open sqlStr, dbget, 1

        if  not rsget.EOF  then
            FTotalCount = rsget("cnt")
        end if
        rsget.close

        sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsList " & CStr(FPageSize*FCurrPage) & ",1,'" & FRectUserID & "','" & FRectOrderSerial & "','" & FRectDivCd & "' "

        rsget.CursorLocation = adUseClient
        rsget.CursorType = adOpenStatic
        rsget.LockType = adLockOptimistic
        rsget.pagesize = FPageSize

        rsget.Open sqlStr, dbget

        FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

        if FResultCount<1 then FResultCount=0

        redim preserve FItemList(FResultCount)
        if  not rsget.EOF  then
            i = 0
			rsget.absolutepage = FCurrPage
            do until rsget.eof
                set FItemList(i) = new CCSASMasterItem

                FItemList(i).Fid                = rsget("id")
                FItemList(i).Fdivcd             = rsget("divcd")
                FItemList(i).FdivcdName         = db2html(rsget("divcdname"))

                FItemList(i).Forderserial       = rsget("orderserial")
                FItemList(i).Fcustomername      = db2html(rsget("customername"))
                FItemList(i).Fuserid            = rsget("userid")
                FItemList(i).Fwriteuser         = rsget("writeuser")
                FItemList(i).Ffinishuser        = rsget("finishuser")
                FItemList(i).Ftitle             = db2html(rsget("title"))
                FItemList(i).Fcurrstate         = rsget("currstate")
                FItemList(i).FcurrstateName         = rsget("currstateName")

                FItemList(i).Fregdate           = rsget("regdate")
                FItemList(i).Ffinishdate        = rsget("finishdate")

                FItemList(i).Fopentitle         = db2html(rsget("opentitle"))
                FItemList(i).Fopencontents       = db2html(rsget("opencontents"))

                FItemList(i).Fgubun01           = rsget("gubun01")
                FItemList(i).Fgubun02           = rsget("gubun02")

                FItemList(i).Fdeleteyn          = rsget("deleteyn")


                rsget.MoveNext
                i = i + 1
            loop
        end if
        rsget.close
    end sub



    public Sub GetCSASTotalPrevCancelCount()
        dim i,sqlStr

        sqlStr = " select count(id) as cnt "
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_new_as_list "
        sqlStr = sqlStr + " where 1 = 1 "

        if (FRectOrderSerial <> "") then
                sqlStr = sqlStr + " and orderserial='" + CStr(FRectOrderSerial) + "' "
        end if

        sqlStr = sqlStr + " and deleteyn='N' and divcd in ('A003','A005','A007') "
        rsget.Open sqlStr, dbget, 1

        if  not rsget.EOF  then
                FResultCount = rsget("cnt")
        else
                FResultCount = 0
        end if
        rsget.close
    end sub

	' 마스터 하나
    public Sub GetOneCSASMaster()
        dim i,sqlStr

        sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsOne " & CStr(FRectCsAsID) & ",1,'" & FRectUserID & "','" & FRectOrderSerial & "'"
        rsget.CursorLocation = adUseClient
        rsget.CursorType = adOpenStatic
        rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FResultCount = rsget.RecordCount

		if (FResultCount < 1) then
			rsget.close
			Exit Sub
		end if

        if  not rsget.EOF  then
            set FOneItem = new CCSASMasterItem

            FOneItem.Fid                  = rsget("id")
            FOneItem.Fdivcd               = rsget("divcd")
            FOneItem.Fgubun01             = rsget("gubun01")
            FOneItem.Fgubun02             = rsget("gubun02")

            FOneItem.FdivcdName           = db2html(rsget("divcdname"))
            FOneItem.Fgubun01Name         = db2html(rsget("gubun01name"))
            FOneItem.Fgubun02Name         = db2html(rsget("gubun02name"))

            FOneItem.Forderserial         = rsget("orderserial")
            FOneItem.Fcustomername        = db2html(rsget("customername"))
            FOneItem.Fuserid              = rsget("userid")
            FOneItem.Fwriteuser           = rsget("writeuser")
            FOneItem.Ffinishuser          = rsget("finishuser")
            FOneItem.Ftitle               = db2html(rsget("title"))
            FOneItem.Fcontents_jupsu      = db2html(rsget("contents_jupsu"))
            FOneItem.Fcontents_finish     = db2html(rsget("contents_finish"))
            FOneItem.Fcurrstate           = rsget("currstate")
            FOneItem.FcurrstateName       = rsget("currstatename")
            FOneItem.FcurrstateColor      = rsget("currstateColor")

            FOneItem.Fregdate             = rsget("regdate")
            FOneItem.Ffinishdate          = rsget("finishdate")


            FOneItem.Fdeleteyn            = rsget("deleteyn")
            FOneItem.Fextsitename         = rsget("extsitename")

            FOneItem.Fopentitle           = db2html(rsget("opentitle"))
            FOneItem.Fopencontents        = db2html(rsget("opencontents"))


            FOneItem.Fsitegubun           = rsget("sitegubun")

            FOneItem.Fsongjangdiv         = rsget("songjangdiv")
            FOneItem.FsongjangdivName     = rsget("songjangdivName")
            FOneItem.Fsongjangno          = rsget("songjangno")

            FOneItem.Frefundrequire       = rsget("refundrequire")
            FOneItem.Frefundresult        = rsget("refundresult")

            FOneItem.Freturnmethod        = rsget("returnmethod")
            FOneItem.FreturnMethodName    = rsget("returnMethodName")

            FOneItem.Frebankname          = rsget("rebankname")
            FOneItem.Frebankaccount       = rsget("rebankaccount")
            FOneItem.Frebankownername     = rsget("rebankownername")
            FOneItem.FencMethod           = rsget("encmethod")
            FOneItem.FdecAccount          = rsget("decaccount")

            FOneItem.Frefundcouponsum     = rsget("refundcouponsum")
            FOneItem.Frefundmileagesum     = rsget("refundmileagesum")

            FOneItem.Frefunddepositsum     = rsget("refunddepositsum")
			FOneItem.Frefundgiftcardsum    = rsget("refundgiftcardsum")

            FOneItem.Frefundbeasongpay    = rsget("refundbeasongpay")
            FOneItem.Frefunddeliverypay    = rsget("refunddeliverypay")

        end if
        rsget.close
		'// 추가정보
        sqlStr = "exec [db_cs].[dbo].sp_Ten_CsAsOneAddInfo " & CStr(FRectCsAsID) & ",1,'" & FRectUserID & "','" & FRectOrderSerial & "'"

        rsget.CursorLocation = adUseClient
        rsget.CursorType = adOpenStatic
        rsget.LockType = adLockOptimistic
        rsget.Open sqlStr, dbget

        FResultCount = rsget.RecordCount

        if  (not rsget.EOF) and (FOneItem.Fid <> "")  then

			FOneItem.Faddmethod               = rsget("addmethod")
			FOneItem.Faddbeasongpay           = rsget("addbeasongpay")
			FOneItem.Freceiveyn               = rsget("receiveyn")
			FOneItem.Frealbeasongpay          = rsget("realbeasongpay")

        end if
        rsget.close

    end sub

	'반품신청 디테일 리스트
	'TODO : 반품CS완료시점으로 변경 필요(배송비관련)
	public Sub GetOrderDetailWithReturnDetail()
	    dim sqlStr, i

		sqlStr =	      " SELECT d.idx, d.itemid, d.itemoption, d.itemno, d.itemoptionname, d.itemcost," + VbCrlf
		sqlStr = sqlStr + " d.itemname, d.reducedPrice as discountAssingedCost, d.makerid, d.currstate, replace(d.songjangno,'-','') as songjangno, d.songjangdiv," + VbCrlf
		sqlStr = sqlStr + " d.cancelyn, d.isupchebeasong, d.mileage, d.requiredetail, d.oitemdiv, d.issailitem, d.itemcouponidx, d.bonuscouponidx," + VbCrlf
		sqlStr = sqlStr + " i.smallimage, i.basicimage, i.brandname, i.brandname, i.itemdiv, i.pojangok" + VbCrlf
		sqlStr = sqlStr + " ,s.divname,s.findurl, s.tel deliveryTel, p.asId " + VbCrlf
		sqlStr = sqlStr + " ,IsNULL(P.regno,0) as regitemno, d.reducedPrice, IsNull(d.etcDiscount,0) as etcDiscount " + VbCrlf
		sqlStr = sqlStr + " FROM [db_order].[dbo].tbl_order_detail d " + VbCrlf
		sqlStr = sqlStr + " JOIN [db_item].[dbo].tbl_item i" + VbCrlf
		sqlStr = sqlStr + "		ON d.itemid=i.itemid " + VbCrlf
		sqlStr = sqlStr + " LEFT JOIN db_order.[dbo].tbl_songjang_div s " + VbCrlf
		sqlStr = sqlStr + "		ON d.songjangdiv = s.divcd " + VbCrlf

		sqlStr = sqlStr + "	LEFT JOIN (" + VbCrlf
		sqlStr = sqlStr + "	    select d.itemid, d.itemoption, sum(confirmitemno) as regno, max(a.id) asId " + VbCrlf
        sqlStr = sqlStr + "	    from" + VbCrlf
        sqlStr = sqlStr + "	    [db_cs].[dbo].tbl_new_as_list a," + VbCrlf
        sqlStr = sqlStr + "	    [db_cs].[dbo].tbl_new_as_detail d" + VbCrlf
        sqlStr = sqlStr + "	    where a.id=d.masterid" + VbCrlf
        sqlStr = sqlStr + "	    and a.orderserial='" + CStr(FRectOrderserial) + "'" + VbCrlf
        sqlStr = sqlStr + "	    and a.divcd in ('A004','A010')" + VbCrlf
        sqlStr = sqlStr + "	    and a.deleteyn='N'" + VbCrlf
        sqlStr = sqlStr + "	    group by d.itemid, d.itemoption" + VbCrlf
        sqlStr = sqlStr + " ) P " + VbCrlf
        sqlStr = sqlStr + "     ON d.itemid=P.itemid and d.itemoption=P.itemoption" + VbCrlf

		sqlStr = sqlStr + " WHERE d.orderserial='" + CStr(FRectOrderserial) + "'" + VbCrlf
		if (FRectIdxArray<>"") then
		    sqlStr = sqlStr + " and d.idx in (" + CStr(FRectIdxArray) + ")" + VbCrlf
		end if
		if (FRectitemidArray<>"") then
		    sqlStr = sqlStr + " and d.itemid in (" + CStr(FRectitemidArray) + ")" + VbCrlf
		end if
		'sqlStr = sqlStr + " and d.itemid<>0" + VbCrlf						'배송비도 검색한다.
		sqlStr = sqlStr + " and d.cancelyn<>'Y'" + VbCrlf
		sqlStr = sqlStr + " order by i.deliverytype"

		rsget.Open sqlStr,dbget,1

		FTotalcount = rsget.Recordcount
		FResultcount = FTotalcount

        redim preserve FItemList(FTotalcount)

        if Not rsget.Eof then
			do until rsget.Eof
				set FItemList(i) = new CCSASDetailItem
				FItemList(i).Forderdetailidx = rsget("idx")
				FItemList(i).FOrderSerial    = FRectOrderserial
				FItemList(i).FItemId         = rsget("itemid")
				FItemList(i).FItemName       = db2html(rsget("itemname"))
				FItemList(i).FItemOption     = rsget("itemoption")
				FItemList(i).FItemNo         = rsget("itemno")
				FItemList(i).FItemOptionName = db2html(rsget("itemoptionname"))
				FItemList(i).FSmallImage     = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemID(FItemList(i).FItemId) + "/" + rsget("smallimage")
                FItemList(i).FBasicImage     = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemID(FItemList(i).FItemId) + "/" + rsget("basicimage")
				'FItemList(i).FSongJangNo     = rsget("songjangno")
				'FItemList(i).FSongjangDiv    = rsget("songjangdiv")
				FItemList(i).Fmakerid        = rsget("makerid")
				FItemList(i).Fbrandname      = db2html(rsget("brandname"))
				FItemList(i).FItemCost		 = rsget("itemcost")

				''반품시사용
				FItemList(i).FdiscountAssingedCost = rsget("discountAssingedCost")
				FItemList(i).FreducedPrice 			= rsget("reducedPrice")
				FItemList(i).FetcDiscount 			= rsget("etcDiscount")

				FItemList(i).FCurrState		 = rsget("currstate")
				FItemList(i).Fitemdiv		 = rsget("itemdiv")
				FItemList(i).FCancelYn       = rsget("cancelyn")
				FItemList(i).Fisupchebeasong = rsget("isupchebeasong")
                FItemList(i).Frequiredetail = db2html(rsget("requiredetail"))
				FItemList(i).FMileage		= rsget("mileage")

				'FItemList(i).FDeliveryName	 = rsget("divname")
				'FItemList(i).FDeliveryURL	 = rsget("findurl")
                FItemList(i).Foitemdiv       = rsget("oitemdiv")
				FItemList(i).FisSailitem     = rsget("issailitem")
				FItemList(i).Fitemcouponidx  = rsget("itemcouponidx")
				FItemList(i).Fbonuscouponidx = rsget("bonuscouponidx")

				'FItemList(i).FMasterSongJangNo   = FMasterItem.FSongjangNo

				FItemList(i).Fregitemno      = rsget("regitemno")

				FItemList(i).FDeliveryName	 = rsget("divname")
				FItemList(i).FSongJangNo     = rsget("songjangno")
				FItemList(i).FDeliveryTel	 = rsget("deliveryTel")
				FItemList(i).FasId			= rsget("asId")


				i=i+1
				rsget.movenext
			loop
		end if
		rsget.close
    end Sub

	'전체반품인가(고객이 반품수량을 최대로 했을 경우 기준)/텐배인가/업배인가/배송비는 얼마인가
	'전체반품은 기존 CS내역을 합산하여 계산한다.
	public Sub GetOrderDetailRefundBeasongPay(byref isallrefund, byref makeridbeasongpay, byval isupbea, byval beasongmakerid, byval orderserial, byval checkidx)
	    dim sqlStr, i

		sqlStr =	      " SELECT " + VbCrlf
		sqlStr = sqlStr + " 	IsNull(SUM(CASE " + VbCrlf
		sqlStr = sqlStr + " 			WHEN ('" & isupbea & "' = 'Y') and (d.itemid <> 0) and (d.makerid = '" & beasongmakerid & "') and (d.idx not in (" & checkidx & ")) and ((d.itemno - IsNULL(P.regno,0)) > 0) THEN 1 " + VbCrlf
		sqlStr = sqlStr + " 			WHEN ('" & isupbea & "' <> 'Y') and (d.itemid <> 0) and (d.isupchebeasong <> 'Y') and (d.idx not in (" & checkidx & ")) and ((d.itemno - IsNULL(P.regno,0)) > 0) THEN 1 " + VbCrlf
		sqlStr = sqlStr + " 			else 0 " + VbCrlf
		sqlStr = sqlStr + " 		end " + VbCrlf
		sqlStr = sqlStr + " 	), 0) as remainitemcount " + VbCrlf
		sqlStr = sqlStr + " 	, IsNull(SUM(CASE " + VbCrlf
		sqlStr = sqlStr + " 			WHEN ('" & isupbea & "' = 'Y') and (d.itemid = 0) and (d.makerid = '" & beasongmakerid & "') THEN d.itemcost " + VbCrlf
		sqlStr = sqlStr + " 			WHEN ('" & isupbea & "' <> 'Y') and (d.itemid = 0) and (IsNull(d.makerid, '') = '') THEN d.itemcost " + VbCrlf
		sqlStr = sqlStr + " 			else 0 " + VbCrlf
		sqlStr = sqlStr + " 		end " + VbCrlf
		sqlStr = sqlStr + " 	), 0) as makeridbeasongpay " + VbCrlf
		sqlStr = sqlStr + " FROM " + VbCrlf
		sqlStr = sqlStr + " 	[db_order].[dbo].tbl_order_detail d " + VbCrlf
		sqlStr = sqlStr + " 	LEFT JOIN ( " + VbCrlf
		sqlStr = sqlStr + " 		SELECT " + VbCrlf
		sqlStr = sqlStr + " 			d.itemid, d.itemoption, sum(confirmitemno) as regno, max(a.id) asId " + VbCrlf
		sqlStr = sqlStr + " 		FROM " + VbCrlf
		sqlStr = sqlStr + " 			[db_cs].[dbo].tbl_new_as_list a " + VbCrlf
		sqlStr = sqlStr + " 			, [db_cs].[dbo].tbl_new_as_detail d " + VbCrlf
		sqlStr = sqlStr + " 		WHERE " + VbCrlf
		sqlStr = sqlStr + " 			1 = 1 " + VbCrlf
		sqlStr = sqlStr + " 			and a.id = d.masterid " + VbCrlf
		sqlStr = sqlStr + " 			and a.orderserial = '" & orderserial & "' " + VbCrlf
		sqlStr = sqlStr + " 			and a.divcd in ('A004','A010') " + VbCrlf
		sqlStr = sqlStr + " 			and a.deleteyn = 'N' " + VbCrlf
		sqlStr = sqlStr + " 		group by " + VbCrlf
		sqlStr = sqlStr + " 			d.itemid, d.itemoption " + VbCrlf
		sqlStr = sqlStr + " 	) P " + VbCrlf
		sqlStr = sqlStr + " 	ON " + VbCrlf
		sqlStr = sqlStr + " 		1 = 1 " + VbCrlf
		sqlStr = sqlStr + " 		and d.itemid = P.itemid " + VbCrlf
		sqlStr = sqlStr + " 		and d.itemoption = P.itemoption " + VbCrlf
		sqlStr = sqlStr + " WHERE " + VbCrlf
		sqlStr = sqlStr + " 	1 = 1 " + VbCrlf
		sqlStr = sqlStr + " 	and d.orderserial='" & orderserial & "' " + VbCrlf
		sqlStr = sqlStr + " 	and d.cancelyn<>'Y' " + VbCrlf
		'response.write sqlStr

		rsget.Open sqlStr,dbget,1

		isallrefund = "N"
		makeridbeasongpay = 0
        if Not rsget.Eof then
        	if (rsget("remainitemcount") = 0) then
        		isallrefund = "Y"
        	end if

        	makeridbeasongpay = rsget("makeridbeasongpay")
		end if
		rsget.close
    end Sub

	public function getUpcheBeasongPayOneBrand(makerid)
		dim sqlStr
		dim i

		'텐텐배송비 : 2000
		if (makerid = "") then
            '// 텐텐배송 2500으로 변경
            If (Left(Now, 10) >= "2019-01-01") Then
			    getUpcheBeasongPayOneBrand = 2500
            Else
                getUpcheBeasongPayOneBrand = 2000
            End If
			exit function
		end if

		sqlStr = " select top 1 "
		sqlStr = sqlStr + " 	IsNull(b.defaultfreebeasonglimit, 0) as defaultfreebeasonglimit, IsNull(b.defaultdeliverpay, 0) as defaultdeliverpay "
		sqlStr = sqlStr + " from "
		sqlStr = sqlStr + " 	db_user.dbo.tbl_user_c b "
		sqlStr = sqlStr + " where "
		sqlStr = sqlStr + " 	1 = 1 "
		sqlStr = sqlStr + " 	and b.userid = '" & makerid & "' "

        'response.write sqlStr &"<br>"
		rsget.Open sqlStr,dbget,1

		if not rsget.eof then
			if (rsget("defaultfreebeasonglimit") = 0) then
				if (rsget("defaultdeliverpay") = 0) then
					'업체무료배송이고 기본배송비 설정 않되어 있으면 2000원
					getUpcheBeasongPayOneBrand = 2500
				else
					getUpcheBeasongPayOneBrand = rsget("defaultdeliverpay")
				end if
			else
				getUpcheBeasongPayOneBrand = rsget("defaultdeliverpay")
			end if
		else
            '// 텐텐배송 2500으로 변경
            If (Left(Now, 10) >= "2019-01-01") Then
			    getUpcheBeasongPayOneBrand = 2500
            Else
			    getUpcheBeasongPayOneBrand = 2000
            End If
		end if
		rsget.close
	end function

    public Sub GetOrderDetailByCsDetail()
        dim SqlStr, i

		sqlStr = "select d.idx as orderdetailidx, d.orderserial,d.itemid,d.itemoption,d.itemno,d.itemcost, d.buycash"
		sqlStr = sqlStr + " ,d.mileage,d.cancelyn "
		sqlStr = sqlStr + " ,d.itemname, d.makerid, d.itemoptionname "
		sqlStr = sqlStr + " ,d.currstate as orderdetailcurrstate, d.upcheconfirmdate, d.songjangdiv, d.songjangno"
		sqlStr = sqlStr + " ,d.beasongdate, d.isupchebeasong, d.issailitem , d.cancelyn "
		sqlStr = sqlStr + " ,d.oitemdiv, d.itemcouponidx"
		sqlStr = sqlStr + " ,c.id, c.masterid, IsNULL(c.regitemno,0) as regitemno, IsNULL(c.confirmitemno,0) as confirmitemno"
		sqlStr = sqlStr + " ,c.gubun01, c.gubun02, c.regdetailstate"
		sqlStr = sqlStr + " ,C2.comm_name as gubun01name, C3.comm_name as gubun02name"
		sqlStr = sqlStr + " ,i.smallimage, i.basicimage "

		sqlStr = sqlStr + " from [db_order].[dbo].tbl_order_detail d "
		sqlStr = sqlStr + " left join [db_item].[dbo].tbl_item i on d.itemid=i.itemid"
		sqlStr = sqlStr + " left join [db_cs].[dbo].tbl_new_as_detail c "
		sqlStr = sqlStr + " on c.masterid=" + CStr(FRectCsAsID) + ""
		sqlStr = sqlStr + " and c.orderdetailidx=d.idx "
		sqlStr = sqlStr + " Left Join [db_cs].[dbo].tbl_cs_comm_code C2"
        sqlStr = sqlStr + "  on c.gubun01=C2.comm_cd"
        sqlStr = sqlStr + " Left Join [db_cs].[dbo].tbl_cs_comm_code C3"
        sqlStr = sqlStr + "  on c.gubun02=C3.comm_cd"

		sqlStr = sqlStr + " where d.orderserial='" + CStr(FRectOrderSerial) + "'"

        sqlStr = sqlStr + " order by d.isupchebeasong, d.makerid, d.itemid, d.itemoption"

		rsget.Open sqlStr,dbget,1

		FTotalCount = rsget.RecordCount
		FResultCount = FTotalCount

		redim preserve FItemList(FResultCount)

		i=0
		do until rsget.eof
			set FItemList(i) = new CCSASDetailItem

            ''tbl_as_detail's
            FItemList(i).Fid              = rsget("id")
            FItemList(i).Fmasterid        = rsget("masterid")
            FItemList(i).Fgubun01         = rsget("gubun01")
            FItemList(i).Fgubun02         = rsget("gubun02")
            FItemList(i).Fregitemno       = rsget("regitemno")
            FItemList(i).Fconfirmitemno   = rsget("confirmitemno")
            FItemList(i).Fregdetailstate  = rsget("regdetailstate")
            'FItemList(i).Fcausecontent    = db2html(rsget("causecontent"))
            'FItemList(i).Fcausediv        = rsget("causediv")
            'FItemList(i).Fcausedetail     = rsget("causedetail")

            ''tbl_order_detail's
            FItemList(i).Forderdetailidx  = rsget("orderdetailidx")
            FItemList(i).Forderserial     = rsget("orderserial")
            FItemList(i).Fitemid          = rsget("itemid")
            FItemList(i).Fitemoption      = rsget("itemoption")
            FItemList(i).Fmakerid         = rsget("makerid")
            FItemList(i).Fitemname        = db2html(rsget("itemname"))
            FItemList(i).Fitemoptionname  = db2html(rsget("itemoptionname"))
            FItemList(i).Fitemcost        = rsget("itemcost")
            FItemList(i).Fbuycash         = rsget("buycash")
            FItemList(i).Fitemno          = rsget("itemno")
            FItemList(i).Fisupchebeasong  = rsget("isupchebeasong")
            FItemList(i).FCancelyn        = rsget("cancelyn")
            FItemList(i).ForderDetailcurrstate = rsget("orderdetailcurrstate")

            ''쿠폰 사용하거나, 마일리지샾 상품은 할인 안되었음.
            if (rsget("oitemdiv")="82") or (rsget("itemcouponidx")<>0) then
                FItemList(i).FAllAtDiscountedPrice = 0
            else
                FItemList(i).FAllAtDiscountedPrice = round(((1-0.94) * FItemList(i).Fitemcost / 100) * 100 )
            end if


            ''tbl_item's
            FItemList(i).FSmallImage      = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemID(FItemList(i).Fitemid) + "/" + rsget("smallimage")
            FItemList(i).FBasicImage      = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemID(FItemList(i).Fitemid) + "/" + rsget("basicimage")

            if (FItemList(i).Fitemid=0) then
                FDeliverPay          = FItemList(i).Fitemcost
            else
                IsUpchebeasongExists = IsUpchebeasongExists or (FItemList(i).Fisupchebeasong="Y")
                IsTenbeasongExists   = IsTenbeasongExists or (FItemList(i).Fisupchebeasong<>"Y")
            end if

            FItemList(i).Fgubun01name   = rsget("gubun01name")
            FItemList(i).Fgubun02name   = rsget("gubun02name")

			rsget.movenext
			i=i+1
		loop
		rsget.close

    end Sub

	' 디테일 리스트
    public Sub GetCsDetailList()
        dim SqlStr, i, arr

		'### 포장데이터 조회
		if IsUserLoginOK() then
			arr = fnMyPojangItemList(FRectUserID,FRectOrderserial)
		end if

		sqlStr = "select c.id,c.masterid,c.gubun01,c.gubun02,c.regitemno,c.confirmitemno"
		sqlStr = sqlStr + " ,c.regdetailstate, c.orderdetailidx, c.orderserial, c.itemid,c.itemoption"
		sqlStr = sqlStr + " ,c.makerid,c.itemname,c.itemoptionname"
		sqlStr = sqlStr + " ,d.currstate as orderdetailcurrstate"

		sqlStr = sqlStr + " ,isNULL(d.itemcost,c.itemcost) as itemcost"
		sqlStr = sqlStr + " ,isNULL(d.buycash,c.buycash) as buycash"
		sqlStr = sqlStr + " ,c.orderitemno,d.isupchebeasong,d.reducedPrice as discountAssingedCost,d.bonuscouponidx" ''추가

		sqlStr = sqlStr + " ,C2.comm_name as gubun01name, C3.comm_name as gubun02name"
		sqlStr = sqlStr + " ,i.smallimage, i.basicimage, i.pojangok "
		sqlStr = sqlStr + " ,d.songjangno, s.divname, s.findurl, s.tel deliveryTel " + VbCrlf

		sqlStr = sqlStr + " from [db_cs].[dbo].tbl_new_as_detail c "
		sqlStr = sqlStr + " left join [db_order].[dbo].tbl_order_detail d"
		sqlStr = sqlStr + "  on c.orderdetailidx=d.idx"
		sqlStr = sqlStr + " left join [db_item].[dbo].tbl_item i "
		sqlStr = sqlStr + "  on c.itemid=i.itemid"
		sqlStr = sqlStr + " Left Join [db_cs].[dbo].tbl_cs_comm_code C2"
        sqlStr = sqlStr + "  on c.gubun01=C2.comm_cd"
        sqlStr = sqlStr + " Left Join [db_cs].[dbo].tbl_cs_comm_code C3"
        sqlStr = sqlStr + "  on c.gubun02=C3.comm_cd"

		sqlStr = sqlStr + " LEFT JOIN db_order.[dbo].tbl_songjang_div s " + VbCrlf
		sqlStr = sqlStr + "		ON d.songjangdiv = s.divcd " + VbCrlf

		sqlStr = sqlStr + " where c.masterid=" + CStr(FRectCsAsID) + ""
        sqlStr = sqlStr + " order by c.isupchebeasong, c.makerid, c.itemid, c.itemoption"

		rsget.Open sqlStr,dbget,1

		FTotalCount = rsget.RecordCount
		FResultCount = FTotalCount

		redim preserve FItemList(FResultCount)

		i=0
		do until rsget.eof
			set FItemList(i) = new CCSASDetailItem

            FItemList(i).Fid              = rsget("id")
            FItemList(i).Fmasterid        = rsget("masterid")
            FItemList(i).Fgubun01         = rsget("gubun01")
            FItemList(i).Fgubun02         = rsget("gubun02")
            FItemList(i).Fregitemno       = rsget("regitemno")
            FItemList(i).Fconfirmitemno   = rsget("confirmitemno")
            ''접수 당시 진행 상태

            FItemList(i).Fregdetailstate  = rsget("regdetailstate")
            FItemList(i).Forderdetailidx  = rsget("orderdetailidx")
            FItemList(i).Forderserial     = rsget("orderserial")
            FItemList(i).Fitemid          = rsget("itemid")
            FItemList(i).Fitemoption      = rsget("itemoption")
            FItemList(i).Fmakerid         = rsget("makerid")
            FItemList(i).Fitemname        = db2html(rsget("itemname"))
            FItemList(i).Fitemoptionname  = db2html(rsget("itemoptionname"))
            FItemList(i).Fitemcost        = rsget("itemcost")
            FItemList(i).Fbuycash         = rsget("buycash")
            FItemList(i).Fitemno          = rsget("orderitemno")
            FItemList(i).Fisupchebeasong  = rsget("isupchebeasong")


            FItemList(i).Forderdetailcurrstate  = rsget("orderdetailcurrstate")

            FItemList(i).FSmallImage      = "http://webimage.10x10.co.kr/image/small/" + GetImageSubFolderByItemID(FItemList(i).Fitemid) + "/" + rsget("smallimage")
            FItemList(i).FBasicImage      = "http://webimage.10x10.co.kr/image/basic/" + GetImageSubFolderByItemID(FItemList(i).Fitemid) + "/" + rsget("basicimage")

            if (FItemList(i).Fitemid=0) then
                FDeliverPay          = FItemList(i).Fitemcost
            else
                IsUpchebeasongExists = IsUpchebeasongExists or (FItemList(i).Fisupchebeasong="Y")
                IsTenbeasongExists   = IsTenbeasongExists or (FItemList(i).Fisupchebeasong<>"Y")
            end if

            FItemList(i).Fgubun01name   = rsget("gubun01name")
            FItemList(i).Fgubun02name   = rsget("gubun02name")

			FItemList(i).FDeliveryName	 = rsget("divname")
			FItemList(i).FSongJangNo     = rsget("songjangno")
			FItemList(i).FDeliveryTel	 = rsget("deliveryTel")

            FItemList(i).FdiscountAssingedCost = rsget("discountAssingedCost") ''2013/12/30 추가
            FItemList(i).Fbonuscouponidx       = rsget("bonuscouponidx")       ''2013/12/30 추가
            FItemList(i).FPojangok		= rsget("pojangok")

            if InStr(arr, (rsget("itemid")&rsget("itemoption"))) > 0 then
            	FItemList(i).FIsPacked = "Y"
        	end if

			rsget.movenext
			i=i+1
		loop
		rsget.close

    end Sub

    public Sub GetCSASTotalCount()
        dim i,sqlStr

        sqlStr = " select count(id) as cnt "
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_new_as_list "
        sqlStr = sqlStr + " where 1 = 1 "

        if (FRectNotCsID<> "") then
            sqlStr = sqlStr + " and id<>'" + CStr(FRectNotCsID) + "' "
        end if

        if (FRectUserID <> "") then
                sqlStr = sqlStr + " and userid='" + CStr(FRectUserID) + "' "
        end if

        if (FRectUserName <> "") then
                sqlStr = sqlStr + " and customername='" + CStr(FRectUserName) + "' "
        end if

        if (FRectOrderSerial <> "") then
                sqlStr = sqlStr + " and orderserial='" + CStr(FRectOrderSerial) + "' "
        end if

        if (FRectStartDate <> "") then
                sqlStr = sqlStr + " and regdate>='" + CStr(FRectStartDate) + "' "
        end if

        if (FRectEndDate <> "") then
                sqlStr = sqlStr + " and regdate <'" + CStr(FRectEndDate) + "' "
        end if

        if (FRectSearchType = "norefund") then
                '환불미처리
                sqlStr = sqlStr + " and currstate<7 and divcd in ('3','5') "
        elseif (FRectSearchType = "cardnocheck") then
                '카드취소미처리
                sqlStr = sqlStr + " and currstate<7 and divcd='7' "
        elseif (FRectSearchType = "beasongnocheck") then
                '배송유의사항/취소
                sqlStr = sqlStr + " and currstate<7 and divcd in ('8','6') and ((requireupche is Null) or (requireupche='N')) "
        elseif (FRectSearchType = "upchemifinish") then
                '업체미처리
                sqlStr = sqlStr + " and currstate<6 and requireupche='Y' and deleteyn='N' "
        elseif (FRectSearchType = "upchefinish") then
                '업체처리완료
                sqlStr = sqlStr + " and currstate=6 and requireupche='Y' and deleteyn='N' "
        elseif (FRectSearchType = "returnmifinish") then
                '회수요청미처리
                sqlStr = sqlStr + " and currstate<2 and divcd ='10' "
        end if

        rsget.Open sqlStr, dbget, 1

        if  not rsget.EOF  then
            FResultCount = rsget("cnt")
        else
            FResultCount = 0
        end if
        rsget.close
    end sub

    public Sub GetOneCsDeliveryItem()
        dim i,sqlStr

        sqlStr = " select top 1 A.* "
        sqlStr = sqlStr + " from [db_cs].[dbo].tbl_new_as_delivery A "
        sqlStr = sqlStr + " where asid= " + CStr(FRectCsAsID) + " "

        rsget.Open sqlStr, dbget, 1

        FResultCount = rsget.RecordCount

        if  not rsget.EOF  then
            set FOneItem = new CCSDeliveryItem
            FOneItem.Fasid              = rsget("asid")
            FOneItem.Freqname           = db2html(rsget("reqname"))
            FOneItem.Freqphone          = rsget("reqphone")
            FOneItem.Freqhp             = rsget("reqhp")
            FOneItem.Freqzipcode        = rsget("reqzipcode")
            FOneItem.Freqzipaddr        = rsget("reqzipaddr")
            FOneItem.Freqetcaddr        = db2html(rsget("reqetcaddr"))
            FOneItem.Freqetcstr          = db2html(rsget("reqetcstr"))
            FOneItem.Fsongjangdiv       = rsget("songjangdiv")
            FOneItem.Fsongjangno        = rsget("songjangno")
            FOneItem.Fregdate           = rsget("regdate")
            FOneItem.Fsenddate          = rsget("senddate")

        end if
        rsget.close

    end Sub


	' 송장번호 고객등록
    Public Function InputSongjangNo(ByVal songjangDiv, ByVal songjangNo)

		Dim ErrCode, ErrMsg

		Dim strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@asId"			, adInteger	, adParamInput	,		, FRectCsAsID)	_
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, FRectUserID) _
			,Array("@orderSerial"	, adVarchar	, adParamInput	, 11	, FRectOrderserial) _
			,Array("@songjangDiv"	, adInteger	, adParamInput	,		, songjangDiv) _
			,Array("@songjangNo"	, adVarchar	, adParamInput	, 32	, songjangNo) _
		)

		strSql = "db_cs.dbo.sp_Ten_CsAs_SongjangInput"
		Call fnExecSP(strSql, paramInfo)

		ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))			' 에러코드

		InputSongjangNo = ErrCode

	End Function

	' 반품신청 취소(삭제)
    Public Function DeleteAsListOne()

		Dim ErrCode, ErrMsg

		Dim strSql
		Dim paramInfo
		paramInfo = Array(Array("@RETURN_VALUE",adInteger,adParamReturnValue,,0) _
			,Array("@asId"			, adInteger	, adParamInput	,		, FRectCsAsID)	_
			,Array("@userID"		, adVarchar	, adParamInput	, 32	, FRectUserID) _
			,Array("@orderSerial"	, adVarchar	, adParamInput	, 11	, FRectOrderserial) _
		)

		strSql = "db_cs.dbo.sp_Ten_CsAs_DeleteOne"
		Call fnExecSP(strSql, paramInfo)

		ErrCode  = CInt(GetValue(paramInfo, "@RETURN_VALUE"))			' 에러코드

		DeleteAsListOne = ErrCode

	End Function


    Private Sub Class_Initialize()
        FCurrPage       = 1
        FPageSize       = 10
        FResultCount    = 0
        FScrollCount    = 10
        FTotalCount     = 0
    End Sub

    Private Sub Class_Terminate()

    End Sub

    public Function HasPreScroll()
            HasPreScroll = StartScrollPage > 1
    end Function

    public Function HasNextScroll()
            HasNextScroll = FTotalPage > StartScrollPage + FScrollCount -1
    end Function

    public Function StartScrollPage()
            StartScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
    end Function

end Class




%>
