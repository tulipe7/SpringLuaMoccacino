
function trim(s)
	if not s then return "" end
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end



function extractAPICall(line)
	_,subStart = string.find(line, "name=\"")
	subEnd,_ = string.find(line, "func", subStart)
	subString=string.sub(line,subStart,subEnd-1)
	subString = subString:gsub("\"","")
	subString = trim(subString)

	return subString
end

function endOfTheLine(line)
	return string.find(line,"</KeyWord>") ~= nil
end

function startOfAPILine(line)
	return string.find(line,"<KeyWord name=") ~= nil
end

API={}
sortListAPI={}
outPut={}

function main()
	print("Main reached")
	file = io.open("Springtemp.xml","r")
	boolAPIOpen= false

	for line in file:lines() do
		if startOfAPILine(line)==true then
		boolAPIOpen= true


		nameOfApi= extractAPICall(line)
		API[nameOfApi]={}
		table.insert(sortListAPI,nameOfApi)
		end

		if boolAPIOpen == true then
			API[nameOfApi][#API[nameOfApi]+1]= line
		end

		if endOfTheLine(line)==true then
			boolAPIOpen=false
		end
	end

	table.sort(sortListAPI)

	for i=1,#sortListAPI do
		outPut[#outPut+1] ="\r\n"
		for j=1,#API[sortListAPI[i]] do
			outPut[#outPut+1] =API[sortListAPI[i]][j].."\n"
		end
	end


	file = io.open("out.txt","w")
	io.output(file)

	for i=1,#outPut, 1 do
		io.write(outPut[i])
	end

end

main()
