clc, clear all  %#ok<CLALL>
sendMsg = 'ABCDEFG'; %The plaintext
fprintf("Original Message :%s\n", sendMsg) 

%We choose a large prime q
q=prevprime(10000000);  

%From the cyclic group Fq, choose any element g
g = randi([2, q],1); %the element of the cyclic group Fq

key = gen_prevate_key(q); %Private key for decryption(an element a such that gcd(a, q) = 1)
h = power(g, key, q);   % q^key

display('public key:') %q, g and h are public keys
fprintf("q used : %.4f\n", q);
fprintf("g used : %.4f\n", g);
fprintf("g^a used : %.4f\n", h)

display('private key:')   %#ok<*DISPLAYPROG> %private key
fprintf("key used : %.4f\n", key);


[encMsg, p] = elGamal_encrypt(sendMsg, q, h, g) ;%message is encrypted using public key

decMsg = elGamal_decrypt(encMsg, p, key, q); %decrypt the encrypted message 
                                             %using p , key and q 

fprintf("Decrypted Message :%s\n", decMsg); 

% ElGamal encryption
function dr_msg = elGamal_decrypt(encMsg, p, key, q)
    %p: it is recieved from encryption
    %key: decrypting the private key
    %q: public key
    dr_msg = ''; 
    s = power(p, key, q) ;%decryption calculates secret key
    for ii=1 : length(encMsg)
        dr_msg =strcat(dr_msg , (char(fix(encMsg(ii)/s)))) ;%decrypt the message by 
                                                            %computing M = encMsg x s^-1    
    end

end
% ElGamal encryption
function [en_msg2, p] = elGamal_encrypt(msg, q, h, g) 
 % a message is encrypted using public key q, h and g
    en_msg = msg; 
  
    k = gen_prevate_key(q);   % Private key for the sender 
    
    s = power(h, k, q);  %the shared secret
    p = power(g, k, q);  %the sender calculates g^k
         
    display('encrypt parameters:')
    fprintf("g^k used : %.4f\n", p); 
    fprintf("g^ak used : %.4f\n", s); 
    for ii =1:length(en_msg) 
        en_msg2(ii) = s * double(en_msg(ii)); %#ok<AGROW> %encrypt m by computing X=msg x s
    end
end

% Generating private key
function key= gen_prevate_key(q)
    %private key is generated  such that gcd(key, q) = 1
    key = randi([100000, q],1); 
    
    while (gcd(q, key) ~= 1) 
        key = randi([100000, q],1) ;
    end
end
      
% power calculation 
function rr = power(a, b, c)
    %a:  element of the cyclic group Fq , or the shared secret
    %b:  exponent
    %c:  prime number
    x = 1;
    y = a;
  
    while b > 0
        if mod(b , 2) == 0 
            x = mod((x * y) , c);
        end
        y = mod((y * y) , c );
        b = fix(b / 2) ;
    end
  
    rr= mod(x, c);  
end   

function  rr= gcd(x, y) 
    %the condition function used when private key is generated 
    if x < y 
        rr= gcd(y,x); 
    elseif mod(x , y) == 0 
        rr= y ;
    else 
        rr= gcd(y, mod(x , y)); 
    end
end