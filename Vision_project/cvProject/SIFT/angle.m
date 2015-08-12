or (p=x-1:x+1)
for(q=y-1:y+1)
temp_m=[temp_m sqrt((scsp1(p+1,q)-scsp1(p-1,q))^2+(scsp1(p,q+1)-scsp1(p,q-1))^2)];
if ((scsp1(p+1,q)-scsp1(p-1,q))>=0 & (scsp1(p,q+1)-scsp1(p,q-1))<=0)
temp_o=[temp_o 360+atand((scsp1(p,q+1)-scsp1(p,q-1))/(scsp1(p+1,q)-scsp1(p-1,q)))];
elseif ((scsp1(p+1,q)-scsp1(p-1,q))<0 & (scsp1(p,q+1)-scsp1(p,q-1))<0)
temp_o=[temp_o 180+atand((scsp1(p,q+1)-scsp1(p,q-1))/(scsp1(p+1,q)-scsp1(p-1,q)))];
elseif ((scsp1(p+1,q)-scsp1(p-1,q))<0 & (scsp1(p,q+1)-scsp1(p,q-1))>=0)
temp_o=[temp_o 180+atand((scsp1(p,q+1)-scsp1(p,q-1))/(scsp1(p+1,q)-scsp1(p-1,q)))];
else
temp_o=[temp_o atand((scsp1(p,q+1)-scsp1(p,q-1))/(scsp1(p+1,q)-scsp1(p-1,q)))];
end
end
