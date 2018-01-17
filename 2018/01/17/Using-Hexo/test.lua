local test = {"1",1,true}

-- for k,v in pairs(test) do
-- 	 table.remove(test)
-- end
c = true
d = false
local a = c or d
print(a)
print(#test)
print( table.remove(test,1) )
print( table.remove(test,1) )
print( table.remove(test,1) )
print(#test)

print(math.floor(4.7))
print(string.sub("0c",1,1))


print(101 >100 and (1.6>(1.1-0.1)))

local str = "c123"
local s,ss = string.sub(str,2)
print(s,str)
str = 123456 + 1

print(str)

local tb = {1,3,5,}
local tb1 = {}
for k,v in pairs(tb) do
	tb1[k] = false
	tb1[v] = true
end

for k,v in pairs(tb1) do
	print(k,v,"__")
end

local test1 = ""

test1 = (true and 1) or "c3"
print(test1)

print("---------------------")
local ttt = {{},{},{}}
print(#ttt)
-- local str = "page_1"
-- local int = 10

-- print(string.find(int,"page"))

-- local ttb = {[5]= 10,[6]=11}
-- for k,v in pairs(ttb) do
-- 	print(k,v)
-- end

-- local str = "gg.mp3"
-- print(str)

-- local xx = string.sub(str,1,2)
-- print(xx)
-- print(str)





-- local tt = function()
-- 	print(123)
-- 	return true
-- end


-- if  tt() and false then
-- 	print(456)
-- end


-- print(os.time())
-- print("----------")
-- print(os.time({year=1970, month=1, day=1, hour=0}))
-- print(os.date())






-- local t = math.min(5,2)




-- local str = "000000000000000.00"
-- local int , j = str:gsub("(%d%d%d)","%1,")
-- print(int,j)




























-- local str = "1234561956.96"
-- --69.6591
-- local int,i = str:reverse():gsub("(%d%d%d)", "%1,")
-- local ret,j = int:reverse():gsub("^,","")

-- -- str = ",123"
-- -- print((str:gsub("^,","")))

-- print(str:reverse())
-- print(int)
-- print(i)

-- print("-----")
-- print(ret)
-- print(j)










































-- local t = {0,0,0,0,0,0}



-- t = {1,2,3,4,5,6,7,8,9}
-- t = {1}
-- t = {{5},nil,{2,2},{2,2}}
-- function reverseTable( tb )
-- 	--将表中的元素顺序反转  不考虑索引不连续的情况
-- 	local length = #tb
-- 	for index = length,math.ceil(length/2), -1 do
-- 		local element = tb[length-(index-1)]
-- 		tb[length-(index-1)] = tb[index]
-- 		tb[index] = element
-- 	end
-- 	return tb
-- end

-- -- local i = 3.3

-- -- i = math.ceil(i)
-- -- print(i)
-- for k,v in pairs(t) do
-- 	if type(v) == "table" then
-- 		for k1,v1 in pairs(v) do
-- 			print(k,v1)
-- 		end
-- 	end
-- end

-- t = reverseTable(t)

-- for k,v in pairs(t) do
-- 	if type(v) == "table" then
-- 		for k1,v1 in pairs(v) do
-- 			print(k,v1)
-- 		end
-- 	end
-- end

