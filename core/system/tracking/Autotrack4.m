function [ res ] = Autotrack4(cod, maxdist, mod)
%Ujii_Autotrack4 Summary of this function goes here
%   Detailed explanation goes here
%
% This code was originally developed by Prof. Hiroshi-Uji-i at KU Leuven,
% Belgium: https://sites.google.com/site/hiroshisgroup/ and is used here
% with minor modification of the comments sections.
%
% This function can be used to reconstruct single particle tracks from wide
% field fluorescence localization data of single emitters.
%
% Input:
%
% cod: The coordinates that compose the tracks with corresponding frame 
%      number
%
% maxdist: The maximum distance between tracks to be connected
%
% mod: The mode of connection. mod==1; does not connect tracks when more than
% one tracks are found within maxdist.
%
% Output:
% res: The trajectories (see below for the format of the output).
%
% Format of cod:
%
%            (frame)     (x)      (y)
%   cod = [     1       258.5	135.17
%               1       287.27	162.1
%               1       187.56	356.22
%               1       279.98	290.76
%               2       282.05	152.73
%               2       338.58	321.48
%               3       260.87	154.81
%               3       246.17	307.33
%               4       233.25	321.75	];
%
% Format of res:
%
%               (x)       (y)    (frame)   (# trajectry)
% res = [       187.56	356.22      1       1
%               338.37	321.13      1       2
%               338.58	321.48      2       2
%               169.07	251.52      1       3
%               143.18	262.2       2       3
%               137.43	266.29      3       3
%               141.13	384.25      1       4
%               447.17	49.03       1       5
%               445	    46          2       5
%               441	    50          3       5  ];


%%%%%%%% Creat initial matrix for trajectries %%%%%%%%%%
tic
%MM=zeros(max(cod(:,1)), round(size(cod,1).*0.7));
selfr=cod(1:5000:end, 1);
selfr=cat(1, selfr, cod(end,1));
selfr=unique(selfr);
MM=zeros(max(diff(selfr)), 5000);
k=1;
while k
    if ~isempty(cod(cod(:,1)==k,:))
        MM(1, 1:size(cod(cod(:,1)==k,:),1))=1:size(cod(cod(:,1)==k,:),1);
        k=0;
    else
        k=k+1;
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bigres=[];
trnr=1;
res=zeros(size(cod));
trnum=zeros(1, size(cod, 1));
conn=zeros(1, size(cod, 1));
h=waitbar(0, 'Calculating trajectories...');
for fr=cod(1,1):cod(end,1)-1
    if ~isempty(cod(cod(:,1)==fr,:)) || ~isempty(cod(cod(:,1)==fr+1,:))
        MMclm=find(sum(MM,2)>0, 1, 'last');
        
        a1=cod(cod(:,1)==fr,:);
        a2=cod(cod(:,1)==fr+1,:);
        %creat a matrix of distances between each track
        dr=pdist2(a1(:,2:3), a2(:,2:3));
        %dr is a matrix of distance between each track.
        %dr=[a1(1,:) to a2(1,:), a1(1,:) to a2(2,:), ...;
        %    a1(2,:) to a2(1,:), a1(2,:) to a2(2, :). ...;
        %    a1(3,:) to a2(1,:), a1(3,:) to a2(2, :). ...]
        % clear a1 a2 dx dy
        %[C,~] = min(dr);
        %nosel=find(C>maxdist);
        inds=find(dr<=maxdist);
        %b=[];
        if ~isempty(inds) %there are points in the radius
            b=dr(inds);
            try
                [b(:,3), b(:,2)]= ind2sub(size(dr),inds);
            catch
                b=b';
                [b(:,3), b(:,2)]= ind2sub(size(dr),inds);
            end
            b=sortrows(b, 1);
            
            nosel=setdiff(1:size(a2,1), b(:,2)); %new points
            
            if mod==0%connect tracks even if more than one tracks are found within maxdist
                %connect to the closest point
                kk=b;
                indsel=[];
                while ~isempty(kk)
                    indsel=cat(1, indsel, find(b(:,1)==kk(1,1) & b(:,2)==kk(1,2) & b(:,3)==kk(1,3)));
                    kk(kk(:,2)==kk(1,2) | kk(:,3)==kk(1,3), :)=[];
                end
                I=b(indsel, 2:3);
                nosel2=b(:,2);
                nosel2=nosel2(~ismember(nosel2, I(:,1)));
                nosel2=unique(nosel2)';
                nosel=sort(cat(2, nosel, nosel2));
            else
                kk=b;
                indsel=[];
                while ~isempty(kk)
                    check=size(find(b(:,3)==kk(1,3)),1);
                    if check==1
                        indsel=cat(1, indsel, find(b(:,1)==kk(1,1) & b(:,2)==kk(1,2) & b(:,3)==kk(1,3)));
                        kk(kk(:,2)==kk(1,2) | kk(:,3)==kk(1,3), :)=[];
                    else
                        kk(kk(:,3)==kk(1,3), :)=[]; %delete point from list
                    end
                end
                I=b(indsel, 2:3);
                nosel2=b(:,2);
                nosel2=nosel2(~ismember(nosel2, I(:,1)));
                nosel2=unique(nosel2)';
                nosel=sort(cat(2, nosel, nosel2));
            end
            
            
            I(:,1)=I(:,1)+size(cod(cod(:,1)<fr+1),1); %get number of point in original cod matrix
            I(:,2)=I(:,2)+size(cod(cod(:,1)<fr),1);
            
            col=arrayfun(@(x)findcol(MM(MMclm,:),x),I(:,2));
            %col=arrayfun(@(x)find(MM(MMclm,:)==x), I(:,2));
            MM(MMclm+1, col)=I(:,1)';
            %clear I indsel indsel1 indsel2 b inds
        else
            nosel=1:size(a2,1);
        end
        

        nosel=[nosel+size(cod(cod(:,1)<fr+1),1)]';
        MM(MMclm+1, find(sum(MM,1)>0, 1, 'last')+1:find(sum(MM,1)>0, 1, 'last')+size(nosel,1))=nosel';
        
        clear mn dr
    end
    %disp(num2str(fr))
    waitbar(fr/(cod(end,1)-1), h);
    %end
    
    if ismember(fr+1, selfr) || fr==cod(end,1)-1
        MM(all(MM==0,2),:)=[];
        MM(:, all(MM==0,1))=[];
        
        ff=find(selfr==fr+1);
        stpos=find(cod(:,1)==selfr(ff-1), 1, 'first');
        if fr==cod(end,1)-1
            fnpos=find(cod(:,1)==selfr(ff), 1, 'last');
        else
            fnpos=find(cod(:,1)==selfr(ff), 1, 'first')-1;
        end
        %tic
        mxxx=max(trnum);
        trnum(stpos:fnpos)=arrayfun(@(x)findcol(MM,x),stpos:fnpos);
        trnum(stpos:fnpos)=trnum(stpos:fnpos)+mxxx;
        keep=MM(end, :);
        MM=zeros(max(diff(selfr)), 5000);
        MM(1, 1:size(keep,2))=keep;
    end
end
toc
res=[cod(:,2:3), cod(:,1), trnum', cod(:,4:end)];
%connect break trajectories
for ii=2:size(selfr,1)-1
    deltr=[];
    fr=selfr(ii);
    a1=res(res(:,3)==fr-1,:);
    a2=res(res(:,3)==fr,:);
    dr=pdist2(a1(:,1:2), a2(:,1:2));
    dr=dr.*(dr(:,:)<=maxdist);
    dr(~dr)=NaN;
    k=1;
    while k
        if sum(double(~isnan(dr(:))))>0
            [c, r]=find(dr==min(dr(:)), 1, 'first');
            ntr=a2(r,4);otr=a1(c, 4);
            deltr=cat(1,deltr,ntr);
            res(res(:,4)==ntr,4)=res(res(:,4)==ntr,4)-(ntr-otr);
            %res(res(:,4)>ntr,4)=res(res(:,4)>ntr,4)-1;
            res=sortrows(res,4);
            dr(:, r)=NaN; dr(c,:)=NaN;
        else
            k=0;
        end
    end
    deltr=sort(deltr);
    for iii=size(deltr, 1):-1:1
        res(res(:,4)>deltr(iii),4)=res(res(:,4)>deltr(iii),4)-1;
    end
    waitbar(ii/(size(selfr,1)-1),h,'Reconnecting tracks...')
%     inds=find(dr<=maxdist);
%     if ~isempty(inds)
%         b=dr(inds);
%         [b(:,3), b(:,2)]= ind2sub(size(dr),inds);
%         b=sortrows(b, 1);
%         for iii=1:size(b,2)
%             ntr=a2(b(iii,2),4);otr=a1(b(iii,3), 4);
%             res(res(:,4)==ntr,4)=res(res(:,4)==ntr,4)-(ntr-otr);
%             res(res(:,4)>ntr,4)=res(res(:,4)>ntr,4)-1;
%             res=sortrows(res,4);
%         end
%     end
end
toc


disp(['connection has been done!! Till frame = ' num2str(max(res(:,3)))]);
close(h)

clear fr track trck mod dx dy c a1 a2 j jjj MMclm t tmp tt %MM

end

function b=findcol(a, x)
[~, b]=find(a==x, 1, 'first');
end


