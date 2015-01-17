<%
'
'	functions_exif.asp
'	EXIF decoding functions and JPEG/TIFF image reader.
'	
'	v1.1 Borrowed from http://www.spaz.com/rtw/test/testExif2.asp
'	     In turn based on VB class at http://sourceforge.net/projects/exifclass/

'	2005/02/03	MPBT	v2.0	 thorough rewrite to deal with TIFFs as well as JPEGs
'				mike.trinder@millerhare.com
'
'		* More efficient IFD reading
'		* File read buffering
'		* corrected decoding of inline Undefined format
'		* More efficient byte order checking
'		* removed dependance on global variables. Now only file buffer is declated by this include
'		* Utility functions to read Fstop, Shutter Speed, Date and focallength from EXIF
'		* More value descriptions added
'		* IFD number added to IFDdirectory to aid distinguishing between thumbnail and main image in TIFF (not actually used yet though)
'
'	TODO
'		* Process MakerNote for various cameras - some formats here: http://park2.wakwak.com/~tsuruzoh/Computer/Digicams/exif-e.html
'		* Merge EXIF directories from two images
'		* Save updated EXIF to image
'		* Return thumbnail data as image
'

'
'	Public Functions
'

'	Load Image - Read EXIF/IFD data from supplied JPEG or TIFF image, return error if any
'		filePath		path to image file
'		IFDDirectory	empty array into which the IFD data will be collected
'		fileOffsets		entry array into which various offsets are collected for use
'						by the image writing functions (not currently implemented)

'	LookupExifTag	- return tag name for supplied tag ID
'		which			tag ID number

'	GetExifByName	- return exif value for supplied tag name
'		IFDDirectory	IFD data array returned from Load Image
'		ExifTagName		name of tag to look for
'		ValueDescribed	boolean - true to return value description, otherwise return raw value

'	getExifByTag	- return exif value for supplied tag ID number
'		IFDDirectory	IFD data array returned from Load Image
'		ExifTag			ID number of tag to look for
'		ValueDescribed	boolean - true to return value description, otherwise return raw value

'	getFStop		- return Fstop for image to one decimal place
'		IFDDirectory	IFD data array returned from Load Image

'	getFocalLength	- return Focal Length of lens for image
'		IFDDirectory	IFD data array returned from Load Image

'	getShutterSpeed	- return Shutter Speed for image as decimal or text
'		IFDDirectory	IFD data array returned from Load Image
'		asText			boolean - true to return Shutter Speed as a text "1/nn s" otherwise returns raw speed

'	getDateTime		- return Date of image as vbScript date
'		IFDDirectory	IFD data array returned from Load Image



'File stream constants
'-----------------------------------------------------------------
const TristateUseDefault = -2
const TristateTrue = -1
const TristateFalse = 0

const ForReading = 1
const ForWriting = 2
const ForAppending = 8

'JPEG constants
'-----------------------------------------------------------------
const JPEG_SOS_MARKER		= "FFDA"
const JPEG_START_MARKER		= "FFD8"
const JPEG_APP0_MARKER		= "FFE0"
const JPEG_APP1_MARKER		= "FFE1"

const JPEG_EXIF_MARKER		= "45786966"	'"Exif"

'TIFF constants
'-----------------------------------------------------------------
const TIFF_MOTOROLA_MARKER  = "4D4D"
const TIFF_INTEL_MARKER		= "4949"
const TIFF_MOTOROLA_MAGIC	= "002A"		'42 in motorola order
const TIFF_INTEL_MAGIC		= "2A00"		'42 in intel order

'EXIF constants
'-----------------------------------------------------------------
const m_BYTE		= 1
const m_STRING		= 2
const m_SHORT		= 3
const m_LONG		= 4
const m_RATIONAL	= 5
const m_SBYTE		= 6
const m_UNDEFINED	= 7
const m_SSHORT		= 8
const m_SLONG		= 9
const m_SRATIONAL	= 10
const m_SINGLE		= 11
const m_DOUBLE		= 12

const IFD0_TAG_ExifOffset	= "8769"
const EXIF_TAG_MakerNote	= "927C"
const EXIF_TAG_UserComment	= "9286"


Public ExifLookup
set ExifLookup = Server.CreateObject("Scripting.Dictionary")

'IFD0 Tags
ExifLookup.Add "Image Description",			"010E"
ExifLookup.Add "Camera Make",				"010F"
ExifLookup.Add "Camera Model",				"0110"
ExifLookup.Add "Orientation",				"0112"
ExifLookup.Add "X Resolution",				"011A"
ExifLookup.Add "Y Resolution",				"011B"
ExifLookup.Add "Resolution Unit",			"0128"
ExifLookup.Add "Software",					"0131"
ExifLookup.Add "Date Time",					"0132"
ExifLookup.Add "White Point",				"013E"
ExifLookup.Add "Primary Chromaticities",	"013F"
ExifLookup.Add "YCbCr Coefficients",		"0211"
ExifLookup.Add "YCbCr Positioning",			"0213"
ExifLookup.Add "Reference Black White",		"0214"
ExifLookup.Add "Copyright",					"8298"
ExifLookup.Add "Exif Offset",				"8769"
'ExifSubIFD Tags
ExifLookup.Add "Exposure Time",				"829A"
ExifLookup.Add "FStop",						"829D"
ExifLookup.Add "Exposure Program",			"8822"
ExifLookup.Add "ISO Speed Ratings",			"8827"
ExifLookup.Add "Exif Version",				"9000"
ExifLookup.Add "Date Time Original",		"9003"
ExifLookup.Add "Date Time Digitized",		"9004"
ExifLookup.Add "Components Configuration",	"9101"
ExifLookup.Add "Compressed Bits Per Pixel",	"9102"
ExifLookup.Add "Shutter Speed Value",		"9201"
ExifLookup.Add "Aperture Value",			"9202"
ExifLookup.Add "Brightness Value",			"9203"
ExifLookup.Add "Exposure Bias Value",		"9204"
ExifLookup.Add "Max Aperture Value",		"9205"
ExifLookup.Add "Subject Distance",			"9206"
ExifLookup.Add "Metering Mode",				"9207"
ExifLookup.Add "Light Source",				"9208"
ExifLookup.Add "Flash",						"9209"
ExifLookup.Add "Focal Length",				"920A"
ExifLookup.Add "Maker Note",				"927C"
ExifLookup.Add "User Comment",				"9286"
ExifLookup.Add "Subsec Time",				"9290"
ExifLookup.Add "Subsec Time Original",		"9291"
ExifLookup.Add "Subsec Time Digitized",		"9292"
ExifLookup.Add "Flash Pix Version",			"A000"
ExifLookup.Add "Color Space",				"A001"
ExifLookup.Add "Exif Image Width",			"A002"
ExifLookup.Add "Exif Image Height",			"A003"
ExifLookup.Add "Related Sound File",		"A004"
ExifLookup.Add "Exif Interoperability Offset", "A005"
ExifLookup.Add "Focal Plane X Resolution",	"A20E"
ExifLookup.Add "Focal Plane Y Resolution",	"A20F"
ExifLookup.Add "Focal Plane Resolution Unit", "A210"
ExifLookup.Add "Exposure Index",			"A215"
ExifLookup.Add "Sensing Method",			"A217"
ExifLookup.Add "File Source",				"A300"
ExifLookup.Add "Scene Type",				"A301"
ExifLookup.Add "CFA Pattern",				"A302"
'Interoperability IFD Tags
ExifLookup.Add "Interoperability Index",	"0001"
ExifLookup.Add "Interoperability Version",	"0002"
ExifLookup.Add "Related Image File Format",	"1000"
ExifLookup.Add "Related Image Width",		"1001"
ExifLookup.Add "Related Image Length",		"1002"
'IFD1 Tags
ExifLookup.Add "Image Width",				"0100"
ExifLookup.Add "Image Height",				"0101"
ExifLookup.Add "Bits Per Sample",			"0102"
ExifLookup.Add "Compression",				"0103"
ExifLookup.Add "Photometric Interpretation", "0106"
ExifLookup.Add "Strip Offsets",				"0111"
ExifLookup.Add "Sample Per Pixel",			"0115"
ExifLookup.Add "Rows Per Strip",			"0116"
ExifLookup.Add "Strip Byte Counts",			"0117"
ExifLookup.Add "X Resolution 2",			"011A"
ExifLookup.Add "Y Resolution 2",			"011B"
ExifLookup.Add "Planar Configuration",		"011C"
ExifLookup.Add "Resolution Unit 2",			"0128"
ExifLookup.Add "JPEG Interchange Format",	"0201"
ExifLookup.Add "JPEG Interchange Format Length", "0202"
ExifLookup.Add "YCbCr Coeffecients",		"0211"
ExifLookup.Add "YCbCr Sub Sampling",		"0212"
ExifLookup.Add "YCbCr Positioning 2",		"0213"
ExifLookup.Add "Reference Black White 2",	"0214"
'Misc Tags
ExifLookup.Add "New Subfile Type",			"00FE"
ExifLookup.Add "Subfile Type",				"00FF"
ExifLookup.Add "Transfer Function",			"012D"
ExifLookup.Add "Artist",					"013B"
ExifLookup.Add "Predictor",					"013D"
ExifLookup.Add "Tile Width",				"0142"
ExifLookup.Add "Tile Length",				"0143"
ExifLookup.Add "Tile Offsets",				"0144"
ExifLookup.Add "Tile Byte Counts",			"0145"
ExifLookup.Add "Sub IFDs",					"014A"
ExifLookup.Add "JPEG Tables",				"015B"
ExifLookup.Add "CFA Repeat Pattern Dim",	"828D"
ExifLookup.Add "CFA Pattern 2",				"828E"
ExifLookup.Add "Battery Level",				"828F"
ExifLookup.Add "IPTC_NAA",					"83BB"
ExifLookup.Add "Inter Color Profile",		"8773"
ExifLookup.Add "Spectral Sensitivity",		"8824"
ExifLookup.Add "GPS Info",					"8825"
ExifLookup.Add "OECF",						"8828"
ExifLookup.Add "Interlace",					"8829"
ExifLookup.Add "Time Zone Offset",			"882A"
ExifLookup.Add "Self Timer Mode",			"882B"
ExifLookup.Add "Flash Energy",				"920B"
ExifLookup.Add "Spatial Frequency Response", "920C"
ExifLookup.Add "Noise",						"920D"
ExifLookup.Add "Image Number",				"9211"
ExifLookup.Add "Security Classification",	"9212"
ExifLookup.Add "Image History",				"9213"
ExifLookup.Add "Subject Location",			"9214"
ExifLookup.Add "Exposure Index 2",			"9215"
ExifLookup.Add "TIFFEP Standard ID",		"9216"
ExifLookup.Add "Flash Energy 2",			"A20B"
ExifLookup.Add "Spatial Frequency Response 2", "A20C"
ExifLookup.Add "Subject Location 2",		"A214"


'File read buffer
'-----------------------------------------------------------------
dim EXIF_bufferSize
EXIF_buffersize = 1024
dim EXIF_fileBuffer
dim EXIF_fileBufferStart
EXIF_fileBufferStart = -1

'IFD directory subarray indices
'-----------------------------------------------------------------
const IFD_IDX_Tag_No		= 0
const IFD_IDX_Tag_Name		= 1
const IFD_IDX_Data_Format	= 2
const IFD_IDX_Components	= 3
const IFD_IDX_Value			= 4
const IFD_IDX_Value_Desc	= 5
const IFD_IDX_OffsetToValue	= 6
const IFD_IDX_IFD_No		= 7

'fileOffsets array indices
'-----------------------------------------------------------------
const Offset_to_TIFF		= 0
const Offset_to_IFD0		= 1
	
const Offset_to_APP0		= 2
const Offset_to_APP1		= 3
const Length_of_APP0		= 4
const Length_of_APP1		= 5


'Post LoadImage lookup functions
'-----------------------------------------------------------------

Function LookupExifTag(which)
	dim item
	for each item in ExifLookup
		if ExifLookup(item) = which then
			LookupExifTag = item
			exit function
		end if
	next
	LookupExifTag = which
End Function

Function GetExifByName(byref IFDDirectory, byVal ExifTagName, ValueDescribed)
	Dim i
	GetExifByName = null
	For i = 0 To UBound(IFDDirectory)
		If IFDDirectory(i)(IFD_IDX_Tag_Name) = ExifTagName Then
			if ValueDescribed then
				GetExifByName = IFDDirectory(i)(IFD_IDX_Value_Desc)
			else
				GetExifByName = IFDDirectory(i)(IFD_IDX_Value)
			end if
			Exit For
		End If
	Next
End Function

function getExifByTag(byref IFDDirectory, byVal ExifTag, ValueDescribed)
	Dim i
	getExifByTag = null
	For i = 0 To UBound(IFDDirectory)
		If IFDDirectory(i)(IFD_IDX_Tag_No) = ExifTag Then
			if ValueDescribed then
				getExifByTag = IFDDirectory(i)(IFD_IDX_Value_Desc)
			else
				getExifByTag = IFDDirectory(i)(IFD_IDX_Value)
			end if
			Exit For
		End If
	Next
End Function

Function getFStop(byref IFDDirectory)
	dim fStop
	
	fStop = getExifByTag(IFDDirectory, "829D", false)
	if isnull(fStop) then
		fStop = getExifByTag(IFDDirectory, "9202", false)
		if not isnull(fStop) then
			fStop = rationalToDecimal(fStop)
			fStop = 1.4142^fStop
		else
			fStop = 0
		end if
	else
		fStop = rationalToDecimal(fStop)
	end if
	
	getFStop = cint(fStop*10)/10
end function

function getFocalLength(byref IFDDirectory)
	dim focalLength
	
	focalLength = getExifByTag(IFDDirectory, "920A", false)
	if not isnull(focalLength) then
		focalLength = rationalToDecimal(focalLength)
	end if
	getFocalLength = focalLength
end function

function getShutterSpeed(byref IFDDirectory, byval asText)
	dim shutterSpeedReciprocal
	
	shutterSpeedReciprocal = getExifByTag(IFDDirectory, "9201", false)
	if not isnull(shutterSpeedReciprocal) then
		shutterSpeedReciprocal = rationalToDecimal(shutterSpeedReciprocal)
		shutterSpeedReciprocal = 2^shutterSpeedReciprocal
	else
		shutterSpeedReciprocal = getExifByTag(IFDDirectory, "829A", false)
		if not isnull(shutterSpeedReciprocal) then
			shutterSpeedReciprocal = 1/rationalToDecimal(shutterSpeedReciprocal)
		end if
	end if
	
	if not isnull(shutterSpeedReciprocal) then
		if asText then
			if cint(shutterSpeedReciprocal) = 0 then
				getShutterSpeed = "0"
			else 
				getShutterSpeed = "1/" & cint(shutterSpeedReciprocal)
			end if
		else
			if cint(shutterSpeedReciprocal) = 0 then
				getShutterSpeed = 0
			else
				getShutterSpeed = 1/shutterSpeedReciprocal
			end if
		end if
	else
		getShutterSpeed = null
	end if
end function

function getDateTime(byRef IFDDirectory)
	dim dateTime
	
	dateTime = getExifByTag(IFDDirectory, "0132", true)
	if isnull(dateTime) then
		dateTime = getExifByTag(IFDDirectory, "9003", true)
		if isnull(dateTime) then
			dateTime = getExifByTag(IFDDirectory, "9004", true)
		end if
	end if
	getDateTime = dateTime
end function

'----------------------------------------------------------------------------------
'Load Image - Read EXIF/IFD data from supplied JPEG or TIFF image
'	filePath		path to image file
'	IFDDirectory	empty array into which the IFD data will be collected
'	fileOffsets		entry array into which various offsets are collected for use
'					by the image writing functions (not currently implemented)
'----------------------------------------------------------------------------------
function LoadImage(filePath, byref IFDDirectory, byref fileOffsets)
	Dim magicNumber
	Dim FSO, File
	dim imageError
	
	dim ImageFileType
	
	dim isIntel
	
	fileOffsets = array(-1,-1,-1,-1,-1,-1)

	isIntel = false
	
	IFDDirectory = array(0)
	
	If filePath = "" Then
		LoadImage = "No file path provided"
		Exit function
	End If
	
	clearFileBuffer

	If filePath <> "" Then

		Set FSO = Server.CreateObject("Scripting.FileSystemObject")
		If FSO.FileExists(filePath) Then
			Set File = FSO.GetFile(filePath)
			
			'MPBT look for magic numbers at start of file.
			
			magicNumber = getFileData(File, 0, 2)
			select case MagicNumber
			
				case TIFF_MOTOROLA_MARKER
					ImageFileType = "TIFF"
				case TIFF_INTEL_MARKER
					ImageFileType = "TIFF"
				case JPEG_START_MARKER
					ImageFileType = "JPEG"
				case else
					ImageFileType = ""
					
			end select
			
			if ImageFileType = "" then
				LoadImage = "Unrecognised image format"
				Exit function
			end if
			
			
			if imageFileType = "JPEG" then
				imageError = inspectJPGFile(file, isIntel, fileOffsets)
				If imageError<>"" Then
					LoadImage = imageError
					exit function
				End If
			else
				imageError = inspectTIFFfile(file, isIntel, fileOffsets)
				if imageError<>"" then
					LoadImage = imageError
					exit function
				end if
			end if
			
			'splittime("About to load Directory entries")
			GetDirectoryEntries File, isIntel, fileOffsets, IFDDirectory
			MakeSenseOfMeaninglessValues IFDDirectory
			
			LoadImage = ""
			set File = nothing
			
		else
			LoadImage = "File does not exist"
		End If
	
		Set FSO = Nothing
	End If

End function


'File reading/buffering functions
'-----------------------------------------------------------------

function readFile(file, startOffset, length)
	dim stream, strData, i

	'splittime("Reading file from " & startOffset & " for " & length)
	set stream = file.OpenAsTextStream(ForReading, TristateFalse)
	
	if startOffset > 0 then
		stream.skip(startOffset)
	end if
	
	'splittime("Found start")
	i = 0
	strData = ""
	While Not stream.AtEndOfStream and i < length

		strData = strData & Right("0" & Hex(Asc(stream.Read(1))), 2)
		i = i + 1
						
	Wend
	'splittime("read done")
	readFile = strData
	stream.close
end function

function getFileData(file, startOffset, length)
	dim i, strData
	'splittime("Getting file data from " & startOffset & " for " & length)
	if length < EXIF_bufferSize then
		if EXIF_fileBufferStart <0 or startOffset < EXIF_fileBufferStart or startOffset+length >= EXIF_fileBufferStart + EXIF_bufferSize then 'need to read data into the buffer first
			readFileIntoBuffer file, startOffset
		end if
		for i = startOffset - EXIF_fileBufferStart to startOffset - EXIF_fileBufferStart + length -1
			strData = strData & EXIF_fileBuffer(i)
		next
	else
		strData = readFile(file, startOffset, length)
	end if
	getFileData = strData
end function

sub readFileIntoBuffer(file, startOffset)
	dim stream, strData, i, length
	length = EXIF_bufferSize
	
	clearFileBuffer
	EXIF_fileBufferStart = startOffset
	'splittime("Buffering file from " & startOffset & " for " & length)
	set stream = file.OpenAsTextStream(ForReading, TristateFalse)
	
	if startOffset > 0 then
		stream.skip(startOffset)
	end if
	
	'splittime("Found start")
	i = 0
	While Not stream.AtEndOfStream and i < length

		EXIF_fileBuffer(i) = Right("0" & Hex(Asc(stream.Read(1))), 2)
		i = i + 1
						
	Wend
	'splittime("read done")
	stream.close
end sub

function readIFD(file, isIntel, startOffset, byref lngEntryCount)
	dim strData, length

	'splittime("Reading IFD from " & startOffset)

	
	length = 2
	strData = getFileData(file, startOffset, length)
	
	lngEntryCount = twoByteOffset(isIntel, strData)
	
	length = 12 * lngEntryCount + 4 '12 bytes per entry followed by a 4 byte offset to the next entry
	
	strData = strData & getFileData(file, startOffset + 2, length)
	
	'splittime("read IFD done")
	readIFD = strData
end function

function readFileUntil(file, startOffset, strHexEndMarker)
	dim stream, strData,  markerFound, markerLength, i
	
	if strHexEndMarker<>"" then
	
		'splittime("Reading file from " & startOffset & " until " & strHexEndMarker)
		markerLength = len(strHexEndMarker)
		set stream = file.OpenAsTextStream(ForReading, TristateFalse)
	
		if startOffset > 0 then
			stream.skip(startOffset)
		end if
	
		markerFound = false
		i = 2
		While Not stream.AtEndOfStream and not markerFound

			strData = strData & Right("0" & Hex(Asc(stream.Read(1))), 2)
			if i >= markerLength then
				if right(strData, markerLength) = strHexEndMarker then
					markerFound = true
				end if
			end if
			
			i = i + 2
							
		Wend
	
		'splittime("read done")
		readFileUntil = strData
		stream.close
	else
		readFileUntil = ""
	end if
end function

function findJPEGmarker(file, startOffset, strHexJPEGmarker, byref markerOffset)
	dim stream, strData,  markerFound, markerLength, i
	
	if strHexJPEGmarker<>"" then
		'splittime("Reading file from " & startOffset & " looking for JPEG marker " & strHexJPEGmarker)
		markerLength = len(strHexJPEGmarker)
		set stream = file.OpenAsTextStream(ForReading, TristateFalse)
	
		if startOffset > 0 then
			stream.skip(startOffset)
		end if
	
		markerFound = false
		strData = "**********************************************"
		i = startOffset
		While Not stream.AtEndOfStream and not markerFound

			strData = right(strData, markerLength - 2) & Right("0" & Hex(Asc(stream.Read(1))), 2)
			if strData = strHexJPEGmarker then
				markerFound = true
				markerOffset = i-1
				'read next six bytes to get JPEG marker length and possible Exif ID sequence
				for i = 1 to 6 
					strData = strData & Right("0" & Hex(Asc(stream.Read(1))), 2)
				next
			end if
			if strData = JPEG_SOS_MARKER and not markerFound then 'shortcut out of here - anything we are interested in is always before the SOS marker
				markerOffset = -1
				strData = ""
				markerFound = true
			end if
			i = i + 1		
		Wend
		if instr(1, strData, "*") then strData = ""
		
		'splittime("read done")
		findJPEGmarker = strData
		stream.close
	else
		findJPEGmarker = ""
	end if
	
end function

sub clearFileBuffer
	EXIF_fileBufferStart = -1
	redim EXIF_fileBuffer(EXIF_bufferSize)
	'splittime("Buffer reset")
end sub


'Image reading functions
'-----------------------------------------------------------------


Function InspectJPGFile(file, byref isIntel, byref fileOffsets)
	dim strJPEGdata
	
	dim headerBytes
	
	'splittime("Inspecting JPEG file")
	
	headerBytes = getFileData(file, 0, 2)
	If headerBytes <> JPEG_START_MARKER Then
		InspectJPGFile = "File is not JPEG format"
	Else
		'Look for APP0 marker FFE0, which signals JFIF data
		fileOffsets(Offset_to_APP0) = -1
		fileOffsets(Length_of_APP0) = -1
		strJPEGdata = findJPEGmarker(file, 0, JPEG_APP0_MARKER, fileOffsets(Offset_to_APP0))
		
		if strJPEGdata<>"" and fileOffsets(Offset_to_APP0) >= 0 then
			fileOffsets(Length_of_APP0) = twobyteoffset(true, mid(strJPEGdata, 5, 4)) 'jpeg lengths are always Intel based
		end if

		'Look for APP1 marker FFE1, which signals JPEG embedded EXIF data
		fileOffsets(Offset_to_APP1) = -1
		fileOffsets(Length_of_APP1) = -1
		fileOffsets(Offset_to_TIFF) = -1
		fileOffsets(Offset_to_IFD0) = -1
		
		strJPEGdata = findJPEGmarker(file, 0, JPEG_APP1_MARKER, fileOffsets(Offset_to_APP1))
		
		if strJPEGdata<>"" and fileOffsets(Offset_to_APP1) >= 0 then
			fileOffsets(Length_of_APP1) = twobyteoffset(true, mid(strJPEGdata, 5, 4))
			fileOffsets(Offset_to_TIFF) = fileOffsets(Offset_to_APP1) + 10 'TIFF always starts 10 bytes after the APP1 marker

			'check for EXIF data marker
			If mid(strJPEGdata, 9, 8) <> JPEG_EXIF_MARKER Then
				InspectJPGFile = "APP1 marker found, but doesn't contain EXIF data"
				Exit Function
			End If
		
			InspectJPGFile = checkTIFFheader(file, isIntel, fileOffsets)
			
		else
			InspectJPGFile = "No EXIF data found"
		end if
	End If
End Function

function InspectTIFFfile(file, byref isIntel, byref fileOffsets)

	'These 4 are meaningless in a TIFF
	fileOffsets(Offset_to_APP0) = -1
	fileOffsets(Offset_to_APP1) = -1
	fileOffsets(Length_of_APP0) = -1
	fileOffsets(Length_of_APP1) = -1
	
	'splittime("Inspecting TIFF file")
	
	'TIFFs naturally start at the beginning of the file
	fileOffsets(Offset_to_TIFF) = 0
	fileOffsets(Offset_to_IFD0) = -1
	
	InspectTIFFfile = checkTIFFheader(file, isIntel, fileOffsets)
	
end function

function checkTIFFheader(file, byref isIntel, byref fileOffsets)

	dim headerBytes
	'splittime("Checking TIFF file at " & fileOffsets(Offset_to_TIFF) & " bytes")
	headerBytes = getFileData(file, fileOffsets(Offset_to_TIFF), 8)
	checkTIFFheader = ""
	select case left(headerBytes, 8)
		case TIFF_MOTOROLA_MARKER & TIFF_MOTOROLA_MAGIC
			isIntel = false
		case TIFF_INTEL_MARKER & TIFF_INTEL_MAGIC
			isIntel = true
		case else
			checkTIFFheader = "File is not TIFF format"
			exit function
	end select
	
	fileOffsets(Offset_to_IFD0) = fourbyteoffset(isIntel, right(headerBytes,8))
end function


'TIFF Image File Directory (IFD) reader
'-----------------------------------------------------------------------------------

Sub GetDirectoryEntries(file, isIntel, byref fileOffsets, byref IFDDirectory)

	dim offset
	Dim BytesPerComponent
	Dim Offset_to_MakerNote
	
	dim Offset_to_Next_Full_IFD
	dim Offset_to_Next_IFD
	dim Offset_to_ExifSubIFD
	Dim Processing_ExifSubIFD
	
	dim strHexIFD
	dim lngIFDentryCount
	dim IFDnumber
	dim DEoffset

	Dim i, k
	

	dim rationalData

	IFDnumber = 0
	
	Offset_to_MakerNote = 0
	Offset_to_Next_Full_IFD = 0
	Offset_to_Next_IFD = 0
	Processing_ExifSubIFD = false
	
	offset = fileOffsets(Offset_to_TIFF) + fileOffsets(Offset_to_IFD0)
	
	k = -1
	
	Do
		Offset_to_ExifSubIFD = 0
		
		strHexIFD = readIFD(file, isIntel, offset, lngIFDentryCount)
		
		ReDim Preserve IFDDirectory(k + lngIFDentryCount)
		
		'splittime("IFD " & IFDnumber & " found with " & lngIFDentryCount & " entries")
		
		For i = 1 To lngIFDentryCount
		
			k = k + 1
			
			'splittime("Processing IFD " & IFDnumber & " entry " & i & " - array index " & k)
			
			IFDDirectory(k) = array(null,null,null,null,null,null,null,null)
			
			DEoffset = ((i-1)*12 + 2) * 2 + 1 'entry is 12 bytes, plus 2 byte count offset, doubled to take account of each byte being two hex digits

			IFDDirectory(k)(IFD_IDX_IFD_No) = IFDnumber

			if isIntel then
				IFDDirectory(k)(IFD_IDX_Tag_No) = _
					mid(strHexIFD, DEoffset + 2, 2) & _
					mid(strHexIFD, DEoffset, 2)
			else
				IFDDirectory(k)(IFD_IDX_Tag_No) = _
					mid(strHexIFD, DEoffset, 4)
			end if

			IFDDirectory(k)(IFD_IDX_Data_Format) = _
			twoByteOffset(isIntel, mid(strHexIFD, DEoffset + 4, 4))

			IFDDirectory(k)(IFD_IDX_Components) = _
			fourByteOffset(isIntel, mid(strHexIFD, DEoffset + 8, 8))

			BytesPerComponent = 0
				
			Select Case IFDDirectory(k)(IFD_IDX_Data_Format)

				Case m_BYTE, m_SBYTE
					BytesPerComponent = 1
					If IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent <= 4 Then
						if isIntel then
							IFDDirectory(k)(IFD_IDX_Value) = _
							mid(strHexIFD, DEoffset + 22, 2) & _
							mid(strHexIFD, DEoffset + 20, 2) & _
							mid(strHexIFD, DEoffset + 18, 2) & _
							mid(strHexIFD, DEoffset + 16, 2)
						else
							IFDDirectory(k)(IFD_IDX_Value) = mid(strHexIFD, DEoffset + 16, 8)
						end if
					Else
						IFDDirectory(k)(IFD_IDX_OffsetToValue) = _
							fourByteOffset(isIntel, mid(strHexIFD, DEoffset + 16, 8))
						IFDDirectory(k)(IFD_IDX_Value) = getFileData(file, fileOffsets(Offset_to_TIFF) + IFDDirectory(k)(IFD_IDX_OffsetToValue), IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent)
					End If

				Case m_STRING, m_UNDEFINED
					BytesPerComponent = 1
					If IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent <= 4 Then
						IFDDirectory(k)(IFD_IDX_Value) =  _
						HexToAscii(mid(strHexIFD, DEoffset + 16,8))
					Else
						
						IFDDirectory(k)(IFD_IDX_OffsetToValue) = _
							fourByteOffset(isIntel, mid(strHexIFD, DEoffset + 16, 8))
						if IFDDirectory(k)(IFD_IDX_Tag_No) = EXIF_TAG_UserComment then 'skip first 8 bytes that indicate format
							IFDDirectory(k)(IFD_IDX_OffsetToValue) = IFDDirectory(k)(IFD_IDX_OffsetToValue) + 8
							IFDDirectory(k)(IFD_IDX_Components) = IFDDirectory(k)(IFD_IDX_Components) - 8
						end if
						IFDDirectory(k)(IFD_IDX_Value) = HexToAscii(getFileData(file, fileOffsets(Offset_to_TIFF) + IFDDirectory(k)(IFD_IDX_OffsetToValue), IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent))

					End If

				Case m_SHORT, m_SSHORT
					BytesPerComponent = 2
					If IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent <= 4 Then
						IFDDirectory(k)(IFD_IDX_Value) = _
							twoByteOffset(isIntel, mid(strHexIFD, DEoffset + 16, 4)) + _
							twoByteOffset(isIntel, mid(strHexIFD, DEoffset + 20, 4))
					Else
						IFDDirectory(k)(IFD_IDX_OffsetToValue) = _
							fourByteOffset(isIntel, mid(strHexIFD, DEoffset + 16, 8))
						IFDDirectory(k)(IFD_IDX_Value) = getFileData(file, fileOffsets(Offset_to_TIFF) + IFDDirectory(k)(IFD_IDX_OffsetToValue), IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent)
					End If

				Case m_LONG, m_SLONG
					BytesPerComponent = 4
					If IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent <= 4 Then
						IFDDirectory(k)(IFD_IDX_Value) = _
							fourByteOffset(isIntel, mid(strHexIFD, DEoffset + 16, 8))
					Else
						IFDDirectory(k)(IFD_IDX_OffsetToValue) = _
							fourByteOffset(isIntel, mid(strHexIFD, DEoffset + 16, 8))
						IFDDirectory(k)(IFD_IDX_Value) = getFileData(file, fileOffsets(Offset_to_TIFF) + IFDDirectory(k)(IFD_IDX_OffsetToValue), IFDDirectory(k)(IFD_IDX_Components) * BytesPerComponent)
					End If

				Case m_RATIONAL, m_SRATIONAL 'always offset
					BytesPerComponent = 8
					IFDDirectory(k)(IFD_IDX_OffsetToValue) = _
						fourByteOffset(isIntel, mid(strHexIFD, DEoffset + 16, 8))
					rationalData = getFileData(file, fileOffsets(Offset_to_TIFF) + IFDDirectory(k)(IFD_IDX_OffsetToValue), 8)
					IFDDirectory(k)(IFD_IDX_Value) = _
						fourByteOffset(isIntel, left(rationalData, 8)) & _
						"/" & _
						fourByteOffset(isIntel, right(rationalData, 8))

			End Select

			If IFDDirectory(k)(IFD_IDX_Tag_No) = EXIF_TAG_MakerNote Then
				Offset_to_MakerNote = IFDDirectory(k)(IFD_IDX_OffsetToValue)
			End If
			If IFDDirectory(k)(IFD_IDX_Tag_No) = IFD0_TAG_ExifOffset Then
				Offset_to_ExifSubIFD = CLng(IFDDirectory(k)(IFD_IDX_Value))
			End If
			
			IFDDirectory(k)(IFD_IDX_Tag_Name) = LookupExifTag(IFDDirectory(k)(IFD_IDX_Tag_No))

		Next
		
		If not Processing_ExifSubIFD Then
		
			Offset_to_Next_Full_IFD = _
				fourByteOffset(isIntel, right(strHexIFD, 8))
				
			if Offset_to_ExifSubIFD = 0 then
				Offset_to_Next_IFD = Offset_to_Next_Full_IFD
				IFDnumber = int(IFDNumber) + 1
			else
				Processing_ExifSubIFD = true
				Offset_to_Next_IFD = Offset_to_ExifSubIFD
				IFDNumber = IFDNumber + 0.1
			end if
			
		Else
		
			Offset_to_Next_IFD = Offset_to_Next_Full_IFD
			IFDnumber = int(IFDNumber) + 1
			Processing_ExifSubIFD = false
			
		End If

		Offset = fileOffsets(Offset_to_TIFF) + Offset_to_Next_IFD

	Loop While Offset_to_Next_IFD <> 0

	'If Offset_to_MakerNote <> 0 Then
		'ProcessMakerNote Offset_to_MakerNote + fileOffsets(Offset_to_TIFF)
	'End If
  
End Sub

Function MakeSenseOfMeaninglessValues(byref IFDDirectory)
	dim x
	for x = 0 to ubound(IFDDirectory)
		Select Case IFDDirectory(x)(IFD_IDX_Tag_Name)
		
			Case "Orientation"
				if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
					select case IFDDirectory(x)(IFD_IDX_Value)
						
						case 0
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Undefined"
						case 1
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Normal"
						case 2
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Flip Horizontal"
						case 3
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Rotate 180"
						case 4
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Flip Vertical"
						case 5
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Transpose"
						case 6
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Rotate 90"
						case 7
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Transverse"
						case 8
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Rotate 270"
						case else
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Undefined"
					end select
				end if
				
			Case "Metering Mode"
				if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
					select case IFDDirectory(x)(IFD_IDX_Value)
						
						case 0
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Unknown"
						case 1
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Average"
						case 2
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Centre Weighted Average"
						case 3
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Spot"
						case 4
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Multi-spot"
						case 5
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Multi-segment"
						case 6
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Partial"
						case 255
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Other"
						case else
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Undefined"
					end select
				end if
				
			Case "Flash"
				if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
					select case IFDDirectory(x)(IFD_IDX_Value)
						
						case 0
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "No flash"
						case 1
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Flash fired"
						case 5
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Flash fired, but no strobe bounce detected"
						case 7
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Flash fired, and strobe bounce detected"
						case else
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "No flash" 'undefined
					end select
				end if
				
			case "Color Space"
				if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
					select case IFDDirectory(x)(IFD_IDX_Value)
						
						case 1
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "sRGB"
						case 65535
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Uncalibrated"
						case else
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Undefined"
					end select
				end if
				
			case "Compression"
				if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
					select case IFDDirectory(x)(IFD_IDX_Value)
						
						case 1
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "None"
						case 6
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "JPEG"
						case else
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Undefined"
					end select
				end if
			
			case "Photometric Interpretation"
				if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
					select case IFDDirectory(x)(IFD_IDX_Value)
						
						case 1
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Monochrome"
						case 2
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "RGB"
						case 6
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "YCbCr"
						case else
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Undefined"
					end select
				end if
				
			case "Planar Configuration"
				if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
					select case IFDDirectory(x)(IFD_IDX_Value)
						
						case 1
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Chunked"
						case 2
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Planes"
						case else
							IFDDirectory(x)(IFD_IDX_Value_Desc) = "Undefined"
					end select
				end if					
		End Select
		
		if instr(1, IFDDirectory(x)(IFD_IDX_Tag_Name), " Unit") and isnull(IFDDirectory(x)(IFD_IDX_Value_Desc)) then
			if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
				select case IFDDirectory(x)(IFD_IDX_Value)
					case 1
						IFDDirectory(x)(IFD_IDX_Value_Desc) = "no unit"
					case 2
						IFDDirectory(x)(IFD_IDX_Value_Desc) = "inch"
					case 3
						IFDDirectory(x)(IFD_IDX_Value_Desc) = "cm"
					case else
						IFDDirectory(x)(IFD_IDX_Value_Desc) = "undefined"
				end select
			end if
		end if
		
		if instr(1, IFDDirectory(x)(IFD_IDX_Tag_Name), " Version") and isnull(IFDDirectory(x)(IFD_IDX_Value_Desc)) then
			if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
				IFDDirectory(x)(IFD_IDX_Value_Desc) = cint(left(IFDDirectory(x)(IFD_IDX_Value), 2)) & "." & right(IFDDirectory(x)(IFD_IDX_Value), 2)
				
			end if
		end if
		
		if instr(1, IFDDirectory(x)(IFD_IDX_Tag_Name), "Date Time") and isnull(IFDDirectory(x)(IFD_IDX_Value_Desc)) then
			if not isnull(IFDDirectory(x)(IFD_IDX_Value)) then
				on error resume next
				IFDDirectory(x)(IFD_IDX_Value_Desc) = cdate(replace(IFDDirectory(x)(IFD_IDX_Value), ":", "/", 1, 2))
				if err.number <> 0 then IFDDirectory(x)(IFD_IDX_Value_Desc) = ""
				on error goto 0
			end if
		end if
	next
End Function 


'conversion utilities
'-----------------------------------------------------------------------------------

function fourByteOffset(intel, strHexBytes)
	If intel Then
		fourByteOffset = _
			HexToDec(mid(strHexBytes, 7, 2)) * 16777216 + _
			HexToDec(mid(strHexBytes, 5, 2)) * 65536 + _
			HexToDec(mid(strHexBytes, 3, 2)) * 256 + _
			HexToDec(left(strHexBytes, 2))
	Else
		fourByteOffset = _
			HexToDec(left(strHexBytes, 2))   * 16777216 + _
			HexToDec(mid(strHexBytes, 3, 2)) * 65536 + _
			HexToDec(mid(strHexBytes, 5, 2)) * 256 + _
			HexToDec(mid(strHexBytes, 7, 2))
	End If
end function

function twoByteOffset(intel, strHexBytes)
	If intel Then
		twoByteOffset = _
			HexToDec(mid(strHexBytes, 3, 2)) * 256 + _
			HexToDec(left(strHexBytes, 2))
	Else
		twoByteOffset = _
			HexToDec(left(strHexBytes, 2))   * 256 + _
			HexToDec(mid(strHexBytes, 3, 2))
	End If
end function

function rationalToDecimal(rational)
	dim slashpos

	slashpos = instr(1, rational, "/")
	if slashpos>=0 then
		rationalToDecimal = left(rational, slashpos-1) / mid(rational, slashpos+1)
	else
		rationalToDecimal = rational
	end if
end function

function HexToDec(strHex)
	HexToDec = clng("&H" & left(strHex, 2))
end function

Function HexToAscii(strHex)
  dim i
  for i = 1 To Len(strHex) Step 2
    HexToAscii = HexToAscii & Chr(cint("&H" & Mid(strHex, i, 2)))
  Next
End Function

Function HexToBinary(btHex)

' Function Converts a single hex value into it's binary equivalent
'
' Written By: Mark Jager
' Written Date: 8/10/2000
'
' Free to distribute as long as code is not modified, and header is kept intact
'
	Select Case btHex
		Case "0"
			HexToBinary = "0000"
		Case "1"
			HexToBinary = "0001"
		Case "2"
			HexToBinary = "0010"
		Case "3"
			HexToBinary = "0011"
		Case "4"
			HexToBinary = "0100"
		Case "5"
			HexToBinary = "0101"
		Case "6"
			HexToBinary = "0110"
		Case "7"
			HexToBinary = "0111"
		Case "8"
			HexToBinary = "1000"
		Case "9"
			HexToBinary = "1001"
		Case "A"
			HexToBinary = "1010"
		Case "B"
			HexToBinary = "1011"
		Case "C"
			HexToBinary = "1100"
		Case "D"
			HexToBinary = "1101"
		Case "E"
			HexToBinary = "1110"
		Case "F"
			HexToBinary = "1111"
		Case Else
			HexToBinary = "2222"
	End Select
End Function

Function HexBlockToBinary(strHex)
' Function Converts a 8 digit/32 bit hex value to its 32 bit binary equivalent
'
' Written By: Mark Jager
' Written Date: 8/10/2000
'
' Free to distribute as long as code is not modified, and header is kept intact
'
    Dim intPos
    Dim strTemp
    
    For intPos = 1 To Len(strHex)
        strTemp = strTemp & HexToBinary(Mid(strHex, cint(intPos), 1))
    Next
    
    HexBlockToBinary = strTemp
    
End Function

%>