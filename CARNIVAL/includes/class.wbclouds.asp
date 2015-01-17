<%

'** WBclouds 1.1 ( 2006/10/10 )
'** Simone Cingano (imente) Copyright 2006
'** http://www.imente.it

Class wbClouds
	
	'//---------------------------------------------------------------
	
	'// href di base per i tag (opzionale)
	'// se non indicato, non viene inserito alcun tag A
	public baseUrl
	
	'// classe (opzionale) da assegnare al tag A (valido solo se baseUrl è valorizzato)
	public aClass
	
	'// onclick (opzionale) da assegnare al tag A (valido solo se baseUrl è valorizzato)
	public aOnClick
	
	'// classe (opzionale) da assegnare al tag SPAN
	public spanClass
	
	'// dimensione font (percentuale. minimo = percSize*0.5, massimo = percSize*2
	public percSize
	
	'// terminatore di tag (divisore fra un tag e l'altro)
	public space
	
	'//---------------------------------------------------------------
	
	'// variabili di servizio
	private cloud()
	private minentries
	private maxentries
	
	'//---------------------------------------------------------------
	
	'// inizializza la classe
	'// da eseguirsi SEMPRE dopo l'istanziamento
	public sub Init()
		'// inizializza l'array
		clear()
		
		'// imposta i valori di base
		baseUrl = ""
		aClass = ""
		aOnClick = ""
		spanClass = ""
		percSize = 150 'minimo = 150*0.5=75, massimo = 150*2=300
		space = "&nbsp;&nbsp;"
	end sub
	
	'//---------------------------------------------------------------
	
	'// svuota l'array ma non reimposta le opzioni
	public sub clear()
		redim cloud(3,0)
		maxentries = 0
		minentries = -1
	end sub
	
	'// aggiunge un tag alla lista
	'// i parametri sono
	'//		tagName = il testo che verrà stampato
	'//		tagEntries = il valore del tag (quanti record correlati)
	'//		tagUrlAdd = una stringa da aggiungere al baseUrl nell'href dell'A
	public sub add(tagName,tagId,tagEntries,tagUrlAdd)
		redim preserve cloud(3,ubound(cloud,2)+1)
		cloud(0,ubound(cloud,2)) = tagName
		cloud(1,ubound(cloud,2)) = tagId
		cloud(2,ubound(cloud,2)) = tagEntries
		cloud(3,ubound(cloud,2)) = tagUrlAdd
		if tagEntries > maxentries then maxentries = tagEntries
		if tagEntries < minentries or minentries = -1 then minentries = tagEntries
	end sub
	
	'// stampa i tag secondo le opzioni indicate
	public sub print()
		dim fontsize,ii
		for ii=1 to ubound(cloud,2)
			if maxentries-minentries = 0 then 
				fontsize = percSize & "%"
			else
				'valori fra +0.5% e +2.0% di percsize
				fontsize = int(percSize*(1.0+(1.5*(cloud(2,ii)-minentries)-(maxentries-minentries)/2)/(maxentries-minentries)))
				fontsize = replace(cstr(fontsize),",",".") & "%"
			end if
			response.write "<span style=""font-size:" & fontsize & """"
			if spanClass <> "" then response.write " class=""" & spanClass & """"
			if baseUrl <> "" then response.write "><a href=""" & replacetext(baseUrl,cloud(0,ii),cloud(1,ii)) & cloud(3,ii) & """"
			if baseUrl <> "" and aClass <> "" then response.write " class=""" & aClass & """"
			if baseUrl <> "" and aOnClick <> "" then response.write " onclick=""" & replacetext(aOnClick,cloud(0,ii),cloud(1,ii)) & """"
			response.write ">" & cloud(0,ii)
			if baseUrl <> "" then response.write "</a>"
			response.write "</span>"& space & vbcrlf
		
		next
	end sub
	
	private function replacetext(byval value,name,id)
	
		value = replace(value,"%id",id)
		value = replace(value,"%name",name)
		replacetext = value
	
	end function
	
	'// esegue l'ordinamento dei tag
	'//		vector = "entries" ordina per occorrenze
	'//				 "name" ordina per nome
	'//		order = "asc" ordinamento crescente
	'//				"desc" ordinamento decrescente
	public sub sort(vector, order)
		if vector = "entries" then vector = 2
		if vector = "name" then vector = 0
		if vector <> 0 and vector <> 1 then exit sub
		dim tmp,ii
		for ii=1 to ubound(cloud,2)-1
			if (cloud(vector,ii) > cloud(vector,ii+1) and order = "asc") or (cloud(vector,ii) < cloud(vector,ii+1) and order = "desc") then
				call swap(ii,ii+1)
				ii=0
			end if
		next
	
	end sub
	
	'//---------------------------------------------------------------
	
	'// funzione interna
	'// scambia due elementi dell'array di posizione
	private sub swap(argIndex1, argIndex2)
	
		dim val0, val1, val2, val3
		val0 = cloud(0,argIndex1)
		val1 = cloud(1,argIndex1)
		val2 = cloud(2,argIndex1)
		val3 = cloud(3,argIndex1)
		cloud(0,argIndex1) = cloud(0,argIndex2)
		cloud(1,argIndex1) = cloud(1,argIndex2)
		cloud(2,argIndex1) = cloud(2,argIndex2)
		cloud(3,argIndex1) = cloud(3,argIndex2)
		cloud(0,argIndex2) = val0
		cloud(1,argIndex2) = val1
		cloud(2,argIndex2) = val2
		cloud(3,argIndex2) = val3
	
	end sub
	
	
	
end class
%>