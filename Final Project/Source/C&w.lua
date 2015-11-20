require 'torch'
require 'nn'

--[[
Dataset:
i like nlp
i hate dl
i do math
]]--

-- Step 1: Define your vocabulary map
vocab={}
vocab['i']=1
vocab['like']=2
vocab['nlp']=3
vocab['hate']=4
vocab['dl']=5
vocab['do']=6
vocab['math']=7
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

dictionary = {}
-- print all line numbers and their contents
final_word = {}
lining={}
count = 0
j=0
local file = 'dict.txt'
local BUFSIZE = 2^13     -- 8K
    local f = io.input(file)   -- open input file
  --  local cc, lc, wc = 0, 0, 0   -- char, line, and word counts
    while true do
      local lines, rest = f:read(BUFSIZE, "*line")
      if not lines then break end
      if rest then lines = lines .. rest .. '\n' end
  --ii    print(lines)
	for word in string.gmatch(lines,'([^\n]+)') do
	--print(word)
	  j=1
          for wording in string.gmatch(word, '([^ ]+)') do
          	if j==2 then 
            		dictionary[i] = wording
            		j=1
			count = count +1
          	else
            		i = wording
            		j= j+1
          	end    
       	  end 
        end
      end
--print (count)
-- Step 2: Define constants
vocab_size=count
word_embed_size=50
learning_rate=0.01
window_size=3
max_epochs=5

-- Step 3: Prepare your dataset
local file = 'sswe_token.txt'
local lines = lines_from(file)
data ={}
context_count =1
for k,v in pairs(lines) do
  --print (v)
  j=0
  for word in string.gmatch(v, '([^ ]+)') do
    j =j+1
    if j==3 then
      input=torch.Tensor{dictionary[i],dictionary[word]} -- P(like | i, nlp)
      output=torch.Tensor{dictionary[i1]}
      j=2
      i= i1
      i1 = word
      data[context_count] ={input,output}
      context_count = context_count +1
      --print ('varun') 
       
    else if j==2 then
      i1 = word
    else
      i= word
    end
    end 	 	
    --print(word)
  end 
  --print (k)
end
function data:size() return context_count-1 end
--print (context_count)


-- Step 4: Define your model
model=nn.Sequential()
model:add(nn.LookupTable(vocab_size,word_embed_size))
model:add(nn.Mean())
model:add(nn.Linear(word_embed_size,vocab_size))
model:add(nn.LogSoftMax())

-- Step 5: Define the loss function (Negative log-likelihood)
criterion = nn.CrossEntropyCriterion()


-- Step 6: Define the trainer
trainer=nn.StochasticGradient(model,criterion)
trainer.learningRate=learning_rate
trainer.maxIteration=max_epochs

--print('Word Lookup before learning')
--print(model.modules[1].weight)

-- Step 7: Train the model with dataset
trainer:train(data)

-- Step 8: Get the word embeddings
--print('\nWord Lookup after learning')
vectors = model.modules[1].weight

--print (vectors)

array = {}



i = 1

while i<2  do
x = vectors:sub(i,i,1,50)
--print(y)

table.insert(array, x)
i = i+1
end 

file = torch.DiskFile('vector_syn.txt', 'w')
file:writeObject(array)
file:close()
 



