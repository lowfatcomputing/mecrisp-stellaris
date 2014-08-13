\ adc.4th -- Analog-to-Digital Converter


$4004803C constant SIM_SCGC6

$4003B000 constant ADC0_SC1A  \ ADC Status and Control Registers 1
$4003B004 constant ADC0_SC1B  \ ADC Status and Control Registers 1
$4003B008 constant ADC0_CFG1  \ ADC Configuration Register 1
$4003B00C constant ADC0_CFG2  \ ADC Configuration Register 2
$4003B010 constant ADC0_RA    \ ADC Data Result Register
$4003B014 constant ADC0_RB    \ ADC Data Result Register
$4003B018 constant ADC0_CV1   \ Compare Value Registers
$4003B01C constant ADC0_CV2   \ Compare Value Registers
$4003B020 constant ADC0_SC2   \ Status and Control Register 2
$4003B024 constant ADC0_SC3   \ Status and Control Register 3
$4003B028 constant ADC0_OFS   \ ADC Offset Correction Register
$4003B02C constant ADC0_PG    \ ADC Plus-Side Gain Register
$4003B030 constant ADC0_MG    \ ADC Minus-Side Gain Register
$4003B034 constant ADC0_CLPD  \ ADC Plus-Side General Calibration Value Register
$4003B038 constant ADC0_CLPS  \ ADC Plus-Side General Calibration Value Register
$4003B03C constant ADC0_CLP4  \ ADC Plus-Side General Calibration Value Register
$4003B040 constant ADC0_CLP3  \ ADC Plus-Side General Calibration Value Register
$4003B044 constant ADC0_CLP2  \ ADC Plus-Side General Calibration Value Register
$4003B048 constant ADC0_CLP1  \ ADC Plus-Side General Calibration Value Register
$4003B04C constant ADC0_CLP0  \ ADC Plus-Side General Calibration Value Register
$4003B050 constant ADC0_PGA   \ ADC PGA Register
$4003B054 constant ADC0_CLMD  \ ADC Minus-Side General Calibration Value Register
$4003B058 constant ADC0_CLMS  \ ADC Minus-Side General Calibration Value Register
$4003B05C constant ADC0_CLM4  \ ADC Minus-Side General Calibration Value Register
$4003B060 constant ADC0_CLM3  \ ADC Minus-Side General Calibration Value Register
$4003B064 constant ADC0_CLM2  \ ADC Minus-Side General Calibration Value Register
$4003B068 constant ADC0_CLM1  \ ADC Minus-Side General Calibration Value Register
$4003B06C constant ADC0_CLM0  \ ADC Minus-Side General Calibration Value Register
$400BB000 constant ADC1_SC1A  \ ADC Status and Control Registers 1
$400BB004 constant ADC1_SC1B  \ ADC Status and Control Registers 1
$400BB008 constant ADC1_CFG1  \ ADC Configuration Register 1
$400BB00C constant ADC1_CFG2  \ ADC Configuration Register 2
$400BB010 constant ADC1_RA    \ ADC Data Result Register
$400BB014 constant ADC1_RB    \ ADC Data Result Register
$400BB018 constant ADC1_CV1   \ Compare Value Registers
$400BB01C constant ADC1_CV2   \ Compare Value Registers
$400BB020 constant ADC1_SC2   \ Status and Control Register 2
$400BB024 constant ADC1_SC3   \ Status and Control Register 3
$400BB028 constant ADC1_OFS   \ ADC Offset Correction Register
$400BB02C constant ADC1_PG    \ ADC Plus-Side Gain Register
$400BB030 constant ADC1_MG    \ ADC Minus-Side Gain Register
$400BB034 constant ADC1_CLPD  \ ADC Plus-Side General Calibration Value Register
$400BB038 constant ADC1_CLPS  \ ADC Plus-Side General Calibration Value Register
$400BB03C constant ADC1_CLP4  \ ADC Plus-Side General Calibration Value Register
$400BB040 constant ADC1_CLP3  \ ADC Plus-Side General Calibration Value Register
$400BB044 constant ADC1_CLP2  \ ADC Plus-Side General Calibration Value Register
$400BB048 constant ADC1_CLP1  \ ADC Plus-Side General Calibration Value Register
$400BB04C constant ADC1_CLP0  \ ADC Plus-Side General Calibration Value Register
$400BB050 constant ADC1_PGA   \ ADC PGA Register
$400BB054 constant ADC1_CLMD  \ ADC Minus-Side General Calibration Value Register
$400BB058 constant ADC1_CLMS  \ ADC Minus-Side General Calibration Value Register
$400BB05C constant ADC1_CLM4  \ ADC Minus-Side General Calibration Value Register
$400BB060 constant ADC1_CLM3  \ ADC Minus-Side General Calibration Value Register
$400BB064 constant ADC1_CLM2  \ ADC Minus-Side General Calibration Value Register
$400BB068 constant ADC1_CLM1  \ ADC Minus-Side General Calibration Value Register
$400BB06C constant ADC1_CLM0  \ ADC Minus-Side General Calibration Value Register

: init-adc ( -- )
  1 27 lshift SIM_SCGC6 bis! \ Enable clock for ADC

  3 5 lshift 
  3 2 lshift or ADC0_CFG1 ! \ 16 Bit Single Ended, Clock divider /8 --> 20.97 MHz / 8 = 2.62 MHz
  7             ADC0_SC3  ! \ Average 32 samples

  $80 ADC0_SC3 bis! \ Start calibration
  begin $80 ADC0_SC3 bit@ not until \ Wait for calibration to be completed
  $40 ADC0_SC3 bit@ if ." ADC calibration failed." then

  $8 ADC0_SC3 bis! \ Enable continuous conversion

  $4003B034 @
  $4003B038 @ +
  $4003B03C @ +
  $4003B040 @ +
  $4003B044 @ +
  $4003B048 @ +
  $4003B04C @ +  2/ $FFFF and $8000 or ADC0_PG !

  $4003B054 @
  $4003B058 @ +
  $4003B05C @ +
  $4003B060 @ +
  $4003B064 @ +
  $4003B068 @ +
  $4003B06C @ +  2/ $FFFF and $8000 or ADC0_MG !

  $4 ADC0_SC3 cbic! \ disable HW avg.
;

create APINs 5 , 14 , 8 , 9 , 13 , 12 , 6 , 7 , 15 , 4 , 0 , 19 , 3 , 21 ,
             \ 26 , 22 , 23 , 27 , 29 , 30 ,

: analog ( pin -- value )
  cells APINs + @ \ pin -> channel A0-A13
  $1F and ADC0_SC1A ! \ Select channel
  \ 1 5 lshift ADC0_SC1A cbis!
  begin $80 ADC0_SC1A bit@ until \ Wait for conversion completed
  ADC0_RA @ \ Read result
;

