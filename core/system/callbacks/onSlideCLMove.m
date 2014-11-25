function onSlideCLMove( source , callbackdata )

value = round(get( source, 'Value' ));

% We use a convenience method so we do not need hard-coded references to
% handles
setcurrentframeCL( value );

end



