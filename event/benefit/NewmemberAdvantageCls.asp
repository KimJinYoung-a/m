<%
Class NewmemberAdvantageCls

	'자동발급 쿠폰 리스트
	public function getAutoCouponList()	
		dim SqlStr												

		sqlStr = sqlStr & " Select couponname "
		sqlStr = sqlStr & " 	  , couponvalue "
		sqlStr = sqlStr & " 	  , minbuyprice "
		sqlStr = sqlStr & " 	  , startdate "
		sqlStr = sqlStr & " 	  , expiredate "
		sqlStr = sqlStr & " 	  , DATEDIFF(dd, startdate, expiredate) + 1 as diff         "
		sqlStr = sqlStr & " 	  , coupontype"
		sqlStr = sqlStr & " From db_user.dbo.tbl_user_coupon_master WITH(NOLOCK)"
		sqlStr = sqlStr & " Where 1 = 1"
		sqlStr = sqlStr & " AND ISOPENLISTCOUPON = 'N' "
		sqlStr = sqlStr & " and startdate < getdate() "
		sqlStr = sqlStr & " and openfinishdate > getdate()				 "
		sqlStr = sqlStr & " And isusing='Y'  "
		sqlStr = sqlStr & " AND isnull(targetCpnType, '')<> 'B' "
		sqlStr = sqlStr & " order by couponvalue desc "

		'response.write sqlStr &"<br>"
		'response.end
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    getAutoCouponList = rsget.getRows()	
		end if
		rsget.close			
	End function

	'마일리지 이벤트 리스트
	public function getMileageEvent()	
		dim SqlStr												

		sqlStr = sqlStr & " SELECT TOP 1 "
		sqlStr = sqlStr & " 	   a.evt_code "
		sqlStr = sqlStr & " 	 , a.evt_startdate "
		sqlStr = sqlStr & " 	 , a.evt_enddate "
		sqlStr = sqlStr & " 	 , left(a.evt_name, 4) as mileleage "
		sqlStr = sqlStr & " 	 , DATEDIFF(dd, a.evt_startdate, a.evt_enddate) + 1 as diff "
		sqlStr = sqlStr & "   FROM DB_EVENT.DBO.tbl_event as a "
		sqlStr = sqlStr & "  inner join db_event.DBO.tbl_event_display b on a.evt_code = b.evt_code "
		sqlStr = sqlStr & "  where 1 = 1 "
		sqlStr = sqlStr & "    and CONVERT(char(10), evt_startdate,126) <= CONVERT(char(10), getdate(),126) "
		sqlStr = sqlStr & "    and CONVERT(char(10), evt_enddate,126) >= CONVERT(char(10), getdate(),126) "
		sqlStr = sqlStr & "    and a.evt_using = 'Y' "
		sqlStr = sqlStr & "    and a.evt_state = 7 "
		sqlStr = sqlStr & "    and a.evt_kind = 28 "
		sqlStr = sqlStr & "    and convert(varchar(max), b.evt_forward) = '마일리지 이벤트' "		
		   
		'response.write sqlStr &"<br>"
		'response.end
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    getMileageEvent = rsget.getRows()	
		end if
		rsget.close			
	End function

	'자동발급 마일리지 정보
	public function getAutoMileageInfo()	
		dim SqlStr												

		sqlStr = sqlStr & "SELECT TOP 1"
		sqlStr = sqlStr & " E.evt_startdate, E.evt_enddate, M.mileage"
		sqlStr = sqlStr & " From [db_event].[dbo].[tbl_event] AS E WITH(NOLOCK)"
		sqlStr = sqlStr & " JOIN [db_event].[dbo].[tbl_event_login_mileage] AS M WITH(NOLOCK) ON E.evt_code=M.evt_code"
		sqlStr = sqlStr & " WHERE M.isusing='Y'"
		sqlStr = sqlStr & " AND E.evt_kind='28'"
		sqlStr = sqlStr & " AND E.evt_startdate <= GETDATE()"
		sqlStr = sqlStr & " AND E.evt_enddate  > CONVERT(VARCHAR(10),DATEADD(D,1,GETDATE()),120)"

		'response.write sqlStr &"<br>"
		'response.end
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    getAutoMileageInfo = rsget.getRows()
		end if
		rsget.close
	End function

	'자동발급 쿠폰 리스트
	public function getNewAutoCouponList()	
		dim SqlStr												

		sqlStr = sqlStr & " Select couponname"
		sqlStr = sqlStr & " 	  , couponvalue"
		sqlStr = sqlStr & " 	  , minbuyprice"
		sqlStr = sqlStr & " 	  , startdate"
		sqlStr = sqlStr & " 	  , expiredate"
		sqlStr = sqlStr & " 	  , DATEDIFF(dd, startdate, expiredate) + 1 as diff"
		sqlStr = sqlStr & " 	  , coupontype"
		sqlStr = sqlStr & " From db_user.dbo.tbl_user_coupon_master WITH(NOLOCK)"
		sqlStr = sqlStr & " Where 1 = 1"
		sqlStr = sqlStr & " AND ISOPENLISTCOUPON = 'N'"
		sqlStr = sqlStr & " and startdate < getdate()"
		sqlStr = sqlStr & " and openfinishdate > getdate()"
		sqlStr = sqlStr & " and isnull(validsitename,'') = ''"
		sqlStr = sqlStr & " And isusing='Y'"
		sqlStr = sqlStr & " AND isnull(targetCpnType, '')<> 'B'"
		sqlStr = sqlStr & " order by couponvalue desc"

		'response.write sqlStr &"<br>"
		'response.end
		
		rsget.CursorLocation = adUseClient
        rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
		
 		if not rsget.EOF then
		    getNewAutoCouponList = rsget.getRows()	
		end if
		rsget.close			
	End function

	Private Sub Class_Terminate()
    End Sub	

end Class
%>
