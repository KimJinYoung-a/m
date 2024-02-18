<%
''http://evolt.org/node/21724/
''' ADO Array Sort
Sub QuickSortADO(vec,loBound,hiBound,SortField,SortDir)

  '==--------------------------------------------------------==
  '== Sort a multi dimensional array on SortField            ==
  '==                                                        ==
  '== This procedure is adapted from the algorithm given in: ==
  '==    ~ Data Abstractions & Structures using C++ by ~     ==
  '==    ~ Mark Headington and David Riley, pg. 586    ~     ==
  '== Quicksort is the fastest array sorting routine for     ==
  '== unordered arrays.  Its big O is n log n                ==
  '==                                                        ==
  '== Parameters:                                            ==
  '== vec       - array to be sorted                         ==
  '== SortField - The field to sort on (1st dimension value) ==
  '== loBound and hiBound are simply the upper and lower     ==
  '==   bounds of the array's "row" dimension. It's probably ==
  '==   easiest to use the LBound and UBound functions to    ==
  '==   set these.                                           ==
  '== SortDir   - ASC, ascending; DESC, Descending           ==
  '==--------------------------------------------------------==
  if not (hiBound - loBound = 0) then

      Dim pivot(),loSwap,hiSwap,temp,counter
      Redim pivot (Ubound(vec,1))
      SortDir = UCase(SortDir)
      '== Two items to sort

      if hiBound - loBound = 1 then
        if (SortDir = "ASC") then
            if FormatCompare(vec(SortField,loBound),vec(SortField,hiBound)) > FormatCompare(vec(SortField,hiBound),vec(SortField,loBound)) then Call SwapRowsADO(vec,hiBound,loBound)
        else
            if FormatCompare(vec(SortField,loBound),vec(SortField,hiBound)) < FormatCompare(vec(SortField,hiBound),vec(SortField,loBound)) then Call SwapRowsADO(vec,hiBound,loBound)
        end if
      End If
      '== Three or more items to sort

      For counter = 0 to Ubound(vec,1)
        pivot(counter) = vec(counter,int((loBound + hiBound) / 2))
        vec(counter,int((loBound + hiBound) / 2)) = vec(counter,loBound)
        vec(counter,loBound) = pivot(counter)
      Next
      loSwap = loBound + 1

      hiSwap = hiBound
      do

        '== Find the right loSwap
        if (SortDir = "ASC") then
            while loSwap < hiSwap and FormatCompare(vec(SortField,loSwap),pivot(SortField)) <= FormatCompare(pivot(SortField),vec(SortField,loSwap))
              loSwap = loSwap + 1
            wend
        else
            while loSwap < hiSwap and FormatCompare(vec(SortField,loSwap),pivot(SortField)) >= FormatCompare(pivot(SortField),vec(SortField,loSwap))
              loSwap = loSwap + 1
            wend
        end if
        '== Find the right hiSwap
        if (SortDir = "ASC") then
            while FormatCompare(vec(SortField,hiSwap),pivot(SortField)) > FormatCompare(pivot(SortField),vec(SortField,hiSwap))
              hiSwap = hiSwap - 1
            wend
        else
            while FormatCompare(vec(SortField,hiSwap),pivot(SortField)) < FormatCompare(pivot(SortField),vec(SortField,hiSwap))
              hiSwap = hiSwap - 1
            wend
        end if
        '== Swap values if loSwap is less then hiSwap
        if loSwap < hiSwap then Call SwapRowsADO(vec,loSwap,hiSwap)
      loop while loSwap < hiSwap
      For counter = 0 to Ubound(vec,1)

        vec(counter,loBound) = vec(counter,hiSwap)
        vec(counter,hiSwap) = pivot(counter)
      Next
      '== Recursively call function .. the beauty of Quicksort

        '== 2 or more items in first section
        if loBound < (hiSwap - 1) then Call QuickSortADO(vec,loBound,hiSwap-1,SortField,SortDir)
        '== 2 or more items in second section
        if hiSwap + 1 < hibound then Call QuickSortADO(vec,hiSwap+1,hiBound,SortField,SortDir)
  end if
End Sub  'QuickSortADO
Sub SwapRowsADO(ary,row1,row2)

  '==------------------------------------------==
  '== This proc swaps two rows of an array     ==
  '==------------------------------------------==
  Dim x,tempvar

  For x = 0 to Ubound(ary,1)
    tempvar = ary(x,row1)
    ary(x,row1) = ary(x,row2)
    ary(x,row2) = tempvar
  Next
End Sub  'SwapRowsADO
function FormatCompare(sOne,sTwo)
  '==------------------------------------------==
  '==  Checks sOne & sTwo, returns sOne as a   ==
  '==  Numeric if both pass isNumeric, if not  ==
  '==  returns sOne as a string.               ==
  '==------------------------------------------==
    if (isNumeric(Trim(sOne)) AND isNumeric(Trim(sTwo))) then

        FormatCompare = CDbl(Trim(sOne))
    else
        FormatCompare = Trim(sOne)
    end if
end function

Sub PrintArrayADO(vec,loRow,hiRow,markCol)
   
  '==------------------------------------------==
  '== Print out an array  Highlight the column ==
  '==  whose number matches param markCol      ==
  '==------------------------------------------==
  Dim ColNmbr,RowNmbr

  Response.Write "<table border=""1"" cellspacing=""0"">"
  For RowNmbr = loRow to hiRow
    Response.Write "<tr>"
    For ColNmbr = 0 to Ubound(vec,1)
      If ColNmbr = markCol then
        Response.Write "<td bgcolor=""FFFFCC"">"
      Else
        Response.Write "<td>"
      End If
      Response.Write vec(ColNmbr,RowNmbr) & "</td>"
    Next
    Response.Write "</tr>"
  Next
  Response.Write "</table>"
End Sub  'PrintArray
%>