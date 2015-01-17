<%
'***********************************************************************************************************************
'** FileName	:	Upload.asp
'** Versione	: 	3.1.1
'** Autore  	: 	Lorenzo Abbati
'** Email		: 	lorenzomail@tiscalinet.it
'** download 	: 	http://www21.brinkster.com/lorzdesign/upload/
'** licenza		:	Copyright (GNU)
'** Si ringrazia Ludo VR del forum di Html.it (http://forum.html.it) per l'aiuto.
'***********************************************************************************************************************

	Const TEM = &h01
	Const SOF = &hc0
	Const DHT = &hc4
	Const JPGA= &hc8
	Const DAC = &hcc
	Const RST = &hd0
	Const SOI = &hd8
	Const EOI = &hd9
	Const SOS = &hda
	Const DQT = &hdb
	Const DNL = &hdc
	Const DRI = &hdd
	Const DHP = &hde
	Const EXP_ = &hdf
	Const APP = &he0
	Const JPG = &hf0
	Const COM = &hfe

	Const adLongVarChar		= 201
	Const adLongVarBinary	= 205
	Const adBoolean			= 11
	Const adVarChar			= 200
	Const adSmallInt		= 2
	Const adInteger			= 3
	Const adBigInt			= 20
	Const adDate			= 7

	Const adBinary			= 1
	Const adText			= 2

	Const adFBinary			= 1
	Const adFText			= 2

	Const AND_	= " AND "
	Const OR_	= " OR "

	Class cDatabase
		Private Conn
		Private Rs
		Public Fields

		Public ConnectionString
		Public Source

		Private Sub ClassInitialize()
		End Sub

		Private Sub Class_Terminate()
			Close()
		End Sub

		Private Sub CreateFields()
			If VarType(Fields)<>9 then Set Fields = Server.CreateObject ("Scripting.Dictionary")
		End Sub

		Public Sub Open()
			SetConnection ConnectionString
			SetRecordset Source
		End Sub

		Public Sub SetConnection(byRef ConnOrString)
			CreateFields()
			Select Case VarType(ConnOrString)
				Case 9:
					Set Conn = ConnOrString
					if dbManager.conn.State = 0 then dbManager.conn.Open()
				Case Else:
					Set Conn = CreateObject("ADODB.Connection")
					dbManager.conn.ConnectionString = ConnOrString
					dbManager.conn.Open
			End Select
		End Sub

		Public Sub SetRecordset(byRef RecordsetOrQuery)
			Select Case VarType(RecordsetOrQuery)
				Case 9:
					Set Rs = RecordsetOrQuery
				Case Else:
					Set Rs = CreateObject("ADODB.Recordset")
					Rs.Open RecordsetOrQuery,Conn,3,3
			End Select
		End sub

		Public Sub AddNew()
			Rs.AddNew
			Update()
		End Sub

		Public Sub Update()
		Dim elm,Error
			If Fields.Count>0 then
				Error = False
				On error resume next
				For each elm in Fields.Keys
					Rs(Elm) = Fields(Elm)
					If err<>0 then
						Response.Write("<p style='font-size:11px;font-family:verdana'><strong>Errore </strong> durante l'inserimento di <strong>" & elm & "</strong> : " & err.Description &"</p>")
					end if
				next
				Rs.Update
				Fields.RemoveAll
				On error goto 0
			end if
		End Sub

		Public Sub Close()
			On error resume next
			Rs.Close
			dbManager.conn.Close
			On error goto 0
			Set Conn = Nothing
			Set Rs = Nothing
			Fields.RemoveAll
			Set Fields = Nothing
		End Sub
	End Class

	Class cUpload
			'*** Info ****
			Public Version
			Public Autore

			'*** Variabili ***
			Public WebServerFP
			Public IsMultipart


			'*** Oggetti ***
			Public Stream
			Public Fso
			Public Form
			Public Files
			Public Connection
			Public Database

			'*** Opzioni Utente ***
			Public OverWrite
			Public AutoRename

			Public EnabledAspUpload
			Public EnabledLog
			Public EnabledImageSize
			Public ConnectionSpeed

			Public LoadFilesInForm
			Public LogDelimiter
			Public LogName

			Public FormValuesDelimiter

			Public IsDataLoad
			'*** Private ****

			Private Rs
			Private iTotalBytes
			Private RequestBin
			Private iPath
			Private PathInclude
			Private CurrentPath
			Private iTempFolder

			Private iLogFolder
			Private iAddInformationToLog
			Private iOnlySave
			Private InitTime

			Private cContentDisp
			Private cContentType
			Private cName
			Private cFileName
			Private cEndBin
			Private c13b
			Private c34b
			Private cVbCrLf

'************************ Initialize() *****************************************************************
	Private Sub Class_Initialize()
		Dim tMp
			InitTime = Timer()
			'*** Creazione Oggetti ****
			Set Stream 	= 	Server.CreateObject("ADODB.Stream")
			Set Rs		=	Server.CreateObject("ADODB.Recordset")
			Set Fso 	= 	Server.CreateObject("Scripting.FileSystemObject")
			Set Form	=	Server.CreateObject("Scripting.Dictionary")
			Form.CompareMode = 1
			Rs.Fields.Append "sBinary"			, adLongVarChar, -1
			Rs.Fields.Append "bBinary"			, adLongVarBinary,-1
			Rs.Open

			'*** Impostazione Variabili ****
			Server.ScriptTimeout = 500
			Version 	= 	"3.1.1"
			Autore 		= 	"Lorenzo Abbati - lorenzomail@tiscalinet.it"
			WebServerFP	= 	Request.ServerVariables("APPL_PHYSICAL_PATH")
			iTotalBytes  =	Request.TotalBytes
			LogDelimiter = "|"
			iPath		 =	""
			CurrentPath = 	GetCurrentPath()
			iLogFolder	 = CurrentPath & "Logs\"
			iTempFolder	 = CurrentPath & "UploadTempFolder\"
			PathInclude  = CurrentPath & "include\"
			iAddInformationToLog = ""
			LogName		 = Replace(Date(),"/","-") & ".log"
			IsDataLoad = False
			'*** Impostazioni Default Parametri Utente ****
			OverWrite	=	False
			AutoRename	=	True
			EnabledLog	=	False
			IsMultipart =	False
			EnabledImageSize = True
			EnabledAspUpload = False
			LoadFilesInForm = True
			FormValuesDelimiter = ", "
	end sub

	public property get TotalBytes()
		TotalBytes = iTotalBytes
	end property

	private Function InitUploadFiles()
	'*** Impostazione Valori in Byte ****
		If VarType(Files)<>9 then
		cContentDisp = getByteString("Content-Disposition")
		cContentType = getByteString("Content-Type:")
		cName		 = getByteString("name=""")
		cFileName	 = getByteString("filename=")
		c13b	     = getByteString(chr(13))
		c34b		 = getByteString(chr(34))
		cEndBin		 = getByteString("--")
		cVbCrLf		 = getByteString(vbCrLf)
		Set Files	= 	Server.CreateObject("ADODB.Recordset")
		Files.Fields.append "InputName"		,adVarChar,255
		Files.Fields.append "FileName"		,adVarChar,255
		Files.Fields.append "DestPath"		,adVarChar,255
		Files.Fields.append "Name"			,adVarChar,255
		Files.Fields.append "Ext"			,adVarChar,255
		Files.Fields.append "FileExists"	,adBoolean,1
		Files.Fields.append "ContentType"	,adVarChar,255
		Files.Fields.append "Size"			,adBigInt,-1
		Files.Fields.append "StreamType"	,adSmallInt,2
		Files.Fields.append "Date"			,adDate,-1
		Files.Fields.append "OverWrite"		,adBoolean,1
		Files.Fields.append "AutoRename"	,adBoolean,1
		Files.Fields.append "Cancel"		,adBoolean,1
		Files.Fields.append "Saved"			,adBoolean,1
		If EnabledImageSize then
			Files.Fields.append "Height"		,adInteger,-1
			Files.Fields.append "Width"			,adInteger,-1
			Files.Fields.append "Info"			,adVarChar,255
		end if
		Files.Fields.append "ErrorNumber"	,adInteger,4
		Files.Fields.append "Error"			,adVarChar,255
		Files.Fields.append "Content"		,adLongVarBinary,-1

		Files.Open
		end if
	end function

	Private function BinaryStringRead()
	Dim bR,bTr
			bR = 0:bTr = 1024 * 20
				Rs.AddNew
			while bR< iTotalBytes
				if iTotalBytes - (br + bTr)< 0 then bTr = iTotalBytes - bR
				rs.fields("sBinary").AppendChunk Request.BinaryRead(bTr)
				bR = bR + bTr
			wend
			Rs.Update
			BinaryStringRead = rs.fields("sBinary")
			Rs.CancelUpdate
	end function

	Private function BinaryRead()
	Dim bR,bTr,iT,eT,ePT
			Stream.Type = 1
			Stream.Open
			bR = 0:bTr = 1024 * 20
			iT = Timer()
			do while bR< iTotalBytes
				if iTotalBytes - (br + bTr)< 0 then bTr = iTotalBytes - bR
				Stream.Write Request.BinaryRead(bTr)
				bR = bR + bTr
			loop

			eT = Timer()
			if (Et-iT)<>0 then
				ConnectionSpeed = cStr(round((bR / (Et-iT)) / 1024,1)) & " [kb/s]"
			else
				ConnectionSpeed =   cStr(round(bR/1024,1)) & " [kb/ms]"
			end if
			Stream.Position = 0
	end function

'************************ Funzioni Principali ****************************************************
	Public Sub CreateDatabase()
		Set Database = new cDatabase
	End Sub

	Public Sub SetDatabase(ConnString,Source)
		CreateDatabase()
		Database.ConnectionString = ConnString
		Database.Source = Source
	End Sub

	Public Sub Load()
		UpLoad()
	end Sub

	Private Sub AddToForm(Name,Value)
		If Not Form.Exists(Name) then
				If Value<>"" then Form.add Name, Value
			else
				If Value<>"" then
					Form(name) = Form(name) & FormValuesDelimiter & Value
				end if
		end if
	End Sub

	Public Function UpLoad()
	Dim index,elm,i,EndOfFile,arPosBeg(),arPosEnd(),arPosName(),SizeStream,nE,BytesToRead,Header ,arContent,ar,tmp
	Dim PosBeg,PosEnd,Name,FileName,ContentType,StreamType,Boundary,Content,boundaryLen,boundaryPos,Pos,arV,fieldValue
		If EnabledLog then CreateFolder iLogFolder
		If iTotalBytes>0 then
				If Request.ServerVariables("HTTP_CONTENT_TYPE")="application/x-www-form-urlencoded" then
					Content = BinaryStringRead()
					ar = split(Content,"&")
					ar = split(Content,"&")
					for each elm in ar
						arV = split(elm,"=")
						Index = URLDecode(arV(0))
						on error resume next
						FieldValue = URLDecode(arV(1))
						on error goto 0
						AddToForm Index,FieldValue
					next
				else
					IsMultipart =  True
					InitUploadFiles()
					BinaryRead()
					'**** Deteterminazione Boundary ****

					SizeStream = Stream.Size
					RequestBin = Stream.Read(60)
					PosBeg = 1:PosEnd = InstrB(PosBeg,RequestBin,c13b)
					boundary = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
					boundaryLen = LenB(boundary):boundaryPos = 1

					'**** End OF File Position ****
					EndOfFile = SizeStream - boundaryLen - 3

					'**** Salvataggio Posizione di Boundary *****
					Stream.Position = 0
					RequestBin = Stream.Read()
					nE = -1:Pos = 1
					do
						PosBeg = InStrB(Pos,RequestBin,boundary)
						if PosBeg>0 then
							PosBeg = InStrB(PosBeg + boundaryLen,RequestBin,cName)
							PosEnd = InstrB(PosBeg+1,RequestBin,boundary)
							If PosEnd >0 then
								nE = nE + 1
								redim preserve arPosBeg(nE)
								redim preserve arPosEnd(nE)
								redim preserve arPosName(nE)
								arPosBeg(nE) = PosBeg
								arPosEnd(nE) = PosEnd
								tmp = InStrB(PosBeg + 1,RequestBin,cContentType)
								arPosName(Ne) = 0
								If tmp<PosEnd then
									arPosName(Ne) = tmp
								end if
								if arPosName(Ne) = 0 then
									arPosName(Ne) = InStrB(PosBeg + 1,RequestBin,c13b) + 3
								end if
							end if
							Pos  = PosEnd
						end if
					loop until Pos=EndOfFile
					for i=0 to nE
						FileName=""
						Stream.Position = arPosBeg(i)-1
						Header = Split(BinaryToString(Stream.Read(arPosName(i)-arPosBeg(i))),"; ")
						if uBound(Header)>0 then
							on error resume next
							execute Header(0) & ":" & Header(1)
							if err.number<>0 then
								response.write err.description &"<br />"
								response.write Header(0) & ":" & Header(1)
								response.end
							end if
							on error goto 0
							If FileName<>"" then
								Stream.Position = arPosName(i)-1
								RequestBin = Stream.Read (60)
								Pos = InStrB(1,RequestBin,c13b)
								ContentType = BinaryToString(MidB(RequestBin,1,Pos-1))
								arContent = Split(ContentType,": ")
								ContentType = arContent (1)
								StreamType=1 : If InStr(ContentType,"text/")>0 then StreamType=2
								PosBeg = arPosName(i) + Pos + 2
								Stream.Position = PosBeg
								RequestBin = Stream.Read (arPosEnd(i)-PosBeg-3)
								AddNewRs Name,FileName,ContentType,StreamType,RequestBin
								if LoadFilesInForm then AddToForm Name,FileName
							else
								Form(Name) = ""
							end if
						else
							Execute Header(0)
							Stream.Position = arPosName(i)
							RequestBin = Stream.Read(arPosEnd(i)-arPosName(i)-3)
							AddToForm Name,BinaryToString(RequestBin)
						end if
					next
					IsDataLoad = True
					Stream.Close
					MoveFirst
					end if
		End if
	End function

'************************ Funzioni per il salvataggio files *********************************************************

	Private sub AddNewRs(Name,FileName,ContentType,StreamType,ByRef RequestBin)
	Dim tmpName,ar
		tmpName = Right(FileName,Len(FileName)-InstrRev(FileName,"\"))
		Files.AddNew
		Files("InputName")		= Name
		Files("FileName")		= lCase(FileName)
		If InstrRev(tmpName,".")=0 then tmpName = tmpName & "."
		Files("ext")			= lCase(Right(tmpName,Len(tmpName)-InstrRev(tmpName,".")))
		Files("Name")			= lCase(Left(tmpName ,InstrRev(tmpName,".")-1))
		Files("DestPath")		= lCase(GetPath(iPath))
		Files("ContentType")	= ContentType
		Files("Date")			= Now()
		Files("StreamType")		= StreamType
		Files("Cancel") 		= False
		Files("Saved")			= False
		Files("OverWrite") 		= OverWrite
		Files("AutoRename") 	= AutoRename
		Files("FileExists")     = fso.FileExists(Files("DestPath") & GetFileName() )
		Files("Content").AppendChunk RequestBin
		Files("Size") = Files("Content").ActualSize
		If EnabledImageSize then
			If Mid(ContentType,1,5) = "image" then
				pGetImageSize RequestBin,ContentType,ar
				Files("Height") = ar(0)
				Files("Width") = ar(1)
				Files("Info") = ar(2)
			end if
		end if
		Files.Update
	end sub

	Public Function SaveAs(NewName)
	Dim FolderDest,FileName
		If IsMultipart then
			if Not Files.EOF then
				If Not Files("Cancel") and Not Files("Saved") then
					FolderDest = Files("DestPath")
					If CreateFolderDest(FolderDest)=0 then
							if NewName<>"" then FileName = SetNewName(NewName)
							FileName = FolderDest & GetFileName()
							If Files("AutoRename")=True then
								FileName =  Rename(Files("Name"),Files("Ext"),-1)
							end if
							If Files("Ext")<>"asp" or EnabledAspUpload then
								Modules_Save FileName
							else
								Files.Delete
								Files.Update
							end if
							If EnabledLog then SaveLog(LogName)
						end if
				end if
			End if
		end if
	end function

	Public Function Save()
		SaveAs("")
	end function

	Public Function SaveAll()
		If IsMultiPart then
			MoveFirst
			While Not Files.EOF
				SaveAs ""
			MoveNext
			Wend
		end If
	end function

	Public Function UpLoadAndSave()
		UpLoad
		SaveAll
	end function

	Public Function LoadRemoteFile(URL,FileType,ContentType)
	Dim ServerHTTP,Content,RequestBin,RequestText,FileName,StreamType,Name,iT,eT,bR
		on error resume next
		Set ServerHTTP = CreateObject("MSXML2.ServerXMLHTTP.4.0")
		if err.number <>0 then
			Set ServerHTTP = CreateObject("MSXML2.ServerXMLHTTP")
			if err.number <>0 then
				response.Write("<p style=""font-family:verdana;font-size:10""><strong>Errore</strong>: L'oggetto MSXML2.ServerXMLHTTP non è installato sul server</p>")
				response.end
			end if
		end if
		on error goto 0
		InitUploadFiles()
		IsMultipart = true
		ServerHTTP.open "GET",URL,false
		ServerHTTP.Send
		iT = Timer()
		RequestBin = ServerHTTP.responseBody
		while ServerHTTP.readyState<>4
			ServerHTTP.waitForResponse 1000
		wend
		bR = LenB(RequestBin)
		FileName = Replace(URL,"/","\")
		StreamType = FileType
		eT = Timer()
		if (Et-iT)<>0 then
			ConnectionSpeed = cStr(round((bR / (Et-iT)) / 1024,1)) & " [kb/s]"
		else
			ConnectionSpeed =   cStr(round(bR/1024,1)) & " [kb/ms]"
		end if
		AddNewRs Name,FileName,ContentType,StreamType,RequestBin
		MoveFirst
		Set ServerHTTP = Nothing
	End function

	Public Function SaveLog(Name)
	dim i,nFields,s,FileName,TextFile
		FileName = iLogFolder & Name
		s= iAddInformationToLog
		if s<>"" then s = s & LogDelimiter
		s = Request.ServerVariables("REMOTE_ADDR") & LogDelimiter
		nFields = Files.Fields.Count
		For i=0 to nFields-2
			if Not IsNull(Files(i).Value) then s = s & Files(i).Value
			if i <> nFields then s = s & LogDelimiter
		next
		If Not Fso.FileExists (FileName) then
			Set TextFile= Fso.CreateTextFile(FileName,True)
		else
			Set TextFile = Fso.OpenTextFile(FileName,8)
		end if
		TextFile.WriteLine s
		TextFile.Close
		Set TextFile = nothing
	End function

'************************ Funzioni Get *********************************************************
	Public Function GetContent()
		if Not Files.EOF then
				GetContent = Files("Content").GetChunk(Files("Content").ActualSize)
		end if
	end function

	Public Function GetHTTPPathFile()
	Dim s
		GetHTTPPathFile=""
		if Not Files.EOF then
			s = Files("DestPath") & Files("Name")
			s = Mid(s,Len(WebServerFP))
			s = Replace(s,"\","/")
			if Files("Ext")<>"" then s = s & "." & Files("Ext")
			GetHTTPPathFile = s
		end if
	end function

	Public Function GetCompletePathFile()
	Dim s
		GetCompletePathFile=""
		if Not Files.EOF then
			s = Files("DestPath") & Files("Name")
			if Files("Ext")<>"" then s = s & "." & Files("Ext")
			GetCompletePathFile = s
		end if
	end function

	Public Function GetFileName()
	Dim s
		GetFileName=""
		if Not Files.EOF then
			s = Files("Name")
			if Files("Ext")<>"" then s = s & "." & Files("Ext")
			GetFileName = s
		end if
	end function

	Public Function GetCurrentPath()
	Dim tMp
		tMp = Request.ServerVariables("PATH_TRANSLATED")
		GetCurrentPath = Mid(tMp,1,InStrRev(tMp,"\"))
	End function

	Private Function GetPath(Path)
		If Path<>"" then
			GetPath	= Path
		else
			GetPath	= CurrentPath
		end if
	end function

	Public Function GetImageSize(FileName,byRef width, ByRef height,byRef info)
	Dim Bin,ar
		Stream.Type = 1
		Stream.Open
		Stream.LoadFromFile FileName
		Bin = Stream.Read
		pGetImageSize Bin,Mid(FileName,InStrRev(FileName,".")+1),ar
		height = ar(0)
		Width = ar(1)
		Info = ar(2)
		Stream.Close
	end function

	Public Function GetTextFile(PathFile)
	Dim f
		If fso.FileExists(PathFile) then
			Set f=Fso.OpenTextFile(PathFile,1)
			GetTextFile = f.ReadAll
			f.close
			Set f= Nothing
		else
			GetTextFile = ""
			Response.Write("<p style=""font-size:11;font-family:verdana"">File richiesto non trovato [<strong>" & PathFile &"</strong>]</p>")
		end if
	end function

	private Function ConvertPos(position)
	dim value
		on error resume next
		value = cLng(Position)
			if err.number <>0 then
				ConvertPos = HexToDec(Position) + 1
			else
				ConvertPos = Position + 1
			end if
		on error goto 0
 	end function

	private function ReadAsEdian(byRef Content,HexPos,nBytes)
	Dim posDec,value
		PosDec = ConvertPos(HexPos)
		value = BytesToHex(GetByteString(strReverse(ReadAsString(Content,HexPos,nBytes))))
		ReadAsEdian = HexToDec(value)
	end function

	private function ReadAsDec(byRef Content,HexPos,nBytes)
	Dim posDec,value
		PosDec = ConvertPos(HexPos)
		value = ReadAsHex(Content,HexPos,nBytes)
		ReadAsDec = HexToDec(value)
	end function

	private function ReadAsBytes(byRef Content,HexPos,nBytes)
	Dim posDec,value
		PosDec = ConvertPos(HexPos)
		ReadAsBytes =MidB(content,PosDec,nBytes)
	end function

	private function ReadAsHex(byRef Content,HexPos,nBytes)
	Dim posDec,value
		PosDec = ConvertPos(HexPos)
		ReadAsHex = BytesToHex(MidB(content,PosDec,nBytes))
	end function

	private function ReadAsString(byRef Content,HexPos,nBytes)
	Dim posDec,valueB,value
		PosDec = ConvertPos(HexPos)
		ReadAsString =  BinaryToString(MidB(content,PosDec,nBytes))
	end function

	Private Function FindBytes(StartPos,byRef Content,BytesToFind)
		FindBytes = InStrB(StartPos,Content,HexToByte(BytesToFind))
	end function

	Private Sub Inc(byRef Var , count)
		var = var + count
	end sub

	Private Function pGetImageSize(byRef RequestBin,ContentType,ByRef arResult)
	Dim h,w,Tmp,Size,segment,Pos,SOfLenght,Info,hH,Marker,arSOF,FileSize
		h=-1:w=-1
			Select Case lcase(ContentType)
				case "image/pjpeg","image/jpeg","jpg","jpeg":
					arSOF =	Array("baseline DCT Huffman","extended sequential DCT Huffman",_
							"progressive DCT Huffman","spatial lossless Huffman",_
							"SOF4","differential sequential DCT Huffman",_
							"differential progressive DCT Huffman","differential spatial Huffman",_
							"SOF8","extended sequential DCT arithmetic",_
							"progressive DCT arithmetic","spatial lossless arithmetic",_
							"SOF12","differential sequential DCT arithmetic",_
							"differential progressive DCT arithmetic","differential spatial arithmetic")
					Pos = 0:FileSize = LenB(RequestBin)
					If ReadAsDec(RequestBin,Pos,1)=&hff then
						Do While (Pos<FileSize)
							Inc Pos,1
							Marker = ReadAsDec(RequestBin,Pos,1)
							while  Marker = &hff
								Inc Pos,1
								Marker = ReadAsDec(RequestBin,Pos,1)
							Wend
							Inc Pos,1
							Select Case Marker
								Case DHP,SOF+0,SOF+1,SOF+2,SOF+3,SOF+9,SOF+10,SOF+11,SOF+5,SOF+6,SOF+7,SOF+13,SOF+14,SOF+15:
									if marker=DHP then
										Info = "DHP"
									else
										Info = "JPG : " & arSOF(Marker-SOF)
									end if
									SOFLenght = ReadAsDec(RequestBin,Pos,2)
									Inc Pos,3 'Skip Precision
									H = ReadAsDec(RequestBin,Pos,2)
									Inc Pos,2
									W = ReadAsDec(RequestBin,Pos,2)
									Inc Pos,2
									Exit Do
								Case APP+0,APP+1,APP+2,APP+3,APP+4,APP+5,APP+6,APP+7,APP+8,APP+9,APP+10,APP+11,APP+12,APP+13,APP+14,APP+15:
									Inc Pos,ReadAsDec(RequestBin,Pos,2)
								Case DRI,SOS,DQT,DHT,DAC,DNL,EXP_:
									Inc Pos,ReadAsDec(RequestBin,Pos,2)
							End select
						Loop
					end if
				case "image/gif","gif":
					Info = ReadAsString(RequestBin,"0000",6)
					w = ReadAsEdian(RequestBin,"0006",2)
					h = ReadAsEdian(RequestBin,"0008",2)
				case "image/bmp","bmp":
					info = "Bitmap"
					w = ReadAsEdian(RequestBin,18,4)
					h = ReadAsEdian(RequestBin,22,4)
				case "image/png","png":
				Case Else
					info = "Format Not Supported "& ContentType
			end select
			arResult = array(h,w,info)
	end function

'************************ Funzionisi Impostazione Percorsi  *********************************************************

	Public Function SetLogFile(AddInformationToLog)
		EnabledLog=True
		iAddInformationToLog=AddInformationToLog
	end function

	Public Function SetPath(StringPath)
		iPath = Server.MapPath (StringPath) & "\"
		If IsDataLoad then
			MoveFirst
			While Not EOF
				Files("DestPath") = iPath
				Files.Update
			MoveNext
			Wend
			MoveFirst
		end if
	End function

	Public Function SetLogPath(value)
		iLogPath = Server.MapPath (Value)
	end function

	Public Function SetServerTimeOut(Minutes)
		Server.ScriptTimeout = Minutes * 60
	end function

'************************ Funzioni su folder, path, file *********************************************************
	Private sub Modules_Save(FileName)
	Dim TextFile,TestOverWrite
			select Case Files("StreamType")
			Case 1
				Stream.Type = Files("StreamType")
				Stream.Open
				Stream.Write Files("Content")
				If TestError(err) then
					exit sub
				end if
				on error resume next
				Stream.SaveToFile FileName,GetOverValue(Files("OverWrite"))
				If TestError(err) then
					exit sub
				end if
				Stream.close
				on error goto 0

			Case 2
				on error resume next
				Set TextFile = Fso.CreateTextFile(FileName,Files("OverWrite"))
				If TestError(err) then
					exit sub
				end if
				TextFile.Write(BinaryToString(Files("Content")))
				If TestError(err) then
					exit sub
				end if
				TextFile.close
				on error goto 0

			end select
	end sub

	Private function TestError(byRef e)
		TestError=False
		If E.Number <> 0 then
				Files("Error") = e.Description
				Files("Saved") = False
				TestError=True
			else
				Files("Saved") = true
		end if
		Files("ErrorNumber") = e.number
	end function

	Private function Rename (Name,ext,count)
	Dim Dest,tmpExt
		If fso.fileExists(GetCompletePathFile()) then
			Count = -1:tmpExt =""
			if Ext<>"" then tmpExt = "." & Ext
			do
				Count = Count + 1
				Dest = Files("DestPath") & Files("Name") & "_" & cStr(Count) & tmpExt
			loop while fso.fileExists(Dest)
			If Not Files("Overwrite") then
					Files("Name") = Name & "_" & Count
					Files("ext") = Ext
					Files.update
					Rename = Dest
			else
					Fso.MoveFile GetCompletePathFile(),Dest
					Rename = GetCompletePathFile()	
			End if
		else
			rename = GetCompletePathFile()
		end if
	end function

	Private function CreateFolderDest(FolderDest)
		If Not Fso.FolderExists(FolderDest) then
			on error resume next
				fso.CreateFolder FolderDest
				if err.number<>0 then
					Files("ErrorNumber") = err.number
					Files("Error") = err.Description
					Files("Saved") = false
					Files.MoveNext
				end if
				CreateFolderDest = err.number
				Exit Function
			on error goto 0
		End if
		CreateFolderDest = 0
	End Function

	Private Function CreateFolder(f)
		If not Fso.FolderExists(f) then Fso.CreateFolder(f)
	end function

'************************ Conversioni String-Byte Byte-String ****************************************************

	Private Function GetString(StringBin)
	Dim IntCount
		getString =""
		For intCount = 1 to LenB(StringBin)
			getString = getString & chr(AscB(MidB(StringBin,intCount,1)))
		Next
	End Function

	Private Function GetByteString(StringStr)
	Dim i,	char
		For i = 1 to Len(StringStr)
			char = Mid(StringStr,i,1)
			getByteString = getByteString & chrB(AscB(char))
		Next
	End Function

	private Function HexToByte(valueHex)
	dim LenV,Word,Result,i
		Result = null
		LenV = Len(valueHex)
		if lenV mod 2 <> 0 then
			LenV = LenV + 1
			valueHex = "0" & valueHex
		end if
		for i=1 to LenV
			Word = Mid(ValueHex,i,2)
			Result = Result & ChrB(HexToDec(Word))
			i=i+1
		next
		HexToByte = result
	end function

	Private Function BinaryToString(xBinary)
	Dim Binary,LBinary
	If vartype(xBinary)=8 Then Binary = MultiByteToBinary(xBinary) Else Binary = xBinary
		LBinary = LenB(Binary)
		If LBinary>0 Then
			RS.AddNew
			RS("sBinary").AppendChunk Binary
			RS.Update
			BinaryToString = RS("sBinary")
			Rs.CancelUpdate
		Else
			BinaryToString = ""
		End If
	End Function

	Private Function MultiByteToBinary(MultiByte)
	Dim LMultiByte, Binary
		LMultiByte = LenB(MultiByte)
			If LMultiByte>0 Then
				RS.AddNew
					RS("bBinary").AppendChunk MultiByte &chrB(0)
				RS.Update
				Binary = RS("bBinary").GetChunk(LMultiByte)
				Rs.Delete
				RS.Update
			End If
		MultiByteToBinary = Binary
	End Function

	Private Function HexToDec(cadhex)
		Dim n, i, ch, decimal
		decimal = 0
		n = Len(cadhex)
		For i = 1 to n
			decimal = decimal * 16
			ch = Mid(cadhex, i, 1)
			decimal = decimal + inStr(1,"0123456789ABCDEF", ch,1) - 1
		Next
		hextodec = decimal
	End Function

	Private Function HexAt(s, n)
		hexat = hex(asc(mid(s, n, 1)))
		If len(hexat) = 1 then hexat = "0" & hexat
	End Function

	Private Function BytesToHex(v)
	Dim i,r,s
		r = ""
		s = GetString(v)
		For i=1 to LenB(v)
			r = r & lCase(HexAt(s,i))
		next
		BytesToHex = r
	end function

	Private Function BytesToDec(Bytes)
		v = HexToDec(BytesToHex(Bytes))
		BytesToDec = v
	End Function

	Public Function URLDecode(ByVal What)
	Dim Pos, pPos
		What = Replace(What, "+", " ")
		Stream.Type = 2 'String
		Stream.Open
		Pos = InStr(1, What, "%")
		pPos = 1
		Do While Pos > 0
		Stream.WriteText Mid(What, pPos, Pos - pPos) + _
			Chr(CLng("&H" & Mid(What, Pos + 1, 2)))
		pPos = Pos + 3
		Pos = InStr(pPos, What, "%")
		Loop
		Stream.WriteText Mid(What, pPos)
		Stream.Position = 0
		URLDecode = Stream.ReadText
		Stream.Close
	End Function

'************************ Funzioni su Recodset Files *****************************************************************
	Public Function MoveFirst()
		On error resume next
			Files.MoveFirst
		on error goto 0
	end function

	Public Function MoveNext()
		on error resume next
			Files.MoveNext
		on error goto 0
	end function

	Public Property Get EOF()
		EOF = Files.EOF
	end property

	Public Function Cancel()
		If Not Files.EOF then Files("Cancel")=True
	end function

	Public Function Delete()
		If Not Files.EOF then
			Files.Delete
			Files.Update
		end if
	end function

	Public Property Get Count
		count = Files.RecordCount
	end property

	public Function Close()
		on error resume next
			Files.close
			Rs.Close
			Stream.Close
		on error goto 0
				Set Stream 	= 	nothing
		Set Connection = nothing
		Set Files	= 	nothing
		Set Fso 	= 	nothing
		Set Rs		=	nothing
		Set Form	=   nothing
	end function

'************************ Filtri Preimpostati ******************************************************************************

	Public Property Let Filter(sFilter)
		Files.Filter = sFilter
	end Property

	Public Sub UploadOnly(sToFilter)
		Select Case lCase(sToFilter)
			Case "images","image"	:Files.Filter = FilterImage()
			Case "audio"			:Files.Filter = FilterAudio()
			Case "application"		:Files.Filter = FilterApplication()
			Case "text"				:Files.Filter = FilterText()
			Case "video"			:Files.Filter = FilterVideo()
			Case "zip"				:Files.Filter = "ContentType like 'application/x-zip-compressed'"
		end Select
	end sub

	public function FilterContentType(sMime,sType)
		FilterContentType = "([ContentType] like '"& sMime & "/" & sType &"')"
	end function

	Public function FilterImageSize(Height,Width)
		FilterImageSize =  FilterImage() & " AND ([Height]" & Height & " and [width]" & Width & ")"
	end function

	Public function FilterSize(MaxSize)
		FilterSize = "([SIZE]<" & MaxSize &")"
	end function

	Public Function FilterImage()
		FilterImage = FilterContentType("image","*")
	End Function

	Public Function FilterAudio()
		FilterAudio = FilterContentType("audio","*")
	End Function

	Public Function FilterApplication()
		FilterApplication = FilterContentType("application","*")
	End Function

	Public Function FilterText()
		FilterText = FilterContentType("text","*")
	End Function

	Public Function FilterVideo()
		FilterVideo = FilterContentType("video","*")
	End Function

'************************ Funzioni Varie ******************************************************************************

	private Function SetNewName(NewName)
	Dim Pos
			Pos = InStrRev(NewName,".")
			If Pos>0 then
				Files("ext")=Mid(NewName,Pos+1,Len(NewName)-Pos)
				Files("Name")=Left(NewName,Pos-1)
			else
				Files("Name")=NewName
				Files("ext")=""
			end if
	End function

	private Function GetOverValue(t)
	Dim v
		v=1:If t=True then v=2
		GetOverValue=v
	end function

'************************ Funzioni Print ******************************************************************************
	Private Function WriteRecordset(byRef rRs,Title)
		Dim f,StrTmp,nCol
		If IsMultiPart then
		nCol=1

		nCol = rRs.Fields.count
		Response.Write("<Table border=0 cellspacing=1 cellpadding=2 style=""background-color:silver;font-size:11;font-Family:verdana;width:100%""><tr><td style=""background-color:#B0C4DE;color:navy"" colSpan="""& nCol & """><strong>" & Title &"</strong></td></tr><tr>")
			For each f in rRs.Fields
				Response.Write("<td style="" background-color:#E0EEF8;color:navy;"">" & f.name & "</td>")
			next
			Response.Write("</tr>")
		on error resume next
			rRs.MoveFirst
		on error goto 0
			While Not rRs.EOF
				Response.Write("<tr>")
				For each f in rRs.Fields
					If f.Name<>"Content" then
						strTmp = Files(f.name)
					else
						strTmp=""
						'strTmp = Server.HTMLEncode(BinaryToString(Files(f.name)))
					end if
					if StrTmp="" then strTmp ="&nbsp;"
					Response.Write("<td style="" background-color: #FFFFE0;"">" & strTmp & "</td>")
				next
				Response.Write("</tr>")
				rRs.MoveNext
			WEnd

		Response.Write("<tr><td  colspan=""" & nCol &""" style=""font-size:10;background-color:#E0EEF8;color:gray""><u>Altre Informazioni</u> <strong>Speed</strong>:" & ConnectionSpeed &" <strong>Time</strong>:"& GetExecuteTime()&" sec. - <strong>Log Attivo</strong>:"& EnabledLog &"["&LogName &"] - <strong>OverWrite</strong>:" & OverWrite & " - <strong>AutoRename</strong>:" & AutoRename & " - <strong>Filtri</strong>:" & Files.Filter  &" - <strong>TotalBytes</strong>:" & iTotalBytes&"</td></tr>")
		Response.Write("</Table><br />")
		'on error goto 0
		end if
	end function

	Public Function PrintForm()
	dim i,n,arK,arI
		arK = form.Keys
		arI = form.items
		Response.Write("<Table border=0 cellspacing=1 cellpadding=2 style=""background-color:silver;font-size:11;font-Family:verdana""><tr><td style=""background-color:#B0C4DE;color:navy"" colSpan=""2""><strong>.: Contenuto dell'oggetto FORM :.</strong></td></tr><tr>")
		Response.Write("<td style="" background-color:#E0EEF8;color:navy;"">Name</td><td style="" background-color:#E0EEF8;color:navy;"">Value</td></tr>")
		for i=0 to Form.Count -1
			Response.Write("<td style="" background-color: #FFFFE0;"">" &arK(i) &"</td><td style="" background-color: #FFFFE0;"">" & arI(i) &"</td></tr>")
		next
	Response.Write("</Table><br />")
	end function

	Public Function GetExecuteTime()
		 GetExecuteTime = Timer() - InitTime
	end function

	Public Function PrintStatus(Title)
			WriteRecordset Files,Title
	end function

'************************ Terminate *************
	Private Sub Class_Terminate()
		Close()
	end sub
	

	End Class


%>