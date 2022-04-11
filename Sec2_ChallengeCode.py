check_string = input()
#print('input_string = ', check_string)
Count = {}
for s in check_string:
    if s in Count:
        Count[s]+=1
    else:
        Count[s] = 1
        continue
#print(Count.values())
l = list(Count.values())
#print(l)
for i in range (len(l)):
#  print(i)
  j = i + 1
#  print(j)
  break

if l[i] >= l[j]:
  print('is_beautiful_string(input_string) = ', True)
else:
  print('is_beautiful_string(input_string) = ', False)