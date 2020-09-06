function [ LBF, LBP, GBP ,GBF ] = LocalBestPosition( CP,Xo,CF,CFo,n )
  LBF=zeros(1,n);
  LBP=zeros(1,n);
  for i=1:n
    if CF(i) > CFo(i)
       LBF(i)=CF(i);
       LBP(i)=CP(i);
    elseif CF(i)< CFo(i)
           LBF(i)=CFo(i);
           LBP(i)=Xo(i);
    else
        LBF(i)=CP(i);
    end
  end
  GBF=max(LBF);
  GBP=LBP(find(LBF==GBF));
  
end
