import random
random.seed(99999999999)

scramble = True

fname = 'Filename' + '.pdf'
output = fname.split('.')[0] + '.bytes'

inp = fname if scramble else output
with open(inp, 'rb') as f:
  data = f.read()
  
lenn = len(data)
print(lenn)

indx_list = list(range(lenn))
random.shuffle(indx_list)
zipp = zip(indx_list, list(range(lenn))) if scramble else zip(list(range(lenn)), indx_list)
position_map = {aa:bb for aa, bb in zipp}
newbob = [0 for ii in range(lenn)]
for new_ind, num in position_map.items():
  newbob[new_ind] = data[num]
outbob = bytes(newbob)

outname = output if scramble else fname
with open(outname, 'wb') as f:
  f.write(outbob)