function img_out = sc2(img,varargin)
% Call sc with reduce factor of the image
% See Also : sc
reduced=max(1,floor(size(img,1)/2000));
if nargout
    img_out = sc(img(1:reduced:end,1:reduced:end,:),varargin{:});
else
    sc(img(1:reduced:end,1:reduced:end,:),varargin{:})
end