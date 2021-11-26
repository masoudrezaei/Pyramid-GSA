function  DataN=normalData(Data)
[Dnum,Fnum]=size(Data);
DataN=Data;
for i=1:Fnum
    m=max(Data(:,i)); n=min(Data(:,i));
    if m~=n
        DataN(:,i)= (Data(:,i)-n)./(m-n);
    else
        DataN(:,i)= (Data(:,i))./(m);
    end
end

end