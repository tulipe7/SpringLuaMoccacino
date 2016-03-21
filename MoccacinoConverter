
typeStrings={
	["boolean"]="boolean",
	["table"]="table",
	["number"]="number",
	["string"]="string",
	["function"]="function",
}


typeMockValues={
	["boolean"]="true",
	["table"]="{exampletable= true}",
	["number"]= "42",
	["string"]="TestString",
	["function"]= "function (bar) return bar; end",
}

function generatePreample(outTable)
	outTable[#outTable+1]="--==================================================================================================\n"

	outTable[#outTable+1]="-- Copyright (C) <2016> <PicassoCT>\n"

	outTable[#outTable+1]="--This program is free software: you can redistribute it and/or modify\n"
	outTable[#outTable+1]="--it under the terms of the GNU General Public License as published by\n"
	outTable[#outTable+1]="--the Free Software Foundation, either version 3 of the License, or\n"
	outTable[#outTable+1]="--(at your option) any later version.\n"

	outTable[#outTable+1]="--This program is distributed in the hope that it will be useful,\n"
	outTable[#outTable+1]="--but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
	outTable[#outTable+1]="--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n"
	outTable[#outTable+1]="--GNU General Public License for more details.\n"

	outTable[#outTable+1]="-- You should have received a copy of the GNU General Public License\n"
	outTable[#outTable+1]="--along with this program. If not, see <http://www.gnu.org/licenses/>.\n"


	outTable[#outTable+1]="--==================================================================================================\n"
	outTable[#outTable+1]="--Variables for the MockUp\n"
	outTable[#outTable+1]="Spring ={}\n"

	for k,v in pairs(typeStrings) do
		outTable[#outTable+1] = k .."Mock ="..typeMockValues[k].."\n"
	end
	outTable[#outTable+1]="--==================================================================================================\n"
	outTable[#outTable+1]="\n"
	return outTable
end


function getFirstVisibileAscii(line, index)
	if not line then return -1 end

	for i=index, string.len(line),1 do

		asciival= string.byte(line, i)

		if asciival then
			if (asciival > 48 and asciival < 58) or(asciival > 64 and asciival < 91) or (asciival < 123 and asciival > 96) then
				return i
			end
		end

	end
	return -1
end

function getFirstSymbol(line, index)
	if not line then return -1 end

	for i=index, string.len(line),1 do

		asciival= string.byte(line, i)
		if asciival then
			if ((asciival > 64 and asciival < 91) or (asciival < 123 and asciival > 96)) then
			else
				return i
			end
		end
	end
	return -1
end

function containsAscci(line)

	for i=1, string.len(line) do

		asciival= string.byte(line, i)
		if asciival > 32 and asciival < 126 then
			return true
		end

	end
	return false
end

function trim(s)
	if not s then return "" end
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function sanitizeWord(word)

	coma= string.find(word,",")
	if coma then
		word=string.sub(word,1,coma-1)
	end

	goose= string.find(word,"\"")
	if goose then
		word=string.sub(word,1,goose-1)
	end

	goose= string.find(word,"]")
	if goose then
		word=string.sub(word,1,goose-1)
	end

	goose= string.find(word,"%)")
	if goose then
		word=string.sub(word,1,goose-1)
	end

	return word
end


function getWord(line, wordStart)
	wordStart =getFirstVisibileAscii(line,wordStart)
	wordEnd = getFirstSymbol(line, wordStart)
	word =string.sub(line,wordStart,wordEnd)

	word = sanitizeWord(word)

	word= trim(word)

	return word, wordStart, wordEnd
end

boolLastLineContainedArgument=false

function getHead(HeaderEnd,line)
	functionNameEnd=string.find(line," ", HeaderEnd+1)
	functionName=string.sub(line,HeaderEnd+1,functionNameEnd)
	processedString= "Spring."..functionName.. " = function ".." ( "
	boolFoundHeader=true
	boolValidHead=true

	return functionNameEnd, functionName,processedString, boolFoundHeader, boolValidHead
end

function handleTables (line)
tableStart= string.find(line,"{")
tableEnd = string.find(line, "}")

if tableStart and tableEnd then
line = string.sub(line,1,tableStart-1).." table mock ,"..string.sub(line,tableEnd+1,string.len(line))
elseif tableStart then
line = string.sub(line,1,tableStart-1).." table mock ,"
elseif tableEnd then
line =string.sub(line,tableEnd+1,string.len(line))
end
return line
end

function getArguments(line, start, endArg, isReturnData)
	ret={numberArguments= 0, [""]=""}

	if not isReturnData then
		if string.find(line,"|") then
			line = string.sub(line,1, string.find(line,"|"))
		end

		braceOpen =string.find(line,"%(")
		braceClose =string.find(line,"%)")
		if braceOpen and braceClose then
			line= string.sub(line,braceOpen,braceClose)
		end
		line=trim(line)

		if not line or not start or not endArg then
			return ret
		end

		if containsAscci(line)==false then
			return ret
		end
	else
		ret={numberArguments= 0, [""]=""}
		if not line or not start or not endArg then return ret end
		--search for return type nil
		nilFound, nilEnd= string.find(line,"nil")
		nilfound, nilEnd= string.find(line, "|",nilEnd)
		if nilEnd then
			line=string.sub(line,nilEnd+1)
			nextor=string.find(line,"|", nilEnd) or string.find(line,"%)")
		end
	end


	numberArguments= 0


	--iterrate over the string and at least get the type


	boolFoundSomething=true
	boolTypeFound = false

	currentType =""

	wordStart =getFirstVisibileAscii(line,1)
	wordEnd=1
	word = ""
	argCounter=0
	boolLastLineContainedArgument=false

	line = handleTables(line)

	while boolFoundSomething == true and argCounter < 15 do
		boolFoundSomething=false
		argCounter=argCounter+1
		word, wordStart,wordEnd = getWord(line, wordEnd)

		if word and typeStrings[word] then

			currentType= typeStrings[word]
			numberArguments= numberArguments+1

			if	isReturnData then
				ret[numberArguments]={}
				ret[numberArguments].types =currentType
				ret[numberArguments].value ="ReturnValue"
				boolLastLineContainedArgument=true
				--skip the next word
				boolFoundSomething=true
				boolTypeFound = true
			else

				word, wordStart,wordEnd = getWord(line, wordEnd)
				boolTypeFound = true
				boolFoundSomething=true
			end
		end

		if word and boolTypeFound == true then
			--	print("VarName:"..word)
			ret[numberArguments]={}
			ret[numberArguments].types =currentType
			ret[numberArguments].value =word


			boolFoundSomething= true
			boolTypeFound=false
			word = nil
		end

	end

	ret.numberArguments= numberArguments
	return ret
end

function twoEmptyInARow(line, LineCount)
	if getFirstVisibileAscii(line,1) == -1 then
	LineCount=LineCount+1
	end

	if  LineCount> 2 then
	return true, 0
	else
	return false, LineCount
	end
end

function createArgsAssert(line,ArgEnd)

			lineEnd= ArgEnd or string.find(line,"%)")
			boolMatchArgumentsStart = true
			argumentsTable = getArguments(line,ArgStart ,lineEnd)

			number=0
			total=(argumentsTable).numberArguments
			argumentsTable.numberArguments=nil
			for i=1, #argumentsTable do
				local element= argumentsTable[i]

				types=element.types
				value=element.value

				if types ~= "" then
					processedString=processedString.." "..value

					number = number + 1
					if number > 0 then
						processedString= processedString.. ","
					end

					assertString = assertString.. "assert(type("..value..") == \""..types.."\",\"Argument ".. value.." is of invalid type - expected "..types.."\");\n"
				end
			end
return  assertString,processedString,boolMatchArgumentsStart
end

function main()
	print("Main reached")
	file = io.open("api.txt","r")

	outPut={}
	outPut=generatePreample(outPut)


	Puffer={}


	for line in file:lines() do
		boolRestart=false
		assertString=""
		returnString=""
		comentString= ""
		processedString =""


	Header,HeaderEnd = string.find(line, "Spring.")

	while boolRestart == false and not Header do
	line=	io.read("*line")
	Header,HeaderEnd = string.find(line, "Spring.")


	--read lines till you found the header
		if boolRestart== false and Header  then
			Puffer={}
			--Reset all the Strings
			assertString=""
			returnString=""
			comentString= ""

			functionNameEnd, functionName,processedString, boolFoundHeader, boolValidHead= getHead(HeaderEnd,line)
		end

	end


	--try to get the argstart
	ArgStart = string.find(line,"%(")
	LineCount=0
	--if no argstart fast forward
	while boolRestart == false  and not ArgStart do
		line=	io.read("*line")
		ArgStart = string.find(line,"%(")
			--if no many arguments found skip forward
			if not ArgStart then
			boolRestart,LineCount = twoEmptyInARow(line, LineCount)
			end
	end


	boolArgContinueCounter= true

	-- process arguments
	while  boolRestart == false  and boolArgContinueCounter == true do

		assertString, processedString = createArgsAssert(line,ArgEnd)

			processedString=string.sub(processedString,1,string.len(processedString)-1)


		ArgEnd 	 = string.find(line,"%)")
		if ArgEnd then
			boolArgContinueCounter= false
			processedString=processedString..")\n"
		end

	end

	--Search for the Return Types
	_,ReturnEnd = string.find(line, "->")
	while boolRestart == false  and not ReturnEnd do

		line=	io.read("*line")
		_, ReturnEnd = string.find(line,"->")
			--if no many arguments found skip forward
			if not ArgStart then
			boolRestart,LineCount = twoEmptyInARow(line, LineCount)
			end
	end

	if ReturnEnd then returnString= "return "end
	boolOneLineEmpty=false

	--handle the return arguments
	while boolRestart == false and boolOneLineEmpty==false do

			argumentsTable = getArguments(line, ReturnEnd, string.len(line),true)


			argumentsTable.numberArguments=nil

			for i=1, #argumentsTable do
				local element= argumentsTable[i]

				types=element.types
				value=element.value

				if types and types ~="" then
					returnString=returnString.." "..types.."Mock"..","
				end
			end




		line=	io.read("*line")
		if getFirstVisibileAscii(line,1) == -1 then
			returnString= string.sub(returnString,1,string.len(returnString)-1)
			boolOneLineEmpty=true
		end

	end


	if boolRestart== false then

		Puffer[#Puffer+1]=comentString..processedString..assertString..returnString.."\n end\n\n"



			for i=1, #Puffer do
				outPut[#outPut+1] = Puffer[i]
			end
			Puffer={}

	end
end


	file = io.open("out.txt","w")
	io.output(file)

	for i=1,#outPut, 1 do
		io.write(outPut[i])
	end

end

main()
