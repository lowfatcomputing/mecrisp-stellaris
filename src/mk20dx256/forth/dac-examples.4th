\ dac-examples.4th -- Digital-to-Analog Converter (DAC) examples
\ 
\ REQUIRES: dac.4th delay.4th
\ 
\ Square wave of a counted string.
\ Triangle wave
\ Sine wave using a sine table computed with: http://www.daycounter.com/Calculators/Sine-Generator-Calculator.phtml

: bounds ( addr len -- addr+len addr )
  over + swap
 ;

: stop-loop
   key?
   if   key $1B =  \ ESC
   else 0
   then
 ;

: triangle-wave
  +dac
  begin
    $FFF 0 ?do      i       dac loop
    $FFF 0 ?do $FFF i -     dac loop
    stop-loop
  until
 ;

$FF0 variable amplitude \ < $FFF

: byte>dac ( byte -- )
  $8 0 do
    dup i rshift 1 and amplitude * dac
    2 ms
  loop drop
 ;

: square-wave ( addr-c -- )
  +dac
  0 ?do
    dup c@ byte>dac 1+
  loop drop
  0 dac
 ;

create sine-table
$7ff , $80c , $818 , $825 , $831 , $83e , $84a , $857 , 
$864 , $870 , $87d , $889 , $896 , $8a2 , $8af , $8bb , 
$8c8 , $8d4 , $8e1 , $8ed , $8fa , $906 , $913 , $91f , 
$92c , $938 , $944 , $951 , $95d , $96a , $976 , $982 , 
$98f , $99b , $9a7 , $9b4 , $9c0 , $9cc , $9d8 , $9e5 , 
$9f1 , $9fd , $a09 , $a15 , $a21 , $a2e , $a3a , $a46 , 
$a52 , $a5e , $a6a , $a76 , $a82 , $a8e , $a9a , $aa5 , 
$ab1 , $abd , $ac9 , $ad5 , $ae0 , $aec , $af8 , $b03 , 
$b0f , $b1b , $b26 , $b32 , $b3d , $b49 , $b54 , $b60 , 
$b6b , $b76 , $b82 , $b8d , $b98 , $ba3 , $baf , $bba , 
$bc5 , $bd0 , $bdb , $be6 , $bf1 , $bfc , $c07 , $c11 , 
$c1c , $c27 , $c32 , $c3c , $c47 , $c52 , $c5c , $c67 , 
$c71 , $c7c , $c86 , $c90 , $c9b , $ca5 , $caf , $cb9 , 
$cc3 , $ccd , $cd8 , $ce1 , $ceb , $cf5 , $cff , $d09 , 
$d13 , $d1c , $d26 , $d30 , $d39 , $d43 , $d4c , $d55 , 
$d5f , $d68 , $d71 , $d7a , $d84 , $d8d , $d96 , $d9f , 
$da8 , $db0 , $db9 , $dc2 , $dcb , $dd3 , $ddc , $de4 , 
$ded , $df5 , $dfe , $e06 , $e0e , $e16 , $e1e , $e26 , 
$e2e , $e36 , $e3e , $e46 , $e4e , $e56 , $e5d , $e65 , 
$e6c , $e74 , $e7b , $e82 , $e8a , $e91 , $e98 , $e9f , 
$ea6 , $ead , $eb4 , $ebb , $ec1 , $ec8 , $ecf , $ed5 , 
$edc , $ee2 , $ee9 , $eef , $ef5 , $efb , $f01 , $f07 , 
$f0d , $f13 , $f19 , $f1f , $f24 , $f2a , $f30 , $f35 , 
$f3a , $f40 , $f45 , $f4a , $f4f , $f54 , $f59 , $f5e , 
$f63 , $f68 , $f6d , $f71 , $f76 , $f7a , $f7f , $f83 , 
$f87 , $f8b , $f8f , $f94 , $f97 , $f9b , $f9f , $fa3 , 
$fa7 , $faa , $fae , $fb1 , $fb5 , $fb8 , $fbb , $fbe , 
$fc1 , $fc4 , $fc7 , $fca , $fcd , $fd0 , $fd2 , $fd5 , 
$fd7 , $fda , $fdc , $fde , $fe0 , $fe2 , $fe4 , $fe6 , 
$fe8 , $fea , $fec , $fed , $fef , $ff0 , $ff2 , $ff3 , 
$ff4 , $ff6 , $ff7 , $ff8 , $ff9 , $ffa , $ffa , $ffb , 
$ffc , $ffc , $ffd , $ffd , $ffd , $ffe , $ffe , $ffe , 
$ffe , $ffe , $ffe , $ffe , $ffd , $ffd , $ffc , $ffc , 
$ffb , $ffb , $ffa , $ff9 , $ff8 , $ff7 , $ff6 , $ff5 , 
$ff4 , $ff3 , $ff1 , $ff0 , $fee , $fed , $feb , $fe9 , 
$fe7 , $fe5 , $fe3 , $fe1 , $fdf , $fdd , $fdb , $fd8 , 
$fd6 , $fd3 , $fd1 , $fce , $fcb , $fc9 , $fc6 , $fc3 , 
$fc0 , $fbd , $fb9 , $fb6 , $fb3 , $faf , $fac , $fa8 , 
$fa5 , $fa1 , $f9d , $f99 , $f95 , $f91 , $f8d , $f89 , 
$f85 , $f81 , $f7c , $f78 , $f73 , $f6f , $f6a , $f65 , 
$f61 , $f5c , $f57 , $f52 , $f4d , $f48 , $f42 , $f3d , 
$f38 , $f32 , $f2d , $f27 , $f22 , $f1c , $f16 , $f10 , 
$f0a , $f04 , $efe , $ef8 , $ef2 , $eec , $ee5 , $edf , 
$ed9 , $ed2 , $ecb , $ec5 , $ebe , $eb7 , $eb0 , $eaa , 
$ea3 , $e9c , $e94 , $e8d , $e86 , $e7f , $e77 , $e70 , 
$e69 , $e61 , $e59 , $e52 , $e4a , $e42 , $e3a , $e32 , 
$e2a , $e22 , $e1a , $e12 , $e0a , $e02 , $df9 , $df1 , 
$de9 , $de0 , $dd8 , $dcf , $dc6 , $dbe , $db5 , $dac , 
$da3 , $d9a , $d91 , $d88 , $d7f , $d76 , $d6d , $d63 , 
$d5a , $d51 , $d47 , $d3e , $d34 , $d2b , $d21 , $d18 , 
$d0e , $d04 , $cfa , $cf0 , $ce6 , $cdd , $cd3 , $cc8 , 
$cbe , $cb4 , $caa , $ca0 , $c96 , $c8b , $c81 , $c76 , 
$c6c , $c62 , $c57 , $c4c , $c42 , $c37 , $c2c , $c22 , 
$c17 , $c0c , $c01 , $bf6 , $beb , $be0 , $bd5 , $bca , 
$bbf , $bb4 , $ba9 , $b9e , $b93 , $b87 , $b7c , $b71 , 
$b65 , $b5a , $b4e , $b43 , $b38 , $b2c , $b20 , $b15 , 
$b09 , $afe , $af2 , $ae6 , $adb , $acf , $ac3 , $ab7 , 
$aab , $a9f , $a94 , $a88 , $a7c , $a70 , $a64 , $a58 , 
$a4c , $a40 , $a34 , $a28 , $a1b , $a0f , $a03 , $9f7 , 
$9eb , $9df , $9d2 , $9c6 , $9ba , $9ae , $9a1 , $995 , 
$989 , $97c , $970 , $963 , $957 , $94b , $93e , $932 , 
$925 , $919 , $90d , $900 , $8f4 , $8e7 , $8db , $8ce , 
$8c2 , $8b5 , $8a9 , $89c , $88f , $883 , $876 , $86a , 
$85d , $851 , $844 , $838 , $82b , $81e , $812 , $805 , 
$7f9 , $7ec , $7e0 , $7d3 , $7c6 , $7ba , $7ad , $7a1 , 
$794 , $788 , $77b , $76f , $762 , $755 , $749 , $73c , 
$730 , $723 , $717 , $70a , $6fe , $6f1 , $6e5 , $6d9 , 
$6cc , $6c0 , $6b3 , $6a7 , $69b , $68e , $682 , $675 , 
$669 , $65d , $650 , $644 , $638 , $62c , $61f , $613 , 
$607 , $5fb , $5ef , $5e3 , $5d6 , $5ca , $5be , $5b2 , 
$5a6 , $59a , $58e , $582 , $576 , $56a , $55f , $553 , 
$547 , $53b , $52f , $523 , $518 , $50c , $500 , $4f5 , 
$4e9 , $4de , $4d2 , $4c6 , $4bb , $4b0 , $4a4 , $499 , 
$48d , $482 , $477 , $46b , $460 , $455 , $44a , $43f , 
$434 , $429 , $41e , $413 , $408 , $3fd , $3f2 , $3e7 , 
$3dc , $3d2 , $3c7 , $3bc , $3b2 , $3a7 , $39c , $392 , 
$388 , $37d , $373 , $368 , $35e , $354 , $34a , $340 , 
$336 , $32b , $321 , $318 , $30e , $304 , $2fa , $2f0 , 
$2e6 , $2dd , $2d3 , $2ca , $2c0 , $2b7 , $2ad , $2a4 , 
$29b , $291 , $288 , $27f , $276 , $26d , $264 , $25b , 
$252 , $249 , $240 , $238 , $22f , $226 , $21e , $215 , 
$20d , $205 , $1fc , $1f4 , $1ec , $1e4 , $1dc , $1d4 , 
$1cc , $1c4 , $1bc , $1b4 , $1ac , $1a5 , $19d , $195 , 
$18e , $187 , $17f , $178 , $171 , $16a , $162 , $15b , 
$154 , $14e , $147 , $140 , $139 , $133 , $12c , $125 , 
$11f , $119 , $112 , $10c , $106 , $100 , $fa , $f4 , 
$ee , $e8 , $e2 , $dc , $d7 , $d1 , $cc , $c6 , 
$c1 , $bc , $b6 , $b1 , $ac , $a7 , $a2 , $9d , 
$99 , $94 , $8f , $8b , $86 , $82 , $7d , $79 , 
$75 , $71 , $6d , $69 , $65 , $61 , $5d , $59 , 
$56 , $52 , $4f , $4b , $48 , $45 , $41 , $3e , 
$3b , $38 , $35 , $33 , $30 , $2d , $2b , $28 , 
$26 , $23 , $21 , $1f , $1d , $1b , $19 , $17 , 
$15 , $13 , $11 , $10 , $e , $d , $b , $a , 
$9 , $8 , $7 , $6 , $5 , $4 , $3 , $3 , 
$2 , $2 , $1 , $1 , $0 , $0 , $0 , $0 , 
$0 , $0 , $0 , $1 , $1 , $1 , $2 , $2 , 
$3 , $4 , $4 , $5 , $6 , $7 , $8 , $a , 
$b , $c , $e , $f , $11 , $12 , $14 , $16 , 
$18 , $1a , $1c , $1e , $20 , $22 , $24 , $27 , 
$29 , $2c , $2e , $31 , $34 , $37 , $3a , $3d , 
$40 , $43 , $46 , $49 , $4d , $50 , $54 , $57 , 
$5b , $5f , $63 , $67 , $6a , $6f , $73 , $77 , 
$7b , $7f , $84 , $88 , $8d , $91 , $96 , $9b , 
$a0 , $a5 , $aa , $af , $b4 , $b9 , $be , $c4 , 
$c9 , $ce , $d4 , $da , $df , $e5 , $eb , $f1 , 
$f7 , $fd , $103 , $109 , $10f , $115 , $11c , $122 , 
$129 , $12f , $136 , $13d , $143 , $14a , $151 , $158 , 
$15f , $166 , $16d , $174 , $17c , $183 , $18a , $192 , 
$199 , $1a1 , $1a8 , $1b0 , $1b8 , $1c0 , $1c8 , $1d0 , 
$1d8 , $1e0 , $1e8 , $1f0 , $1f8 , $200 , $209 , $211 , 
$21a , $222 , $22b , $233 , $23c , $245 , $24e , $256 , 
$25f , $268 , $271 , $27a , $284 , $28d , $296 , $29f , 
$2a9 , $2b2 , $2bb , $2c5 , $2ce , $2d8 , $2e2 , $2eb , 
$2f5 , $2ff , $309 , $313 , $31d , $326 , $331 , $33b , 
$345 , $34f , $359 , $363 , $36e , $378 , $382 , $38d , 
$397 , $3a2 , $3ac , $3b7 , $3c2 , $3cc , $3d7 , $3e2 , 
$3ed , $3f7 , $402 , $40d , $418 , $423 , $42e , $439 , 
$444 , $44f , $45b , $466 , $471 , $47c , $488 , $493 , 
$49e , $4aa , $4b5 , $4c1 , $4cc , $4d8 , $4e3 , $4ef , 
$4fb , $506 , $512 , $51e , $529 , $535 , $541 , $54d , 
$559 , $564 , $570 , $57c , $588 , $594 , $5a0 , $5ac , 
$5b8 , $5c4 , $5d0 , $5dd , $5e9 , $5f5 , $601 , $60d , 
$619 , $626 , $632 , $63e , $64a , $657 , $663 , $66f , 
$67c , $688 , $694 , $6a1 , $6ad , $6ba , $6c6 , $6d2 , 
$6df , $6eb , $6f8 , $704 , $711 , $71d , $72a , $736 , 
$743 , $74f , $75c , $768 , $775 , $781 , $78e , $79a , 
$7a7 , $7b4 , $7c0 , $7cd , $7d9 , $7e6 , $7f2 , $7ff , 

: sine-wave ( us -- ) \ Pass us delay to control frequency.
  delay-init
  +dac
  begin
    sine-table $400 cells bounds do
      i @ dac
      dup us
      1 cells
    +loop
    stop-loop
  until
  0 dac
 ;


