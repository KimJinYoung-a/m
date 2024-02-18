<%

function CsDeliverDivCd2Nm(byval divcd)
		if isNull(divcd) then
			CsDeliverDivCd2Nm = ""
			Exit function
		end if
		   if CStr(divcd) = "1" then
		    CsDeliverDivCd2Nm =  "한진택배"
		   elseif CStr(divcd) = "2" then
		    CsDeliverDivCd2Nm =  "현대택배"
		   elseif CStr(divcd) = "3" then
		    CsDeliverDivCd2Nm =  "대한통운"
		   elseif CStr(divcd) = "4" then
		    CsDeliverDivCd2Nm =  "CJ GLS"
		   elseif CStr(divcd) = "5" then
		    CsDeliverDivCd2Nm =  "SC로지스"
		   elseif CStr(divcd) = "6" then
		    CsDeliverDivCd2Nm =  "HTH"
		   elseif CStr(divcd) = "7" then
		    CsDeliverDivCd2Nm =  "훼미리택배"
		   elseif CStr(divcd) = "8" then
		    CsDeliverDivCd2Nm =  "우체국"
		   elseif CStr(divcd) = "9" then
		    CsDeliverDivCd2Nm =  "(구)KGB"
		   elseif CStr(divcd) = "10" then
		    CsDeliverDivCd2Nm =  "아주택배"
		   elseif CStr(divcd) = "11" then
		    CsDeliverDivCd2Nm =  "오렌지택배"
		   elseif CStr(divcd) = "12" then
		    CsDeliverDivCd2Nm =  "한국택배"
		   elseif CStr(divcd) = "13" then
		    CsDeliverDivCd2Nm =  "옐로우캡"
		   elseif CStr(divcd) = "14" then
		    CsDeliverDivCd2Nm =  "나이스택배"
		   elseif CStr(divcd) = "15" then
		    CsDeliverDivCd2Nm =  "중앙택배"
		   elseif CStr(divcd) = "16" then
		    CsDeliverDivCd2Nm =  "주코택배"
		   elseif CStr(divcd) = "17" then
		    CsDeliverDivCd2Nm =  "트라넷택배"
		   elseif CStr(divcd) = "18" then
		    CsDeliverDivCd2Nm =  "로젠택배"
		   elseif CStr(divcd) = "19" then
		    CsDeliverDivCd2Nm =  "KGB특급택배"
		   elseif CStr(divcd) = "20" then
		    CsDeliverDivCd2Nm =  "KT로지스"
		   elseif CStr(divcd) = "21" then
		    CsDeliverDivCd2Nm =  "경동택배"
		   elseif CStr(divcd) = "22" then
		    CsDeliverDivCd2Nm =  "고려택배"
		   elseif CStr(divcd) = "23" then
		    CsDeliverDivCd2Nm =  "신세계SEDEX"
		   elseif CStr(divcd) = "24" then
		    CsDeliverDivCd2Nm =  "사가와"
		   elseif CStr(divcd) = "30" then
		    CsDeliverDivCd2Nm =  "이노지스"
		   elseif CStr(divcd) = "31" then
		    CsDeliverDivCd2Nm =  "천일택배"
		   elseif CStr(divcd) = "32" then
		    CsDeliverDivCd2Nm =  "사가와 임시"
		   elseif CStr(divcd) = "33" then
		    CsDeliverDivCd2Nm =  "호남택배"
		   elseif CStr(divcd) = "34" then
		    CsDeliverDivCd2Nm =  "대신화물택배"
		   elseif CStr(divcd) = "35" then
		    CsDeliverDivCd2Nm =  "CVSnet택배"
		   elseif CStr(divcd) = "90" then
		    CsDeliverDivCd2Nm =  "EMS"
		   elseif CStr(divcd) = "99" then
		    CsDeliverDivCd2Nm =  "기타"
		   end if

end function

function CsDeliverDivTrace(byval divcd)
	if isNull(divcd) then
		CsDeliverDivTrace = ""
		Exit function
	end if
		if CStr(divcd) = "1" then
			'한진택배
		    CsDeliverDivTrace =  "http://www.hanjinexpress.hanjin.net/customer/plsql/hddcw07.result?wbl_num="
		elseif CStr(divcd) = "2" then
			'현대택배
		    CsDeliverDivTrace =  "http://www.hydex.net/ehydex/jsp/home/distribution/tracking/trackingViewCus.jsp?InvNo="
		elseif CStr(divcd) = "3" then
			'대한통운
		    CsDeliverDivTrace =  "http://www.doortodoor.co.kr/jsp/cmn/Tracking.jsp?QueryType=3&pTdNo="
		elseif CStr(divcd) = "4" then
			'CJ GLS
		    CsDeliverDivTrace =  "http://www.cjgls.co.kr/kor/service/service02_02.asp?slipno="
		elseif CStr(divcd) = "5" then
			'이클라인
		    CsDeliverDivTrace =  "http://www.sagawa-korea.co.kr/sub4/default2_2.asp?awbino="
		elseif CStr(divcd) = "6" then
			'HTH
		    CsDeliverDivTrace =  "http://cjhth.com/homepage/searchTraceGoods/SearchTraceDtdShtno.jhtml?dtdShtno="
		elseif CStr(divcd) = "7" then
			'훼미리택배
		    CsDeliverDivTrace =  "http://www.e-family.co.kr/member/delivery_search_view.jsp?item_no="
		elseif CStr(divcd) = "8" then
			'우체국
		    CsDeliverDivTrace =  "http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1="
		elseif CStr(divcd) = "9" then
			'(구)KGB
		    CsDeliverDivTrace =  "http://www.kgbls.co.kr/sub3/sub3_4_1.asp?f_slipno="
		elseif CStr(divcd) = "10" then
			'아주택배
		    CsDeliverDivTrace =  "http://www.ajuthankyou.com:8080/jsp/expr1/web_view.jsp?sheetno1="
		elseif CStr(divcd) = "11" then
			'오렌지택배
		    CsDeliverDivTrace =  ""
		elseif CStr(divcd) = "12" then
			'한국택배
		    CsDeliverDivTrace =  ""
		elseif CStr(divcd) = "13" then
			'옐로우캡
		    CsDeliverDivTrace =  "http://yellowcap.bizeye.co.kr/search.asp?slipno="
		elseif CStr(divcd) = "14" then
			'나이스택배
		    CsDeliverDivTrace =  ""
		elseif CStr(divcd) = "15" then
			'중앙택배
		    CsDeliverDivTrace =  ""
		elseif CStr(divcd) = "16" then
			'주코택배 - out
		    CsDeliverDivTrace =  ""
		elseif CStr(divcd) = "17" then
			'트라넷택배
		    CsDeliverDivTrace =  "http://www.etranet.co.kr/branch/chase/listbody.html?a_gb=center&a_cd=4&a_item=0&fr_slipno="
		elseif CStr(divcd) = "18" then
			'로젠택배
		    CsDeliverDivTrace =  "http://www.ilogen.com/customer/reserve_03_detail.asp?f_slipno="
		elseif CStr(divcd) = "19" then
			'KGB특급택배
		    CsDeliverDivTrace =  "http://www.kgbls.co.kr/sub3/sub3_4_1.asp?f_slipno="
		elseif CStr(divcd) = "20" then
			'KT로지스
		    CsDeliverDivTrace =  "http://218.153.4.42/customer/cus_trace_02.asp?searchMethod=I&invc_no="
		elseif CStr(divcd) = "21" then
			'경동택배
			CsDeliverDivTrace =  "http://insu.kdexp.com/insu/search.php?p_item="
		elseif CStr(divcd) = "22" then
			'고려택배
			CsDeliverDivTrace =  "http://www.gologis.com/delivery/s_search.asp?f_slipno="
		elseif CStr(divcd) = "23" then
			'신세계 SEDEX
			CsDeliverDivTrace =  "http://ptop.sedex.co.kr:8080/jsp/tr/detailSheet.jsp?iSheetNo="
		elseif CStr(divcd) = "24" then
			'사가와
		    CsDeliverDivTrace =  "http://www.sc-logis.co.kr/tracking/normal/default.asp?awblno="
		elseif CStr(divcd) = "35" then
			'CSVNet(편의점택배)
		    CsDeliverDivTrace =  "http://was.cvsnet.co.kr/_ver2/board/ctod_status.jsp?pageNum=3&subNum=1&ssNum=0&invoice_no="
		elseif CStr(divcd) = "99" then
		    CsDeliverDivTrace =  ""
		end if

end function

%>