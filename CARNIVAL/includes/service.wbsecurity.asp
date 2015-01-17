<!--#include file = "inc.md5.asp"-->
<!--#include file = "inc.wbsecurity.asp"-->
<%
'************************************'
'* WBsecurity 1.01 - (c) imente 2006 *'
'************************************'
'  distribuito sotto licenza GNU-GPL
'       (vedi allegato gpl.txt)
'*************************************'
' original code of this page
' 	(c) br1 - 2002
' ------------------------------------
'* NON MODIFICARE QUESTO FILE!!!

Dim kk,zz,aa,c,pos,seg
Dim Image
Dim Palette(255)
' parametri
Dim Valore  ' il numero da visualizzare
Dim Nome    ' nome della variabile di sessione che contiene il numero def. "Numero"
Dim Nucleo  ' colore della parte interna della cifra - def. FFFFFF
Dim Bordo   ' colore della parte esterna della cifra - def. 00FFFF
Dim Sfondo  ' colore dello sfondo - def. 000000
Dim Cifre   ' fissato a 8
dim cifra, pc, pp


' numero di cifre nell'immagine
Cifre = 8

' colori
Nucleo = wbs_ForegroundColor
Bordo = wbs_BorderColor
Sfondo = wbs_BackgroundColor

valore = getSecurityCodeGenerator() 
session("wbsecurity-generator") = valore
if valore <> "" then
   ' ricavo il valore da visualizzare
	valore = getSecurityCode(valore)
	Valore = " " & Valore & " "
	
	' definizione matrice immagine
	
	Image = "47494638396170001500F70000[Palette]" & _
	"2C00000000700015000008FE0001081C48B0A0" & _
	"C18308132A5CC8B0A1C38710234A9C4811A29F8B183312A4C3B1A347826A428A" & _
	"1C49108CC99328095A59C9B22541263063CA2428A4A6CD9B0471E8DCC973601F" & _
	"007EFC091DEA07001F817300D0A1C7B4291D007204A601A0469DD5AB6A00A011" & _
	"F80500187060C38201E04560150056ACA95D6B050015814B00306146B72E1300" & _
	"4A040601204498DFBF420000117803000E5C8813E3006043609F9F192F1A3D0A" & _
	"604E528F1CA146059066EAC8905AB702F8D215A549B265015439DB72A5DBB700" & _
	"96C49509136F5E0041F6DEAC297830801B8579EA64DC18409F7E3F0BF2E14779" & _
	"CEBCA405E5C8DB9C26DDD48268D089FEF2AD6B412FDE52FE57A976B620156AB0" & _
	"972C8B5B5089B2DB4182ED2D080498EF1BB70A17B461ABF8F1E400DC21E072CD" & _
	"3D37501B084A479D75038DE16076DB753750161482271E79033DA1E179E9AD37" & _
	"501120BA079F7C03ED60627DF7E537500C2CF2E71F7203DD71CF1D042265A040" & _
	"6DB4D38682523128D018E38C012157120A9445365958681686023DF1CC131CC2" & _
	"E5A14045145384887A9128D00EBBEC8022612A0A14432C31B8E8188C02094823" & _
	"7336420700823B4ED7E375003828A476447A0700854986B76479006808257A52" & _
	"B207008857BE97E57C0098E8A57D60EA07008B65F6E7D84F7B64AAE964482515" & _
	"C7A7A06A26D55467946A6A685C75D5C5AAACA266D659FE53C42AEB6B70C595C4" & _
	"ADB8DAA6D75E3FF4EA6B6F841556C3B0C41247D01EFB24ABEC1E06C511CFB3D0" & _
	"C661D019E7546BED190675D1CDB6DC7661D014D3842BEE14062591CCB9E82661" & _
	"D00FBFB4EBEE0F06D550CBBCF4D640901E7A00A0E9A679E421101C7000006AA8" & _
	"6FBC219019660060EAA965942110175C00C06AAB5B6C219014520020EBAC5144" & _
	"2110124800806BAE471C21900F3E00E0EBAF3DF420100D3400406CB133CC2090" & _
	"1EFAE45B501EF9F80B001CF0045CD01BEF180C8019E6245C5019E5380C0017DC" & _
	"445CD016DB580C8014D2645C5014D1780C0012C8845CD011C7980C800FBEA45C" & _
	"500FBDB80C000DB4C45CD00CB3D80C00CE3A0360C7FEDE3CFB0CB4D000B02138" & _
	"D14623AD34006224CEB4D3504B0D001690536D35D65A03E0C4E55C7B0DB6D800" & _
	"10E139D966A3AD36003A94CEB6DB70CB0D000CACD36D37DE03D9618F1D7DFF1B" & _
	"F4406CB0C306E107273D9018E288B1F8C3510F84053658487E71D60339E18C13" & _
	"997F1CF64044104304E827A73D900EBAE870FACB710F04032C30B87E73CEB1F3" & _
	"DDB3ED800BBE7BD1BD1F9EB8F04D13EF38E4C957BD7CE59743DFB5F49CF3DCF5" & _
	"CA96BDD195CE7B6D039FEA5857BEBADD2C5F7888A00401D0AF7F05CC0D18CC20" & _
	"000A76B08491E183200440C31E16312D98F08400A8D8C532068516BA10001DFB" & _
	"58C88C40C31A02A064274B190F76C84300B4EC659B319381108708809ADD0C00" & _
	"78C087129788070AFE0B006E708714A7E8860D1E0C0064208716B74806113E0C" & _
	"005AD08618C7A885145E0C005080861AD70805187E0C004630861CE768841B9E" & _
	"0C003CE0851EF7C8031FBE0C0032908520072983220E4482889CE04032C8480D" & _
	"0E0484900CE1404E4849140EC485987CE1406AC8491B0E8487A0ECE14086484A" & _
	"2256E494A84CA52A57C9CA56BA322000003B"
	
	' tabella caratteri - segmenti
		dim a(10)
		a(0)="0 123567"
		a(1)="1 36"
		a(2)="2 13457"
		a(3)="3 13467"
		a(4)="4 2346"
		a(5)="5 12467"
		a(6)="6 124567"
		a(7)="7 136"
		a(8)="8 1234567"
		a(9)="9 123467"
		a(10)="  0"
		
	' imposto tutti i colori della Palette al colore di sfondo
		for kk=0 to 255
		  Palette(kk)=Sfondo
		next
	
	' pos=numero cifra
	' seg=numero segmento
	
	' accendo i segmenti del display
	for pos = 1 to Cifre
	  c = mid(Valore,pos,1)
	
	  for zz = 0 to UBound(a)		' rintraccio il carattere nell'array
		if left(a(zz),1) = c then 		' trovato
		  cifra=a(zz)
		  for kk = 3 to len(cifra)  	' scorro i segmenti da accendere
			seg = cint(mid(cifra,kk,1))
			if seg > 0 then			' non e' lo spazio :)
			  pc = 255-((pos-1)*10)-seg	' ricavo la posizione del nucleo nella palette
			  pp = pc-128			' e quella del bordo
			  Palette(pc) = Nucleo		' imposto i colori
			  Palette(pp) = Bordo
			end if
		  next
		  exit for				' l'ho trovato: esco
		end if
	  next
	next
		
	' ottengo la matrice completata con i colori
	Image = Replace(Image, "[Palette]", Join(Palette, ""))
	
	' invio l'immagine
	kk = Len(Image) \ 2
	
	Response.ContentType = "image/gif"
	For zz = 1 To kk
		 Response.BinaryWrite(ChrB("&h" & Mid(Image, ((zz - 1) * 2) + 1, 2)))
	Next

else

response.end

end if 
%>