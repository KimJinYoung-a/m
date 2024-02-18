<%

''/lib/BarcodeFunction.asp
'' SCM �� ������ ��� ������ �����̾�� �Ѵ�.

'// ============================================================================
'// �ٹ����� ���ڵ� ��������
'// function BF_IsMaybeTenBarcode(barcode)

'// itemgubun ���ϱ�
'// function BF_GetItemGubun(barcode)

'// itemid ���ϱ�
'// function BF_GetItemId(barcode)

'// itemoption ���ϱ�
'// function BF_GetItemOption(barcode)

'// �ٹ����� ���ڵ� ���ϱ�
'// function BF_MakeTenBarcode(itemgubun, itemid, itemoption)

'// ������ ���� itemid ���ϱ�(011111, 01000000)
'// function BF_GetFormattedItemId(itemid)

'// ============================================================================
function BF_GetFormattedItemId(itemid)
	dim tmpStr

	if Len(itemid) < 7 then
		tmpStr = Right(CStr(1000000 + itemid), 6)
	else
		tmpStr = Right(CStr(100000000 + itemid), 8)
	end if

	BF_GetFormattedItemid = tmpStr

end function

'// ============================================================================
function BF_MakeTenBarcode(itemgubun, itemid, itemoption)
	BF_MakeTenBarcode = itemgubun & BF_GetFormattedItemId(itemid) & itemoption

end function

'// ============================================================================
function BF_IsMaybeTenBarcode(barcode)
	dim itemid

	BF_IsMaybeTenBarcode = False

	if IsNull(barcode) then
		exit function
	end if

	itemid = BF_GetItemId(barcode)
	if (itemid = "") then
		exit function
	end if

	if IsNumeric(itemid) then
		BF_IsMaybeTenBarcode = True
	end if

end function


'// ============================================================================
function BF_IsAvailPublicBarcode(barcode)
	dim itemid

	BF_IsAvailPublicBarcode = False

	'// 12 �Ǵ� 14 �ڸ� ���ڷ� ������ ���ڵ�� �ٹ����� ���ڵ�� �г� �� �ִ�.
	'// ���� ��ϺҰ�
	itemid = BF_GetItemId(barcode)
	if (itemid = "") then
		BF_IsAvailPublicBarcode = True
	end if

end function


'// ============================================================================
function BF_GetItemGubun(barcode)
	BF_GetItemGubun = ""

	if IsNull(barcode) then
		exit function
	end if

	barcode = Trim(barcode)

	BF_GetItemGubun = Left(barcode, 2)

end function


'// ============================================================================
function BF_GetItemId(barcode)
	BF_GetItemId = ""

	if IsNull(barcode) then
		exit function
	end if

	barcode = Trim(barcode)

	if Not IsNumeric(barcode) then
		exit function
	end if

	'// 12�ڸ� �Ǵ� 14�ڸ� ���ڵ常 ��ȿ�ϴ�.
	select case Len(barcode)
		case 12
			BF_GetItemId = CStr(CLng(mid(barcode,3,6)))
		''case 13
		''	BF_GetItemId = mid(barcode,3,7)
		case 14
			BF_GetItemId = CStr(CLng(mid(barcode,3,8)))
	end select

end function


'// ============================================================================
function BF_GetItemOption(barcode)
	BF_GetItemOption = ""

	if IsNull(barcode) then
		exit function
	end if

	barcode = Trim(barcode)

	BF_GetItemOption = Right(barcode, 4)

end function

%>
