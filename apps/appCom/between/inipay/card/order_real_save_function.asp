<%
Function OrderRealSaveProc(vIdx)
	Dim vQuery, vPGoods, vResult
	Dim vUserID, vGuestSeKey, vPrice, vTn_paymethod, vAcctname, vBuyname, vBuyphone, vBuyhp, vBuyemail, vReqname, vTxZip, vTxAddr1, vTxAddr2, vReqphone, vReqphone4, vReqhp, vComment, vSpendmileage
	Dim vSpendtencash, vSpendgiftmoney, vCouponmoney, vItemcouponmoney, vSailcoupon, vRdsite, vRdUserid, vReqdate, vReqtime, vCardribbon, vMessage, vFromname, vCountryCode, vEmsZipCode
	Dim vReqemail, vEmsPrice, vGift_code, vGiftkind_code, vGift_kind_option, vCheckitemcouponlist, vPacktype, vMid, vP_STATUS, vP_TID, vP_AUTH_NO, vP_RMESG1, vP_RMESG2, vP_FN_CD1, vP_CARD_ISSUER_CODE, vP_CARD_PRTC_CODE
	Dim vChkKakaoSend, vDGiftCode, vDiNo, vTotCouponAssignPrice
	'vIdx 	= Request.Form("idx")
	vResult = "ok"

	IF vIdx = "" Then
		vResult = "x1"
	End If

	IF IsNumeric(vIdx) = false Then
		vResult = "x2"
	End If

	IF vResult = "ok" Then
		vQuery = "SELECT TOP 1 * FROM [db_order].[dbo].[tbl_order_temp] WHERE temp_idx = '" & vIdx & "' AND IsPay = 'N'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.EOF THEN
			vUserID					= rsget("userid")
			vGuestSeKey				= rsget("guestSessionID")
			vPrice					= rsget("price")
			vTn_paymethod			= rsget("Tn_paymethod")
			vAcctname				= rsget("acctname")
			vBuyname				= rsget("buyname")
			vBuyphone				= rsget("buyphone")
			vBuyhp					= rsget("buyhp")
			vBuyemail				= rsget("buyemail")
			vReqname				= rsget("reqname")
			vTxZip					= rsget("txZip")
			vTxAddr1				= rsget("txAddr1")
			vTxAddr2				= rsget("txAddr2")
			vReqphone				= rsget("reqphone")
			vReqphone4				= rsget("reqphone4")
			vReqhp					= rsget("reqhp")
			vComment				= rsget("comment")
			vSpendmileage			= rsget("spendmileage")
			vSpendtencash			= rsget("spendtencash")
			vSpendgiftmoney			= rsget("spendgiftmoney")
			vCouponmoney			= rsget("couponmoney")
			vItemcouponmoney		= rsget("itemcouponmoney")
			vSailcoupon				= rsget("sailcoupon")
			vRdsite					= rsget("rdsite")
			vRdUserid				= rsget("rdUserid")
			vReqdate				= rsget("reqdate")
			vReqtime				= rsget("reqtime")
			vCardribbon				= rsget("cardribbon")
			vMessage				= rsget("message")
			vFromname				= rsget("fromname")
			vCountryCode			= rsget("countryCode")
			vEmsZipCode				= rsget("emsZipCode")
			vReqemail				= rsget("reqemail")
			vEmsPrice				= rsget("emsPrice")
			vGift_code				= rsget("gift_code")
			vGiftkind_code			= rsget("giftkind_code")
			vGift_kind_option		= rsget("gift_kind_option")
			vCheckitemcouponlist	= rsget("checkitemcouponlist")
			vPacktype				= rsget("packtype")
			vMid					= rsget("mid")

			vP_STATUS				= rsget("P_STATUS")
			vP_TID					= rsget("P_TID")
			vP_AUTH_NO				= rsget("P_AUTH_NO")
			vP_RMESG1				= rsget("P_RMESG1")
			vP_RMESG2				= rsget("P_RMESG2")
			vP_FN_CD1				= rsget("P_FN_CD1")
			vP_CARD_ISSUER_CODE		= rsget("P_CARD_ISSUER_CODE")
			vP_CARD_PRTC_CODE		= rsget("P_CARD_PRTC_CODE")
			vChkKakaoSend			= rsget("chkKakaoSend")
			vDGiftCode				= rsget("dGiftCode")
			vDiNo					= rsget("DiNo")
			rsget.close
		ELSE
			rsget.close
			vResult = "x3"
		END IF


		IF vResult = "ok" Then
			''신용카드 / 실시간 이체 결제.
			'' 사이트 구분
			Const sitename = "10x10"

			dim i, userid, guestSessionID
			userid          = vUserID
			guestSessionID  = vGuestSeKey

			dim iorderParams
			dim subtotalprice
			subtotalprice   = vPrice


			set iorderParams = new COrderParams

			iorderParams.Fjumundiv          = "1"
			iorderParams.Fuserid            = userid
			iorderParams.Fipkumdiv          = "0"           '' 초기 주문대기
			iorderParams.Faccountdiv        = vTn_paymethod
			iorderParams.Fsubtotalprice     = subtotalprice
			iorderParams.Fdiscountrate      = 1


			iorderParams.Fsitename          = sitename

			iorderParams.Faccountname       = vAcctname
			iorderParams.Faccountno         = "" '''request.Form("acctno")
			iorderParams.Fbuyname           = vBuyname
			iorderParams.Fbuyphone          = vBuyphone
			iorderParams.Fbuyhp             = vBuyhp
			iorderParams.Fbuyemail          = vBuyemail
			iorderParams.Freqname           = vReqname
			iorderParams.Freqzipcode        = vTxZip
			iorderParams.Freqzipaddr        = vTxAddr1
			iorderParams.Freqaddress        = vTxAddr2
			iorderParams.Freqphone          = vReqphone
			iorderParams.Freqhp             = vReqhp
			iorderParams.Fcomment           = vComment

			iorderParams.Fmiletotalprice    = vSpendmileage
			iorderParams.Fspendtencash      = vSpendtencash
			iorderParams.Fspendgiftmoney    = vSpendgiftmoney
			iorderParams.Fcouponmoney       = vCouponmoney
			iorderParams.Fitemcouponmoney   = vItemcouponmoney
			iorderParams.Fcouponid          = vSailcoupon                ''할인권 쿠폰번호
			iorderParams.FallatDiscountprice= 0
			
			If vRdsite = "app_wish" Then
				iorderParams.Frdsite    	= "app_wish"
			ElseIf vRdsite = "app_wish2" Then
				iorderParams.Frdsite		= "app_wish2"
			ElseIf vRdsite = "betweenshop" Then
				iorderParams.Frdsite		= "betweenshop"
			Else
				if request.cookies("rdsite")<>"" then
					iorderParams.Frdsite    = request.cookies("rdsite")
				else
					iorderParams.Frdsite    = "mobile"
				end if
			End If

			iorderParams.Frduserid          = vRdUserid
			iorderParams.FchkKakaoSend      = vChkKakaoSend				''카카오톡 발송여부

			iorderParams.FUserLevel         = GetLoginUserLevel
			iorderParams.Freferip           = Left(request.ServerVariables("REMOTE_ADDR"),32)

			''플라워
			if (vReqdate<>"") then
			    iorderParams.Freqdate           = CStr(vReqdate)
			    iorderParams.Freqtime           = vReqtime
			    iorderParams.Fcardribbon        = vCardribbon
			    iorderParams.Fmessage           = vMessage
			    iorderParams.Ffromname          = vFromname
			end if

			''해외배송 추가 : 2009 ===================================================================
			if (vCountryCode<>"") and (vCountryCode<>"KR") and (vCountryCode<>"ZZ") then
			    iorderParams.Freqphone      = iorderParams.Freqphone + "-" + vReqphone4
			    iorderParams.FemsZipCode    = vEmsZipCode
			    iorderParams.Freqemail      = vReqemail
			    iorderParams.FemsPrice      = vEmsPrice
			    iorderParams.FcountryCode   = vCountryCode
			elseif (vCountryCode="ZZ") then
			    iorderParams.FcountryCode   = "ZZ"
			    iorderParams.FemsPrice      = 0
			else
			    iorderParams.FcountryCode   = "KR"
			    iorderParams.FemsPrice      = 0
			end if
			''========================================================================================

			''사은품 추가=======================
			iorderParams.Fgift_code         = vGift_code
			iorderParams.Fgiftkind_code     = vGiftkind_code
			iorderParams.Fgift_kind_option  = vGift_kind_option

			''다이어리 사은품 추가=======================
			iorderParams.FdGiftCodeArr      = vDGiftCode
			iorderParams.FDiNoArr           = vDiNo

			dim checkitemcouponlist
			dim Tn_paymethod, packtype

			checkitemcouponlist = vCheckitemcouponlist
			if (Right(vCheckitemcouponlist,1)=",") then checkitemcouponlist=Left(checkitemcouponlist,Len(checkitemcouponlist)-1)
			Tn_paymethod        = vTn_paymethod
			packtype            = vPacktype

			''Param Check
			if (iorderParams.Faccountname="") then iorderParams.Faccountname = iorderParams.Fbuyname
			if (Not isNumeric(iorderParams.Fmiletotalprice)) or (iorderParams.Fmiletotalprice="") then iorderParams.Fmiletotalprice=0
			if (Not isNumeric(iorderParams.Fspendtencash)) or (iorderParams.Fspendtencash="") then iorderParams.Fspendtencash=0
			if (Not isNumeric(iorderParams.Fspendgiftmoney)) or (iorderParams.Fspendgiftmoney="") then iorderParams.Fspendgiftmoney=0
			if (Not isNumeric(iorderParams.Fitemcouponmoney)) or (iorderParams.Fitemcouponmoney="") then iorderParams.Fitemcouponmoney=0
			if (Not isNumeric(iorderParams.Fcouponmoney)) or (iorderParams.Fcouponmoney="") then iorderParams.Fcouponmoney=0
			if (Not isNumeric(iorderParams.Fcouponid)) or (iorderParams.Fcouponid="") then iorderParams.Fcouponid=0
			if (Not isNumeric(iorderParams.FemsPrice)) or (iorderParams.FemsPrice="") then iorderParams.FemsPrice=0
			if (packtype="") then packtype="0000"

			'On Error resume Next
			dim sqlStr



			'''' ########### 마일리지 사용 체크 - ################################
			dim oMileage, availtotalMile
			set oMileage = new TenPoint
			oMileage.FRectUserID = userid
			if (userid<>"") then
			    oMileage.getTotalMileage
			    availtotalMile = oMileage.FTotalMileage
			end if

			''예치금 추가
			Dim oTenCash, availtotalTenCash
			set oTenCash = new CTenCash
			oTenCash.FRectUserID = userid
			if (userid<>"") then
			    oTenCash.getUserCurrentTenCash
			    availtotalTenCash = oTenCash.Fcurrentdeposit
			end if

			''Gift카드 추가
			Dim oGiftCard, availTotalGiftMoney
			availTotalGiftMoney = 0
			set oGiftCard = new myGiftCard
			oGiftCard.FRectUserID = userid
			if (userid<>"") then
			    availTotalGiftMoney = oGiftCard.myGiftCardCurrentCash
			end if

			if (availtotalMile<1) then availtotalMile=0
			if (availtotalTenCash<1) then availtotalTenCash=0


			if (CLng(iorderParams.Fmiletotalprice)>CLng(availtotalMile)) then
			    'response.write "<script>alert('장바구니 금액 오류 (사용가능 마일리지 부족) - 다시계산해 주세요.')</script>"
				vResult = "x4"
			end if

			IF vResult = "ok" Then

				if (CLng(iorderParams.Fspendtencash)>CLng(availtotalTenCash)) then
				    'response.write "<script>alert('장바구니 금액 오류 (사용가능 예치금 부족) - 다시계산해 주세요.')</script>"
					vResult = "x5"
				end if

				IF vResult = "ok" Then
					if (CLng(iorderParams.Fspendgiftmoney)>CLng(availTotalGiftMoney)) then
					    'response.write "<script>alert('장바구니 금액 오류 (사용가능 Gift카드 잔액 부족) - 다시계산해 주세요.')</script>"
						vResult = "x6"
					end if

					'''' ##################################################################

					IF vResult = "ok" Then
						dim oshoppingbag,goodname
						set oshoppingbag = new CShoppingBag
						oshoppingbag.FRectUserID = userid
						oShoppingBag.FRectUserSn    = "BTW_USN_" & vRdUserid
						''oshoppingbag.FRectSessionID = guestSessionID
						oShoppingBag.FRectSiteName  = sitename
						oShoppingBag.FcountryCode = iorderParams.FcountryCode           ''2009추가

						oshoppingbag.GetShoppingBagDataDB_Checked	''체크한것들만.//201202
						''oshoppingbag.GetShoppingBagDataDB

						'if (oshoppingbag.IsShoppingBagVoid) then
						'	'response.write "<script>alert('쇼핑백이 비었습니다. - 결제는 이루어지지 않았습니다.');</script>"
						'	vResult = "x7"
						'end if

						IF vResult = "ok" Then
							''품절상품체크::임시.연아다이어리
							if (oshoppingbag.IsSoldOutSangpumExists) then
							    'response.write "<script>alert('죄송합니다. 품절된 상품은 구매하실 수 없습니다.');</script>"
								'vResult = "x8"
							end if

							IF vResult = "ok" Then
								''업체 개별 배송비 상품이 있는경우
								if (oshoppingbag.IsUpcheParticleBeasongInclude)  then
								    oshoppingbag.GetParticleBeasongInfoDB_Checked
								end if

								goodname = oshoppingbag.getGoodsName

								dim tmpitemcoupon, tmp
								tmpitemcoupon = split(checkitemcouponlist,",")

								'상품쿠폰 적용
								for i=LBound(tmpitemcoupon) to UBound(tmpitemcoupon)
									tmp = trim(tmpitemcoupon(i))

									if oshoppingbag.IsCouponItemExistsByCouponIdx(tmp) then
										oshoppingbag.AssignItemCoupon(tmp)
									end if
								next

								''보너스 쿠폰 적용
								if (iorderParams.Fcouponid<>0) then
								    oshoppingbag.AssignBonusCoupon(iorderParams.Fcouponid)
								end if

								''Ems 금액 적용
								oshoppingbag.FemsPrice = iorderParams.FemsPrice


								''20090602 KB카드 할인 추가. 카드 할인금액 - 위치에 주의 : 상품쿠폰 먼저 적용후 계산.====================
								if (request.cookies("rdsite")="kbcard") and (vMid="teenxteen5") then
								    oshoppingbag.FDiscountRate = 0.95
								    iorderParams.FallatDiscountprice = oshoppingbag.GetAllAtDiscountPrice
								end if
								'' =================================================================================


								'''금액일치확인 ***
								if (CLng(oshoppingbag.getTotalCouponAssignPrice(packtype)-iorderParams.Fmiletotalprice-iorderParams.Fcouponmoney-iorderParams.FallatDiscountprice-iorderParams.Fspendtencash-iorderParams.Fspendgiftmoney) <> CLng(subtotalprice)) then
									'response.write "<script>alert('장바구니 금액 오류 - 다시계산해 주세요.')</script>"
									if (vIdx<>77623) and (vIdx<>83757) and (vIdx<>101957) then
									    vResult = "x9"
								    end if
								end if

								IF vResult = "ok" Then
									''##############################################################################
									''디비작업
									''##############################################################################
									dim iorderserial, iErrStr

									iorderserial = oshoppingbag.SaveOrderDefaultDB(iorderParams, iErrStr)

									if (iErrStr<>"") then
									    'response.write iErrStr
									    'response.write "<script language='javascript'>alert('결제는 이루어 지지 않았습니다. \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"

										''관리자통보
									    'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
										'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
										'sqlStr = sqlStr + " convert(varchar(250),'주문오류 :" + iorderserial +":"+CStr(vIdx)+":"+ replace(iErrStr,"'","") + "'))"

										'dbget.Execute sqlStr
										vResult = "x10"
									end if

									IF vResult = "ok" Then
										'-------------------------------------------------------------------------------------------------------------------------------------------------
										dim INIpay, PInst
										dim Tid, ResultCode, ResultMsg, PayMethod
										dim Price1, Price2, AuthCode, CardQuota, QuotaInterest
										dim CardCode, AuthCertain, PGAuthDate, PGAuthTime, OCBSaveAuthCode, OCBUseAuthCode, OCBAuthDate, CardIssuerCode, PrtcCode
										dim AckResult
										dim DirectBankCode, Rcash_rslt, ResultCashNoAppl
										dim i_Resultmsg
										i_Resultmsg = vP_RMESG1

										iorderParams.Fresultmsg  = i_Resultmsg
										iorderParams.Fauthcode = vP_AUTH_NO
										iorderParams.Fpaygatetid = vP_TID
										iorderParams.IsSuccess = (vP_STATUS = "00")

										''2011-04-27 추가(부분취소시 필요항목)
										IF (Tn_paymethod="20") Then
										    iorderParams.FPayEtcResult = LEFT(DirectBankCode,16)
										ELSe
										    iorderParams.FPayEtcResult = LEFT(vP_FN_CD1&"|"&vP_CARD_ISSUER_CODE&"|"&vP_RMESG2&"|"&vP_CARD_PRTC_CODE,16)
										END IF

										Call oshoppingbag.SaveOrderResultDB(iorderParams, iErrStr)

										if (iErrStr<>"") then
										    'response.write "<script language='javascript'>alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n: 오류 -" & replace(iErrStr,"'","") & "');</script>"
											vResult = "x11"
										end if

										IF vResult = "ok" Then
											if (Err) then
												'response.write "<script>javascript:alert('작업중 오류가 발생하였습니다. 고객센터로 문의해 주세요.: \n\n" & iErrStr & "')</script>"
												vResult = "x12"
											end if

											IF vResult = "ok" Then
												On Error resume Next
												dim osms, helpmail, vIsSuccess
												helpmail = oshoppingbag.GetHelpMailURL

												    IF (iorderParams.IsSuccess) THEN
												        call sendmailorder(iorderserial,helpmail)

												        set osms = new CSMSClass
														osms.SendJumunOkMsg iorderParams.Fbuyhp, iorderserial
													    set osms = Nothing

												    end if
												on Error Goto 0


												''Save OrderSerial / UserID or SSN Key
												session("before_orderserial") = iorderserial

												if (iorderParams.IsSuccess) then
													session("before_issuccess") = "true"
												else
													session("before_issuccess") = "false"
												end if
												vIsSuccess = iorderParams.IsSuccess
											End If
										End If
									End If
								End If
							End If
						End If
						vTotCouponAssignPrice = oshoppingbag.getTotalCouponAssignPrice(vPacktype)
						set oshoppingbag = Nothing
					End If
				End If
			End If

			set iorderParams = Nothing
			set oMileage = Nothing
			set oTenCash = Nothing
			set oGiftCard = Nothing

		End If
	End If


	If vResult <> "ok" Then
		IF vResult <> "x1" AND vResult <> "x2" Then
			''관리자통보
		    'sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg )"
			'sqlStr = sqlStr + " values( '010-6324-9110', '1644-6030', '1', getdate(), "
			'sqlStr = sqlStr + " convert(varchar(250),'주문오류 :" + iorderserial +":"+CStr(vIdx)+":vResult="+ vResult + "'))"
			'dbget.Execute sqlStr

			'####### 카드결제 오류 로그 전송
			sqlStr = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
			sqlStr = sqlStr & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
			sqlStr = sqlStr & " 'real','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & vTotCouponAssignPrice & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
			sqlStr = sqlStr & " '" & vSpendgiftmoney & "','" & vPrice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
			dbget.execute sqlStr

		End If

		''2014/01/28 추가
		session("before_orderserial") = ""
		session("before_issuccess") = "false"

	End If

	OrderRealSaveProc = vResult & "|" & iorderserial & "|" & vIsSuccess
End Function
%>